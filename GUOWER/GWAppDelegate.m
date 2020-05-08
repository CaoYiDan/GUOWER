  //
  //  GWAppDelegate.m
  //  GUOWER
  //
  //  Created by ourslook on 2018/6/25.
  //  Copyright © 2018年 Vanne. All rights reserved.
  //
  #define STOREAPPID @"1503276587"

  #import "GWTabBarVC.h"

  #import "GWAppDelegate.h"
  //推送到 ——————》新闻详情
  #import "GWNewsDetailVC.h"

  #import "GWNavigationController.h"
  //FPS
  #import <JPFPSStatus.h>
  // 引入 JPush 功能所需头文件
  #import "JPUSHService.h"
  // iOS10 注册 APNs 所需头文件
  #ifdef NSFoundationVersionNumber_iOS_9_x_Max
  #import <UserNotifications/UserNotifications.h>
  #endif
  //shareSDK
  #import <ShareSDK/ShareSDK.h>
  #import <ShareSDKConnector/ShareSDKConnector.h>
  //腾讯开放平台（对应QQ和QQ空间）SDK头文件
  #import <TencentOpenAPI/TencentOAuth.h>
  #import <TencentOpenAPI/QQApiInterface.h>
  //微信
  #import <WXApi.h>
  //新浪微博SDK头文件
  #import <WeiboSDK.h>
  #import <YYWebImageManager.h>
  #import <YYCache.h>
#import "ZYVersionUpdate.h"
  #define  JPushAppKey @"07fd99472be0f30fd9bf2df9"
  @interface GWAppDelegate ()<JPUSHRegisterDelegate>

  @end

  @implementation GWAppDelegate

  /**
   *    @brief    App将要启动
   */
  - (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions{
      
      return YES;
      
  }

  /**
   *    @brief    App已经启动
   */
  - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
          
      self.window.backgroundColor = [UIColor whiteColor];
      [self.window makeKeyAndVisible];
      
      [self initJPushApns];
      
      // Required
      // init Push
      // notice: 2.1.5 版本的 SDK 新增的注册方法，改成可上报 IDFA，如果没有使用 IDFA 直接传 nil
      [JPUSHService setupWithOption:launchOptions appKey:JPushAppKey
                            channel:@"GUOWEI"
                   apsForProduction:0];
      
  #if defined(DEBUG)||defined(_DEBUG)
      [[JPFPSStatus sharedInstance] open];
  #endif
      
      //若由其他应用程序通过openURL:启动
      NSURL *url = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
      if(url){
          
      }
      //启动的源应用程序的 bundle ID
      NSString *bundleId = [launchOptions objectForKey:UIApplicationLaunchOptionsSourceApplicationKey];
      if(bundleId){
          
      }
      
      //若由本地通知启动
      UILocalNotification * localNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
      if(localNotification){
          
          
      }
      
      //若由远程通知启动
      NSDictionary * remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
      if(remoteNotification){
          
          
      }
      
      [self setupShareSDK];
      
      [self updateToken];
    
      [self hsUpdateApp];
      
      return YES;
  }

/**
 * 检测app更新
 */
-(void)hsUpdateApp
{
    //1.获取一个全局串行队列
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    //2.把任务添加到队列中执行
    dispatch_async(queue, ^{
        
        //2先获取当前工程项目版本号
        NSDictionary *infoDic=[[NSBundle mainBundle] infoDictionary];
        NSString *currentVersion=infoDic[@"CFBundleShortVersionString"];
        
        //3从网络获取appStore版本号
        NSError *error;
        NSData *response = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/cn/lookup?id=%@",STOREAPPID]]] returningResponse:nil error:nil];
        if (response == nil) {
            
            return;
        }
        
        NSDictionary *appInfoDic = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
        if (error) {
            
            return;
        }
        NSArray *array = appInfoDic[@"results"];
        NSDictionary *dic = [array lastObject];
        NSString *appStoreVersion = dic[@"version"];
        NSLog(@"%@  %@",currentVersion,appStoreVersion);
        //4当前版本号小于商店版本号,就更新
        if(![currentVersion isEqualToString:appStoreVersion])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"版本有更新" message:[NSString stringWithFormat:@"检测到新版本(%@),是否更新?",appStoreVersion] delegate:self cancelButtonTitle:@"取消"otherButtonTitles:@"更新",nil];
                [alert show];
            });
            
        }else{
            //不做任何处理
        }
        
    });
}

- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //5实现跳转到应用商店进行更新
    if(buttonIndex==1)
    {
        //6此处加入应用在app store的地址，方便用户去更新，一种实现方式如下：
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/us/app/lets-gou/id%@?l=zh&ls=1&mt=8", STOREAPPID]];
        [[UIApplication sharedApplication]openURL:url];
    }
}
  #pragma mark -初始化 极光APNS
  -(void)initJPushApns{
      //Required
      //notice: 3.0.0 及以后版本注册可以这样写，也可以继续用之前的注册方式
      JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
      entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|UNAuthorizationOptionProvidesAppNotificationSettings;
      if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
          // 可以添加自定义 categories
          // NSSet<UNNotificationCategory *> *categories for iOS10 or later
          // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
      }
      [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
  }


  /**
   *    @brief    App将要进入前台
   */
  - (void)applicationWillResignActive:(UIApplication *)application {
      
  }

  - (void)application:(UIApplication *)application
  didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
      
      /// Required - 注册 DeviceToken
      [JPUSHService registerDeviceToken:deviceToken];
  }

  #pragma mark- JPUSHRegisterDelegate

  // iOS 12 Support
  - (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
      if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
          //从通知界面直接进入应用
      }else{
          //从通知设置界面进入应用
      }
  }

  // iOS 10 Support
  - (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
      // Required
      NSDictionary * userInfo = notification.request.content.userInfo;
      if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
          [JPUSHService handleRemoteNotification:userInfo];
      }
      completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
  }
-(NSString *)enumJsonWithObjec:(NSDictionary *)dic valueForKey:(NSString *)keyStr{
  
    NSArray *allKeys = dic.allKeys;

    for (NSString *key in allKeys) {
        if ([key isEqualToString:keyStr]) {
            if ([dic[key] isKindOfClass:[NSString class]]) {
             
                return dic[key];
                break;
            }
        }else if ([dic[key] isKindOfClass:[NSDictionary class]]){
        
            NSString *resultStr = [self enumJsonWithObjec:dic[key] valueForKey:keyStr];
            if (![NSString va_isBlankString:resultStr]) {
                return resultStr;
            }
        }else{

        }
    }
      NSLog(@"未找到id");
      return @"";
}

  // iOS 10 Support
  - (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
      // Required
      NSDictionary * userInfo = response.notification.request.content.userInfo;
      NSLog(@"%@",userInfo);

      //直接跳转到快报列表页，并且刷新快报列表
     GWTabBarVC *tabbarVC = (GWTabBarVC *)self.window.rootViewController;
     tabbarVC.selectedIndex = 1;
      
   if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
          [JPUSHService handleRemoteNotification:userInfo];
      }
      completionHandler();  // 系统要求执行这个方法
  }

  -(void)p_pushToNewsDetailWithnewsId:(NSString *)newsId{
      GWNewsDetailVC *newsDetailVC = [[GWNewsDetailVC alloc]init];
         newsDetailVC.newsID = newsId;
      GWNavigationController *nav = [[GWNavigationController alloc]initWithRootViewController:newsDetailVC];

      [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
  }

  - (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
      
      // Required, iOS 7 Support
      [JPUSHService handleRemoteNotification:userInfo];
      completionHandler(UIBackgroundFetchResultNewData);
  }

  - (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
      
      // Required, For systems with less than or equal to iOS 6
      [JPUSHService handleRemoteNotification:userInfo];
  }
  /**
   *    @brief    App已经进入前台
   */
  - (void)applicationDidBecomeActive:(UIApplication *)application {
      
      [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
      [JPUSHService setBadge:0];
      
  }

  /**
   *    @brief    App将要进入后台
   */
  - (void)applicationWillEnterForeground:(UIApplication *)application {
      
  }

  /**
   *    @brief    App已经进入后台
   */
  - (void)applicationDidEnterBackground:(UIApplication *)application {
      
      
      
  }


  /**
   *    @brief    App将要退出
   */
  - (void)applicationWillTerminate:(UIApplication *)application {
      
      [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
      
      }];
      
      [[YYWebImageManager sharedManager].cache.diskCache removeAllObjects];
      [[YYWebImageManager sharedManager].cache.memoryCache removeAllObjects];
      
  }

  /**
   *    @brief    App内存警告
   */
  -  (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
  {
      NSLog(@"系统内存不足");
  }

  /**
   *    @brief    StatusBar框方向将要变化
   */
  -  (void)application:(UIApplication*)application willChangeStatusBarOrientation:
  (UIInterfaceOrientation)newStatusBarOrientation duration:(NSTimeInterval)duration
  {
      
  }

  /**
   *    @brief    StatusBar框方向已经变化
   */
  -  (void)application:(UIApplication*)application  didChangeStatusBarOrientation:(UIInterfaceOrientation)oldStatusBarOrientation{
  }

  /**
   *    @brief    StatusBar框坐标将要变化
   */
  -  (void)application:(UIApplication*)application willChangeStatusBarFrame:(CGRect)newStatusBarFrame{
      
      
  }

  /**
   *    @brief    StatusBar框坐标已经变化
   */
  -  (void)application:(UIApplication*)application didChangeSetStatusBarFrame:(CGRect)oldStatusBarFrame{
      
      
  }

  /**
   *    @brief    当系统时间发生改变时执行
   */
  - (void)applicationSignificantTimeChange:(UIApplication *)application{
      
  }


  /**
   *    @brief    初始化ShareSDK
   */
  -(void)setupShareSDK{
      
      //shareSDK
      [ShareSDK registerActivePlatforms:@[
                                          @(SSDKPlatformTypeSinaWeibo),
                                          @(SSDKPlatformTypeWechat),
                                          @(SSDKPlatformTypeQQ),
                                          ]
                               onImport:^(SSDKPlatformType platformType)
       {
           switch (platformType)
           {
               case SSDKPlatformTypeWechat:
                   [ShareSDKConnector connectWeChat:[WXApi class]];
                   break;
               case SSDKPlatformTypeQQ:
                   [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                   break;
               case SSDKPlatformTypeSinaWeibo:
                   [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                   break;
               default:
                   break;
           }
       }onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
       {
           switch (platformType)
           {
               case SSDKPlatformTypeSinaWeibo:
                   //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                   [appInfo SSDKSetupSinaWeiboByAppKey:@"1603704370"
                                             appSecret:@"3e7ff2fbffe78a5bc6aedf59242d7d65f"
                                           redirectUri:API_BASE_URL
                                              authType:SSDKAuthTypeBoth];
                   break;
               case SSDKPlatformTypeWechat:
                   [appInfo SSDKSetupWeChatByAppId:@"wx5552f3c83120a95f"
                                         appSecret:@"5b3c8442aba931573d02f73ae7436b22"];
                   break;
               case SSDKPlatformTypeQQ:
                   [appInfo SSDKSetupQQByAppId:@"1107056764"
                                        appKey:@"lejIQkrEL0PHltck"
                                      authType:SSDKAuthTypeBoth];
                   break;
               default:
                   break;
           }
       }];
      
  }

  - (void)updateToken{
      
      if (AccountMannger_isLogin) {
          [URLRequestHelper api_p_updateTokenWithToken:AccountMannger_userInfo.token parentView:nil hasHud:NO hasMask:NO end:^(URLResponse *response) {
              
          } success:^(URLResponse *response, id object) {
              
              GWUserModel *model = [GWUserModel mj_objectWithKeyValues:object];
              AccountMannger_setUserInfo(model);
              [JPUSHService setAlias:model.ID.stringValue completion:nil seq:0];
              
          } failure:^(URLResponse *response, NSInteger code, NSString *message) {
              
              AccountMannger_removeUserInfo;
              m_ToastCenter(@"登录失效");
              
          } netWorkError:^(NSError *error) {
              
          }];
      }
  }

  @end
