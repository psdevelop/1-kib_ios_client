//
//  DocTypeTableViewCell.m
//  MultipleDetailViews
//
//  Created by MacMini on 09.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MainMenuTableViewCell.h"

@implementation MainMenuTableViewCell 

@synthesize label, imageView, mainMenuCellView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        if (mainMenuCellView==nil) {
            [[NSBundle mainBundle] loadNibNamed:@"MainMenuTableViewCell" owner:self options:nil];
            [self.contentView addSubview: mainMenuCellView];
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
    self.label = nil;
    self.imageView = nil;
    self.mainMenuCellView = nil;
}

- (void)dealloc
{
    [label release];
    [imageView release];
    [mainMenuCellView release];
    [super dealloc];
}

@end
