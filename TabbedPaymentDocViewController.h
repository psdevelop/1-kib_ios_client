//
//  TabbedPaymentDocViewController.h
//  MultipleDetailViews
//
//  Created by MacMini on 15.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubstitutableDetailViewController.h"

#import "PaymentDoc.h"
#import "PaymentDocViewController.h"
#import "CoordinationsViewController.h"
#import "MainHTTPConnection.h"
#import "DataDestinationViewController.h"
#import "AppDelegate.h"
#import "SystemMessage.h"

@interface TabbedPaymentDocViewController : UIViewController <SubstitutableDetailViewController, UIScrollViewDelegate, DataDestinationViewController> {
    PaymentDoc *paymentDoc;
    
    UISplitViewController *splitViewController;
    UIPopoverController *popoverController;    
    UIBarButtonItem *rootPopoverButtonItem;
    
    //UIToolbar *toolbar;
    PaymentDocViewController *paymentDocScrollViewController;
    CoordinationsViewController *docCoordinationScrollViewController;
    UITableViewController *parentTableViewController;
    UIScrollView *docsSectionsScrollView;
    UISegmentedControl *scrollSegmControl;
    UITextField *codeTextField;
    UITextField *createDateTextField;
    UILabel *statementStatusLabel;
    UILabel *statementDateLabel;
    UIImageView *paymentFormTextField;
    UITextField *importanceLevelTextField;
    UITextField *orderTypeTextField;
    UITextField *baseDocTextField;
    UITextField *executorTextField;
    UITextField *respTextField;
    UITextField *commentTextField;
    UIView *basedView;
    UIBarButtonItem *statementSetButton;
    UIImageView *statusImageView;
    UIImageView *notIncludeInPayPlanImageView;
    UIImageView *overBudget;
    UIImageView *isExchequer;
    UITextField *chargeMaxDateTextField;
    UITextField *chargeDateTextField;
    UITextField *projectTextField;
    UITextField *currencyTextField;
    UITextField *docSummTextField;
    UITextField *cfoTextField;
    UITextField *turnAccountTextField;
    UITextField *orgNameTextField;
    UITextField *contragentTextField;
    UITextField *contractTextField;
    
@private
    // for downloading the xml data
    NSMutableArray *DocsList;
    NSMutableData *DocsData;
    NSOperationQueue *parseQueue;
}

@property (nonatomic, retain) IBOutlet UIImageView *notIncludeInPayPlanImageView;
@property (nonatomic, retain) IBOutlet UIImageView *overBudget;
@property (nonatomic, retain) IBOutlet UIImageView *isExchequer;
@property (nonatomic, retain) IBOutlet UIImageView *statusImageView;
@property (nonatomic, retain) UITableViewController *parentTableViewController;
@property (nonatomic, retain) UISplitViewController *splitViewController;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) UIBarButtonItem *rootPopoverButtonItem;
@property (nonatomic, retain) IBOutlet UITextField *codeTextField;
@property (nonatomic, retain) IBOutlet UITextField *createDateTextField;
@property (nonatomic, retain) IBOutlet UILabel *statementStatusLabel;
@property (nonatomic, retain) IBOutlet UILabel *statementDateLabel;
@property (nonatomic, retain) IBOutlet UIImageView *paymentFormTextField;
@property (nonatomic, retain) IBOutlet UITextField *importanceLevelTextField;
@property (nonatomic, retain) IBOutlet UITextField *orderTypeTextField;
@property (nonatomic, retain) IBOutlet UITextField *baseDocTextField;
@property (nonatomic, retain) IBOutlet UITextField *executorTextField;
@property (nonatomic, retain) IBOutlet UITextField *respTextField;
@property (nonatomic, retain) IBOutlet UITextField *commentTextField;
//@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) PaymentDocViewController *paymentDocScrollViewController;
@property (nonatomic, retain) CoordinationsViewController *docCoordinationScrollViewController;
@property (nonatomic, retain) IBOutlet UIScrollView
    *docsSectionsScrollView;
@property (nonatomic, retain) IBOutlet UISegmentedControl *scrollSegmControl;
@property (nonatomic, retain) PaymentDoc *paymentDoc;
@property (nonatomic, retain) IBOutlet UIView
 *basedView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *statementSetButton;
@property (nonatomic, retain) NSMutableData *DocsData;    
@property (nonatomic, retain) NSOperationQueue *parseQueue;
@property (nonatomic, retain) NSMutableArray *DocsList;
@property (nonatomic, retain) IBOutlet UITextField *chargeDateTextField;
@property (nonatomic, retain) IBOutlet UITextField *chargeMaxDateTextField;
@property (nonatomic, retain) IBOutlet UITextField *cfoTextField;
@property (nonatomic, retain) IBOutlet UITextField *turnAccountTextField;
@property (nonatomic, retain) IBOutlet UITextField *projectTextField;
@property (nonatomic, retain) IBOutlet UITextField *currencyTextField;
@property (nonatomic, retain) IBOutlet UITextField *docSummTextField;
@property (nonatomic, retain) IBOutlet UITextField *orgNameTextField;
@property (nonatomic, retain) IBOutlet UITextField *contragentTextField;
@property (nonatomic, retain) IBOutlet UITextField *contractTextField;


- (IBAction)changePageToOne:(id)sender;
- (IBAction)changePageTo:(id)sender;
- (IBAction)sendStatementRequest:(id)sender;
- (void)showSystemMessage:(SystemMessage *)systemMessage;
- (IBAction) navBack:(id) sender;

@end
