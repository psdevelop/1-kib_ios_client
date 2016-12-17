//
//  CoordinationTableViewCell.m
//  MultipleDetailViews
//
//  Created by MacMini on 15.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CoordinationTableViewCell.h"


@implementation CoordinationTableViewCell

@synthesize coordCellView, numLabel, viseTextView, postTextView, personNamesTextView, solutionTextField, solutionActorTextField, setDateTextField, setManualImageView, maxSetDateTextField, commentTextView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        if (coordCellView==nil) {
            [[NSBundle mainBundle] loadNibNamed:@"CoordinationTableViewCell" owner:self options:nil];
            [self.contentView addSubview: coordCellView];
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
    self.numLabel = nil;
    self.viseTextView = nil;
    self.postTextView = nil;
    self.personNamesTextView = nil;
    self.solutionTextField = nil;
    self.solutionActorTextField = nil;
    self.setDateTextField = nil;
    self.setManualImageView = nil;
    self.maxSetDateTextField = nil;
    self.commentTextView = nil;
    self.coordCellView = nil;
}

- (void)dealloc
{
    [numLabel release];
    [viseTextView release];
    [postTextView release];
    [personNamesTextView release];
    [solutionTextField release];
    [solutionActorTextField release];
    [setDateTextField release];
    [setManualImageView release];
    [maxSetDateTextField release];
    [commentTextView release];
    [coordCellView release];
    [super dealloc];
}

@end
