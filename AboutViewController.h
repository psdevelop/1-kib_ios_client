//
//  AboutViewController.h
//  KIBIOSCLient
//
//  Created by MacMini on 18.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubstitutableDetailViewController.h"


@interface AboutViewController : UIViewController <SubstitutableDetailViewController> {
    
    //UIToolbar *toolbar;
    UILabel *memLabel;
}

//@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UILabel *memLabel;

- (void) getFreeMemInfo;

@end
