//
//  JMHTTPSessionManager.h
//  ContractMerchants
//
//  Created by joker on 2017/4/6.
//  Copyright © 2017年 joker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JMHTTPResponse.h"

extern NSString * const moc_http_request_operation_manager_response_server_error_message;
extern NSString * const moc_http_request_operation_manager_response_server_error_code;
extern NSString * const moc_http_request_operation_manager_response_network_error_message;
extern NSString * const moc_http_request_operation_manager_response_network_error_code;
extern NSString * const moc_http_request_operation_manager_response_token_error_message;
extern NSString * const moc_http_request_operation_manager_response_token_error_code;
extern NSString * const moc_http_request_operation_manager_response_other_error_message;
extern NSString * const moc_http_request_operation_manager_response_other_error_code;
typedef void (^MOCResponseBlock)(JMHTTPResponse *response,NSError *error);

@interface JMHTTPSessionManager : NSObject
+ (void)setupRequestOperationManagerBaseURLString:(NSString *)baseURLString;
+ (void)setupRequestOperationManager:(NSString *)resultKey successCode:(NSString *)successCode dataKey:(NSString *)dataKey messageKey:(NSString *)messageKey;
+ (NSURLSessionTask * )requestWithURL:(NSString *)url post:(BOOL)isPost class:(Class)aclass parameters:(id)parameters timeoutInterval:(NSTimeInterval)timeoutInterval completionHandler:(MOCResponseBlock)completionHandler;
- (BOOL)validateTokenIsLegal:(id)responseObject;
- (id)packageParameters:(id)parameters;
- (void)cancelRequest;
- (NSDictionary *)JSONSDictionary:(NSString *)jsonString;
@end
