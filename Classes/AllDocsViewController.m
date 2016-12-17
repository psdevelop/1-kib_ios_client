//
//  AllDocsViewController.m
//  MultipleDetailViews
//
//  Created by MacMini on 18.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AllDocsViewController.h"
#import "AppDelegate.h"


@implementation AllDocsViewController

@synthesize  DocsListController, docsListPlaceHolderView, rootPopoverButtonItem, backToFilterButton, docsNavBar;

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
    [backToFilterButton release];
    //[toolbar release];
    [DocsListController release];
    [docsListPlaceHolderView release];
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
    
    if(UIDeviceOrientationIsLandscape(deviceOrientation)) {
        
        //if (DocsListController.showAlways)  {
        //    [DocsListController.view setHidden:false];        
        //}
        //else    {
        //    [DocsListController.view setHidden:true];
        //}
        
        [DocsListController.view setFrame:CGRectMake(0,0, 700, 720)];    
    }
    
    if (UIDeviceOrientationIsPortrait(deviceOrientation)) {
        //[DocsListController.view setHidden:false];        
        [DocsListController.view setFrame:CGRectMake(0,0, 800, 950)];
    }
}

- (IBAction) moreDocsTapped: (id) sender    {
    [DocsListController moreDocsTapped];
}

#pragma mark - Popup Window delegate 
//**//
-(void)popupWindowDoneClicked:(UIView *)view
{
    
}
//**//

- (IBAction) dateSetTapped: (id) sender    {

    [[allDTDetailViewController view] setFrame:CGRectMake(0, 0, 400, 400)];
    PopupWindow *navController = [[PopupWindow alloc] initWithRootViewController:allDTDetailViewController];
    navController.popupDelegate = self;
    //[modalView release];
    
    [self presentModalViewController:navController animated:YES];
    [navController release];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications]; 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    
    if (deviceOrientation==UIDeviceOrientationUnknown)  {
        deviceOrientation=startOrientation;
    }  
    
    //[DocsListController.view setHidden:true];
    [self.docsListPlaceHolderView addSubview:DocsListController.view];
    
    if(UIDeviceOrientationIsLandscape(deviceOrientation)) {
        
        //if (DocsListController.showAlways)  {
        //    [DocsListController.view setHidden:false];        
        //}
        //else    {
        //    [DocsListController.view setHidden:true];
        //}
        
        [DocsListController.view setFrame:CGRectMake(0,0, 720, 720)];    
    }
    
    if (UIDeviceOrientationIsPortrait(deviceOrientation)) {
        //[DocsListController.view setHidden:false];        
        [DocsListController.view setFrame:CGRectMake(0,0, 780, 950)];
    }
    
    if (DocsListController.showAlways)
        [backToFilterButton setEnabled:NO];
    else
        [backToFilterButton setEnabled:YES];
    
    UIBarButtonItem *moreButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Больше", @"")  style:UIBarButtonItemStyleBordered  target:self	  action:@selector(moreDocsTapped:)];
    UIBarButtonItem *datesButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Даты", @"")  style:UIBarButtonItemStyleBordered  target:self	  action:@selector(dateSetTapped:)];   
    NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:2];
    [buttons addObject:moreButton];
    [buttons addObject:datesButton];
    
    UIToolbar *tools = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 150, 45)];
    [tools setItems:buttons animated:NO];
    
    UIBarButtonItem *rightButtons = [[UIBarButtonItem alloc] initWithCustomView:tools];
    //[[[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Больше", @"")  style:UIBarButtonItemStyleBordered  target:self	  action:@selector(moreDocsTapped:)] autorelease];
	self.navigationItem.rightBarButtonItem = rightButtons;
    //self.navigationItem.title = @"Заявки на расход 00.00.0000 - 00.00.0000";
    self.navigationItem.backBarButtonItem.title = @"Назад";
    self.navigationItem.leftBarButtonItem.title = @"Назад";
    //self.navigationController.navigationItem.backBarButtonItem.title = @"Назад";
    //NSArray *buttonArray = [[NSArray alloc] initWithObjects:moreButton, nil];
    //self.navigationItem.rightBarButtonItems
    //self.navigationItem.rightBarButtonItems 
    //[self.navigationItem.rightBarButtonItems paste:moreButton];    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.backToFilterButton = nil;
    //self.toolbar = nil;
    self.docsListPlaceHolderView = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self showRootPopoverButtonItem:self.rootPopoverButtonItem:NO];
    NSDateFormatter *canonicalFullFormatter = [[NSDateFormatter alloc] init];
    [canonicalFullFormatter setDateFormat:@"yyyyMMddHHmmss"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"Y-MM-dd"];
    
    if (DocsListController.showAlways)
    {
        if (DocsListController.docType.doc_type_id==3)
            self.navigationItem.title = @"Реестры платежей";
        else
                self.navigationItem.title = @"Заявки на расход";
    }
    else        {
        if (DocsListController.docType.doc_type_id==3)
            self.navigationItem.title = @"Реестры платежей";
        else        
            self.navigationItem.title = [[[@"Заявки на расход " stringByAppendingString:[formatter stringFromDate:[canonicalFullFormatter dateFromString:kStartDate]]] stringByAppendingString:@" - "] stringByAppendingString:[formatter stringFromDate:[canonicalFullFormatter dateFromString:kEndDate]]];
    }
    
    [canonicalFullFormatter release]; 
    [formatter release];    
}

- (void) viewWillDisappear:(BOOL)animated   {
    [super viewWillDisappear:animated];
    if (DocsListController.docType.doc_type_id==3)
        self.navigationItem.title = @"Реестры";
    else    
        self.navigationItem.title = @"Заявки";
}

#pragma mark -
#pragma mark Managing the popover

- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem : (BOOL) itIsOrientationChanging {
    
}

-(IBAction) navBack:(id) sender {
    //[childDocListController.navigationController popViewControllerAnimated:true];
    
    [self.navigationController popViewControllerAnimated:true];
}

- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    
    // Remove the popover button from the toolbar.
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
