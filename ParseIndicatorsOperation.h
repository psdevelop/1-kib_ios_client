//
//  ParseIndicatorsOperation.h
//  Uni1CCLient
//
//  Created by MacMini on 03.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *kAddIndicatorsNotif;
extern NSString *kIndicatorsResultMsgNotif;
extern NSString *kIndicatorsResultsKey;
extern NSString *kIndicatorsMsgResultKey;

@interface ParseIndicatorsOperation : NSOperation <NSXMLParserDelegate> {
    
    NSData *indicatorsData;   
    NSMutableArray *indicators;
    NSUInteger parsedIndicatorsCounter;
    BOOL didAbortParsing;    
}

@property (copy, readonly) NSData *indicatorsData;
@property (nonatomic, retain) NSMutableArray *indicators;

@end
