//
//  AppDelegate.m
//  ContractMerchants
//
//  Created by joker on 2017/4/5.
//  Copyright © 2017年 joker. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginUser.h"
#import "BaseTabBarController.h"
#import "LoginViewController.h"

@interface AppDelegate ()
@property (strong, nonatomic) UIView *ADlunchView;
@end

@implementation AppDelegate
@synthesize ADlunchView;
+ (AppDelegate *)sharedInstance{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    _rootNaviController= [[UINavigationController alloc] initWithRootViewController:[BaseTabBarController sharedInstance]];
    _rootNaviController.delegate=[BaseTabBarController sharedInstance];
    
    [LoginUser parseLoginUserInfoFromUserDefaults];
    
    self.window.rootViewController =  [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
    
    [self.window makeKeyAndVisible];
    
//    ADlunchView = [[UIView alloc] init];
//    ADlunchView.backgroundColor = [UIColor clearColor];
//    ADlunchView.frame = CGRectMake(0, 0, self.window.screen.bounds.size.width, self.window.screen.bounds.size.height);
//    [self.window addSubview:ADlunchView];
//    UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
//    NSString *bannerName=@"";
//    
//    if([LoginUser sharedInstance].isAdvertisement){
//        bannerName=[LoginUser sharedInstance].advertisementPhoto==nil?bannerName:[LoginUser sharedInstance].advertisementPhoto;
//        if([LoginUser sharedInstance].isAdvertisementClick){
//            ADlunchView.userInteractionEnabled=NO;
//        }
//    }else{
//        imageView.image=[UIImage imageNamed:bannerName];
//    }
//    [ADlunchView addSubview:imageView];
//    [self.window bringSubviewToFront:ADlunchView];
//    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(removeLun) userInfo:nil repeats:NO];
    return YES;
}
-(void)removeLun{
    [ADlunchView removeFromSuperview];
    ADlunchView = nil;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
}
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [application setApplicationIconBadgeNumber:0];
}
- (void)applicationWillTerminate:(UIApplication *)application
{
    [self saveContext];
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"FinancialManager" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"FinancialManager.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return _persistentStoreCoordinator;
}
- (NSManagedObjectContext *)managedObjectContext {
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support
- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


@end
