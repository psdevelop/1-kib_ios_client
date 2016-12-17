//
//  PaymentDocViewController.m
//  MultipleDetailViews
//
//  Created by MacMini on 14.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PaymentDocViewController.h"


@implementation PaymentDocViewController

@synthesize toolbar, tabBarController, tabBarPlaceHolderView, rootPopoverButtonItem, paymentDoc;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [toolbar release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self showRootPopoverButtonItem: rootPopoverButtonItem];
    //[self.tabBarPlaceHolderView addSubview:tabBarController.view];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    self.toolbar = nil;
}

#pragma mark -
#pragma mark Managing the popover

- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    
    // Add the popover button to the toolbar.
    //NSMutableArray *itemsArray = [toolbar.items mutableCopy];
    //[itemsArray insertObject:barButtonItem atIndex:0];
    //[toolbar setItems:itemsArray animated:NO];
    //[itemsArray release];
}


- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    
    // Remove the popover button from the toolbar.
    //NSMutableArray *itemsArray = [toolbar.items mutableCopy];
    //[itemsArray removeObject:barButtonItem];
    //[toolbar setItems:itemsArray animated:NO];
    //[itemsArray release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
