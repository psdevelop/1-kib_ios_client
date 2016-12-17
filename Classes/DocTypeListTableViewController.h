//
//  DocTypeListTableViewController.h
//  MultipleDetailViews
//
//  Created by MacMini on 09.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DocType.h"
#import "SubstitutableDetailViewController.h"
#import "MainHTTPConnection.h"
#import "DataDestinationViewController.h"

@interface DocTypeListTableViewController : UITableViewController <UISplitViewControllerDelegate, DataDestinationViewController, UIAlertViewDelegate> {
        NSMutableArray *DocTypesList;
        UISplitViewController *splitViewController;
        
        UIPopoverController *popoverController;    
        UIBarButtonItem *rootPopoverButtonItem;
    
@private
    //for loading the xml data
    NSMutableData *earthquakeData;
    NSOperationQueue *parseQueue;
    DocType *prevDocTypeObject;
    NSString *currentFilter;
}

@property (nonatomic, retain) NSMutableArray *DocTypesList;
@property (nonatomic, assign) UISplitViewController *splitViewController;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) UIBarButtonItem *rootPopoverButtonItem;
@property (nonatomic, retain) DocType *prevDocTypeObject;
@property (nonatomic, retain) NSString *currentFilter;

- (void)insertDocTypes:(NSArray *)docTypes;
- (void)alertRefreshOKCancelAction;
- (void) selectByRowNumber:(NSMutableArray*) ObjList : (NSUInteger) row: (BOOL) refreshDocs;

@end
