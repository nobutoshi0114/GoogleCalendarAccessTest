//
//  CalendarManager.h
//  GoogleCalendarAccessTest
//
//  Created by yuriken27 on H.24/04/01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GData.h"
#import "CalendarData.h"

@interface CalendarManager : NSObject
{
    NSMutableArray *aCalendar;
    
    GDataServiceGoogleCalendar *gDataSrviceCalendar;
    
    EventData *m_EventData;
    CalendarData *m_CalendarData;
    
    NSInteger startDay;  // Event取得開始日(実行日からの差分) 
    NSInteger endDay;    // Event取得修了日(実行日からの差分) 
    
    NSString *gglUsername;
    NSString *gglPassword;
    
    NSString *notifyMessage;
}

@property (strong, nonatomic) NSMutableArray *aCalendar;

-(void) setEventDataByCalendarTitle:(NSString*)calendarTitle event:(EventData*)calendarEvent;
-(CalendarData*) createCalendar:(NSString*)calendarTitle;

-(CalendarData*) getCalendarDataByName:(NSString*)calendarTitle;
-(CalendarData*) getCalendarDataByIndex:(NSInteger) index;

-(int) getCalendarCount;
-(NSMutableArray*)getCalendarNames;

-(void) getCalendar:(NSString*) messageName;

-(void)setUserInfo:(NSString*)username googlePassword:(NSString*)password;

-(void) clearAllCalendarData;

@end
