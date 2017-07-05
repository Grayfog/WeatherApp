//
//  AdvancedTableViewController.h
//  WeatherApp
//
//  Created by Дмитрий Юргель on 03.07.17.
//  Copyright © 2017 Дмитрий Юргель. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Weather.h"
@interface AdvancedTableViewController : UITableViewController {
    NSDictionary *_data;
}

@property (strong, nonatomic) NSString *them;

+ (AdvancedTableViewController*)initWithData:(Weather*)data them:(NSString*)them;
- (void)setData:(Weather*)weather;
- (NSArray*)curentDataWeather:(NSInteger)index;

@end
