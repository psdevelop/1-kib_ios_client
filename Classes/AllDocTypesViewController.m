/*
   Version: 1.1
  */

#import "AllDocTypesViewController.h"
#import "ParseDocTypesOperation.h"
#import "FilterPopoverViewController.h"
#import "DocTypesRootViewController.h"
#import "AppDelegate.h"

#define kStdButtonWidth		106.0
#define kStdButtonHeight	40.0

@implementation AllDocTypesViewController

@synthesize filterView, popoverController, rootPopoverButtonItem, startDatePicker, startDateTextField, endDateTextField, onlyNonStatButton, formatter, notShowClosedButton, canonicalFormatter, toolbar, currentFilter, docTypeSelectSegmControl, hidePickerButton, datePickerView;

#pragma mark -
#pragma mark View lifecycle

- (id) init {
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

- (void)orientationChanged:(NSNotification *)notification {
    
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    
    if(UIDeviceOrientationIsLandscape(deviceOrientation)) {
        
    }
    else if (UIDeviceOrientationIsPortrait(deviceOrientation)) {
   
    }
}

- (void) viewDidLoad {
    [super viewDidLoad];
      
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    
    if(UIDeviceOrientationIsLandscape(deviceOrientation)) {
        
    }
    else if (UIDeviceOrientationIsPortrait(deviceOrientation)) {

    }
    
    FilterPopoverViewController *filterPopoverContentView = [[FilterPopoverViewController alloc] initWithNibName:@"FilterPopoverViewController" bundle:nil];
    
    UIPopoverController *filterPopover = [[UIPopoverController alloc] initWithContentViewController:filterPopoverContentView];
    filterPopover.popoverContentSize = CGSizeMake(519, 290);
    filterPopover.delegate = self;
    self.popoverController = filterPopover;  
    [filterPopover release];
    [self createDatePicker];
    
    //NSTimeInterval secondsPerDay = 24 * 60 * 60;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"Y-MM-dd"];
    
    canonicalFormatter = [[NSDateFormatter alloc] init];
    [canonicalFormatter setDateFormat:@"YMMdd"];
    
    if (kNoHasStatementStatus)    {
        [onlyNonStatButton setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
    }
    else    {
        [onlyNonStatButton setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];        
    }
    
    if (kNoHasClosedStatus)    {
        [notShowClosedButton setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
    }
    else    {
        [notShowClosedButton setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];        
    }  
    
    UIImage *buttonBackground = [UIImage imageNamed:@"whiteButton.png"];
    UIImage *buttonBackgroundPressed = [UIImage imageNamed:@"blueButton.png"];
    
    //CGRect button_frame = CGRectMake(182.0, 5.0, kStdButtonWidth, kStdButtonHeight);
    
    // or you can do this:
	//		UIButton *button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	
	hidePickerButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	hidePickerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	
	[hidePickerButton setTitle:@"OK" forState:UIControlStateNormal];	

    [hidePickerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	
	UIImage *newImage = [buttonBackground stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[hidePickerButton setBackgroundImage:newImage forState:UIControlStateNormal];
	
	UIImage *newPressedImage = [buttonBackgroundPressed stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[hidePickerButton setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];
    
    self.navigationItem.title = @"Даты";	
	//[button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	
    // in case the parent view draws with a custom color or gradient, use a transparent color
	hidePickerButton.backgroundColor = [UIColor clearColor];    
}

- (IBAction) touchDocTypeSelect:(id) sender {
    currentDocTypeIndex = docTypeSelectSegmControl.selectedSegmentIndex+1;
}

- (IBAction) byFilterSelect:(id) sender {
    
}

- (void)setCurrentParams    {
    NSDateFormatter *canonicalFullFormatter = [[NSDateFormatter alloc] init];
    [canonicalFullFormatter setDateFormat:@"yyyyMMddHHmmss"];
    
    startDateTextField.text = [formatter stringFromDate:[canonicalFullFormatter dateFromString:kStartDate]];
    endDateTextField.text = [formatter stringFromDate:[canonicalFullFormatter dateFromString:kEndDate]];
    
    docTypeSelectSegmControl.selectedSegmentIndex = currentDocTypeIndex-1;
    
    [canonicalFullFormatter release];
}

- (void)viewDidUnload {
	[super viewDidUnload];
    
	self.toolbar = nil;
    self.startDatePicker = nil;
    self.hidePickerButton = nil;
    self.datePickerView = nil;
    self.startDateTextField = nil;
    self.endDateTextField = nil;
    self.docTypeSelectSegmControl = nil;
    self.notShowClosedButton = nil;
    self.onlyNonStatButton = nil;
       
}

- (void)createDatePicker
{
	//startDatePicker.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
	startDatePicker.datePickerMode = UIDatePickerModeDate;
}

- (IBAction) touchOnlyStat:(id) sender  {
    kNoHasStatementStatus = !kNoHasStatementStatus;
    if (kNoHasStatementStatus)    {
        [onlyNonStatButton setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
    }
    else    {
        [onlyNonStatButton setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];        
    }
}

- (IBAction) touchNotShowPaymed:(id) sender {
    kNoHasClosedStatus = !kNoHasClosedStatus;
    if (kNoHasClosedStatus)    {
        [notShowClosedButton setImage:[UIImage imageNamed:@"checked.png"] forState:UIControlStateNormal];
    }
    else    {
        [notShowClosedButton setImage:[UIImage imageNamed:@"unchecked.png"] forState:UIControlStateNormal];        
    }    
}

- (IBAction) startFilterDateTouch: (id) sender  {
    currentDateField = 1;
    [self showDateSetActionSheet];
}

- (IBAction) endFilterDateTouch:(id) sender     {
    currentDateField = 2;
    [self showDateSetActionSheet];
}

- (IBAction) datePickerTouch:(id) sender    {
    if (currentDateField==1)    {
        NSString *setDateTime = [formatter stringFromDate:[startDatePicker date]];
        startDateTextField.text = setDateTime; 
        [kStartDate release];
        kStartDate = [[[canonicalFormatter stringFromDate:[startDatePicker date]] stringByAppendingString:@"000000"] retain];
        
    }
    else if (currentDateField==2)    {
        NSString *setDateTime = [formatter stringFromDate:[startDatePicker date]];
        endDateTextField.text = setDateTime;
        [kEndDate  release];
        kEndDate = [[[canonicalFormatter stringFromDate:[startDatePicker date]] stringByAppendingString:@"000000"] retain];              
    }
    else    {
        
    }
}

- (NSString*) getStrValue: (NSString *) paramName   {
    if ([paramName isEqualToString:@"start_date"])  {
        return kStartDate;
    }
    else if ([paramName isEqualToString:@"end_date"])  {
        return kEndDate;
    }
    else if ([paramName isEqualToString:@"not_show_stat"])  {
            return @"";
    }
    else if ([paramName isEqualToString:@"not_show_paymed"])  {
            return @"";
    }
    else
        return @"";
}
- (IBAction) exitFromDateSet:(id) sender    {
    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка получения данных" message:@"Не найден файл с данными для DEMO-режима!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    //[alert show];	
    //[alert release];    
    [datePickerView setHidden:YES];
}

- (void) showDateSetActionSheet     {
    //
    [datePickerView setHidden:NO];
	/*UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Payment Type"          delegate:self cancelButtonTitle:@"Done"destructiveButtonTitle:@"Done"   otherButtonTitles:@"Button1ss", @"Button2", @"Button2sss", nil];
    
    // Add the picker
    [startDatePicker setFrame:CGRectMake(0,235,0,0)];
    startDatePicker.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [actionSheet addSubview:startDatePicker];
    [actionSheet showInView:self.view];
    //actionSheet s
    [actionSheet setBounds:CGRectMake(0,0,320, 700)];
    actionSheet.autoresizingMask=UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleTopMargin
    |UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin;
    [actionSheet release]; */   
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self showRootPopoverButtonItem:self.rootPopoverButtonItem:NO];
    [self setCurrentParams];    
}

- (IBAction) filterItemTapped: (id) sender
{
    [self.popoverController presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated: true];
}

#pragma mark -
#pragma mark Managing the popover

- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem : (BOOL) itIsOrientationChanging {
    
    // Add the popover button to the toolbar.
    //NSMutableArray *itemsArray = [toolbar.items mutableCopy];

    //UIBarButtonItem *toolbarItem;
    //BOOL alreadyInclude=NO;

    //for (toolbarItem in itemsArray)
    //{
    //    if (toolbarItem==barButtonItem)  {
    //        alreadyInclude=YES;            
    //    }
    //    else
    //    {
    //    }
    //}

    //if (alreadyInclude&&YES)  {
    //    [itemsArray removeObject:barButtonItem];
    //}
    
    //UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    
    //if (deviceOrientation==UIDeviceOrientationUnknown)  {
    //    deviceOrientation=startOrientation;
    //}
    
    //if (!UIDeviceOrientationIsLandscape(deviceOrientation))  {
    //    if (barButtonItem!=nil)   {
    //        [itemsArray insertObject:barButtonItem atIndex:0];
    //    }
    //}
    //[toolbar setItems:itemsArray animated:YES];
    //self.navigationItem.leftBarButtonItem = barButtonItem;
    
    //[itemsArray release];
}


- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    
    // Remove the popover button from the toolbar.
    //NSMutableArray *itemsArray = [toolbar.items mutableCopy];    
    
    //[itemsArray removeObject:barButtonItem];
    //[toolbar setItems:itemsArray animated:NO];
    
    //[itemsArray release];
}


#pragma mark -
#pragma mark Rotation support

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
    [startDateTextField release];
    [endDateTextField release];
    [docTypeSelectSegmControl release];
    [formatter release];
    [canonicalFormatter release];
    [filterView release];
    [popoverController release];
    [startDatePicker release];
    [hidePickerButton release];
    [datePickerView release];
    [toolbar release];
    [super dealloc];
}	

@end
