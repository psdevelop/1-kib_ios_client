//
//  DocsListTableViewController.h
//  MultipleDetailViews
//
//  Created by MacMini on 10.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DocType.h"
#import "SubstitutableDetailViewController.h"
#import "DataDestinationViewController.h"
#import "MainHTTPConnection.h"
#import "DocTypeListTableViewController.h"
#import "SystemMessage.h"
#import "PaymentPlanDoc.h"

@interface DocsListTableViewController : UITableViewController <UISplitViewControllerDelegate, DataDestinationViewController, UIScrollViewDelegate> {
    
    DocType *docType;
    NSMutableArray *DocsList;
    UISplitViewController *splitViewController;
    UIPopoverController *popoverController;    
    UIBarButtonItem *rootPopoverButtonItem;
    BOOL PortraitMode;
    BOOL showAlways;
    BOOL isChildController;
    NSString *filterParamsStr;
    UIActivityIndicatorView *loadIndicator;
    NSMutableArray *impGroupedDocs;
    NSArray *impGroupedKeys;
    PaymentPlanDoc *currentPlanDoc;
    
@private
    NSMutableData *DocsData;
    NSOperationQueue *parseQueue;
    
}

@property (nonatomic, retain) DocType *docType;
@property (nonatomic, readwrite) BOOL PortraitMode;
@property (nonatomic, readwrite) BOOL showAlways;
@property (nonatomic, readwrite) BOOL isChildController;
@property (nonatomic, retain) NSMutableArray *DocsList;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadIndicator;
@property (nonatomic, retain) UISplitViewController *splitViewController;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) UIBarButtonItem *rootPopoverButtonItem;
@property (nonatomic, retain) NSString *filterParamsStr;
@property (nonatomic, retain) NSMutableArray *impGroupedDocs;
@property (nonatomic, retain) NSArray *impGroupedKeys;
@property (nonatomic, assign) PaymentPlanDoc *currentPlanDoc;

- (void)insertDocs:(NSArray *)docs;
- (void)docsRequest:(BOOL)isPart;
- (void) moreDocsTapped;
- (void)addPropsToList:(NSArray *)props;

@end
