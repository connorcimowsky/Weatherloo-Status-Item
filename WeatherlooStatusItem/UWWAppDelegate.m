//
//  UWWAppDelegate.m
//  WeatherlooStatusItem
//
//  Created by Connor Cimowsky on 1/14/14.
//  Copyright (c) 2014 Connor Cimowsky. All rights reserved.
//

#import "UWWAppDelegate.h"
#import "UWWReading.h"
#import "UWWReading+UWWFormattingAdditions.h"


static NSString *const UWWEndpointURL = @"https://api.uwaterloo.ca/v2/weather/current.json";
static const NSTimeInterval UWWUpdateInterval = 5.0 * 60.0;


@interface UWWAppDelegate ()

@property (nonatomic, strong) NSTimer *downloadTimer;
@property (nonatomic, strong) NSOperationQueue *downloadQueue;
@property (nonatomic, strong) UWWReading *currentReading;
@property (nonatomic, strong) NSStatusItem *statusItem;

@end


@implementation UWWAppDelegate

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _downloadQueue = [[NSOperationQueue alloc] init];
    _downloadQueue.maxConcurrentOperationCount = 1;
    
    return self;
}

#pragma mark - NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    self.downloadTimer = [NSTimer scheduledTimerWithTimeInterval:UWWUpdateInterval
                                                          target:self
                                                        selector:@selector(requestCurrentReading)
                                                        userInfo:nil
                                                         repeats:YES];
    [self.downloadTimer fire];
}

- (void)applicationWillTerminate:(NSNotification *)notification
{
    [self.downloadTimer invalidate];
    self.downloadTimer = nil;
}

#pragma mark - Private Methods

- (void)requestCurrentReading
{
    NSURL *endpointURL = [NSURL URLWithString:UWWEndpointURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:endpointURL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    [NSURLConnection sendAsynchronousRequest:request queue:self.downloadQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        if (!connectionError && data) {
            NSError *jsonError = nil;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            
            if (!jsonError && responseDictionary) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.currentReading = [[UWWReading alloc] initWithResponseDictionary:responseDictionary];
                    [self updateStatusItem];
                });
            }
        }
        
    }];
}

- (void)updateStatusItem
{
    if (!self.currentReading) {
        self.statusItem = nil;
        return;
    }
    
    if (!self.statusItem) {
        self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
        self.statusItem.highlightMode = YES;
    }
    
    self.statusItem.title = [NSString stringWithFormat:@"%@ ºC", [NSNumberFormatter localizedStringFromNumber:self.currentReading.temperature numberStyle:NSNumberFormatterDecimalStyle]];
    
    NSMenu *menu = [[NSMenu alloc] init];
    
    [menu addItemWithTitle:@"Refresh" action:@selector(requestCurrentReading) keyEquivalent:@""];
    
    if (self.currentReading.observationTime) {
        [menu addItemWithTitle:[self.currentReading formattedObservationTime] action:NULL keyEquivalent:@""];
    }
    
    [menu addItem:[NSMenuItem separatorItem]];
    
    NSArray *formattedWeatherConditionStrings = [self.currentReading formattedWeatherConditionStrings];
    for (NSString *conditionString in formattedWeatherConditionStrings) {
        [menu addItemWithTitle:conditionString action:NULL keyEquivalent:@""];
    }
    
    self.statusItem.menu = menu;
}

@end
