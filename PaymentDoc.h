//
//  PaymentDoc.h
//  MultipleDetailViews
//
//  Created by MacMini on 14.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoordinationListDoc.h"
#import "PaymentListDoc.h"

@interface PaymentDoc : CoordinationListDoc {
    //PaymentListDoc *paymentList;
    NSString *nomenclature_group_name;
    NSString *base_doc_name;
    NSString *scenary_name;
    NSString *contragent_name;
    NSString *contract_name;
    NSString *seasone_name;
    
}

//@property (nonatomic, retain) PaymentListDoc *paymentList;
@property (nonatomic, retain) NSString *nomenclature_group_name;
@property (nonatomic, retain) NSString *base_doc_name;
@property (nonatomic, retain) NSString *scenary_name;
@property (nonatomic, retain) NSString *contragent_name;
@property (nonatomic, retain) NSString *contract_name;
@property (nonatomic, retain) NSString *seasone_name;

@end
