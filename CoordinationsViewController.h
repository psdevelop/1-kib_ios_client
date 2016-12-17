//
//  CoordinationsViewController.h
//  MultipleDetailViews
//
//  Created by MacMini on 17.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoordinationListDoc.h"
#import "CoordinationsTableViewController.h"


@interface CoordinationsViewController : UIViewController //<UITabBarControllerDelegate> 
{
    //UITabBarController *tabBarController;
    UIView *coordTableView;
    CoordinationListDoc *coordDoc;
    UIActivityIndicatorView *loadIndicator;
    CoordinationsTableViewController *coordListController; 
}

//@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@property (nonatomic, retain) IBOutlet UIView *coordTableView;
@property (nonatomic, retain) CoordinationListDoc *coordDoc;
@property (nonatomic, retain) CoordinationsTableViewController *coordListController;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *loadIndicator;

@end
