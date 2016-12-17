//
//  Indicator.m
//  Uni1CCLient
//
//  Created by MacMini on 03.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Indicator.h"


@implementation Indicator

@synthesize caption, message, comment, counter, max_date, min_date;

- (void)dealloc {
    
    [caption release];
    [message release];
    [comment release];
    [counter release];
    [min_date release];
    [max_date release];
    
    [super dealloc];
}

@end
