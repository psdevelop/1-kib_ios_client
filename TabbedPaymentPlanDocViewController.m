//
//  TabbedPaymentDocViewController.m
//  MultipleDetailViews
//
//  Created by MacMini on 15.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TabbedPaymentPlanDocViewController.h"

static NSUInteger kNumberOfPages = 2;

@interface TabbedPaymentPlanDocViewController(PrivateMethods)
- (void)loadScrollViewWithPage:(int)page :(UIViewController *)controller;
- (void)changePage:(int)page;
@end

@implementation TabbedPaymentPlanDocViewController

@synthesize paymentPlanDoc, statementSetButton, statementDateLabel, statementStatusLabel, createDateTextField, codeTextField, commentTextField, executorTextField, respTextField, cfoTextField, orgNameTextField, turnAccountTextField, projectTextField, basedView, docsSectionsScrollView, docCoordinationScrollViewController, paymentOrdersViewController, splitViewController, popoverController, rootPopoverButtonItem, DocsData, DocsList, parseQueue, parentTableViewController, statusImageView;

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
    [paymentOrdersViewController release];
    [docCoordinationScrollViewController release];
    [docsSectionsScrollView release];
    //[scrollSegmControl release];
    [DocsList release];
    [DocsData release];
    [codeTextField release];
    [respTextField release];
    [executorTextField release];
    [commentTextField release];
    [createDateTextField release];
    [statementDateLabel release];
    [statementStatusLabel release];
    [statementSetButton release];
    [orgNameTextField release];
    [turnAccountTextField release];
    [projectTextField release];
    [cfoTextField release];
    [statusImageView release];
    [basedView release];
    [parseQueue release];
    [paymentPlanDoc release];
    //[toolbar release];
    [parentTableViewController release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDocsUpdateResultMsgNotif object:nil];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(IBAction) navBack:(id) sender {
    //[childDocListController.navigationController popViewControllerAnimated:true];
    
    [self.navigationController popViewControllerAnimated:true];
}

- (IBAction)sendStatementRequest:(id)sender  {
    if (kDEMOMode)  {
        statementStatusLabel.text = @"Утвержден";
        paymentPlanDoc.statement_state = @"Утвержден";
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"Y-MM-dd hh:mm:ss"];
        
        NSString *currentDateTime = [formatter stringFromDate:[NSDate date]];
        statementDateLabel.text = currentDateTime;
        paymentPlanDoc.statement_date = currentDateTime;
        [formatter release];
        
        if (paymentPlanDoc.statement_state!=nil)    {
            if ([paymentPlanDoc.statement_state isEqualToString:@"Утвержден"])  {
                statementSetButton.enabled = NO;
                statementSetButton.title = @"Согласовано";
                [statusImageView setImage:[UIImage imageNamed:@"checked.png"]];            
            }
            else    {
                statementSetButton.enabled = YES;
                statementSetButton.title = @"Согласовать";
                [statusImageView setImage:[UIImage imageNamed:@"unchecked.png"]];            
            }
        }
        
        if (parentTableViewController!=nil)  {
            [parentTableViewController.tableView reloadData];
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Успешно проведено согласование" message:@"Данная операция является показательной для данного режима!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];	
        [alert release];        
    }   else    {    
        MainHTTPConnection *mainConn = [[MainHTTPConnection alloc] init];
        mainConn.destController = self;
    
        [mainConn sendRequestWithAuth: [[kPHPProxiesBaseAdress stringByAppendingString:@"setDocProperties.php?doc_type_id=3&doc_id="]  stringByAppendingString:paymentPlanDoc.doc_id] : kCurrentHTTPLogin :kCurrentHTTPPassword];
        [mainConn release];
    }
}

- (void)setHide: (BOOL) hideValue {
    self.basedView.hidden = true;
}

- (void)refreshData:(NSMutableData *)data:(NSInteger)queryMode  {
    ParseDocsOperation *parseOperation = [[ParseDocsOperation alloc] initWithData:data];
    parseOperation.docType = nil;
    [self.parseQueue addOperation:parseOperation];
    [parseOperation release]; 
}

- (void)loadScrollViewWithPage:(int)page :(UIViewController *)controller 
{
    if (page < 0)
        return;
    if (page >= kNumberOfPages)
        return;
    
    // add the controller's view to the scroll view
    if (controller.view.superview == nil)
    {
        CGRect frame = docsSectionsScrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [docsSectionsScrollView addSubview:controller.view];
        
    }
}

- (void)changePage:(int)page
{
	// update the scroll view to the appropriate page
    CGRect frame = docsSectionsScrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [docsSectionsScrollView scrollRectToVisible:frame animated:YES];
}

- (IBAction)changePageToOne:(id)sender  {
    //[self changePage:0];
}

- (IBAction)changePageTo:(id)sender  {
    //if(scrollSegmControl.selectedSegmentIndex==1) {
    //    [self changePage:1];
    //}
    //else if(scrollSegmControl.selectedSegmentIndex==0) {
    //    [self changePage:0];
    //}
}

- (void)orientationChanged:(NSNotification *)notification {
    
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    
    //[self showRootPopoverButtonItem:self.rootPopoverButtonItem:YES];
    
    if(UIDeviceOrientationIsLandscape(deviceOrientation)) {
        
        //self.tabBarController.view.frame = CGRectMake(0, 0, 800, 530);
    }
    
    else if (UIDeviceOrientationIsPortrait(deviceOrientation)) {
        
        //self.tabBarController.view.frame = CGRectMake(0, 0, 800, 789);    
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    
    self.DocsList = [NSMutableArray array]; 
    
    parseQueue = [NSOperationQueue new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addDocsUpdateMessage:) name:kDocsUpdateResultMsgNotif object:nil];
    
    if(!UIDeviceOrientationIsLandscape(deviceOrientation)) {
        //self.tabBarController.view.frame = CGRectMake(0, 0, 800, 530);
    }
    else if (UIDeviceOrientationIsPortrait(deviceOrientation)) {
        //self.tabBarController.view.frame = CGRectMake(0, 0, 800, 789);
    }
    
    if (paymentPlanDoc!=nil) {
        codeTextField.text = paymentPlanDoc.code;
        createDateTextField.text = paymentPlanDoc.create_date;
        orgNameTextField.text = paymentPlanDoc.organization_name;
        respTextField.text = paymentPlanDoc.responsible_name;
        executorTextField.text = paymentPlanDoc.executor_name;
        turnAccountTextField.text = paymentPlanDoc.turn_account_name;
        cfoTextField.text = paymentPlanDoc.payment_form_name;
        projectTextField.text = paymentPlanDoc.project_name;
        statementStatusLabel.text = paymentPlanDoc.statement_state;
        statementDateLabel.text = paymentPlanDoc.statement_date;
        cfoTextField.text = paymentPlanDoc.cfo_name;        
        if (paymentPlanDoc.statement_state!=nil)    {
            if ([paymentPlanDoc.statement_state isEqualToString:@"Утвержден"])  {
                statementSetButton.enabled = NO;
                statementSetButton.title = @"Согласовано";
                [statusImageView setImage:[UIImage imageNamed:@"checked.png"]];            
            }
            else    {
                statementSetButton.enabled = YES;
                statementSetButton.title = @"Согласовать";
                [statusImageView setImage:[UIImage imageNamed:@"unchecked.png"]];            
            }
        }
        commentTextField.text = paymentPlanDoc.comment;
        //if (paymentDocSpecificViewController!=nil) {
        //    paymentDocSpecificViewController.paymentDoc=paymentDoc;
            
            
        //}
    }
    if (paymentOrdersViewController==nil)
    {
        paymentOrdersViewController = [PaymentOrdersViewController alloc];
        paymentOrdersViewController.paymentPlanDoc = paymentPlanDoc;
        [paymentOrdersViewController initWithNibName:@"PaymentOrdersViewController" bundle:nil];
    }
    if (docCoordinationScrollViewController==nil)
    {
        docCoordinationScrollViewController = [CoordinationsViewController alloc];
        docCoordinationScrollViewController.coordDoc = paymentPlanDoc;
        [docCoordinationScrollViewController initWithNibName:@"CoordinationsViewController" bundle:nil];
    }
    
    docsSectionsScrollView.pagingEnabled = YES;
    docsSectionsScrollView.contentSize = CGSizeMake(docsSectionsScrollView.frame.size.width * kNumberOfPages, docsSectionsScrollView.frame.size.height);
    docsSectionsScrollView.showsHorizontalScrollIndicator = NO;
    docsSectionsScrollView.showsVerticalScrollIndicator = NO;
    docsSectionsScrollView.scrollsToTop = NO;  
    
    UIBarButtonItem *statButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Согласовать", @"")  style:UIBarButtonItemStyleBordered  target:self	  action:@selector(sendStatementRequest:)];
    
    self.navigationItem.rightBarButtonItem = statButton;
    
    [self loadScrollViewWithPage:0 :docCoordinationScrollViewController];
    [self loadScrollViewWithPage:1 :paymentOrdersViewController]; 
            
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.docsSectionsScrollView = nil;
    //self.scrollSegmControl = nil;
    self.codeTextField = nil;
    self.respTextField = nil;
    self.executorTextField = nil;
    self.commentTextField = nil;
    self.createDateTextField = nil;
    self.statementDateLabel = nil;
    self.statementStatusLabel = nil;
    self.statementSetButton = nil;
    self.orgNameTextField = nil;
    self.turnAccountTextField = nil;
    self.projectTextField = nil;
    self.cfoTextField = nil;
    self.statusImageView = nil;
    self.basedView = nil;
    //self.toolbar = nil;   
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)showSystemMessage:(SystemMessage *)systemMessage {
    if ([systemMessage.doc_id isEqualToString:paymentPlanDoc.doc_id])  {  
        
        [[docCoordinationScrollViewController coordListController] sendDocPropertiesRequest];
        
        NSString *errorMessage = systemMessage.message_text;        
        if (systemMessage.comment!=nil) {
            [errorMessage stringByAppendingString:systemMessage.comment];
        }        
        UIAlertView *alertView =
        [[UIAlertView alloc] initWithTitle:
         systemMessage.message_caption
                               message:errorMessage
                              delegate:nil
                     cancelButtonTitle:@"OK"
                     otherButtonTitles:nil];
        if ([systemMessage.message_caption isEqualToString:@"Успешно проведено согласование"]) {
        statementStatusLabel.text = systemMessage.message_text;
        paymentPlanDoc.statement_state = systemMessage.message_text;
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"Y-MM-dd hh:mm:ss"];
            
            NSString *currentDateTime = [formatter stringFromDate:[NSDate date]];
            statementDateLabel.text = currentDateTime;
            paymentPlanDoc.statement_date = currentDateTime;
            [formatter release];
            
            if (paymentPlanDoc.statement_state!=nil)    {
                if ([paymentPlanDoc.statement_state isEqualToString:@"Утвержден"])  {
                    statementSetButton.enabled = NO;
                    statementSetButton.title = @"Согласовано";
                    [statusImageView setImage:[UIImage imageNamed:@"checked.png"]];            
                }
                else    {
                    statementSetButton.enabled = YES;
                    statementSetButton.title = @"Согласовать";
                    [statusImageView setImage:[UIImage imageNamed:@"unchecked.png"]];            
                }
            }
            
            if (parentTableViewController!=nil)  {
                [parentTableViewController.tableView reloadData];
            }
        }
    [alertView show];
    [alertView release];
    }
}

- (void)addDocsUpdateMessage:(NSNotification *)notif {
    assert([NSThread isMainThread]);
    
    [self showSystemMessage:[[notif userInfo] valueForKey:kDocsUpdateMsgResultKey]];
}

@end
