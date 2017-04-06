//
//  JMNetworkReachabilityManager.h
//  ContractMerchants
//
//  Created by joker on 2017/4/6.
//  Copyright © 2017年 joker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
typedef void(^MOCNetworkReachabilityManagerBlock)();

extern NSString * const moc_network_status_change_notification;
@interface JMNetworkReachabilityManager : NSObject
+ (void)startMonitor:(NSString *)checkURLString;//网络状态变化均会moc_network_status_change_notification通知
+ (void)startMonitor:(NSString *)checkURLString viaWWAN:(MOCNetworkReachabilityManagerBlock)viaWWANBlock viaWiFi:(MOCNetworkReachabilityManagerBlock)viaWiFiBlock notReachable:(MOCNetworkReachabilityManagerBlock)notReachableBlock;
+ (AFNetworkReachabilityStatus)status;
+ (BOOL)isReachable;
@end
