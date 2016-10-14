//
//  AppDelegate.m
//  BackGroundTask
//
//  Created by 刘松洪 on 16/10/12.
//  Copyright © 2016年 刘松洪. All rights reserved.
//

#import "AppDelegate.h"
#define ImageUrl @"http://img05.tooopen.com/images/20141208/sy_76623349543.jpg"

@interface AppDelegate ()
@property (strong, nonatomic) NSString *filePath;//文件存储路径
@end

@implementation AppDelegate

- (NSString *)filePath {
    if (!_filePath) {
        NSArray *fileArray =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path     = [fileArray firstObject];
        _filePath          = [path stringByAppendingString:@"/Image"];
    }
    return _filePath;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    return YES;
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
   NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager contentsAtPath:self.filePath]) {
        NSURL *url = [NSURL URLWithString:ImageUrl];
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:url];
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
        NSURLSessionDownloadTask *dataTask = [session downloadTaskWithRequest:request completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (error) {
                completionHandler(UIBackgroundFetchResultFailed);//告诉系统别杀掉进程（可看api文档）
                return ;
            }
            if (location){
                completionHandler(UIBackgroundFetchResultNewData);
            }else {
                completionHandler(UIBackgroundFetchResultNoData);
            }
            NSError *saveError = nil;
            [manager moveItemAtPath:location.relativePath toPath:self.filePath error:&saveError];
            if (saveError) {
                NSLog(@"%@",saveError);
            }
            //通知UI更新界面
             [[NSNotificationCenter defaultCenter] postNotificationName:@"updataImage" object:self.filePath];
        }];
        [dataTask resume];
    }else {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"updataImage" object:self.filePath];
    }
    
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
