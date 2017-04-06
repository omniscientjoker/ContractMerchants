//
//  JMHTTPSessionManager.m
//  ContractMerchants
//
//  Created by joker on 2017/4/6.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "JMHTTPSessionManager.h"
#import "JMNetworkReachabilityManager.h"
#import "NSDictionary+Common.h"
#import "NSString+Common.h"
#import "AFNetworking.h"
#import "Mantle.h"
#import "LoginUser.h"

NSString * const moc_http_request_operation_manager_response_server_error_message = @"服务器异常";
NSString * const moc_http_request_operation_manager_response_server_error_code = @"9989";
NSString * const moc_http_request_operation_manager_response_network_error_message = @"网络异常,请检查网络是否正常";
NSString * const moc_http_request_operation_manager_response_network_error_code = @"9998";
NSString * const moc_http_request_operation_manager_response_token_error_message = @"token错误";
NSString * const moc_http_request_operation_manager_response_token_error_code = @"9899";

NSString * const moc_http_request_operation_manager_response_other_error_message = @"服务器异常";
NSString * const moc_http_request_operation_manager_response_other_error_code = @"8999";

NSString *moc_http_request_operation_manager_base_url_string;
//http返回的结果key
static NSString *moc_http_request_operation_manager_base_request_success_code;//请求成功码
static NSString *moc_http_request_operation_manager_base_request_result_key;//请求结果code的key
static NSString *moc_http_request_operation_manager_base_request_data_key;//数据部分
static NSString *moc_http_request_operation_manager_base_request_message_key;//错误信息部分
static NSString *moc_http_request_operation_manager_token;

@interface JMHTTPSessionManager ()
@property (nonatomic, strong) JMHTTPResponse *response;
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@end

@implementation JMHTTPSessionManager
+ (void)setupRequestOperationManagerBaseURLString:(NSString *)baseURLString{
    moc_http_request_operation_manager_base_url_string = baseURLString;
}
+ (void)setupRequestOperationManager:(NSString *)resultKey
                         successCode:(NSString *)successCode
                             dataKey:(NSString *)dataKey
                          messageKey:(NSString *)messageKey{
    NSAssert(!IsStrEmpty(resultKey), @"结果key不能为空");
    NSAssert(!IsStrEmpty(successCode), @"成功码不能为空");
    NSAssert(!IsStrEmpty(dataKey), @"数据key不能为空");
    NSAssert(!IsStrEmpty(messageKey), @"信息key不能为空");
    moc_http_request_operation_manager_base_request_success_code = successCode;
    moc_http_request_operation_manager_base_request_result_key   = resultKey;
    moc_http_request_operation_manager_base_request_data_key     = dataKey;
    moc_http_request_operation_manager_base_request_message_key  = messageKey;
}

#pragma mark -
+ (NSURLSessionTask *)requestWithURL:(NSString *)url
                                post:(BOOL)isPost
                               class:(Class)class
                          parameters:(id)parameters
                     timeoutInterval:(NSTimeInterval)timeoutInterval
                   completionHandler:(MOCResponseBlock)completionHandler{
    
    NSAssert(url, @"请求地址不能为空");
    JMHTTPSessionManager *client = [JMHTTPSessionManager manager];
    if (timeoutInterval > 0) {
        [client.manager.requestSerializer setTimeoutInterval:timeoutInterval];
    }
    if (![JMNetworkReachabilityManager isReachable]) {//网络不可达
        [client parseResponseFailed:nil completionHandler:completionHandler logInfo:@"网络不可达"];
        return nil;
    }
    
    parameters = [client packageParameters:parameters];
    
    if ([LoginUser sharedInstance].token)
    {
        [client.manager.requestSerializer setValue:[LoginUser sharedInstance].token forHTTPHeaderField:@"st"];
    }
    [client.manager.requestSerializer setValue:@"m" forHTTPHeaderField:@"s"];
    
    NSData *cookiesdata = [[NSUserDefaults standardUserDefaults] objectForKey:@"cookie"];
    if([cookiesdata length]) {
        NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:cookiesdata];
        NSHTTPCookie *cookie;
        for (cookie in cookies) {
            [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie];
            [client.manager.requestSerializer setHTTPShouldHandleCookies:YES];
        }
    }
    if (isPost)
    {
        NSString * jsonStr = [parameters JSONString];
        jsonStr = [jsonStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        jsonStr = [jsonStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        NSURLSessionTask *task = [client.manager POST:url parameters:jsonStr constructingBodyWithBlock:nil progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:url]];
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookies];
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"cookie"];
            [client parseResponseSuccess:responseObject class:class completionHandler:completionHandler logInfo:[NSString stringWithFormat:@"%@---%@",url,[parameters objectForKey:@"RT"]]];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [client parseResponseFailed:error completionHandler:completionHandler logInfo:error.domain];
        }];
        return task;
    }
    else{
        NSURLSessionTask *task = [client.manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            [client parseResponseSuccess:responseObject class:class completionHandler:completionHandler logInfo:[NSString stringWithFormat:@"%@---%@",url,[parameters objectForKey:@"METHOD"]]];
        }failure:^(NSURLSessionDataTask *task, NSError *error) {
            [client parseResponseFailed:error completionHandler:completionHandler logInfo:error.domain];
        }];
        return task;
    }
}

#pragma mark -
//data为对应部分的数据
- (void)parseResponseSuccess:(id)responseObject
                       class:(Class)class
           completionHandler:(MOCResponseBlock)completionHandler
                     logInfo:(NSString *)info
{
    self.response.data = responseObject;
    if ([self validateTokenIsLegal:responseObject]){//token合法
        NSString *code = [responseObject valueForKey:moc_http_request_operation_manager_base_request_result_key];
        if ([code isEqualToString:moc_http_request_operation_manager_base_request_success_code]) {//返回成功
            id data = [responseObject objectForKey:moc_http_request_operation_manager_base_request_data_key];
            
            if ([data isKindOfClass:[NSString class]]) {
                id parseData = [data parseToArrayOrNSDictionary];//解析前的数据保存
                if ([parseData isKindOfClass:[NSDictionary class]]) {
                    self.response.dataDictionary = parseData;
                }else if ([parseData isKindOfClass:[NSArray class]]) {
                    [self parseServerJsonArrayToJSONModel:parseData class:class];
                }
            }if ([data isKindOfClass:[NSDictionary class]]) {
                self.response.dataDictionary = data;
            }else if ([data isKindOfClass:[NSArray class]]) {
                [self parseServerJsonArrayToJSONModel:data class:class];
            }
            completionHandler?completionHandler(self.response,nil):nil;//成功
        }else if ([code isEqualToString:@"1004"] || [code isEqualToString:@"1009"]){
            int num = (int)info.length;
            NSString * title = [info substringWithRange:NSMakeRange(num-4, 4)];
            if ([title isEqualToString:@"2001"]) {
                [self parseResponseFailed:responseObject completionHandler:completionHandler logInfo:info];
            }else{
//                自动获取tocken
//                [LoginUser systemAutoGetTocken];
                [self parseResponseFailed:responseObject completionHandler:completionHandler logInfo:info];
            }
        }else{
            [self parseResponseFailed:responseObject completionHandler:completionHandler logInfo:info];
        }
    }else{//token不合法
        self.response.errorCode = moc_http_request_operation_manager_response_token_error_code;
        self.response.errorMessage = moc_http_request_operation_manager_response_token_error_message;
        completionHandler?completionHandler(self.response,[[NSError alloc] initWithDomain:moc_http_request_operation_manager_response_token_error_message code:moc_http_request_operation_manager_response_token_error_code.integerValue userInfo:nil]):nil;//失败
    }
}

//data 可能为NSError 或者NSDictionary
- (void)parseResponseFailed:(id)responseObject
          completionHandler:(MOCResponseBlock)completionHandler
                    logInfo:(NSString *)info{
    if (![JMNetworkReachabilityManager isReachable]) {//网络不可达
        self.response.errorCode = moc_http_request_operation_manager_response_network_error_code;
        self.response.errorMessage = moc_http_request_operation_manager_response_network_error_message;
        MOCLogDebug(@"网络错误");
    }else{
        if ([responseObject isKindOfClass:[NSError class]]) {
            self.response.error = responseObject;
            self.response.errorCode = [NSString stringWithFormat:@"%@",@([responseObject code])];
            self.response.errorMessage = [responseObject localizedDescription];
            
            self.response.error = responseObject;
        }else{//服务器请求成功,但是操作失败,这个需要由外部定义成功码
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                id codeObject = [responseObject objectForKey:moc_http_request_operation_manager_base_request_result_key];
                
                if ([codeObject isKindOfClass:[NSNumber class]] || [codeObject isKindOfClass:[NSString class]]) {
                    
                    if ([codeObject isKindOfClass:[NSNumber class]]){
                        codeObject = [codeObject stringValue];
                    }
                    if ([codeObject length] >= 5){
                        self.response.errorMessage = moc_http_request_operation_manager_response_other_error_message;
                        self.response.errorCode = moc_http_request_operation_manager_response_other_error_code;
                    }else{
                        self.response.errorMessage = [responseObject objectForKey:moc_http_request_operation_manager_base_request_message_key] ;
                        self.response.errorCode = [responseObject objectForKey:moc_http_request_operation_manager_base_request_result_key];
                    }
                    
                }else{
                    self.response.errorMessage = moc_http_request_operation_manager_response_other_error_message;
                    self.response.errorCode = moc_http_request_operation_manager_response_other_error_code;
                }
                
            }else{
                self.response.errorMessage = moc_http_request_operation_manager_response_other_error_message;
                self.response.errorCode = moc_http_request_operation_manager_response_other_error_code;
            }
            self.response.data = responseObject;
        }
    }
    NSError *error = self.response.error?:[[NSError alloc] initWithDomain:self.response.errorMessage code:self.response.errorCode.integerValue userInfo:nil];
    completionHandler?completionHandler(self.response,error):nil;
}

//解析服务器的数据到对应的response里面去
- (void)parseServerJsonArrayToJSONModel:(NSArray *)array class:(Class)class{
    if ([class isSubclassOfClass:[MTLModel class]]) {
        NSMutableArray *saveArray = [[NSMutableArray alloc] init];
        for(id obj in array){
            if ([obj isKindOfClass:[NSDictionary class]]) {
                NSError *error;
                id model = [MTLJSONAdapter modelOfClass:class fromJSONDictionary:obj error:&error];
                if (error) {
                    MOCLogDebug(error.domain);
                }else{
                    [saveArray addObject:model];
                }
            }else{
                MOCLogDebug(@"服务器返回的数据应该为字典形式");
            }
        }
        self.response.dataArray = saveArray;
    }else{
        MOCLogDebug(@"class没有继承于JSONModel,只做单纯的返回数据,不处理");
        self.response.dataArray = array;
    }
}
#pragma mark -
+ (JMHTTPSessionManager *)manager{
    NSAssert(moc_http_request_operation_manager_base_request_result_key != nil, @"请有且仅调一次setupRequestOperationManager:successCode:dataKey:messageKey:方法进行网络请求的配置");
    JMHTTPSessionManager *client = [[JMHTTPSessionManager alloc] init];
    
    if (IsStrEmpty(moc_http_request_operation_manager_base_url_string)){
        client.manager= [AFHTTPSessionManager manager];
        client.response = [[JMHTTPResponse alloc] init];
        [client clientSetup];
        return client;
    }else{
        NSURL *baseURL = [[NSURL alloc] initWithString:moc_http_request_operation_manager_base_url_string];
        if (baseURL) {
            client.manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
        }else{
            client.manager = [AFHTTPSessionManager manager];
        }
        client.response = [[JMHTTPResponse alloc] init];
        [client clientSetup];
        return client;
    }
}

- (void)clientSetup{
    
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",@"text/plain", nil];
}
- (NSDictionary *)JSONSDictionary:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
#pragma mark -
//具体工程中建议重载的部分
- (BOOL)validateTokenIsLegal:(id)responseObject{
    return YES;
}
- (id)packageParameters:(id)parameters{
    return parameters;
}
- (void)cancelRequest{
    [self.manager.operationQueue cancelAllOperations];
}
@end
