//
//  PaymentOrderList.h
//  MultipleDetailViews
//
//  Created by MacMini on 15.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PaymentDoc.h"

@interface PaymentOrderList : NSObject {
    NSMutableArray *paymentDocs;
}

@property (nonatomic, retain) NSMutableArray *paymentDocs;

@end
