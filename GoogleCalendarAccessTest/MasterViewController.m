//
//  MasterViewController.m
//  GoogleCalendarAccessTest
//
//  Created by yuriken27 on H.24/04/05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController

@synthesize detailViewController = _detailViewController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"GoogleCalendar", @"GoogleCalendar");
        
        calendarManager = [[CalendarManager alloc] init];
    }
    
    formatter = [[NSDateFormatter alloc]init];
    
    gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    formatter = [[NSDateFormatter alloc]init];
    [formatter setCalendar:gregorianCalendar];
    
    formatDay  = [NSString stringWithString:@"yyyy/MM/dd"];
    //formatTime = [NSString stringWithString:@"HH:mm:ss"];
    formatTime = [NSString stringWithString:@" HH:mm"];
    
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    // Modify::self.navigationItem.leftBarButtonItem = self.editButtonItem;

    // Modify::UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    // Modify::self.navigationItem.rightBarButtonItem = addButton;
    
    // 再読み込みボタン作成
    UIBarButtonItem *btnRefresh = [[UIBarButtonItem alloc] 
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                   target:self
                                   action:@selector(loadCalendarData)];
    // スペース調整ボタン作成
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] 
                               initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                               target:self
                               action:nil];
    
    // ActivityIndicatotボタン作成
    activity = [[UIActivityIndicatorView alloc]
                initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    UIBarButtonItem *btnActivity = [[UIBarButtonItem alloc] 
                                    initWithCustomView:activity];
    // 状況表示ラベルを作成
    lblProcess = [[UILabel alloc] initWithFrame:CGRectMake(0,0,100,30)];
    lblProcess.textColor = [UIColor clearColor];
    lblProcess.backgroundColor = [UIColor clearColor];
    lblProcess.text = [NSString stringWithString:@"読み込み中！！"];
    lblProcess.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    
    
    UIBarButtonItem *btnProcess = [[UIBarButtonItem alloc]  initWithCustomView:lblProcess];
    btnProcess.width = 100;
    
    NSArray *buttons = [NSArray arrayWithObjects:btnRefresh, spacer, btnActivity,btnProcess, spacer, nil]; 
    self.navigationController.toolbarHidden = NO;
    [self setToolbarItems:buttons animated:YES];
    [self loadCalendarData];

    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //return 1;
    return [calendarManager getCalendarCount];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[calendarManager getCalendarDataByIndex:section].aEventData count];
    //return _objects.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil) {
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }


    // Modfy::NSDate *object = [_objects objectAtIndex:indexPath.row];
    // Modfy::cell.textLabel.text = [object description];
    
    EventData *event = [[calendarManager getCalendarDataByIndex:indexPath.section].aEventData objectAtIndex:indexPath.row];
    
    cell.textLabel.text = event.eventTitle;
    
    NSString *startDay;
    NSString *endDay;
    NSString *startTime;
    NSString *endTime;
    
    [formatter setDateFormat:formatDay];
    if (event.startTime) {
        startDay = [formatter stringFromDate:event.startTime];
    } else {
        startDay = [NSString stringWithString:@""];
    }
    if (event.endTime) {
        endDay = [formatter stringFromDate:event.endTime];
    } else {
        endDay = [NSString stringWithString:@""];
    }
    
    if ([startDay isEqualToString:endDay]) {
        endDay = @"";
    //} else {
    //    endDay = [endDay stringByAppendingString:@" "];
    }
    
    NSString *str = [NSString stringWithFormat:@"%@", event.eventTitle]; //, strDay];
    cell.textLabel.text = NSLocalizedString(str, @"Detail");
    
    if (event.allDay) {
        startTime = @"";
        endTime   = @"";
    } else {
        [formatter setDateFormat:formatTime];
        if (event.startTime) {
            startTime = [formatter stringFromDate:event.startTime];
        } else {
            startTime = [NSString stringWithString:@""];
        }
        if (event.endTime) {
            endTime= [formatter stringFromDate:event.endTime];
        } else {
            endTime = [NSString stringWithString:@""];
        }
    }
    
    NSString *detailTextLabel = [NSString stringWithFormat:@"%@%@ ~ %@%@", startDay, startTime, endDay, endTime];
    if ([detailTextLabel length] < 10) {
        detailTextLabel = @" ";
    }
    
    cell.detailTextLabel.text = detailTextLabel;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:16];
    
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.detailViewController) {
        self.detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    }
    //NSDate *object = [_objects objectAtIndex:indexPath.row];
    //self.detailViewController.detailItem = object;
    
    self.detailViewController.event = [[calendarManager getCalendarDataByIndex:indexPath.section].aEventData objectAtIndex:indexPath.row];
    self.detailViewController.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:self.detailViewController animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [calendarManager getCalendarDataByIndex:section].calendarTitle;
}

-(void) setScheduleToTable
{
    lblProcess.textColor = [UIColor clearColor];
    [activity stopAnimating];
    
    [self.tableView reloadData];
}

-(void) loadCalendarData
{
    NSString *notifyLoadMessage = @"CalendarLoaded";
    [calendarManager setUserInfo:@"appdev0927@gmail.com" googlePassword:@"z9741z9741"];
    [calendarManager getCalendar:notifyLoadMessage];
    // デフォルトの通知センターを取得する
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    // 通知センターに通知要求を登録する
    // この例だと、通知センターに"CalendarLoaded"という名前の通知がされた時に、
    // setScheduleToTableメソッドを呼び出すという通知要求の登録を行っている。
    [nc addObserver:self selector:@selector(setScheduleToTable) name:notifyLoadMessage object:nil];
    lblProcess.textColor = [UIColor whiteColor];
    [activity startAnimating];
}

@end
