//
//  PaymentDoc.m
//  MultipleDetailViews
//
//  Created by MacMini on 14.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PaymentDoc.h"


@implementation PaymentDoc

@synthesize base_doc_name, contract_name, nomenclature_group_name, scenary_name, seasone_name, contragent_name;

- (void)dealloc {
    
    [base_doc_name release];
    [contract_name release];
    [nomenclature_group_name release];
    [scenary_name release];
    [seasone_name release];
    [contragent_name release];
    
    [super dealloc];
}

@end
