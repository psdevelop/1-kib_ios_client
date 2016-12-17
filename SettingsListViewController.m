//
//  SettingsListViewController.m
//  Uni1CCLient
//
//  Created by MacMini on 04.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsListViewController.h"
#import "AppDelegate.h"

@implementation SettingsListViewController

@synthesize settingsListPlaceHolderView, settingsListTableViewController, splitViewController, popoverController, rootPopoverButtonItem;

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
    [settingsListTableViewController release];
    [settingsListPlaceHolderView release];
    //[toolbar release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)orientationChanged:(NSNotification *)notification {
    
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    //if (deviceOrientation==UIDeviceOrientationUnknown)  {
    //    deviceOrientation=startOrientation;
    //}    
    if (UIDeviceOrientationIsLandscape(deviceOrientation))  {
        [settingsListTableViewController.view setFrame:CGRectMake(0, 0, 700, 1000)];
    }   else    {
        [settingsListTableViewController.view setFrame:CGRectMake(0, 0, 770, 1000)];
    }
    
    //[self showRootPopoverButtonItem:self.rootPopoverButtonItem:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];    
    
    self.settingsListTableViewController = [SettingsListByTypeTableViewController alloc];
    [settingsListTableViewController initWithNibName:@"SettingsListByTypeTableViewController" bundle:nil];    
    [self.settingsListPlaceHolderView addSubview:settingsListTableViewController.view];
    
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    if (deviceOrientation==UIDeviceOrientationUnknown)  {
        deviceOrientation=startOrientation;
    }    
    if (UIDeviceOrientationIsLandscape(deviceOrientation))  {
        [settingsListTableViewController.view setFrame:CGRectMake(0, 0, 700, 1000)];
    }   else    {
        [settingsListTableViewController.view setFrame:CGRectMake(0, 0, 770, 1000)];
    }
    [settingsListTableViewController release];
    
    UIBarButtonItem *defsRestoreButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Вернуться к стандартным", @"")  style:UIBarButtonItemStyleBordered  target:self	  action:@selector(loadDefaultPrefs:)];
    
    self.navigationItem.rightBarButtonItem = defsRestoreButton;
    // Do any additional setup after loading the view from its nib.
}

- (IBAction) loadDefaultPrefs:(id) sender   {
    [settingsListTableViewController loadDefaultPrefs];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self showRootPopoverButtonItem:self.rootPopoverButtonItem:NO];
}

#pragma mark -
#pragma mark Managing the popover

- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem : (BOOL) itIsOrientationChanging {
    
    
}


- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    //self.toolbar = nil;
    self.settingsListPlaceHolderView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
