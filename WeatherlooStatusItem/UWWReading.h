//
//  UWWReading.h
//  WeatherlooStatusItem
//
//  Created by Connor Cimowsky on 1/15/14.
//  Copyright (c) 2014 Connor Cimowsky. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UWWReading : NSObject

- (instancetype)initWithResponseDictionary:(NSDictionary *)responseDictionary;

@property (nonatomic, strong, readonly) NSDate *observationTime;
@property (nonatomic, strong, readonly) NSNumber *temperature;
@property (nonatomic, strong, readonly) NSNumber *humidex;
@property (nonatomic, strong, readonly) NSNumber *windChill;
@property (nonatomic, strong, readonly) NSNumber *relativeHumidity;
@property (nonatomic, strong, readonly) NSNumber *dewPoint;
@property (nonatomic, strong, readonly) NSNumber *windSpeed;
@property (nonatomic, strong, readonly) NSNumber *windDirection;
@property (nonatomic, strong, readonly) NSNumber *pressure;
@property (nonatomic, copy, readonly) NSString *pressureTrend;
@property (nonatomic, strong, readonly) NSNumber *radiation;

@end
