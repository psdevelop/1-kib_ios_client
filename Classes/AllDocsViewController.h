//
//  AllDocsViewController.h
//  MultipleDetailViews
//
//  Created by MacMini on 18.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubstitutableDetailViewController.h"
#import "DocsListTableViewController.h"
#import "PopupWindow.h"

@interface AllDocsViewController : UIViewController <SubstitutableDetailViewController, popupWindowProtocol> {
      
    UIBarButtonItem *rootPopoverButtonItem;
    
    //UIToolbar *toolbar;
    DocsListTableViewController *DocsListController;
    UIView *docsListPlaceHolderView;
    UIBarButtonItem *backToFilterButton;
    UINavigationBar *docsNavBar;
}

@property (nonatomic, retain) UIBarButtonItem *rootPopoverButtonItem;
//@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) DocsListTableViewController *DocsListController;
@property (nonatomic, retain) IBOutlet UIView *docsListPlaceHolderView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *backToFilterButton;
@property (nonatomic, retain) IBOutlet UINavigationBar *docsNavBar;

-(IBAction) navBack:(id) sender;
- (IBAction) moreDocsTapped: (id) sender;
- (IBAction) dateSetTapped: (id) sender;

@end
