//
//  SystemMessage.h
//  Uni1CCLient
//
//  Created by MacMini on 11.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SystemMessage : NSObject {
    NSInteger message_type_id;
    NSString *message_caption;
    NSString *message_text;
    NSString *comment;
    NSString *doc_id;    
    BOOL isShowed;
}

@property (nonatomic, assign) NSInteger message_type_id;
@property (nonatomic, assign) BOOL isShowed;
@property (nonatomic, retain) NSString *message_caption;
@property (nonatomic, retain) NSString *message_text;
@property (nonatomic, retain) NSString *comment;
@property (nonatomic, retain) NSString *doc_id;

@end
