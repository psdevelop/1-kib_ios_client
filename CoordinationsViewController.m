//
//  CoordinationsViewController.m
//  MultipleDetailViews
//
//  Created by MacMini on 17.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CoordinationsViewController.h"
#import "CoordinationsTableViewController.h"

@implementation CoordinationsViewController

@synthesize coordTableView, coordDoc, loadIndicator, coordListController;

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
    [coordListController release];
    [loadIndicator release];
    [coordDoc release];
    [coordTableView release];
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
    // Do any additional setup after loading the view from its nib.
    coordListController = [CoordinationsTableViewController alloc];
    coordListController.coordDoc = coordDoc;    
    
    coordListController.loadIndicator = loadIndicator;
    
    [coordListController initWithNibName: @"CoordinationsTableViewController" bundle:nil];
    [self.coordTableView addSubview: coordListController.view];
    
    [loadIndicator setFrame: CGRectMake(330, 90,100,100)]; //loadIndicator.frame.size.width, loadIndicator.frame.size.height)];
    [self.coordTableView addSubview:loadIndicator];
        
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.loadIndicator = nil;
    self.coordTableView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
