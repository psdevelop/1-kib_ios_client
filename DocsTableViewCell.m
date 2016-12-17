//
//  DocsTableViewCell.m
//  MultipleDetailViews
//
//  Created by MacMini on 11.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DocsTableViewCell.h"


@implementation DocsTableViewCell

@synthesize docsCellView, codeLabel, numLabel, nameLabel, create_date_label, importance_label, order_type_label, statement_state_label, statement_date, statement_image,org_name_label, contragent_label, executor_name_label, responsible_name_label, cfo_label, currencyLabel, currencyRateLabel, turnAccountLabel, projectLabel, docSummLabel, paymentDate, maxPaymentDate, overPlanImage, cacheMoneyImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        if (docsCellView==nil) {
            if (style==UITableViewCellStyleDefault) {
                [[NSBundle mainBundle] loadNibNamed:@"DocsTableViewCell" owner:self options:nil];
            }
            else
            {
                [[NSBundle mainBundle] loadNibNamed:@"DocsTablePortraitViewCell" owner:self options:nil];
                //[docsCellView setFrame:CGRectMake(0, 0, 760, 72)];
            }
            [self.contentView addSubview: docsCellView];
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
    self.codeLabel=nil;
    self.numLabel=nil;
    self.nameLabel=nil;
    self.create_date_label=nil;
    self.importance_label=nil;
    self.order_type_label=nil;
    self.statement_state_label=nil;
    self.statement_date=nil;
    self.statement_image=nil;
    self.org_name_label=nil;
    self.contragent_label=nil;
    self.executor_name_label=nil;
    self.responsible_name_label=nil;
    self.cfo_label=nil;
    self.currencyLabel=nil;
    self.currencyRateLabel=nil;
    self.turnAccountLabel=nil;
    self.projectLabel=nil;
    self.docSummLabel=nil;
    self.docsCellView=nil;
}

- (void)dealloc
{
    [codeLabel release];
    [numLabel release];
    [nameLabel release];
    [create_date_label release];
    [importance_label release];
    [order_type_label release];
    [statement_state_label release];
    [statement_date release];
    [statement_image release];
    [org_name_label release];
    [contragent_label release];
    [executor_name_label release];
    [responsible_name_label release];
    [cfo_label release];
    [currencyLabel release];
    [currencyRateLabel release];
    [turnAccountLabel release];
    [projectLabel release];
    [docSummLabel release];
    [docsCellView release];
    [super dealloc];
}

@end
