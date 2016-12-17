//
//  DocsTableViewCell.h
//  MultipleDetailViews
//
//  Created by MacMini on 11.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DocsTableViewCell : UITableViewCell {
    UIView *docsCellView;
    UILabel *numLabel;
    UILabel *nameLabel;
    UILabel *codeLabel;
    UILabel *create_date_label;
    UILabel *statement_state_label;
    UIImageView *statement_image;
    UILabel *statement_date;
    UILabel *org_name_label;
    UILabel *importance_label;
    UILabel *order_type_label;
    UILabel *executor_name_label;
    UILabel *responsible_name_label;
    UILabel *contragent_label;
    UILabel *cfo_label;
    UILabel *currencyLabel;
    UILabel *currencyRateLabel;
    UILabel *turnAccountLabel;
    UILabel *projectLabel;
    UILabel *docSummLabel;
    UILabel *paymentDate;
    UILabel *maxPaymentDate;
    UIImageView *overPlanImage;
    UIImageView *cacheMoneyImage;
}

@property (nonatomic, retain) IBOutlet UIView *docsCellView;
@property (nonatomic, retain) IBOutlet UILabel *numLabel;
@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UILabel *codeLabel;
@property (nonatomic, retain) IBOutlet UILabel *create_date_label;
@property (nonatomic, retain) IBOutlet UILabel *statement_state_label;
@property (nonatomic, retain) IBOutlet UILabel *statement_date;
@property (nonatomic, retain) IBOutlet UILabel *org_name_label;
@property (nonatomic, retain) IBOutlet UILabel *importance_label;
@property (nonatomic, retain) IBOutlet UILabel *order_type_label;
@property (nonatomic, retain) IBOutlet UILabel *executor_name_label;
@property (nonatomic, retain) IBOutlet UILabel *responsible_name_label;
@property (nonatomic, retain) IBOutlet UILabel *contragent_label;
@property (nonatomic, retain) IBOutlet UIImageView *statement_image;
@property (nonatomic, retain) IBOutlet UILabel *cfo_label;
@property (nonatomic, retain) IBOutlet UILabel *currencyLabel;
@property (nonatomic, retain) IBOutlet UILabel *turnAccountLabel;
@property (nonatomic, retain) IBOutlet UILabel *currencyRateLabel;
@property (nonatomic, retain) IBOutlet UILabel *projectLabel;
@property (nonatomic, retain) IBOutlet UILabel *docSummLabel;
@property (nonatomic, retain) IBOutlet UILabel *paymentDate;
@property (nonatomic, retain) IBOutlet UILabel *maxPaymentDate;
@property (nonatomic, retain) IBOutlet UIImageView *overPlanImage;
@property (nonatomic, retain) IBOutlet UIImageView *cacheMoneyImage;

@end
