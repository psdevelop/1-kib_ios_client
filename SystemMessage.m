//
//  SystemMessage.m
//  Uni1CCLient
//
//  Created by MacMini on 11.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SystemMessage.h"


@implementation SystemMessage

@synthesize message_text, message_caption, message_type_id, isShowed, comment, doc_id;

- (void)dealloc {
    [message_text release];
    [message_caption release];
    [comment release];
    [doc_id release];
    [super dealloc];
}
@end
