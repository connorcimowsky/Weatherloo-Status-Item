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
#import "Reachability.h"


static NSString *const UWWEndpointURL = @"https://api.uwaterloo.ca/v2/weather/current.json";
static const NSTimeInterval UWWUpdateInterval = 3.0 * 60.0;


@interface UWWAppDelegate ()

@property (nonatomic, strong) Reachability *reachability;
@property (nonatomic, strong) NSTimer *downloadTimer;
@property (nonatomic, strong) NSOperationQueue *processingQueue;
@property (nonatomic, strong) UWWReading *currentReading;
@property (nonatomic, strong) NSStatusItem *statusItem;
@property (nonatomic, strong) NSMenu *menu;

@end


@implementation UWWAppDelegate

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _reachability = [Reachability reachabilityForInternetConnection];
    [_reachability startNotifier];
    
    _processingQueue = [[NSOperationQueue alloc] init];
    _processingQueue.maxConcurrentOperationCount = 1;
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - NSApplicationDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    self.menu = [[NSMenu alloc] init];
    
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
    self.statusItem.highlightMode = YES;
    self.statusItem.menu = self.menu;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
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
    
    [NSURLConnection sendAsynchronousRequest:request queue:self.processingQueue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        UWWReading *reading = nil;
        
        if (!connectionError && data) {
            NSError *jsonError = nil;
            NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
            
            if (!jsonError && responseDictionary) {
                reading = [[UWWReading alloc] initWithResponseDictionary:responseDictionary];
            }
        }
        
        self.currentReading = reading;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateStatusItem];
        });
        
    }];
}

- (void)updateStatusItem
{
    if (self.currentReading.temperature) {
        self.statusItem.title = [NSString stringWithFormat:@"%@ ºC", [NSNumberFormatter localizedStringFromNumber:self.currentReading.temperature numberStyle:NSNumberFormatterDecimalStyle]];
    } else {
        self.statusItem.title = @"-- ºC";
    }
    
    [self.menu removeAllItems];
    
    [self.menu addItemWithTitle:@"Refresh" action:@selector(requestCurrentReading) keyEquivalent:@""];
    
    if (self.currentReading.observationTime) {
        [self.menu addItemWithTitle:[self.currentReading formattedObservationTime] action:NULL keyEquivalent:@""];
    }
    
    [self.menu addItem:[NSMenuItem separatorItem]];
    
    NSArray *formattedWeatherConditionStrings = [self.currentReading formattedWeatherConditionStrings];
    for (NSString *conditionString in formattedWeatherConditionStrings) {
        [self.menu addItemWithTitle:conditionString action:NULL keyEquivalent:@""];
    }
    
    if ([formattedWeatherConditionStrings count]) {
        [self.menu addItem:[NSMenuItem separatorItem]];
    }
    
    [self.menu addItemWithTitle:@"Quit" action:@selector(quitPressed) keyEquivalent:@""];
}

- (void)reachabilityChanged:(NSNotification *)notification
{
    [self requestCurrentReading];
}

- (void)quitPressed
{
    [[NSApplication sharedApplication] terminate:self];
}

@end
