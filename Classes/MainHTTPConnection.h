//
//  MainHTTPConnection.h
//  Uni1CCLient
//
//  Created by MacMini on 23.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataDestinationViewController.h"

extern NSInteger kQueryModeUnknown;
extern NSInteger kQueryModeDocTypes;
extern NSInteger kQueryModePaymentDocs;
extern NSInteger kQueryModePubPaymentDocs;
extern NSInteger kQueryModePlanDocs;
extern NSInteger kQueryModeCoordDocs;
extern NSInteger kQueryModeIncludeDocs;
extern NSInteger kQueryModeStatementSet;
extern NSInteger kQueryModeIndicators;

@interface MainHTTPConnection : NSObject {
    NSString *queryURLString;
    NSString *loginName; 
    NSString *password;    
    NSURLRequest *queryURLRequest;
    NSURLConnection *queryFeedConnection;
    NSMutableData *queryData;
    UIViewController<DataDestinationViewController> *destController;
    UITableViewController<DataDestinationViewController> *destTableController;
    UIActivityIndicatorView *loadIndicator;
    NSInteger queryMode;
}

@property (nonatomic, retain) NSString *queryURLString;
@property (nonatomic, retain) NSString *loginName;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSURLRequest *queryURLRequest;
@property (nonatomic, retain) NSURLConnection *queryFeedConnection;
@property (nonatomic, retain) NSMutableData *queryData;
@property (nonatomic, retain) UIViewController<DataDestinationViewController> *destController;
@property (nonatomic, retain) UITableViewController<DataDestinationViewController> *destTableController;
@property (nonatomic, retain) UIActivityIndicatorView *loadIndicator;
@property (nonatomic, assign) NSInteger queryMode;

- (void)handleError:(NSError *)error;
- (void)sendRequest:(NSString *) urlString;
- (void)sendRequestWithAuth:(NSString *) urlString: (NSString *) authLogin: (NSString *) authPass;

@end
