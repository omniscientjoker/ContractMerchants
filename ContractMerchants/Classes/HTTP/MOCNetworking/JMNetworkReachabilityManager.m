//
//  JMNetworkReachabilityManager.m
//  ContractMerchants
//
//  Created by joker on 2017/4/6.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "JMNetworkReachabilityManager.h"
NSString * const moc_network_status_change_notification = @"moc_network_status_change_notification";

static AFHTTPSessionManager *moc_http_request_operation_manager(NSString *checkURLString){
    static AFHTTPSessionManager *mow_http_request_operation_manager;
    static dispatch_once_t oneToken;
    if (IsStrEmpty(checkURLString)) {
        checkURLString = @"www.baidu.com";
    }
    dispatch_once(&oneToken,^{
        NSURL *baseURL = [NSURL URLWithString:checkURLString];
        mow_http_request_operation_manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    });
    return mow_http_request_operation_manager;
}

AFNetworkReachabilityStatus netwokStatus = AFNetworkReachabilityStatusReachableViaWWAN;//默认环境
BOOL monitorIsInit;

@implementation JMNetworkReachabilityManager
+ (void)startMonitor:(NSString *)checkURLString{
    [JMNetworkReachabilityManager startMonitor:checkURLString viaWWAN:nil viaWiFi:nil notReachable:nil];
}

+ (void)startMonitor:(NSString *)checkURLString viaWWAN:(MOCNetworkReachabilityManagerBlock)viaWWANBlock viaWiFi:(MOCNetworkReachabilityManagerBlock)viaWiFiBlock notReachable:(MOCNetworkReachabilityManagerBlock)notReachableBlock{
    
    AFHTTPSessionManager *manager = moc_http_request_operation_manager(checkURLString);
    monitorIsInit = YES;
    
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
                case AFNetworkReachabilityStatusReachableViaWWAN:{
                    netwokStatus = AFNetworkReachabilityStatusReachableViaWWAN;
                    viaWWANBlock?viaWWANBlock():nil;
                }
                break;
                case AFNetworkReachabilityStatusReachableViaWiFi:{
                    netwokStatus = AFNetworkReachabilityStatusReachableViaWiFi;
                    viaWiFiBlock?viaWiFiBlock():nil;
                }
                break;
                case AFNetworkReachabilityStatusNotReachable:{
                    netwokStatus = AFNetworkReachabilityStatusNotReachable;
                    notReachableBlock?notReachableBlock():nil;
                }
                break;
            default:
                break;
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:moc_network_status_change_notification object:@(status)];
    }];
    
    [manager.reachabilityManager startMonitoring];
}

+ (AFNetworkReachabilityStatus)status{
    return netwokStatus;
}
+ (BOOL)isReachable{
    if (!monitorIsInit) {//如果没有初始化则默认可通
        return YES;
    }
    if (netwokStatus == AFNetworkReachabilityStatusReachableViaWWAN || netwokStatus == AFNetworkReachabilityStatusReachableViaWiFi) {
        return YES;
    }else{
        return NO;
    }
}
@end
