//
//  SettingsListViewController.h
//  Uni1CCLient
//
//  Created by MacMini on 04.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsListByTypeTableViewController.h"
#import "SubstitutableDetailViewController.h"

@interface SettingsListViewController : UIViewController<SubstitutableDetailViewController> {
    
    UISplitViewController *splitViewController;
    UIPopoverController *popoverController;    
    UIBarButtonItem *rootPopoverButtonItem;    
    
    SettingsListByTypeTableViewController * settingsListTableViewController;
    UIView *settingsListPlaceHolderView;
    //UIToolbar *toolbar;
}

@property (nonatomic, retain) UISplitViewController *splitViewController;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) UIBarButtonItem *rootPopoverButtonItem;
@property (nonatomic, retain) SettingsListByTypeTableViewController * settingsListTableViewController;
@property (nonatomic, retain) IBOutlet UIView *settingsListPlaceHolderView;
//@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;

- (IBAction) loadDefaultPrefs:(id) sender;

@end
