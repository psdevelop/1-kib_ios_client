//
//  Setting.h
//  Uni1CCLient
//
//  Created by MacMini on 04.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Setting : NSObject {
    
    NSString *settingType;
    NSString *settingName;
    NSString *settingStrValue;
    BOOL BOOLValue;
}

@property (nonatomic, retain) NSString *settingType;
@property (nonatomic, retain) NSString *settingName;
@property (nonatomic, retain) NSString *settingStrValue;
@property (nonatomic, assign) BOOL BOOLValue;

@end
