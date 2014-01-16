//
//  UWWReading+UWWFormattingAdditions.h
//  WeatherlooStatusItem
//
//  Created by Connor Cimowsky on 1/16/14.
//  Copyright (c) 2014 Connor Cimowsky. All rights reserved.
//

#import "UWWReading.h"


@interface UWWReading (UWWFormattingAdditions)

- (NSString *)formattedObservationTime;
- (NSString *)formattedTemperature;
- (NSString *)formattedHumidex;
- (NSString *)formattedWindChill;
- (NSString *)formattedRelativeHumidity;
- (NSString *)formattedDewPoint;
- (NSString *)formattedWindSpeedAndDirection;
- (NSString *)formattedPressureAndPressureTrend;
- (NSString *)formattedRadiation;

- (NSArray *)formattedWeatherConditionStrings;

@end
