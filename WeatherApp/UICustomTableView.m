//
//  UICustomTableView.m
//  WeatherApp
//
//  Created by Дмитрий Юргель on 03.07.17.
//  Copyright © 2017 Дмитрий Юргель. All rights reserved.
//

#import "UICustomTableView.h"

@implementation UICustomTableView



+ (UITableView*) initCustomTableWithThem:(NSString*)them style:(UITableViewStyle*)style{
    UITableView *result = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds] style:style];
    result.rowHeight = 75;
    result.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIImage *background;
    background = [UIImage imageNamed:them];
    result.backgroundView = [[UIImageView new] autorelease];
    ((UIImageView *)result.backgroundView).image = background;
    return result;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
