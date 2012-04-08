//
//  CalendarManager.m
//  GoogleCalendarAccessTest
//
//  Created by yuriken27 on H.24/04/01.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalendarManager.h"

@implementation CalendarManager

@synthesize aCalendar;

-(id) init
{
    if (self = [super init]) {
        aCalendar = [NSMutableArray array];
        startDay = 0;
        endDay = 180;
    }
    return self;
}

-(CalendarData*) getCalendarDataByName:(NSString*) calendarTitle
{
    for (CalendarData* calendarData in aCalendar ) {
        if ([calendarData.calendarTitle isEqualToString:calendarTitle]){
            return calendarData;
        }
    }
    return nil;
}

/**
 * Create New Calendar Instance
 */
-(CalendarData*) getCalendarDataByIndex:(NSInteger) index
{
    if ([aCalendar count] > index) {
        return [aCalendar objectAtIndex:index];
    }
    return nil;
}

/**
 * Set EventData To Calendar Instance Find By Name
 */
-(void) setEventDataByCalendarTitle:(NSString*)calendarTitle event:(EventData*)calendarEvent
{
    CalendarData* calendarData = [self getCalendarDataByName:calendarTitle];
    
    if (calendarData) {
        [calendarData setEventData:calendarEvent];
    }
}

/**
 * Create New Calendar Instance
 */
-(CalendarData*) createCalendar:(NSString*)calendarTitle
{
    CalendarData* calendarData = [[CalendarData alloc] init];
    if (!calendarData) {
        return nil;
    }
    [calendarData setCalendarTitle:calendarTitle];
    [aCalendar addObject:calendarData];
    
    return calendarData;
}
/**
 * retrun Calendar count
 */
-(int) getCalendarCount
{
    return [aCalendar count];
}


-(NSMutableArray*)getCalendarNames
{
    NSMutableArray *calendarNames = [NSMutableArray array];
    
    for (CalendarData *calendarData in aCalendar) {
        [calendarNames addObject:calendarData.calendarTitle];
    }
    return calendarNames;
}

-(void) eventsTicket:(GDataServiceTicket *)ticket
    finishedWithFeed:(GDataFeedCalendar *)feed
               error:(NSError *) error {
    
    if (error || [[feed entries] count] == 0) {
        NSLog(@"fetch error: %@", error);
        // 通知を作成する
        NSNotification *notice = [NSNotification notificationWithName:notifyMessage object:self];
        // 通知実行
        [[NSNotificationCenter defaultCenter] postNotification:notice];
        return;
    }
    // カレンダー名を取得
    NSString *calendarTitle = [[feed title] stringValue];
    m_CalendarData = [self getCalendarDataByName:calendarTitle];
    
    //GDataEntryCalendar *gDataCalendar;
    GDataEntryCalendarEvent *gDataEvent;
    GDataTextConstruct *titleTextConstruct;
    
    for (GDataFeedCalendar* feedCalendars in [feed entries]) {
        
        // Get Event Infos
        m_EventData = [[EventData alloc] init];
        gDataEvent = (GDataEntryCalendarEvent *)feedCalendars;
        
        titleTextConstruct = [gDataEvent title];
        
        NSString *title = [titleTextConstruct stringValue];
        m_EventData.eventTitle = title;
        m_EventData.eventDescription = [[gDataEvent content] stringValue];
        NSLog(@"EventsTitle:%@", m_EventData.eventTitle);
        // イベントの日時取得
        NSArray *times = [gDataEvent times];
        GDataWhen *when = nil;
        
        if ([times count] > 0) {
            when = [times objectAtIndex:0];
            
            m_EventData.startTime = [[when startTime] date];
            m_EventData.endTime   = [[when   endTime] date];
            // 時間(時、分、秒)が無いとき、終日と判定
            m_EventData.allDay = !([[when startTime] hasTime]) && !([[when endTime] hasTime]);
        }
        
        // イベントの場所取得
        NSArray *location = [gDataEvent locations];
        GDataWhere *where = nil;
        
        if ([location count] > 0) {
            where = [location objectAtIndex:0];
            m_EventData.eventLocation = [where stringValue];
        }
        // 更新日付取得
        m_EventData.updateDate = [[gDataEvent updatedDate] date];
        
        [m_CalendarData setEventData:m_EventData];
    }
    
    // objectをソート
    [m_CalendarData sortEventsByDate];
    
    // 通知を作成する
    NSNotification *notice = [NSNotification notificationWithName:notifyMessage object:self];
    
    // 通知実行
    [[NSNotificationCenter defaultCenter] postNotification:notice];
    
}

-(void)ticket:(GDataServiceTicket *) ticket
finishedWithFeed:(GDataFeedCalendar *)feed
        error:(NSError *)error {
    if (error || [[feed entries] count] == 0) {
        NSLog(@"fetch error: %@", error);
        return;
    }
    
    // カレンダーデータがある場合
    for (GDataEntryCalendar *calendar in [feed entries]){
        
        GDataTextConstruct *titleTextConstruct = [calendar title];
        
        NSString *calendarTitle = [titleTextConstruct stringValue];
        GDataLink *link = [calendar alternateLink];
        
        if (link == nil) {
            continue;
        }
        
        // CalendarManagerにCalendarを追加作成
        m_CalendarData = [self createCalendar:calendarTitle];                     // カレンダー名
        m_CalendarData.calendarLocation    = [[calendar locations] description];  // カレンダーの場所
        m_CalendarData.calendarDescription = [calendar.title stringValue];        // カレンダーの説明
        
        // イベントデータの表示色
        GDataColorProperty *colorProp = [calendar color];
        m_CalendarData.calendarColor = [colorProp stringValueForAttribute:[colorProp attributeName]];
        // タイムゾーン取得
        GDataTimeZoneProperty *timezoneProp = [calendar timeZoneName];
        NSString *timeZoneString = [timezoneProp stringValueForAttribute:[timezoneProp attributeName]];
        m_CalendarData.timezone = [NSTimeZone timeZoneWithName:timeZoneString];
        
        NSURL *calendarURL = [link URL]; // カレンダーから取得したalternateLink
        
        // イベントデータ取得定義開始
        GDataQueryCalendar *query = [GDataQueryCalendar calendarQueryWithFeedURL:calendarURL];

        // 取得するイベントの最大日時
        NSCalendar *nsCalendar = [NSCalendar currentCalendar];
        //NSCalendar *nsCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setDay:startDay]; // 開始日 [0日後から]
        NSDate *minDate = [nsCalendar dateByAddingComponents:comps toDate:[NSDate date] options:0];
        [comps setDay:endDay]; // 終了日 [180日後まで]
        NSDate *maxDate = [nsCalendar dateByAddingComponents:comps toDate:[NSDate date] options:0];
        // タイムゾーン
        NSTimeZone *tz = [NSTimeZone localTimeZone];
        
        GDataDateTime *MinimumDate = [GDataDateTime dateTimeWithDate:minDate timeZone:tz];
        GDataDateTime *MaximumDate = [GDataDateTime dateTimeWithDate:maxDate timeZone:tz];
        
        [query setMinimumStartTime:MinimumDate];
        [query setMaximumStartTime:MaximumDate];
        
        // 開始日でソート　返ってきたデータがソートされていないため、コメント化
        //[query setOrderBy:@"starttime"];
        //[query setMaxResults:2];
        
        // イベントデータ取得をリクエスト
        [gDataSrviceCalendar fetchFeedWithQuery:query 
                                       delegate:self 
                              didFinishSelector:@selector(eventsTicket:finishedWithFeed:error:)];
        
    }
}

-(void) getCalendar:(NSString*) messageName {
    
    notifyMessage = messageName;
    [self clearAllCalendarData];
    
    gDataSrviceCalendar = [[GDataServiceGoogleCalendar alloc] init];
    [gDataSrviceCalendar setUserCredentialsWithUsername:gglUsername
                                               password:gglPassword];
    
    // for performance
    // http://code.google.com/p/gdata-objectivec-client/wiki/PerformanceTuning
    [gDataSrviceCalendar setServiceShouldFollowNextLinks:YES];
    [gDataSrviceCalendar setShouldServiceFeedsIgnoreUnknowns:YES];
    
    // 全てのカレンダーを取得するURL
    NSURL *feedURL = [NSURL URLWithString:kGDataGoogleCalendarDefaultAllCalendarsFeed];
    
    GDataServiceTicket *ticket;
    ticket = [gDataSrviceCalendar fetchFeedWithURL:feedURL
                                          delegate:self
                                 didFinishSelector:@selector(ticket:finishedWithFeed:error:)];
}


-(void)setUserInfo:(NSString*)username googlePassword:(NSString*)password
{
    gglUsername = username;
    gglPassword = password;
}

-(void)clearAllCalendarData
{
    [aCalendar removeAllObjects];
}

@end
