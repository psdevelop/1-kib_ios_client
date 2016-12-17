//
//  Indicator.h
//  Uni1CCLient
//
//  Created by MacMini on 03.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Indicator : NSObject {
    
    NSString *caption;
    NSString *counter;
    NSString *message;
    NSString *comment;
    NSDate *min_date;
    NSDate *max_date;
    
}

@property (nonatomic, retain) NSString *caption;
@property (nonatomic, retain) NSString *counter;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSString *comment;
@property (nonatomic, retain) NSDate *min_date;
@property (nonatomic, retain) NSDate *max_date;

@end
