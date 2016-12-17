//
//  CoordinationTableViewCell.h
//  MultipleDetailViews
//
//  Created by MacMini on 15.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CoordinationTableViewCell : UITableViewCell {
    UILabel *numLabel;
    UITextField *viseTextView;
    UITextField *postTextView;
    UITextField *personNamesTextView;
    UITextField *solutionTextField;
    UITextField *solutionActorTextField;
    UITextField *setDateTextField;
    UITextField *maxSetDateTextField; 
    UIImageView *setManualImageView;
    UITextView *commentTextView;
    UIView *coordCellView;
}

@property (nonatomic, retain) IBOutlet UIView *coordCellView;
@property (nonatomic, retain) IBOutlet UILabel *numLabel;
@property (nonatomic, retain) IBOutlet UITextField *viseTextView;
@property (nonatomic, retain) IBOutlet UITextField *postTextView;
@property (nonatomic, retain) IBOutlet UITextField *personNamesTextView;
@property (nonatomic, retain) IBOutlet UITextField *solutionTextField;
@property (nonatomic, retain) IBOutlet UITextField *solutionActorTextField;
@property (nonatomic, retain) IBOutlet UITextField *setDateTextField;
@property (nonatomic, retain) IBOutlet UITextField *maxSetDateTextField;
@property (nonatomic, retain) IBOutlet UIImageView *setManualImageView;
@property (nonatomic, retain) IBOutlet UITextView *commentTextView;

@end
