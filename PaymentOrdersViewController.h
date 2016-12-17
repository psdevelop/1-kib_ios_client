//
//  CoordinationsViewController.h
//  MultipleDetailViews
//
//  Created by MacMini on 17.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentOrderList.h"
#import "PaymentPlanDoc.h"
#import "PaymentOrdersTableViewController.h"

@interface PaymentOrdersViewController : UIViewController <UITabBarControllerDelegate> {
    PaymentOrdersTableViewController *payOrdersListViewController;
    UIView *paymentOrdListTableView;
    PaymentPlanDoc *paymentPlanDoc;
    UIActivityIndicatorView *loadIndicator;
}

@property (nonatomic, retain) PaymentOrdersTableViewController *payOrdersListViewController;
@property (nonatomic, retain) IBOutlet UIView *paymentOrdListTableView;
@property (nonatomic, retain) PaymentPlanDoc *paymentPlanDoc;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadIndicator;

@end
