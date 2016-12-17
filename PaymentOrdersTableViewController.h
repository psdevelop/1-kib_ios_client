//
//  CoordinationsTableViewController.h
//  MultipleDetailViews
//
//  Created by MacMini on 15.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PaymentOrderList.h"
#import "PaymentPlanDoc.h"
#import "MainHTTPConnection.h"
#import "DataDestinationViewController.h"


@interface PaymentOrdersTableViewController : UITableViewController <UISplitViewControllerDelegate, DataDestinationViewController> {
    PaymentPlanDoc *paymentPlanDoc;
    NSOperationQueue *parseQueue;
    UIActivityIndicatorView *loadIndicator;
}

@property (nonatomic, retain) NSOperationQueue *parseQueue;
@property (nonatomic, retain) PaymentPlanDoc *paymentPlanDoc;
@property (nonatomic, retain) UIActivityIndicatorView *loadIndicator;

- (void)addPropsToList:(NSArray *)docs;
- (void)sendDocPropertiesRequest;

@end
