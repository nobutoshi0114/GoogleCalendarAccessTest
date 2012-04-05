//
//  DetailViewController.h
//  GoogleCalendarAccessTest
//
//  Created by 健 百合野 on H.24/04/05.
//  Copyright (c) 平成24年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
