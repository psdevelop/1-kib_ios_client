//
//  SettingsListByTypeTableViewController.h
//  Uni1CCLient
//
//  Created by MacMini on 04.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Setting.h"
#import "SettingTableCell.h"


@interface SettingsListByTypeTableViewController : UITableViewController {
    
    NSMutableArray *settingsList;
    NSUserDefaults *settings;
    UISwitch *prefDemoSwitch;
    UIView *prefServAdressView;
    UITextField *prefServAdressTextField;
    UIButton *prefServAdressSaveButton;
}

@property (nonatomic, retain) NSMutableArray *settingsList;
@property (nonatomic, retain) NSUserDefaults *settings;
@property (nonatomic, retain) IBOutlet UISwitch *prefDemoSwitch;
@property (nonatomic, retain) IBOutlet UIView *prefServAdressView;
@property (nonatomic, retain) IBOutlet UITextField *prefServAdressTextField;
@property (nonatomic, retain) IBOutlet UIButton *prefServAdressSaveButton;

-(void) refreshData;
- (IBAction)switchDemoPut:(id) sender;
- (IBAction)serverAdressPut:(id) sender;
- (void) loadDefaultPrefs;

@end
