#import <Cordova/CDV.h>
#import "MBProgressHUD.h"

@interface ActivityIndicator: CDVPlugin {
}

@property (nonatomic, assign) MBProgressHUD* activityIndicator;

- (void)show:(CDVInvokedUrlCommand*)command;
- (void)hide:(CDVInvokedUrlCommand*)command;

@end
