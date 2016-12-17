//
//  PaymentListDoc.h
//  MultipleDetailViews
//
//  Created by MacMini on 15.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PaymentListDoc : NSObject {
    NSMutableArray *payments;
}

@property (nonatomic, retain) NSMutableArray *payments;

@end
