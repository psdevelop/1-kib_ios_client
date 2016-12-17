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

@interface DocTypeListPortraitTableViewController : UITableViewController <UISplitViewControllerDelegate> {
        NSMutableArray *DocTypesList;
        UISplitViewController *splitViewController;
        
        UIPopoverController *popoverController;    
        UIBarButtonItem *rootPopoverButtonItem;
@private
    // for downloading the xml data
    NSURLConnection *earthquakeFeedConnection;
    NSMutableData *earthquakeData;
    
    NSOperationQueue *parseQueue;  
}

@property (nonatomic, retain) NSMutableArray *DocTypesList;
@property (nonatomic, assign) IBOutlet UISplitViewController *splitViewController;

@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) UIBarButtonItem *rootPopoverButtonItem;
- (void)insertEarthquakes:(NSArray *)earthquakes;   
// addition method of earthquakes (for KVO purposes)
@end
