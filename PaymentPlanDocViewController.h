//
//  PaymentPlanDocViewController.h
//  MultipleDetailViews
//
//  Created by MacMini on 14.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubstitutableDetailViewController.h"

@interface PaymentPlanDocViewController : UIViewController <SubstitutableDetailViewController> {
    UIToolbar *toolbar;
}

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;

@end
