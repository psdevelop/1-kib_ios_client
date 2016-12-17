//
//  CoordinatedDoc.h
//  MultipleDetailViews
//
//  Created by MacMini on 15.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Doc.h"

@interface CoordinationListDoc : Doc {
    NSMutableArray *coordinateSolutions;
}

@property (nonatomic, retain) NSMutableArray *coordinateSolutions;

@end
