//
//  EventData.h
//  GoogleCalendarAccessTest
//
//  Created by yuriken27 on H.24/04/01.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventData : NSObject
{
}

@property (strong, nonatomic) NSString *eventTitle;
@property (strong, nonatomic) NSString *eventLocation;
@property (strong, nonatomic) NSString *eventDescription;
@property (strong, nonatomic) NSString *eventColor;
@property (strong, nonatomic) NSDate *startTime;
@property (strong, nonatomic) NSDate *endTime;
@property (strong, nonatomic) NSDate *updateDate;
@property BOOL allDay;

@end
