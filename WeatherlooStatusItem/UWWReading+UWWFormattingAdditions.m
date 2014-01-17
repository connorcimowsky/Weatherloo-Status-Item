//
//  UWWReading+UWWFormattingAdditions.m
//  WeatherlooStatusItem
//
//  Created by Connor Cimowsky on 1/16/14.
//  Copyright (c) 2014 Connor Cimowsky. All rights reserved.
//

#import "UWWReading+UWWFormattingAdditions.h"


@implementation UWWReading (UWWFormattingAdditions)

#pragma mark - Public Methods

- (NSString *)formattedObservationTime
{
    if (!self.observationTime) {
        return nil;
    }
    
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterNoStyle;
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
    });
    
    return [NSString stringWithFormat:@"Current Reading: %@", [dateFormatter stringFromDate:self.observationTime]];
}

- (NSString *)formattedTemperature
{
    if (!self.temperature) {
        return nil;
    }
    
    NSString *temperatureString = [NSNumberFormatter localizedStringFromNumber:self.temperature numberStyle:NSNumberFormatterDecimalStyle];
    return [NSString stringWithFormat:@"Temperature: %@ ºC", temperatureString];
}

- (NSString *)formattedHumidex
{
    if (!self.humidex) {
        return nil;
    }
    
    NSString *humidexString = [NSNumberFormatter localizedStringFromNumber:self.humidex numberStyle:NSNumberFormatterDecimalStyle];
    return [NSString stringWithFormat:@"Humidex: %@ ºC", humidexString];
}

- (NSString *)formattedWindChill
{
    if (!self.windChill) {
        return nil;
    }
    
    NSString *windChillString = [NSNumberFormatter localizedStringFromNumber:self.windChill numberStyle:NSNumberFormatterDecimalStyle];
    return [NSString stringWithFormat:@"Windchill: %@ ºC", windChillString];
}

- (NSString *)formattedRelativeHumidity
{
    if (!self.relativeHumidity) {
        return nil;
    }
    
    NSString *relativeHumidityString = [NSNumberFormatter localizedStringFromNumber:self.relativeHumidity numberStyle:NSNumberFormatterDecimalStyle];
    return [NSString stringWithFormat:@"Relative Humidity: %@%%", relativeHumidityString];
}

- (NSString *)formattedDewPoint
{
    if (!self.dewPoint) {
        return nil;
    }
    
    NSString *dewPointString = [NSNumberFormatter localizedStringFromNumber:self.dewPoint numberStyle:NSNumberFormatterDecimalStyle];
    return [NSString stringWithFormat:@"Dew Point: %@ ºC", dewPointString];
}

- (NSString *)formattedWindSpeedAndDirection
{
    if (!self.windSpeed || !self.windDirection) {
        return nil;
    }
    
    NSString *windSpeedString = [NSNumberFormatter localizedStringFromNumber:self.windSpeed numberStyle:NSNumberFormatterDecimalStyle];
    NSString *windDirectionString = [NSNumberFormatter localizedStringFromNumber:self.windDirection numberStyle:NSNumberFormatterDecimalStyle];
    return [NSString stringWithFormat:@"Wind Speed: %@ km/h, %@º", windSpeedString, windDirectionString];
}

- (NSString *)formattedPressureAndPressureTrend
{
    if (!self.pressure || !self.pressureTrend) {
        return nil;
    }
    
    NSString *pressureString = [NSNumberFormatter localizedStringFromNumber:self.pressure numberStyle:NSNumberFormatterDecimalStyle];
    return [NSString stringWithFormat:@"Pressure: %@ kPa, %@", pressureString, self.pressureTrend];
}

- (NSString *)formattedRadiation
{
    if (!self.radiation) {
        return nil;
    }
    
    NSString *radiationString = [NSNumberFormatter localizedStringFromNumber:self.radiation numberStyle:NSNumberFormatterDecimalStyle];
    return [NSString stringWithFormat:@"Incoming Radiation: %@ W/m²", radiationString];
}

- (NSArray *)formattedWeatherConditionStrings
{
    NSMutableArray *formattedWeatherConditionStrings = [[NSMutableArray alloc] init];
    
    NSString *formattedTemperature = [self formattedTemperature];
    if (formattedTemperature) {
        [formattedWeatherConditionStrings addObject:formattedTemperature];
    }
    
    NSString *formattedHumidex = [self formattedHumidex];
    if (formattedHumidex) {
        [formattedWeatherConditionStrings addObject:formattedHumidex];
    }
    
    NSString *formattedWindChill = [self formattedWindChill];
    if (formattedWindChill) {
        [formattedWeatherConditionStrings addObject:formattedWindChill];
    }
    
    NSString *formattedRelativeHumidity = [self formattedRelativeHumidity];
    if (formattedRelativeHumidity) {
        [formattedWeatherConditionStrings addObject:formattedRelativeHumidity];
    }
    
    NSString *formattedDewPoint = [self formattedDewPoint];
    if (formattedDewPoint) {
        [formattedWeatherConditionStrings addObject:formattedDewPoint];
    }
    
    NSString *formattedWindSpeedAndDirection = [self formattedWindSpeedAndDirection];
    if (formattedWindSpeedAndDirection) {
        [formattedWeatherConditionStrings addObject:formattedWindSpeedAndDirection];
    }
    
    NSString *formattedPressureAndPressureTrend = [self formattedPressureAndPressureTrend];
    if (formattedPressureAndPressureTrend) {
        [formattedWeatherConditionStrings addObject:formattedPressureAndPressureTrend];
    }
    
    NSString *formattedRadiation = [self formattedRadiation];
    if (formattedRadiation) {
        [formattedWeatherConditionStrings addObject:formattedRadiation];
    }
    
    return [formattedWeatherConditionStrings copy];
}

@end
