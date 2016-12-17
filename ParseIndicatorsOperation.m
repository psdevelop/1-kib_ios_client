//
//  ParseIndicatorsOperation.m
//  Uni1CCLient
//
//  Created by MacMini on 03.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ParseIndicatorsOperation.h"
#import "ParseDocsOperation.h"
#import "Indicator.h"
#import "SystemMessage.h"

// NSNotification name for sending indicators data back to the app delegate
NSString *kAddIndicatorsNotif = @"AddIndicatorsNotif";
NSString *kIndicatorsResultMsgNotif = @"IndicatorsResultMsgNotif";
// NSNotification userInfo key for obtaining the indicators data
NSString *kIndicatorsResultsKey = @"IndicatorsResultsKey";
NSString *kIndicatorsMsgResultKey = @"IndicatorsMsgResultKey";

@implementation ParseIndicatorsOperation

@synthesize indicatorsData, indicators;

- (id)initWithData:(NSData *)parseData
{
    if ((self = [super init])) {    
        indicatorsData = [parseData copy];
    }
    return self;
}

- (void)addIndicatorsToList:(NSArray *)indicatorsResult {
    assert([NSThread isMainThread]);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kAddIndicatorsNotif object:self userInfo:[NSDictionary dictionaryWithObject:indicatorsResult forKey:kIndicatorsResultsKey]]; 
}

- (void)showIndicatorsResultMessage:(SystemMessage *)systemMessage {
    assert([NSThread isMainThread]);
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kIndicatorsResultMsgNotif object:self userInfo:[NSDictionary dictionaryWithObject:systemMessage                                    forKey:kIndicatorsMsgResultKey]]; 
}

// the main function for this NSOperation, to start the parsing
- (void)main {
    self.indicators = [NSMutableArray array];   
    // It's also possible to have NSXMLParser download the data, by passing it a URL, but this is
    // not desirable because it gives less control over the network, particularly in responding to
    // connection errors.
    //
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:self.indicatorsData];
    [parser setDelegate:self];
    [parser parse];
    
    // depending on the total number of indicators parsed, the last batch might not have been a
    // "full" batch, and thus not been part of the regular batch transfer. So, we check the count of
    // the array and, if necessary, send it to the main thread.
    //
    
    //if ([self.indicators count] > 0) {
        [self performSelectorOnMainThread:@selector(addIndicatorsToList:)
                               withObject:self.indicators
                            waitUntilDone:NO];
    //}    
    
    self.indicators = nil;
    
    [parser release];
}

- (void)dealloc {
    
    [indicators release];
    [indicatorsData release];
    
    [super dealloc];
}


#pragma mark -
#pragma mark Parser constants

// Limit the number of parsed doc props
static const const NSUInteger kMaximumNumberOfIndicatorsToParse = 150;

static NSUInteger const kSizeOfDocBatch = 10;

// Reduce potential parsing errors by using string constants declared in a single place.
static NSString * const kSystemErrorElementName = @"php_error";
static NSString * const kSystemWarningElementName = @"php_warning";
static NSString * const kSuccessValueElementName = @"m:success_value";
static NSString * const kIndicatorElementName = @"m:indicator";
#pragma mark -
#pragma mark NSXMLParser delegate methods

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    // If the number of parsed indicators is greater than
    // kMaximumNumberOfDocsToParse, abort the parse.
    
    
    if (parsedIndicatorsCounter >= kMaximumNumberOfIndicatorsToParse) {
        // Use the flag didAbortParsing to distinguish between this deliberate stop
        // and other parser errors.
        //
        didAbortParsing = YES;
        [parser abortParsing];
    }
    
    if ([elementName isEqualToString:kSystemErrorElementName]) {
        SystemMessage *systemMessage = [[SystemMessage alloc] init];
        systemMessage.isShowed = NO;
        systemMessage.message_type_id=1;
        systemMessage.message_caption=@"Системная ошибка сетевого запроса.";
        systemMessage.message_text = [attributeDict valueForKey:@"msg"];
        systemMessage.comment = [attributeDict valueForKey:@"comment"]; 
        systemMessage.doc_id = [attributeDict valueForKey:@"doc_id"];
        
        [self performSelectorOnMainThread:@selector(showDocsPropResultMessage:) withObject:systemMessage waitUntilDone:NO];
        
        [systemMessage release];
        
    }   else if ([elementName isEqualToString:kSystemWarningElementName]) {
        SystemMessage *systemMessage = [[SystemMessage alloc] init];
        systemMessage.isShowed = NO;
        systemMessage.message_type_id=2;
        systemMessage.message_caption=@"Системное предупреждение звена поставки данных.";
        systemMessage.message_text = [attributeDict valueForKey:@"msg"];
        systemMessage.comment = [attributeDict valueForKey:@"comment"];
        systemMessage.doc_id = [attributeDict valueForKey:@"doc_id"];
        
        [self performSelectorOnMainThread:@selector(showDocsPropResultMessage:) withObject:systemMessage waitUntilDone:NO];
        [systemMessage release];
        
    }   else if ([elementName isEqualToString:kSuccessValueElementName]) {
        SystemMessage *systemMessage = [[SystemMessage alloc] init];
        systemMessage.isShowed = NO;
        systemMessage.message_type_id=3;
        systemMessage.message_caption=[attributeDict valueForKey:@"logical_value"];
        systemMessage.message_text = [attributeDict valueForKey:@"result_text"];
        systemMessage.comment = [attributeDict valueForKey:@"comment"]; 
        systemMessage.doc_id = [attributeDict valueForKey:@"doc_id"];        
        
        [self performSelectorOnMainThread:@selector(showDocsPropResultMessage:) withObject:systemMessage waitUntilDone:NO];
        [systemMessage release];
        
    }   else if ([elementName isEqualToString:kIndicatorElementName]) {
        Indicator *indicator = [[Indicator alloc] init];
        indicator.caption=[attributeDict valueForKey:@"caption"];
        indicator.counter = [attributeDict valueForKey:@"counter"];
        indicator.comment = [attributeDict valueForKey:@"comment"]; 
        indicator.message = [attributeDict valueForKey:@"message"];
        
        NSDateFormatter *indicatorFormatter = [[NSDateFormatter alloc] init];
        [indicatorFormatter setDateFormat:@"yyyy'-'MM'-'dd' 'HH':'mm':'ss"];
        
        indicator.max_date = [indicatorFormatter dateFromString: [[attributeDict valueForKey:@"max_date"] stringByReplacingOccurrencesOfString:@"T" withString:@" "]];
        
        indicator.min_date = [indicatorFormatter dateFromString: [[attributeDict valueForKey:@"min_date"] stringByReplacingOccurrencesOfString:@"T" withString:@" "]];
        
        [self.indicators addObject:indicator];
        
        [indicator release];
        
    }    
    else {
        
    }

}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {     

}

// an error occurred while parsing the doc prop data,
// post the error as an NSNotification to our app delegate.
// 
- (void)handleDocsPropError:(NSError *)parseError {
    [[NSNotificationCenter defaultCenter] postNotificationName:kDocsErrorNotif object:self userInfo:[NSDictionary dictionaryWithObject:parseError forKey:kDocsMsgErrorKey]];
}

// an error occurred while parsing the doc prop data,
// pass the error to the main thread for handling.

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    if ([parseError code] != NSXMLParserDelegateAbortedParseError && !didAbortParsing)
    {
        [self performSelectorOnMainThread:@selector(handleDocsPropError:)
                               withObject:parseError
                            waitUntilDone:NO];
    }
}

@end
