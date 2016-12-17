//
//  PaymentPlanDoc.h
//  MultipleDetailViews
//
//  Created by MacMini on 14.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Doc.h"
#import "PaymentOrderList.h"

@interface PaymentPlanDoc : CoordinationListDoc {
    PaymentOrderList *paymentOrderList;
}

@property (nonatomic, retain) PaymentOrderList *paymentOrderList;

@end
