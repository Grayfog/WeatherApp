//
//  ViewController.m
//  WeatherApp
//
//  Created by Дмитрий Юргель on 22.06.17.
//  Copyright © 2017 Дмитрий Юргель. All rights reserved.
//

#define APP_NAME @"WeatherApp"

#import "ViewController.h"
#import "Weather.h"
#import "UICustomTableView.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSDate *currTime = [NSDate date];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"HH"];
    int time = [format stringFromDate:currTime].intValue;
    [format release];
    if (((int)time >= 6) && ((int)time <= 20))
    {
        _them = [[NSString alloc] initWithString:@"Day.jpg"];
    }
    else
    {
        _them = [[NSString alloc] initWithString:@"Nite.jpg"];
    }
    
    [self configureTable];
    
    NSArray *cities = [[NSArray alloc] initWithObjects:@"Minsk", @"Moskow", nil];
    _weatherData = [[NSMutableArray alloc] initWithCapacity:1];
    
    for (int i = 0; i < cities.count; i++){
        Weather *weather = [Weather initWithCityAndData:[cities objectAtIndex:i] andData:[self getDataFromServer:[self getLatitudeAndLongitude:cities[i]]]];
        [_weatherData addObject:weather];
        [weather release];
    }
    
    [cities release];
}



-(void)loadView {
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    _addBut = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStyleDone target:self action:@selector(addCity)];
    _backBut = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(goBackView)];
    [self.navigationItem setRightBarButtonItem:_addBut animated:YES];
    [self.navigationItem setTitle:APP_NAME];
}

- (void)configureTable {
    self.table = [UICustomTableView initCustomTableWithThem:_them style:UITableViewStylePlain];
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.view addSubview:self.table];
}

- (NSArray*)getLatitudeAndLongitude:(NSString*) city{
    NSURLResponse *response;
    NSError *error;
    NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?address=%@&key=AIzaSyAIHUsvjOvRvc5BsZMnoTazQuaBKL-piW0", city];
    NSData *data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] returningResponse:&response error:&error];
    
    if (data) {
        NSData *jsonData = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        NSArray *location = [jsonData valueForKeyPath:@"results.geometry.location"];
        return location;
    }
    return nil;
}

- (NSData*)getDataFromServer:(NSArray*) location{
    
    NSURLResponse *response;
    NSError *error;
    NSString *lat = [location[0] valueForKey:@"lat"];
    NSString *lng = [location[0] valueForKey:@"lng"];
    NSString *url = [NSString stringWithFormat:@"https://api.darksky.net/forecast/2bde88605c69bf742e02046b37eeb341/%@,%@", lat, lng];
        
    NSData *data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]] returningResponse:&response error:&error];
        
    if (data)
    {
        NSData *jsonData = [NSJSONSerialization JSONObjectWithData: data options:kNilOptions error:&error];
        return jsonData;
    }
    
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_weatherData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [self.table dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
        [cell setBackgroundColor:[UIColor clearColor]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text =  [[_weatherData objectAtIndex:indexPath.row] city];
    
    NSString *detail = [[NSString alloc] initWithFormat:@"Current temperature %i °C", [[_weatherData objectAtIndex:indexPath.row] temperature]];
    cell.detailTextLabel.text = detail;
    [detail release];
    @try {
        cell.imageView.image = [UIImage imageNamed: [[_weatherData objectAtIndex:indexPath.row] weatherIcon]];
    } @catch (NSException *exception) {
        cell.imageView.image = nil;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    _advancedTable = [AdvancedTableViewController initWithData:[_weatherData objectAtIndex:indexPath.row] them:_them];
    [_advancedTable.tableView setFrame:CGRectMake(0, 50, self.view.bounds.size.width, self.view.bounds.size.height)];
    [self.navigationItem setTitle:[[_weatherData objectAtIndex:indexPath.row] city]];
    [self.navigationItem setLeftBarButtonItem:_backBut];
    [self.navigationItem setRightBarButtonItem:nil];
    [self.view addSubview:_advancedTable.tableView];
}

- (IBAction)addCity{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add"
                                                                   message:@"Add your city:"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
        
        @try{
            NSString *city = [NSString stringWithString:alert.textFields[0].text];
            Weather *weather = [Weather initWithCityAndData:city andData:[self getDataFromServer:[self getLatitudeAndLongitude:city]]];
            [_weatherData addObject:weather];
            [_table reloadData];
        }
        @catch (NSException *e){
            UIAlertController *error = [UIAlertController alertControllerWithTitle:@"Error" message:@"Not found your city!" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [error addAction:okAction];
            [self presentViewController:error animated:YES completion:nil];
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             //cancel action
                                                         }];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (IBAction)goBackView{
    [_advancedTable.tableView removeFromSuperview];
    [_advancedTable release];
    [self.navigationItem setRightBarButtonItem:_addBut];
    [self.navigationItem setLeftBarButtonItem: nil];
    [self.navigationItem setTitle:APP_NAME];
}
@end
