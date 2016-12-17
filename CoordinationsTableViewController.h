//
//  CoordinationsTableViewController.h
//  MultipleDetailViews
//
//  Created by MacMini on 15.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoordinationListDoc.h"
#import "DataDestinationViewController.h"
#import "MainHTTPConnection.h"


@interface CoordinationsTableViewController : UITableViewController <UISplitViewControllerDelegate, DataDestinationViewController> {
    CoordinationListDoc *coordDoc;
    NSOperationQueue *parseQueue; 
    UIActivityIndicatorView *loadIndicator;
}

@property (nonatomic, retain) CoordinationListDoc *coordDoc;
@property (nonatomic, retain) NSOperationQueue *parseQueue;
@property (nonatomic, retain) UIActivityIndicatorView *loadIndicator;

- (void)addPropsToList:(NSArray *)props;
- (void)sendDocPropertiesRequest;

@end
