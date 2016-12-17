//
//  CoordinationTableViewCell.m
//  MultipleDetailViews
//
//  Created by MacMini on 15.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PaymentOrderTableViewCell.h"


@implementation PaymentOrderTableViewCell

@synthesize paymentCellView, numLabel, bankAccountNameLabel, deltaSummLabel, docCurrencyLabel, orderNameTextView, orgNameLabel, paymentCurrencyLabel, paymentDocNameLabel, paymentFormNameLabel, statusTextView, summLabel, toPayImage, toPaymentSummLabel, planedSummLabel, paymentPositionTextView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        if (paymentCellView==nil) {
            [[NSBundle mainBundle] loadNibNamed:@"PaymentOrderTableViewCell" owner:self options:nil];
            [self.contentView addSubview: paymentCellView];
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)viewDidUnload   {
    self.numLabel = nil;
    self.bankAccountNameLabel = nil;
    self.deltaSummLabel = nil;
    self.docCurrencyLabel = nil;
    self.orderNameTextView = nil;
    self.orgNameLabel = nil;
    self.paymentCurrencyLabel = nil;
    self.paymentDocNameLabel = nil;
    self.paymentFormNameLabel = nil;
    self.statusTextView = nil;
    self.summLabel = nil;
    self.toPayImage = nil;
    self.toPaymentSummLabel = nil;
    self.planedSummLabel = nil;
    self.paymentPositionTextView = nil;
    self.paymentCellView = nil;
}

- (void)dealloc
{
    [numLabel release];
    [bankAccountNameLabel release];
    [deltaSummLabel release];
    [docCurrencyLabel release];
    [orderNameTextView release];
    [orgNameLabel release];
    [paymentCurrencyLabel release];
    [paymentDocNameLabel release];
    [paymentFormNameLabel release];
    [statusTextView release];
    [summLabel release];
    [toPayImage release];
    [toPaymentSummLabel release];
    [planedSummLabel release];
    [paymentPositionTextView release];
    [paymentCellView release];
    [super dealloc];
}

@end
