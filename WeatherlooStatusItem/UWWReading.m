//
//  UWWReading.m
//  WeatherlooStatusItem
//
//  Created by Connor Cimowsky on 1/15/14.
//  Copyright (c) 2014 Connor Cimowsky. All rights reserved.
//

#import "UWWReading.h"
#import "ISO8601DateFormatter.h"


@interface UWWReading () <NSURLConnectionDelegate>

@property (nonatomic, strong, readwrite) NSDate *observationTime;
@property (nonatomic, strong, readwrite) NSNumber *temperature;
@property (nonatomic, strong, readwrite) NSNumber *humidex;
@property (nonatomic, strong, readwrite) NSNumber *windChill;
@property (nonatomic, strong, readwrite) NSNumber *relativeHumidity;
@property (nonatomic, strong, readwrite) NSNumber *dewPoint;
@property (nonatomic, strong, readwrite) NSNumber *windSpeed;
@property (nonatomic, strong, readwrite) NSNumber *windDirection;
@property (nonatomic, strong, readwrite) NSNumber *pressure;
@property (nonatomic, copy, readwrite) NSString *pressureTrend;
@property (nonatomic, strong, readwrite) NSNumber *radiation;

@end


@implementation UWWReading

#pragma mark - Lifecycle

- (instancetype)initWithResponseDictionary:(NSDictionary *)responseDictionary
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    NSNumber *statusCode = responseDictionary[@"meta"][@"status"];
    if (statusCode.integerValue != 200) {
        return nil;
    }
    
    NSDictionary *responseData = responseDictionary[@"data"];
    
    NSString *observationTime = responseData[@"observation_time"];
    if (![observationTime isKindOfClass:[NSNull class]]) {
        ISO8601DateFormatter *dateFormatter = [[ISO8601DateFormatter alloc] init];
        self.observationTime = [dateFormatter dateFromString:observationTime];
    }
    
    NSNumber *temperature = responseData[@"temperature_current_c"];
    if (![temperature isKindOfClass:[NSNull class]]) {
        self.temperature = temperature;
    }
    
    NSNumber *humidex = responseData[@"humidex_c"];
    if (![humidex isKindOfClass:[NSNull class]]) {
        self.humidex = humidex;
    }
    
    NSNumber *windChill = responseData[@"windchill_c"];
    if (![windChill isKindOfClass:[NSNull class]]) {
        self.windChill = windChill;
    }
    
    NSNumber *relativeHumidity = responseData[@"relative_humidity_percent"];
    if (![relativeHumidity isKindOfClass:[NSNull class]]) {
        self.relativeHumidity = relativeHumidity;
    }
    
    NSNumber *dewPoint = responseData[@"dew_point_c"];
    if (![dewPoint isKindOfClass:[NSNull class]]) {
        self.dewPoint = dewPoint;
    }
    
    NSNumber *windSpeed = responseData[@"wind_speed_kph"];
    if (![windSpeed isKindOfClass:[NSNull class]]) {
        self.windSpeed = windSpeed;
    }
    
    NSNumber *windDirection = responseData[@"wind_direction_degrees"];
    if (![windDirection isKindOfClass:[NSNull class]]) {
        self.windDirection = windDirection;
    }
    
    NSNumber *pressure = responseData[@"pressure_kpa"];
    if (![pressure isKindOfClass:[NSNull class]]) {
        self.pressure = pressure;
    }
    
    NSString *pressureTrend = responseData[@"pressure_trend"];
    if (![pressureTrend isKindOfClass:[NSNull class]]) {
        self.pressureTrend = pressureTrend;
    }
    
    NSNumber *radiation = responseData[@"incoming_shortwave_radiation_wm2"];
    if (![radiation isKindOfClass:[NSNull class]]) {
        self.radiation = radiation;
    }
    
    return self;
}

@end
