//
//  PaymentOrderList.m
//  MultipleDetailViews
//
//  Created by MacMini on 15.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PaymentOrderList.h"


@implementation PaymentOrderList

@synthesize paymentDocs;

- (id) init  {
    self = [super init];
    if (self)   {
        self.paymentDocs = [NSMutableArray array];
    }
    return self;
}

- (void) dealloc    {
    [paymentDocs release];
    [super dealloc];
}

@end
