//
//  DocTypeTableViewCell.m
//  MultipleDetailViews
//
//  Created by MacMini on 09.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DocTypeTableViewCell.h"

@implementation DocTypeTableViewCell 

@synthesize label, imageView, docTypeCellView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        if (docTypeCellView==nil) {
            [[NSBundle mainBundle] loadNibNamed:@"DocTypeTableViewCell" owner:self options:nil];
            [self.contentView addSubview: docTypeCellView];
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
    self.docTypeCellView = nil;
}
- (void)dealloc
{
    [label release];
    [imageView release];
    [docTypeCellView release];
    
    [super dealloc];
}

@end
