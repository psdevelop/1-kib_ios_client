//
//  CurrentTaskViewController.h
//  Uni1CCLient
//
//  Created by MacMini on 02.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubstitutableDetailViewController.h"
#import "DataDestinationViewController.h"
#import "MainHTTPConnection.h"


@interface CurrentTaskViewController : UIViewController <SubstitutableDetailViewController, DataDestinationViewController, UIAlertViewDelegate> {
    
    UIBarButtonItem *rootPopoverButtonItem;    
    
    //UIToolbar *toolbar;
    UISplitViewController *splitViewController; 
    UIActivityIndicatorView *loadIndIndicator;
    NSOperationQueue *parseQueue;
    NSMutableArray *indicatorsArray;
    
    UIButton *heightImpotanceButton;
    UIButton *overBudjetButton;
    UIButton *mediumLowImpotanceButton;
    UILabel *heightImpotanceCountLabel;
    UILabel *overBudjetCountLabel;
    UILabel *mediumLowImpotanceCountLabel;
    UILabel *notStatPlanDocCountLabel;
    UIButton *paymentPlanButton;
    UIButton *moneyUseReportButton;
    NSDateFormatter *canonicalFormatter;
    NSString *indicatorStartDate;
    NSString *paymentPlanStartDate;
}

@property (nonatomic, retain) UIBarButtonItem *rootPopoverButtonItem;
//@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, assign) UISplitViewController *splitViewController;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadIndIndicator;
@property (nonatomic, retain) NSOperationQueue *parseQueue;
@property (nonatomic, retain) NSMutableArray *indicatorsArray;
@property (nonatomic, retain) IBOutlet UIButton *heightImpotanceButton;
@property (nonatomic, retain) IBOutlet UIButton *overBudjetButton;
@property (nonatomic, retain) IBOutlet UIButton *mediumLowImpotanceButton;
@property (nonatomic, retain) IBOutlet UILabel *heightImpotanceCountLabel;
@property (nonatomic, retain) IBOutlet UILabel *overBudjetCountLabel;
@property (nonatomic, retain) IBOutlet UILabel *mediumLowImpotanceCountLabel;
@property (nonatomic, retain) IBOutlet UILabel *notStatPlanDocCountLabel;
@property (nonatomic, retain) IBOutlet UIButton *paymentPlanButton;
@property (nonatomic, retain) IBOutlet UIButton *moneyUseReportButton;
@property (nonatomic, retain) NSDateFormatter *canonicalFormatter;
@property (nonatomic, retain) NSString *indicatorStartDate;
@property (nonatomic, retain) NSString *paymentPlanStartDate;

-(void) requestIndicators;
- (void)addIndicatorsToList:(NSArray *)indicators;
-(void) rewriteIndicatorsButtons;
- (void)insertIndicators:(NSArray *)indicators;
- (void) loadDocsList:(NSString *)filterStr :(NSUInteger) doc_type_num;
- (IBAction) touchHightImportanceButton:(id) sender;
- (IBAction) touchMediumLowImportanceButton:(id) sender;
- (IBAction) touchOverBudjetImportanceButton:(id) sender;
- (IBAction) touchPaymentPlanButton:(id) sender;
- (IBAction) touchMoneyUseReportButton:(id) sender;
- (IBAction) touchRefreshIndicators:(id) sender;

@end
