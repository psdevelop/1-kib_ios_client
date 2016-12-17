//
//  Setting.m
//  Uni1CCLient
//
//  Created by MacMini on 04.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Setting.h"


@implementation Setting

@synthesize settingName, settingType, settingStrValue, BOOLValue;

- (void)dealloc {
    [settingName release];
    [settingType release];
    [settingStrValue release];
    [super dealloc];
}

@end
