//
//  ParseDocProperties.h
//  Uni1CCLient
//
//  Created by MacMini on 29.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Doc.h"
#import "DocType.h"
#import "CoordinationElement.h"
#import "SystemMessage.h"
#import "PaymentDoc.h"
#import "PaymentPlanDoc.h"

extern NSString *kAddDocsCoordNotif;
extern NSString *kAddDocsIncludeNotif;
extern NSString *kDocsPropResultMsgNotif;
extern NSString *kDocCoordResultsKey;
extern NSString *kDocPropResultsKey;
extern NSString *kDocIncludeResultsKey;

@interface ParseDocProperties : NSOperation <NSXMLParserDelegate> {
    NSData *docPropertyData;  
    NSMutableArray *includeDocs;
    NSMutableArray *coordTable;
    NSUInteger parsedIncDocsCounter;
    NSUInteger parsedCoordCounter;
    PaymentDoc *currentPaymentDocObject;
    PaymentPlanDoc *currentPaymentPlanDocObject;
    NSUInteger parsedDocsCounter;
    BOOL didAbortParsing;
}

@property (copy, readonly) NSData *docPropertyData;
@property (nonatomic, retain) NSMutableArray *includeDocs;
@property (nonatomic, retain) NSMutableArray *coordTable;
@property (nonatomic, retain) PaymentDoc *currentPaymentDocObject;
@property (nonatomic, retain) PaymentPlanDoc *currentPaymentPlanDocObject;

@end
