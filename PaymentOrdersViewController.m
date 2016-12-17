//
//  CoordinationsViewController.m
//  MultipleDetailViews
//
//  Created by MacMini on 17.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PaymentOrdersViewController.h"

@implementation PaymentOrdersViewController

@synthesize payOrdersListViewController, paymentOrdListTableView, paymentPlanDoc, loadIndicator;

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
    [payOrdersListViewController release];
    [loadIndicator release];
    [paymentPlanDoc release];
    [paymentOrdListTableView release];
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
    payOrdersListViewController = [PaymentOrdersTableViewController alloc];
    payOrdersListViewController.paymentPlanDoc = paymentPlanDoc;
    
    payOrdersListViewController.loadIndicator = loadIndicator;
    
    [payOrdersListViewController initWithNibName: @"PaymentOrdersTableViewController" bundle:nil];
    [self.paymentOrdListTableView addSubview: payOrdersListViewController.view];
    
    [loadIndicator setFrame: CGRectMake(330, 90,100,100)]; 
    [self.paymentOrdListTableView addSubview:loadIndicator];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.loadIndicator = nil;
    self.paymentOrdListTableView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
