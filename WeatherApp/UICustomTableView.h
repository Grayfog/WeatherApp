//
//  UICustomTableView.h
//  WeatherApp
//
//  Created by Дмитрий Юргель on 03.07.17.
//  Copyright © 2017 Дмитрий Юргель. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICustomTableView : UITableView

+ (UITableView*) initCustomTableWithThem:(NSString*)them style:(UITableViewStyle*)style;

@end
