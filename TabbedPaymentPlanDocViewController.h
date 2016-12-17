//
//  TabbedPaymentDocViewController.h
//  MultipleDetailViews
//
//  Created by MacMini on 15.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubstitutableDetailViewController.h"
#import "PaymentPlanDoc.h"
#import "CoordinationsViewController.h"
#import "PaymentOrdersViewController.h"
#import "SystemMessage.h"
#import "ParseDocsOperation.h"
#import "MainHTTPConnection.h"
#import "DataDestinationViewController.h"
#import "AppDelegate.h"

@interface TabbedPaymentPlanDocViewController : UIViewController <SubstitutableDetailViewController, DataDestinationViewController> {
    PaymentPlanDoc *paymentPlanDoc;
    CoordinationsViewController *docCoordinationScrollViewController;
    PaymentOrdersViewController *paymentOrdersViewController;
    UITableViewController *parentTableViewController;    
    
    UISplitViewController *splitViewController;
    UIPopoverController *popoverController;    
    UIBarButtonItem *rootPopoverButtonItem;
    
    //UIToolbar *toolbar;
    UIBarButtonItem *statementSetButton;
    UIImageView *statusImageView;    
    UITextField *codeTextField;
    UITextField *createDateTextField;
    UILabel *statementStatusLabel;
    UILabel *statementDateLabel;
    UITextField *executorTextField;
    UITextField *respTextField;
    UITextField *commentTextField;
    UITextField *orgNameTextField;
    UITextField *cfoTextField;
    UITextField *turnAccountTextField;
    UITextField *projectTextField;
    UIView *basedView;
    UIScrollView *docsSectionsScrollView;
    //UISegmentedControl *scrollSegmControl;
@private
    // for downloading the xml data
    NSMutableArray *DocsList;
    NSMutableData *DocsData;
    NSOperationQueue *parseQueue;
}

@property (nonatomic, retain) UITableViewController *parentTableViewController;
@property (nonatomic, retain) UISplitViewController *splitViewController;
@property (nonatomic, retain) IBOutlet UIImageView *statusImageView;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) UIBarButtonItem *rootPopoverButtonItem;

//@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *statementSetButton;
@property (nonatomic, retain) PaymentPlanDoc *paymentPlanDoc;
@property (nonatomic, retain) CoordinationsViewController *docCoordinationScrollViewController;
@property (nonatomic, retain) PaymentOrdersViewController *paymentOrdersViewController;
@property (nonatomic, retain) IBOutlet UITextField *codeTextField;
@property (nonatomic, retain) IBOutlet UITextField *createDateTextField;
@property (nonatomic, retain) IBOutlet UILabel *statementStatusLabel;
@property (nonatomic, retain) IBOutlet UILabel *statementDateLabel;
@property (nonatomic, retain) IBOutlet UITextField *executorTextField;
@property (nonatomic, retain) IBOutlet UITextField *respTextField;
@property (nonatomic, retain) IBOutlet UITextField *commentTextField;
@property (nonatomic, retain) IBOutlet UITextField *orgNameTextField;
@property (nonatomic, retain) IBOutlet UITextField *cfoTextField;
@property (nonatomic, retain) IBOutlet UITextField *turnAccountTextField;
@property (nonatomic, retain) IBOutlet UITextField *projectTextField;
@property (nonatomic, retain) IBOutlet UIView *basedView;
@property (nonatomic, retain) IBOutlet UIScrollView
*docsSectionsScrollView;
//@property (nonatomic, retain) IBOutlet UISegmentedControl *scrollSegmControl;
@property (nonatomic, retain) NSMutableData *DocsData;    
@property (nonatomic, retain) NSOperationQueue *parseQueue;
@property (nonatomic, retain) NSMutableArray *DocsList;

- (IBAction)changePageToOne:(id)sender;
- (IBAction)changePageTo:(id)sender;
- (IBAction)sendStatementRequest:(id)sender;
- (void)showSystemMessage:(SystemMessage *)systemMessage;
- (IBAction) navBack:(id) sender;

@end
