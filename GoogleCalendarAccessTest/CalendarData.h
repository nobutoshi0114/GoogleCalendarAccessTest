//
//  CalendarData.h
//  GoogleCalendarAccessTest
//
//  Created by yuriken27 on 12/03/25.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EventData.h"

@interface CalendarData : NSObject
{   
    
}

@property (strong, nonatomic) NSString *calendarTitle;
@property (strong, nonatomic) NSString *calendarLocation;
@property (strong, nonatomic) NSString *calendarDescription;
@property (strong, nonatomic) NSString *calendarColor;
@property (strong, nonatomic) NSTimeZone *timezone;
@property (strong, nonatomic) NSMutableArray *aEventData;

-(void) sortEventsByDate;
-(void) setEventData:(EventData*)calendarEvent;
-(void) clearAllEventData;
@end

