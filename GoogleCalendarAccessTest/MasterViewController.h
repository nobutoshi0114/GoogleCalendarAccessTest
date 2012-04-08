//
//  MasterViewController.h
//  GoogleCalendarAccessTest
//
//  Created by yuriken27 on H.24/04/05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GData.h"
#import "CalendarManager.h"
@class DetailViewController;

@interface MasterViewController : UITableViewController
{
    CalendarManager *calendarManager;
    //NSArray *events;
    NSString *formatDay;
    NSString *formatTime;
    NSDateFormatter *formatter;
    
    UIActivityIndicatorView *activity;
    UILabel *lblProcess;
    NSCalendar *gregorianCalendar;
}

@property (strong, nonatomic) DetailViewController *detailViewController;

-(void) setScheduleToTable;
-(void) loadCalendarData;

@end
