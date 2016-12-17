//
//  CoordinationTableViewCell.h
//  MultipleDetailViews
//
//  Created by MacMini on 15.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PaymentOrderTableViewCell : UITableViewCell {
    UILabel *numLabel;
    UIImageView *toPayImage;
    UITextView *statusTextView;
    UITextField *paymentFormNameLabel;
    UILabel *orgNameLabel;
    UITextField *bankAccountNameLabel;
    UITextView *orderNameTextView;
    UITextView *paymentPositionTextView;
    UILabel *docCurrencyLabel;
    UILabel *summLabel;
    UILabel *deltaSummLabel;
    UILabel *paymentCurrencyLabel;
    UILabel *planedSummLabel;
    UILabel *toPaymentSummLabel;
    UILabel *paymentDocNameLabel;
    UIView *paymentCellView;
}

@property (nonatomic, retain) IBOutlet UIView *paymentCellView;
@property (nonatomic, retain) IBOutlet UILabel *numLabel;
@property (nonatomic, retain) IBOutlet UIImageView *toPayImage;
@property (nonatomic, retain) IBOutlet UITextView *statusTextView;
@property (nonatomic, retain) IBOutlet UITextField *paymentFormNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *orgNameLabel;
@property (nonatomic, retain) IBOutlet UITextField *bankAccountNameLabel;
@property (nonatomic, retain) IBOutlet UITextView *orderNameTextView;
@property (nonatomic, retain) IBOutlet UITextView *paymentPositionTextView;
@property (nonatomic, retain) IBOutlet UILabel *docCurrencyLabel;
@property (nonatomic, retain) IBOutlet UILabel *summLabel;
@property (nonatomic, retain) IBOutlet UILabel *deltaSummLabel;
@property (nonatomic, retain) IBOutlet UILabel *paymentCurrencyLabel;
@property (nonatomic, retain) IBOutlet UILabel *planedSummLabel;
@property (nonatomic, retain) IBOutlet UILabel *toPaymentSummLabel;
@property (nonatomic, retain) IBOutlet UILabel *paymentDocNameLabel;

@end
