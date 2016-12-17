//
//  SettingTableCell.h
//  Uni1CCLient
//
//  Created by MacMini on 04.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingTableCell : UITableViewCell {
    UIView *settingCell;
    UILabel *settingNameLabel;
}

@property (nonatomic, retain) IBOutlet UIView *settingCell;
@property (nonatomic, retain) IBOutlet UILabel *settingNameLabel;

@end
