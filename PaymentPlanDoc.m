//
//  PaymentPlanDoc.m
//  MultipleDetailViews
//
//  Created by MacMini on 14.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PaymentPlanDoc.h"

@implementation PaymentPlanDoc

@synthesize paymentOrderList;

- (id) init  {
    self = [super init];
    if (self)   {
        self.paymentOrderList = [[PaymentOrderList alloc] init];
    }
    return self;
}

- (void) dealloc    {
    [paymentOrderList release];
    [super dealloc];
}

@end
