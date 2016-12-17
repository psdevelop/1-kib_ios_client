//
//  CoordinatedDoc.m
//  MultipleDetailViews
//
//  Created by MacMini on 15.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CoordinationListDoc.h"


@implementation CoordinationListDoc

@synthesize coordinateSolutions;

-(id) init {
    self = [super init];
    if (self)   {
        self.coordinateSolutions = [NSMutableArray array];
    }
    
    return self;
}

- (void) dealloc    {
    [coordinateSolutions release];
    [super dealloc];
}

@end
