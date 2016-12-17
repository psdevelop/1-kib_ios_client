//
//  DocTypeTableViewCell.h
//  MultipleDetailViews
//
//  Created by MacMini on 09.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainMenuTableViewCell : UITableViewCell {
	UILabel *label;
    UIImageView *imageView;
    UIView *mainMenuCellView;
    
}

@property (nonatomic, retain) IBOutlet UILabel *label;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIView *mainMenuCellView;

@end
