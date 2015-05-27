#import <Cordova/CDV.h>
#import "ProgressIndicator.h"
#import "MBProgressHUD.h"

@implementation ProgressIndicator
@synthesize progressIndicator;


/**
 * SIMPLE
 */

- (void)showSimple:(CDVInvokedUrlCommand *)command {
    
    // obtain commands
    bool dim = [[command.arguments objectAtIndex:0] boolValue];
    //UIColor* color = [command.arguments objectAtIndex:1];
    
    // initialize indicator with options, text, detail
    self.progressIndicator = nil;
    self.progressIndicator = [MBProgressHUD showHUDAddedTo:self.webView.superview animated:YES];
    self.progressIndicator.mode = MBProgressHUDModeIndeterminate;
    
    // Check if dim : true ? false
    if (dim == true) {
        self.progressIndicator.dimBackground = YES;
    }
    
    // Cordova success
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}



/**
 * SIMPLE with LABEL
 */

- (void)showSimpleWithLabel:(CDVInvokedUrlCommand *)command {
    
    // obtain commands
    bool dim = [[command.arguments objectAtIndex:0] boolValue];
    NSString* text = [command.arguments objectAtIndex:1];
    //UIColor* color = [command.arguments objectAtIndex:2];
    
    // initialize indicator with options, text, detail
    self.progressIndicator = nil;
    self.progressIndicator = [MBProgressHUD showHUDAddedTo:self.webView.superview animated:YES];
    self.progressIndicator.mode = MBProgressHUDModeIndeterminate;
    self.progressIndicator.labelText = text;
    //self.progressIndicator.color =  [UIColor color:color];
    //HUD.color = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
    
    // Check if dim : true ? false
    if (dim == true) {
        self.progressIndicator.dimBackground = YES;
    }
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    
}



/**
 * SIMPLE with LABEL and DETAIL
 */
- (void)showSimpleWithLabelDetail:(CDVInvokedUrlCommand *)command   {
    // obtain commands
    bool dim = [[command.arguments objectAtIndex:0] boolValue];
    NSString* text = [command.arguments objectAtIndex:1];
    NSString* detail = [command.arguments objectAtIndex:2];
    //UIColor* color = [command.arguments objectAtIndex:3];
    
    // initialize indicator with options, text, detail
    self.progressIndicator = nil;
    self.progressIndicator = [MBProgressHUD showHUDAddedTo:self.webView.superview animated:YES];
    self.progressIndicator.mode = MBProgressHUDModeIndeterminate;
    self.progressIndicator.labelText = text;
    self.progressIndicator.detailsLabelText = detail;
    //self.progressIndicator.color =  [UIColor color:color];
    //HUD.color = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];
    
    // Check for dim : true ? false
    if (dim == true) {
        self.progressIndicator.dimBackground = YES;
    }
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}




/**
 * TEXT ONLY
 */

- (void)showText:(CDVInvokedUrlCommand *)command {
    
    // obtain commands
    bool dim = [[command.arguments objectAtIndex:0] boolValue];
    NSString* text = [command.arguments objectAtIndex:1];
    NSString* position = [command.arguments objectAtIndex:2];
    //UIColor* color = [command.arguments objectAtIndex:2];
    
    // initialize indicator with options, text, detail
    self.progressIndicator = nil;
    self.progressIndicator = [MBProgressHUD showHUDAddedTo:self.webView.superview animated:YES];
    self.progressIndicator.mode = MBProgressHUDModeText;
    self.progressIndicator.labelText = text;
	self.progressIndicator.margin = 10.f;
    
    
    if ([position isEqualToString:@"top"]) {
        self.progressIndicator.yOffset = -150.f;
    }
    else if ([position isEqualToString:@"bottom"]) {
        self.progressIndicator.yOffset = 200.f;
    }
    else {
        CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
		return;
    }
	
    
    // Check for dim : true ? false
    if (dim == true) {
        self.progressIndicator.dimBackground = YES;
    }
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
    
}




/**
 * DETERMINATE
 */

-(void)showDeterminate:(CDVInvokedUrlCommand *)command {
    
    // obtain commands
    bool dim = [[command.arguments objectAtIndex:0] boolValue];
    int increment = [[command.arguments objectAtIndex:1] intValue];
    NSNumber* incrementValue = @(increment);
    
    // initialize indicator with options, text, detail
    self.progressIndicator = nil;
    self.progressIndicator = [MBProgressHUD showHUDAddedTo:self.webView.superview animated:YES];
    self.progressIndicator.mode = MBProgressHUDModeDeterminate;
    
    
    // Check for dim : true ? false
    if (dim == true) {
        self.progressIndicator.dimBackground = YES;
    }
    
    // Load Progress bar with ::incrementValue
    [self.progressIndicator showWhileExecuting:@selector(progressTask:) onTarget:self withObject:incrementValue animated:YES];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}



/**
 *  DETERMINATE with LABEL
 */

-(void)showDeterminateWithLabel:(CDVInvokedUrlCommand *)command {
    
    // obtain commands
    bool dim = [[command.arguments objectAtIndex:0] boolValue];
    int increment = [[command.arguments objectAtIndex:1] intValue];
    NSNumber* incrementValue = @(increment);
    NSString* text = [command.arguments objectAtIndex:2];
    
    // initialize indicator with options, text, detail
    self.progressIndicator = nil;
    self.progressIndicator = [MBProgressHUD showHUDAddedTo:self.webView.superview animated:YES];
    self.progressIndicator.mode = MBProgressHUDModeDeterminate;
    self.progressIndicator.labelText = text;
    
    // Check for dim : true ? false
    if (dim == true) {
        self.progressIndicator.dimBackground = YES;
    }
    
    // Load Progress bar with ::incrementValue
    [self.progressIndicator showWhileExecuting:@selector(progressTask:) onTarget:self withObject:incrementValue animated:YES];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}



/**
 * DETERMINATE ANNULAR
 */

- (void)showDeterminateAnnular:(CDVInvokedUrlCommand *)command  {
    
    // obtain commands
    bool dim = [[command.arguments objectAtIndex:0] boolValue];
    int increment = [[command.arguments objectAtIndex:1] intValue];
    NSNumber* incrementValue = @(increment);
    
    // initialize indicator with options, text, detail
    self.progressIndicator = nil;
    self.progressIndicator = [MBProgressHUD showHUDAddedTo:self.webView.superview animated:YES];
    self.progressIndicator.mode = MBProgressHUDModeAnnularDeterminate;
    
    // Check for dim : true ? false
    if (dim == true) {
        self.progressIndicator.dimBackground = YES;
    }
    
    // Load Progress bar with ::incrementValue
    [self.progressIndicator showWhileExecuting:@selector(progressTask:) onTarget:self withObject:incrementValue animated:YES];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}



/**
 * DETERMINATE ANNULAR with LABEL
 */
- (void)showDeterminateAnnularWithLabel:(CDVInvokedUrlCommand *)command  {
    
    // obtain commands
    bool dim = [[command.arguments objectAtIndex:0] boolValue];
    int increment = [[command.arguments objectAtIndex:1] intValue];
    NSNumber* incrementValue = @(increment);
    NSString* text = [command.arguments objectAtIndex:2];
    
    // initialize indicator with options, text, detail
    self.progressIndicator = nil;
    self.progressIndicator = [MBProgressHUD showHUDAddedTo:self.webView.superview animated:YES];
    self.progressIndicator.mode = MBProgressHUDModeAnnularDeterminate;
    self.progressIndicator.labelText = text;
    
    // Check for dim : true ? false
    if (dim == true) {
        self.progressIndicator.dimBackground = YES;
    }
    
    // Load Progress bar with ::incrementValue
    [self.progressIndicator showWhileExecuting:@selector(progressTask:) onTarget:self withObject:incrementValue animated:YES];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}



/**
 * DETERMINATE BAR
 */

- (void)showDeterminateBar:(CDVInvokedUrlCommand *)command {
    
    // obtain commands
    bool dim = [[command.arguments objectAtIndex:0] boolValue];
    int increment = [[command.arguments objectAtIndex:1] intValue];
    NSNumber* incrementValue = @(increment);
    
    // initialize indicator with options, text, detail
    self.progressIndicator = nil;
    self.progressIndicator = [MBProgressHUD showHUDAddedTo:self.webView.superview animated:YES];
    self.progressIndicator.mode = MBProgressHUDModeDeterminateHorizontalBar;
    
    
    // Check for dim : true ? false
    if (dim == true) {
        self.progressIndicator.dimBackground = YES;
    }
    
    // Load Progress bar with ::incrementValue
    [self.progressIndicator showWhileExecuting:@selector(progressTask:) onTarget:self withObject:incrementValue animated:YES];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}



/**
 * DETERMINATE BAR with LABEL
 */

- (void)showDeterminateBarWithLabel:(CDVInvokedUrlCommand *)command {
    
    // obtain commands
    bool dim = [[command.arguments objectAtIndex:0] boolValue];
    int increment = [[command.arguments objectAtIndex:1] intValue];
    NSNumber* incrementValue = @(increment);
    NSString* text = [command.arguments objectAtIndex:2];
    
    // initialize indicator with options, text, detail
    self.progressIndicator = nil;
    self.progressIndicator = [MBProgressHUD showHUDAddedTo:self.webView.superview animated:YES];
    self.progressIndicator.mode = MBProgressHUDModeDeterminateHorizontalBar;
    self.progressIndicator.labelText = text;
    
    
    // Check for dim : true ? false
    if (dim == true) {
        self.progressIndicator.dimBackground = YES;
    }
    
    // Load Progress bar with ::incrementValue
    [self.progressIndicator showWhileExecuting:@selector(progressTask:) onTarget:self withObject:incrementValue animated:YES];
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}


/**
 * SUCCESS
 */

-(void)showSuccess:(CDVInvokedUrlCommand *)command {
    
    // obtain commands
    bool dim = [[command.arguments objectAtIndex:0] boolValue];
    NSString* text = [command.arguments objectAtIndex:1];
    
    // initialize indicator with options, text, detail
    self.progressIndicator = nil;
    self.progressIndicator = [MBProgressHUD showHUDAddedTo:self.webView.superview animated:YES];
    self.progressIndicator.mode = MBProgressHUDModeCustomView;
    self.progressIndicator.labelText = text;
    
    // custom success image from bundle
    NSString *image = @"ProgressIndicator.bundle/37x-Checkmark.png";
    self.progressIndicator.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
    
    
    // Check for dim : true ? false
    if (dim == true) {
        self.progressIndicator.dimBackground = YES;
    }
    
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}



/**
 * MULTIPLE STEPS using array
 
 
 - (void)showMultiple:(CDVInvokedUrlCommand*)command {
 
 // obtain commands
 bool dim = [[command.arguments objectAtIndex:0] boolValue];
 NSArray = [commands.arguments objectAtIndex:1];
 
 
 // initialize indicator with options, text, detail
 self.progressIndicator = nil;
 self.progressIndicator = [MBProgressHUD showHUDAddedTo:self.webView.superview animated:YES];
 self.progressIndicator.mode = MBProgressHUDModeCustomView;
 self.progressIndicator.labelText = text;
 
 // custom success image from bundle
 NSString *image = @"progressIndicator.bundle/37x-Checkmark.png";
 self.progressIndicator.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:image]];
 
 
 // Check for dim : true ? false
 if (dim == true) {
 self.progressIndicator.dimBackground = YES;
 }
 
 CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
 [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
 
 }
 */

/**
 * HIDE
 */

- (void)hide:(CDVInvokedUrlCommand*)command
{
	if (!self.progressIndicator) {
		CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR];
		[self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
		return;
	}
	[self.progressIndicator hide:YES];
    CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:@""];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
}



/**
 * PROGRESS TASK EVENT
 */

- (void)progressTask:(NSNumber *)increment{
    
    // get increment value
    int _increment = [increment intValue];
    
    float progress = 0.0f;
    while (progress < 1.0f) {
        progress += 0.01f;
        self.progressIndicator.progress = progress;
        
        // increment in microseconds (100000mms = 1s)
        usleep(_increment);
    }
}

@end
