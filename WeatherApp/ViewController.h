//
//  ViewController.h
//  WeatherApp
//
//  Created by Дмитрий Юргель on 22.06.17.
//  Copyright © 2017 Дмитрий Юргель. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdvancedTableViewController.h"

@interface ViewController : UIViewController

@property (strong, nonatomic) UITableView *table;
@property (strong, nonatomic) NSString *them;
@property (strong, nonatomic) NSMutableArray *weatherData;
@property (strong, nonatomic) UIBarButtonItem *addBut;
@property (strong, nonatomic) UIBarButtonItem *backBut;
@property (strong, nonatomic) AdvancedTableViewController *advancedTable;


- (NSData*)getDataFromServer:(NSArray*) location;
- (NSArray*)getLatitudeAndLongitude:(NSString *) city;
- (IBAction)addCity;
- (IBAction)goBackView;
@end

