//
//  AdvancedTableViewController.m
//  WeatherApp
//
//  Created by Дмитрий Юргель on 03.07.17.
//  Copyright © 2017 Дмитрий Юргель. All rights reserved.
//

#import "AdvancedTableViewController.h"
#import "UICustomTableView.h"


@interface AdvancedTableViewController ()

@end

@implementation AdvancedTableViewController


+ (AdvancedTableViewController*)initWithData:(Weather*)data them:(NSString*)them{
    AdvancedTableViewController *result = [[AdvancedTableViewController alloc] init];
    [result setData:data];
    result.tableView = [UICustomTableView initCustomTableWithThem:them style:UITableViewStyleGrouped];
    result.tableView.delegate = result;
    result.tableView.dataSource = result;
    [result.tableView setRowHeight:50];
    return result;
    
}

- (void)dealloc
{
    [_data release];
    [_them release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [_data count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *currentData = [self curentDataWeather:section];
    return [currentData count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return [[_data allKeys] objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSArray *curentData = [self curentDataWeather:indexPath.section];
    
    if (indexPath.section == 0)
    {
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        cell.textLabel.text = curentData[indexPath.row];
    }
    else if (indexPath.section == 1){
        if(cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        }
        cell.textLabel.text = curentData[indexPath.row][0];
        cell.imageView.image = [UIImage imageNamed:curentData[indexPath.row][1]];
        cell.detailTextLabel.text = curentData[indexPath.row][2];
    }

    
    

    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)setData:(Weather*)weather{
    NSMutableDictionary *tempData = [[NSMutableDictionary alloc] initWithCapacity:1];
    NSMutableArray *todayData = [[NSMutableArray alloc] initWithCapacity:1];
    NSString *tempStr = [NSString stringWithFormat:@"Current temperature: %i °C", [weather temperature]];
    [todayData addObject:tempStr];
    tempStr = [NSString stringWithFormat:@"Wind: %i m/s", [weather wind]];
    [todayData addObject:tempStr];
    tempStr = [NSString stringWithFormat:@"Humidity: %i%%", [weather humidity]];
    [todayData addObject:tempStr];
    tempStr = [NSString stringWithFormat:@"Pressure: %i hPa", [weather pressure]];
    [todayData addObject:tempStr];
    [tempData setValue:todayData forKey:@"Today"];
    [todayData release];
    
    NSMutableArray *onWeek = [[NSMutableArray alloc] initWithCapacity:1];
    NSArray *dataWeek = [NSArray arrayWithArray:[[weather dataDictionary] valueForKey:@"onWeek"]];
    for (int i = 0; i < 7; i++){
        NSMutableArray *tempDay = [[NSMutableArray alloc] initWithCapacity:1];
        NSString *tempStr = [NSString stringWithString:[dataWeek[i] valueForKey:@"day"]];
        [tempDay addObject:tempStr];
        tempStr = [NSString stringWithString:[dataWeek[i] valueForKey:@"icon"]];
        [tempDay addObject:tempStr];
        
        float temperatureFahrenheitMax = [[dataWeek[i] valueForKeyPath:@"temperatureMax"] floatValue];
        int temperatureCelsiusMax = (temperatureFahrenheitMax - 32) * 5 / 9;
        float temperatureFahrenheitMin = [[dataWeek[i] valueForKeyPath:@"temperatureMin"] floatValue];
        int temperatureCelsiusMin = (temperatureFahrenheitMin - 32) * 5 / 9;
        
        tempStr = [NSString stringWithFormat:@"Temperature: %i - %i °C", temperatureCelsiusMin, temperatureCelsiusMax];
        
        [tempDay addObject:tempStr];
        
        [onWeek addObject:tempDay];
        [tempDay release];
    }
    [tempData setValue:onWeek forKey:@"Week"];
    [onWeek release];
    _data = [[NSDictionary alloc] initWithDictionary:tempData];
    [tempData release];
}

- (NSArray*)curentDataWeather:(NSInteger)index {
    NSArray *keys = [_data allKeys];
    NSString *curentKey = [keys objectAtIndex:index];
    NSArray *curentData = [_data objectForKey:curentKey];
    return curentData;
}

@end
