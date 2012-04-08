//
//  CalendarData.m
//  GoogleCalendarAccessTest
//
//  Created by yuriken27 on 12/03/25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalendarData.h"

@implementation CalendarData

@synthesize calendarTitle;
@synthesize calendarLocation;
@synthesize calendarDescription;
@synthesize calendarColor;
@synthesize timezone;
@synthesize aEventData;


-(id) init
{
    if (self = [super init]) {
        aEventData = [NSMutableArray array];
        calendarTitle       = nil;
        calendarLocation    = nil;
        calendarDescription = nil;
        timezone            = nil;
    }
    return self;
}

- (void)dealloc
{
    [aEventData removeAllObjects];
    //[super dealloc];
}

-(void) sortEventsByDate
{
    
    NSSortDescriptor *sortDispNo = [[NSSortDescriptor alloc] initWithKey:@"startTime" ascending:YES]; 
    NSArray *sortDescArray = [NSArray arrayWithObjects:sortDispNo, nil];  
    
    NSArray* tmpArray;
    tmpArray = [aEventData sortedArrayUsingDescriptors:sortDescArray];
    aEventData = [NSMutableArray arrayWithArray:tmpArray]; 
    
}

-(void) setEventData:(EventData*)calendarEvent
{
    [aEventData addObject:calendarEvent];
}

-(void) clearAllEventData
{
    [aEventData removeAllObjects];
}

@end
