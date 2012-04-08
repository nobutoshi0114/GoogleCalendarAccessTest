//
//  EventData.m
//  GoogleCalendarAccessTest
//
//  Created by yuriken27 on H.24/04/01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EventData.h"

@implementation EventData

@synthesize eventTitle;
@synthesize eventLocation;
@synthesize eventDescription;
@synthesize eventColor;
@synthesize startTime;
@synthesize endTime;
@synthesize updateDate;
@synthesize allDay;

-(id) init
{
    if (self = [super init]) {
        // init code
        eventTitle       = NULL;
        eventLocation    = NULL;
        eventDescription = NULL;
        startTime        = NULL;
        endTime          = NULL;
    }
    return self;
}

@end
