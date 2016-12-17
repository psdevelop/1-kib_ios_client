//
//  DataDestinationViewController.h
//  Uni1CCLient
//
//  Created by MacMini on 24.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol DataDestinationViewController 
- (void)refreshData:(NSMutableData *)data:(NSInteger)queryMode;
@end
