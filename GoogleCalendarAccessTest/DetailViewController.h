//
//  DetailViewController.h
//  GoogleCalendarAccessTest
//
//  Created by yuriken27 on H.24/04/05.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarManager.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblLocation;
@property (strong, nonatomic) IBOutlet UILabel *lblContent;

@property (strong, nonatomic) EventData* event;
@end
