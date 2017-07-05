//
//  Weather.h
//  WeatherApp
//
//  Created by Дмитрий Юргель on 28.06.17.
//  Copyright © 2017 Дмитрий Юргель. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Weather : NSObject {
    NSString *_city;
    NSDictionary *_data;
}

+ (Weather*)initWithCityAndData:(NSString*)city andData:(NSData*)data;
- (void)setCity:(NSString*)city;
- (NSString*)city;
- (void)setDataDictionary:(NSDictionary*)data;
- (NSDictionary*)dataDictionary;
- (int)temperature;
- (NSString*)weatherIcon;
- (int)wind;
- (int)humidity;
- (int)pressure;
@end
