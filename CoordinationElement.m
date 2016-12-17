//
//  CoordinationElement.m
//  MultipleDetailViews
//
//  Created by MacMini on 15.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CoordinationElement.h"


@implementation CoordinationElement

@synthesize vise_name, actor_post_name, comment, max_set_date, person_name, set_date, solution_actor_name, statement_solution_value, setManual;

- (void)dealloc {
    [vise_name release];
    [actor_post_name release];
    [comment release];
    [max_set_date release];
    [person_name release];
    [set_date release];
    [solution_actor_name release];
    [statement_solution_value release];
    [super dealloc];
}

@end
