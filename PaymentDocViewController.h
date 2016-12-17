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
    
    UITextField *scenaryTextField;
    
    
    UITextField *nomGroupTextField;
     
    
    UITextField *currencyRateTextField;
    
    UITextField *seasonTextField;    
    UITextField *addTaxValueTextField;
    UITextField *addTaxSummTextField;
    UITextField *payTargetTextField;
    UITextField *payTargetManageTextField;    
}

@property (nonatomic, retain) IBOutlet UITextField *addTaxValueTextField;
@property (nonatomic, retain) IBOutlet UITextField *addTaxSummTextField;

@property (nonatomic, retain) IBOutlet UITextField *scenaryTextField;

@property (nonatomic, retain) IBOutlet UITextField *nomGroupTextField;


@property (nonatomic, retain) IBOutlet UITextField *currencyRateTextField;

@property (nonatomic, retain) IBOutlet UITextField *seasonTextField;
@property (nonatomic, retain) IBOutlet UITextField *payTargetTextField;
@property (nonatomic, retain) IBOutlet UITextField *payTargetManageTextField;
@property (nonatomic, retain) PaymentDoc *paymentDoc;

@end
