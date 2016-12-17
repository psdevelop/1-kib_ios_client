//
//  PaymentDocViewController.h
//  MultipleDetailViews
//
//  Created by MacMini on 14.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubstitutableDetailViewController.h"
#import "PaymentDoc.h"

@interface PaymentDocViewController : UIViewController <SubstitutableDetailViewController> {
    PaymentDoc *paymentDoc;
    UIToolbar *toolbar;
    UITabBarController *tabBarController;
    UIView *tabBarPlaceHolderView;
    UIBarButtonItem *rootPopoverButtonItem;
}

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet UIView *tabBarPlaceHolderView;
@property (nonatomic, retain) UIBarButtonItem *rootPopoverButtonItem;
@property (nonatomic, retain) PaymentDoc *paymentDoc;

@end
