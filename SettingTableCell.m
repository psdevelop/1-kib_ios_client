//
//  SettingTableCell.m
//  Uni1CCLient
//
//  Created by MacMini on 04.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingTableCell.h"


@implementation SettingTableCell

@synthesize settingCell, settingNameLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        if (settingCell==nil) {
            [[NSBundle mainBundle] loadNibNamed:@"SettingTableCell" owner:self options:nil];
            [self.contentView addSubview: settingCell];
            [settingCell setFrame:CGRectMake(10, 2, 600, 40)];
        }
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)viewDidUnload   {
    self.settingNameLabel = nil;
    self.settingCell = nil;
}

- (void)dealloc
{
    [settingNameLabel release];
    [settingCell release];
    [super dealloc];
}

@end
