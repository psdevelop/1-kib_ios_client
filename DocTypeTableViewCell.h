//
//  DocTypeTableViewCell.h
//  MultipleDetailViews
//
//  Created by MacMini on 09.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DocTypeTableViewCell : UITableViewCell {
	UILabel *label;
	//UITextView *textView;
    UIImageView *imageView;
    //UIImageView *rigthArrow;
    UIView *docTypeCellView;
    //UIView *backGroundView;
    //UIImageView *backImageView;
}

@property (nonatomic, retain) IBOutlet UILabel *label;
//@property (nonatomic, retain) IBOutlet UITextView *textView;
@property (nonatomic, retain) IBOutlet UIImageView *imageView;
//@property (nonatomic, retain) IBOutlet UIImageView *rigthArrow;
@property (nonatomic, retain) IBOutlet UIView *docTypeCellView;
//@property (nonatomic, retain) IBOutlet UIView *backGroundView;
//@property (nonatomic, retain) IBOutlet UIImageView *backImageView;

@end
