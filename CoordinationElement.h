//
//  CoordinationElement.h
//  MultipleDetailViews
//
//  Created by MacMini on 15.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CoordinationElement : NSObject {
    NSString *vise_name;
    NSString *actor_post_name;
    NSString *person_name;
    NSString *statement_solution_value;
    NSString *solution_actor_name;
    NSString *set_date;
    NSString *max_set_date;
    NSString *comment;
    BOOL setManual;
}

@property (nonatomic, retain) NSString *vise_name;
@property (nonatomic, retain) NSString *actor_post_name;
@property (nonatomic, retain) NSString *person_name;
@property (nonatomic, retain) NSString *statement_solution_value;
@property (nonatomic, retain) NSString *solution_actor_name;
@property (nonatomic, retain) NSString *comment;
@property (nonatomic, retain) NSString *set_date;
@property (nonatomic, retain) NSString *max_set_date;
@property (nonatomic, assign) BOOL setManual;

@end
