//UniversalAnalyticsPlugin.h
//Created by Daniel Wilson 2013-09-19

#import <Foundation/Foundation.h>
#import <Cordova/CDV.h>
#import "GAI.h"

@interface UniversalAnalyticsPlugin : CDVPlugin {
    bool _trackerStarted;
    bool _debugMode;
	NSMutableDictionary *_customDimensions;
}

- (void) startTrackerWithId: (CDVInvokedUrlCommand*)command;
- (void) setUserId: (CDVInvokedUrlCommand*)command;
- (void) debugMode: (CDVInvokedUrlCommand*)command;
- (void) addCustomDimension: (CDVInvokedUrlCommand*)command;
- (void) trackEvent: (CDVInvokedUrlCommand*)command;
- (void) trackTiming: (CDVInvokedUrlCommand*)command;
- (void) trackView: (CDVInvokedUrlCommand*)command;
- (void) trackException: (CDVInvokedUrlCommand*)command;
- (void) addTransaction: (CDVInvokedUrlCommand*)command;
- (void) addTransactionItem: (CDVInvokedUrlCommand*)command;

@end

