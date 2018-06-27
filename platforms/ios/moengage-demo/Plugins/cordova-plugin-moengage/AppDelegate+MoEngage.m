
//
//  AppDelegate+MoEngage.m
//  MoEngage
//
//  Created by Chengappa C D on 18/08/2016.
//  Copyright MoEngage 2016. All rights reserved.
//


#import "AppDelegate+MoEngage.h"
#import <objc/runtime.h>
#import <MoEngage/MoEngage.h>
#import "MoECordova.h"

#define MoEngage_APP_ID_KEY                 @"MoEngage_APP_ID"
#define MoEngage_DICT_KEY                   @"MoEngage"
#define SDK_Version                         @"300"


@interface  AppDelegate (MoEngageNotifications) <MOInAppDelegate>

@end

@implementation AppDelegate (MoEngageNotifications)

#pragma mark- Load Method

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        //ApplicationDidFinshLaunching Method
        SEL appDidFinishLaunching = @selector(application:didFinishLaunchingWithOptions:);
        SEL swizzledAppDidFinishLaunching = @selector(moengage_swizzled_application:didFinishLaunchingWithOptions:);
        [self swizzleMethodWithClass:class originalSelector:appDidFinishLaunching andSwizzledSelector:swizzledAppDidFinishLaunching];
    });
}

#pragma mark- Swizzle Method

+ (void)swizzleMethodWithClass:(Class)class originalSelector:(SEL)originalSelector andSwizzledSelector:(SEL)swizzledSelector {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

#pragma mark- Application LifeCycle methods

- (BOOL)moengage_swizzled_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    //Add Observer for app termination
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moengage_applicationWillTerminate:) name:UIApplicationWillTerminateNotification object:nil];
    [self initializeApplication:application andLaunchOptions:launchOptions];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        id delegate = [UIApplication sharedApplication].delegate;
        
        //Application Register for remote notification
        if ([delegate respondsToSelector:@selector(application:didRegisterForRemoteNotificationsWithDeviceToken:)]) {
            SEL registerForNotificationSelector = @selector(application:didRegisterForRemoteNotificationsWithDeviceToken:);
            SEL swizzledRegisterForNotificationSelector = @selector(moengage_swizzled_application:didRegisterForRemoteNotificationsWithDeviceToken:);
            [AppDelegate swizzleMethodWithClass:class originalSelector:registerForNotificationSelector andSwizzledSelector:swizzledRegisterForNotificationSelector];
        } else {
            SEL registerForNotificationSelector = @selector(application:didRegisterForRemoteNotificationsWithDeviceToken:);
            SEL swizzledRegisterForNotificationSelector = @selector(moengage_swizzled_no_application:didRegisterForRemoteNotificationsWithDeviceToken:);
            [AppDelegate swizzleMethodWithClass:class originalSelector:registerForNotificationSelector andSwizzledSelector:swizzledRegisterForNotificationSelector];
        }
        
        if ([delegate respondsToSelector:@selector(application:didFailToRegisterForRemoteNotificationsWithError:)]) {
            SEL failRegisterForNotificationSelector = @selector(application:didFailToRegisterForRemoteNotificationsWithError:);
            SEL swizzledFailRegisterForNotificationSelector = @selector(moengage_swizzled_application:didFailToRegisterForRemoteNotificationsWithError:);
            [AppDelegate swizzleMethodWithClass:class originalSelector:failRegisterForNotificationSelector andSwizzledSelector:swizzledFailRegisterForNotificationSelector];
        } else {
            SEL failRegisterForNotificationSelector = @selector(application:didFailToRegisterForRemoteNotificationsWithError:);
            SEL swizzledFailRegisterForNotificationSelector = @selector(moengage_swizzled_no_application:didFailToRegisterForRemoteNotificationsWithError:);
            [AppDelegate swizzleMethodWithClass:class originalSelector:failRegisterForNotificationSelector andSwizzledSelector:swizzledFailRegisterForNotificationSelector];
        }
        
        
        //Application Register for  user notification settings
        if ([delegate respondsToSelector:@selector(application:didRegisterUserNotificationSettings:)]) {
            SEL registerForUserSettingsSelector = @selector(application:didRegisterUserNotificationSettings:);
            SEL swizzledRegisterForUserSettingsSelector = @selector(moengage_swizzled_application:didRegisterUserNotificationSettings:);
            [AppDelegate swizzleMethodWithClass:class originalSelector:registerForUserSettingsSelector andSwizzledSelector:swizzledRegisterForUserSettingsSelector];
        } else {
            SEL registerForUserSettingsSelector = @selector(application:didRegisterUserNotificationSettings:);
            SEL swizzledRegisterForUserSettingsSelector = @selector(moengage_swizzled_no_application:didRegisterUserNotificationSettings:);
            [AppDelegate swizzleMethodWithClass:class originalSelector:registerForUserSettingsSelector andSwizzledSelector:swizzledRegisterForUserSettingsSelector];
        }
        
        //Application Did Receive Remote Notification
        if ([delegate respondsToSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)]) {
            SEL receivedNotificationSelector = @selector(application:didReceiveRemoteNotification:fetchCompletionHandler:);
            SEL swizzledReceivedNotificationSelector = @selector(moengage_swizzled_application:didReceiveRemoteNotification:fetchCompletionHandler:);
            [AppDelegate swizzleMethodWithClass:class originalSelector:receivedNotificationSelector andSwizzledSelector:swizzledReceivedNotificationSelector];
        } else if ([delegate respondsToSelector:@selector(application:didReceiveRemoteNotification:)]) {
            SEL receivedNotificationSelector = @selector(application:didReceiveRemoteNotification:);
            SEL swizzledReceivedNotificationSelector = @selector(moengage_swizzled_application:didReceiveRemoteNotification:);
            [AppDelegate swizzleMethodWithClass:class originalSelector:receivedNotificationSelector andSwizzledSelector:swizzledReceivedNotificationSelector];
        } else {
            SEL receivedNotificationSelector = @selector(application:didReceiveRemoteNotification:);
            SEL swizzledReceivedNotificationSelector = @selector(moengage_swizzled_no_application:didReceiveRemoteNotification:);
            [AppDelegate swizzleMethodWithClass:class originalSelector:receivedNotificationSelector andSwizzledSelector:swizzledReceivedNotificationSelector];
            
        }
        
        if ([delegate respondsToSelector:@selector(application:handleActionWithIdentifier:forRemoteNotification:completionHandler:)]) {
            SEL handleActionForNotificationSelector = @selector(application:handleActionWithIdentifier:forRemoteNotification:completionHandler:);
            SEL swizzledHandleActionForNotificationSelector = @selector(moengage_swizzled_application:handleActionWithIdentifier:forRemoteNotification:completionHandler:);
            [AppDelegate swizzleMethodWithClass:class originalSelector:handleActionForNotificationSelector andSwizzledSelector:swizzledHandleActionForNotificationSelector];
        } else {
            SEL handleActionForNotificationSelector = @selector(application:handleActionWithIdentifier:forRemoteNotification:completionHandler:);
            SEL swizzledHandleActionForNotificationSelector = @selector(moengage_swizzled_no_application:handleActionWithIdentifier:forRemoteNotification:completionHandler:);
            [AppDelegate swizzleMethodWithClass:class originalSelector:handleActionForNotificationSelector andSwizzledSelector:swizzledHandleActionForNotificationSelector];
        }
    });
    return [self moengage_swizzled_application:application didFinishLaunchingWithOptions:launchOptions];
}

-(void)initializeApplication:(UIApplication*)application andLaunchOptions:(NSDictionary*)launchOptions{
    NSString* appID = [self getMoEngageAppID];
    if (appID == nil) {
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:SDK_Version forKey:MoEngage_Cordova_SDK_Version];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
#ifdef DEBUG
    [[MoEngage sharedInstance] initializeDevWithApiKey:appID inApplication:application withLaunchOptions:launchOptions openDeeplinkUrlAutomatically:YES];
#else
    [[MoEngage sharedInstance] initializeProdWithApiKey:appID inApplication:application withLaunchOptions:launchOptions openDeeplinkUrlAutomatically:YES];
#endif
    
    NSDictionary *notificationMessage = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (notificationMessage && ([[[UIDevice currentDevice] systemVersion] floatValue] < 10.0)) {			// Check if launch from notification Click
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSelector:@selector(callbackForNotificationReceived:) withObject:notificationMessage afterDelay: 0.5];
        });
    }
    
    [MoEngage sharedInstance].delegate = self;
    
}

-(NSString*)getMoEngageAppID {
    NSString* moeAppID;
    NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
    
    if ( [infoDict objectForKey:MoEngage_DICT_KEY] != nil && [infoDict objectForKey:MoEngage_DICT_KEY] != [NSNull null]) {
        NSDictionary* moeDict = [infoDict objectForKey:MoEngage_DICT_KEY];
        if ([moeDict objectForKey:MoEngage_APP_ID_KEY] != nil && [moeDict objectForKey:MoEngage_APP_ID_KEY] != [NSNull null]) {
            moeAppID = [moeDict objectForKey:MoEngage_APP_ID_KEY];
        }
    }
    
    if (moeAppID.length > 0) {
        return moeAppID;
    }
    else{
        NSLog(@"MoEngage - Provide the APP ID for your MoEngage App in Info.plist for key MoEngage_APP_ID to proceed. To get the AppID login to your MoEngage account, after that go to Settings -> App Settings. You will find the App ID in this screen.");
        return nil;
    }

}


- (void)moengage_applicationWillTerminate:(NSNotification *)notif {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
}


#pragma mark- Register For Push methods

- (void)moengage_swizzled_application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [self moengage_swizzled_application:application didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];
    [[MoEngage sharedInstance] setPushToken:deviceToken];
    
    NSDictionary* userInfo = @{MoEngage_Device_Token_Key: deviceToken};
    [[NSNotificationCenter defaultCenter] postNotificationName:MoEngage_Notification_Registered_Notification object:[UIApplication sharedApplication] userInfo:userInfo];
    [self callbackForRegisteredForNotificationWithToken:deviceToken];
}

- (void)moengage_swizzled_no_application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [[MoEngage sharedInstance] setPushToken:deviceToken];
    
    NSDictionary* userInfo = @{MoEngage_Device_Token_Key: deviceToken};
    [[NSNotificationCenter defaultCenter] postNotificationName:MoEngage_Notification_Registered_Notification object:[UIApplication sharedApplication] userInfo:userInfo];
    [self callbackForRegisteredForNotificationWithToken:deviceToken];
}

-(void)moengage_swizzled_application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [self moengage_swizzled_application:application didFailToRegisterForRemoteNotificationsWithError:error];
    [[MoEngage sharedInstance]didFailToRegisterForPush];
    
    NSDictionary* userInfo = @{@"error": error};
    [[NSNotificationCenter defaultCenter] postNotificationName:MoEngage_Notification_Registration_Failed_Notification object:[UIApplication sharedApplication] userInfo:userInfo];
}


-(void)moengage_swizzled_no_application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [[MoEngage sharedInstance]didFailToRegisterForPush];

    NSDictionary* userInfo = @{@"error": error};
    [[NSNotificationCenter defaultCenter] postNotificationName:MoEngage_Notification_Registration_Failed_Notification object:[UIApplication sharedApplication] userInfo:userInfo];
}

-(void)moengage_swizzled_application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    [self moengage_swizzled_application:application didRegisterUserNotificationSettings:notificationSettings];
    [[MoEngage sharedInstance]didRegisterForUserNotificationSettings:notificationSettings];
    
    NSDictionary* userInfo = @{MoEngage_Notification_Settings_Key: notificationSettings};
    [[NSNotificationCenter defaultCenter] postNotificationName:MoEngage_Notification_UserSettings_Registered_Notification object:[UIApplication sharedApplication] userInfo:userInfo];
}

-(void)moengage_swizzled_no_application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings{
    [[MoEngage sharedInstance]didRegisterForUserNotificationSettings:notificationSettings];
    
    NSDictionary* userInfo = @{MoEngage_Notification_Settings_Key: notificationSettings};
    [[NSNotificationCenter defaultCenter] postNotificationName:MoEngage_Notification_UserSettings_Registered_Notification object:[UIApplication sharedApplication] userInfo:userInfo];
    
}

#pragma mark- Receive Notification methods

- (void)moengage_swizzled_application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)]) {
        [self moengage_swizzled_application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
    }
    
    [[MoEngage sharedInstance] didReceieveNotificationinApplication:application withInfo:userInfo openDeeplinkUrlAutomatically:NO];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:MoEngage_Notification_Received_Notification object:[UIApplication sharedApplication] userInfo:userInfo];
    [self callbackForNotificationReceived:userInfo];
}

- (void)moengage_swizzled_application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [self moengage_swizzled_application:application didReceiveRemoteNotification:userInfo];
    [[MoEngage sharedInstance] didReceieveNotificationinApplication:application withInfo:userInfo openDeeplinkUrlAutomatically:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:MoEngage_Notification_Received_Notification object:[UIApplication sharedApplication] userInfo:userInfo];
    [self callbackForNotificationReceived:userInfo];
}

- (void)moengage_swizzled_no_application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [[MoEngage sharedInstance] didReceieveNotificationinApplication:application withInfo:userInfo openDeeplinkUrlAutomatically:NO];
    [[NSNotificationCenter defaultCenter] postNotificationName:MoEngage_Notification_Received_Notification object:[UIApplication sharedApplication] userInfo:userInfo];
    [self callbackForNotificationReceived:userInfo];
}

- (void)moengage_swizzled_application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler {
    [[MoEngage sharedInstance] handleActionWithIdentifier:identifier forRemoteNotification:userInfo];
    [self callbackForNotificationReceived:userInfo];
    completionHandler();
}

- (void)moengage_swizzled_no_application:(UIApplication *)application handleActionWithIdentifier:(nullable NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler {
    [[MoEngage sharedInstance] handleActionWithIdentifier:identifier forRemoteNotification:userInfo];
    [self callbackForNotificationReceived:userInfo];
    completionHandler();
}

#pragma mark- iOS10 UserNotification Framework delegate methods

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)())completionHandler{
    [[MoEngage sharedInstance] userNotificationCenter:center didReceiveNotificationResponse:response];
    NSDictionary *pushDictionary = response.notification.request.content.userInfo;
    
    if (pushDictionary) {
        [[NSNotificationCenter defaultCenter] postNotificationName:MoEngage_Notification_Received_Notification object:[UIApplication sharedApplication] userInfo:pushDictionary];
        [self callbackForNotificationReceived:pushDictionary];
    }
    
    completionHandler();
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    completionHandler((UNNotificationPresentationOptionSound
                       | UNNotificationPresentationOptionAlert ));
}

#pragma mark- InApp Delegate methods

-(void)inAppShownWithCampaignID:(NSString *)campaignID{
    if (!campaignID.length) {
        return;
    }
    MoECordova* cordovaHandler = [self getCommandInstance:@"MoEngage"];
    [cordovaHandler inAppShownWithCampaignID:campaignID];
}

-(void)inAppClickedForWidget:(InAppWidget)widget screenName:(NSString *)screenName andDataDict:(NSDictionary *)dataDict{
    MoECordova* cordovaHandler = [self getCommandInstance:@"MoEngage"];
    NSString* widgetStr = @"";
    switch (widget) {
        case BUTTON:
            widgetStr = @"Button";
            break;
        case IMAGE:
            widgetStr = @"Image";
            break;
        case LABEL:
            widgetStr = @"Label";
            break;
        case CLOSE_BUTTON:
            widgetStr = @"CloseButton";
            break;
        default:
            break;
    }
    [cordovaHandler inAppClickedWithWidget:widgetStr andScreenName:screenName andDataDict:dataDict];
}



#pragma mark- Push JS Callbacks

-(void)callbackForNotificationReceived:(NSDictionary*)userInfo{
    MoECordova* cordovaHandler = [self getCommandInstance:@"MoEngage"];
    [cordovaHandler pushNotificationClickedWithUserInfo:userInfo];
}

-(void)callbackForRegisteredForNotificationWithToken:(NSData*)deviceToken{
    MoECordova* cordovaHandler = [self getCommandInstance:@"MoEngage"];
    NSString* token = [self hexTokenForData:deviceToken];
    [cordovaHandler registeredWithdeviceToken:token];
}

#pragma mark- Utility methods

- (id) getCommandInstance:(NSString*)className
{
    return [self.viewController getCommandInstance:className];
}
     
// Gives Device token in Hex String
-(NSString *)hexTokenForData:(NSData *)data{
    if(!data){
        return @"";
    }
    const unsigned *tokenBytes = [data bytes];
    NSString *hexToken = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    return hexToken;
}

@end





