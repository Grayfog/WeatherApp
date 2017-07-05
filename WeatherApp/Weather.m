//
//  Weather.m
//  WeatherApp
//
//  Created by Дмитрий Юргель on 28.06.17.
//  Copyright © 2017 Дмитрий Юргель. All rights reserved.
//

#import "Weather.h"

@implementation Weather

+ (Weather*)initWithCityAndData:(NSString*)city andData:(NSData *)data{
    Weather *result = [[Weather alloc] init];
    [result setCity:city];

    NSMutableDictionary *dataDictionary = [[NSMutableDictionary alloc] initWithCapacity:1];
    NSData *currently = [data valueForKey:@"currently"];
    NSMutableDictionary *currentlyDictionary = [[NSMutableDictionary alloc] initWithCapacity:1];
    [currentlyDictionary setObject:[currently valueForKey:@"summary"] forKey:@"summary"];
    [currentlyDictionary setObject:[currently valueForKey:@"windSpeed"] forKey:@"windSpeed"];
    [currentlyDictionary setObject:[currently valueForKey:@"humidity"] forKey:@"humidity"];
    [currentlyDictionary setObject:[currently valueForKey:@"pressure"] forKey:@"pressure"];
    [currentlyDictionary setObject:[currently valueForKey:@"icon"] forKey:@"icon"];
    [currentlyDictionary setObject:[currently valueForKey:@"temperature"] forKey:@"temperature"];
    [dataDictionary setObject:currentlyDictionary forKey:@"currently"];
    [currentlyDictionary release];
    NSArray *daily = [data valueForKeyPath:@"daily.data"];
    NSMutableArray *dayArr = [[NSMutableArray alloc] initWithCapacity:1];
    for (int i = 1; i <= 7; i++)
    {
        NSMutableDictionary *tempDay = [[NSMutableDictionary alloc] initWithCapacity:1];
        NSTimeInterval timeStamp = [[daily[i] valueForKey:@"time"] doubleValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeStamp];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEEE"];
        NSString *day = [dateFormatter stringFromDate:date];
        [dateFormatter release];
        [tempDay setObject:day forKey:@"day"];
        [tempDay setObject:[daily[i] valueForKey:@"icon"] forKey:@"icon"];
        [tempDay setObject:[daily[i] valueForKey:@"temperatureMin"] forKey:@"temperatureMin"];
        [tempDay setObject:[daily[i] valueForKey:@"temperatureMax"] forKey:@"temperatureMax"];
        [dayArr addObject:tempDay];
        [tempDay release];
    }
    [dataDictionary setObject:dayArr forKey:@"onWeek"];
    [result setDataDictionary:dataDictionary];
    [dayArr release];
    NSLog(@"%@",dataDictionary);
    [dataDictionary release];
    return result;
}

- (void)setCity:(NSString*)city{
    _city = [[NSString alloc] initWithString:city];
}

- (void)setDataDictionary:(NSDictionary*)data{
    _data = [[NSDictionary alloc] initWithDictionary:data];
}

- (NSString*)city{
    return _city;
}

- (NSDictionary*)dataDictionary{
    return _data;
}

- (int)temperature{
    float temperatureFahrenheit = [[_data valueForKeyPath:@"currently.temperature"] floatValue];
    int temperatureCelsius = (temperatureFahrenheit - 32) * 5 / 9;
    return temperatureCelsius;
}

- (NSString*)weatherIcon{
    return [_data valueForKeyPath:@"currently.icon"];
}

- (int)wind{
    float windSpeedInMile = [[_data valueForKeyPath:@"currently.windSpeed"] floatValue];
    int windSpeedInMetr = windSpeedInMile * 0.44704;
    return windSpeedInMetr;
}

- (int)humidity{
    return [[_data valueForKeyPath:@"currently.humidity"] floatValue] * 100;
}

- (int)pressure{
    return [[_data valueForKeyPath:@"currently.pressure"] intValue];
}



@end
