//
//  TabbedPaymentDocViewController.m
//  MultipleDetailViews
//
//  Created by MacMini on 15.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TabbedPaymentDocViewController.h"
#import "ParseDocsOperation.h"
#import "ParseDocProperties.h"

static NSUInteger kNumberOfPages = 2;

@interface TabbedPaymentDocViewController(PrivateMethods)
- (void)loadScrollViewWithPage:(int)page :(UIViewController *)controller;
- (void)changePage:(int)page;
@end

@implementation TabbedPaymentDocViewController

@synthesize paymentDoc, codeTextField, paymentFormTextField, orderTypeTextField, respTextField, executorTextField, importanceLevelTextField, baseDocTextField, commentTextField, createDateTextField, statementDateLabel, statementStatusLabel, docsSectionsScrollView, scrollSegmControl, basedView, DocsData, parseQueue, statementSetButton, DocsList, splitViewController, popoverController, rootPopoverButtonItem, notIncludeInPayPlanImageView, overBudget, isExchequer, parentTableViewController, docCoordinationScrollViewController, paymentDocScrollViewController, statusImageView, chargeDateTextField, chargeMaxDateTextField, cfoTextField, turnAccountTextField, projectTextField, docSummTextField, currencyTextField, orgNameTextField,  contragentTextField, contractTextField;

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
    [paymentDocScrollViewController release];
    [docCoordinationScrollViewController release];
    [docsSectionsScrollView release];
    [scrollSegmControl release];
    [DocsList release];
    [DocsData release];
    [codeTextField release];
    [orderTypeTextField release];
    [respTextField release];
    [executorTextField release];
    [importanceLevelTextField release];
    [baseDocTextField release];
    [cfoTextField release];
    [turnAccountTextField release];
    [projectTextField release]; 
    [currencyTextField release];
    [docSummTextField release];
    [orgNameTextField release];
    [contractTextField release];
    [contragentTextField release];
    [commentTextField release];
    [createDateTextField release];
    [statementDateLabel release];
    [statementStatusLabel release];
    [statementSetButton release];
    [paymentFormTextField release];
    [notIncludeInPayPlanImageView release];
    [overBudget release];
    [statusImageView release];
    [isExchequer release];
    [basedView release];
    [parseQueue release];
    [paymentDoc release];
    //[toolbar release];
    [chargeDateTextField release]; 
    [chargeMaxDateTextField release];
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
        statementStatusLabel.text = @"Утверждена";
        paymentDoc.statement_state = @"Утверждена";
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"Y-MM-dd hh:mm:ss"];
        
        NSString *currentDateTime = [formatter stringFromDate:[NSDate date]];
        statementDateLabel.text = currentDateTime;
        paymentDoc.statement_date = currentDateTime;
        [formatter release];
        
        if (paymentDoc.statement_state!=nil)    {
            if ([paymentDoc.statement_state isEqualToString:@"Утверждена"])  {
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
    
        if (paymentDoc.doc_type_id==1)  {
            [mainConn sendRequestWithAuth: [[kPHPProxiesBaseAdress stringByAppendingString:@"setDocProperties.php?doc_type_id=1&doc_id="]  stringByAppendingString:paymentDoc.doc_id] : kCurrentHTTPLogin :kCurrentHTTPPassword];
        }
        else if (paymentDoc.doc_type_id==2)  {
            [mainConn sendRequestWithAuth: [[kPHPProxiesBaseAdress stringByAppendingString:@"setDocProperties.php?doc_type_id=2&doc_id="]  stringByAppendingString:paymentDoc.doc_id] : kCurrentHTTPLogin :kCurrentHTTPPassword];
        }
        [mainConn release];
    }
}

- (void)refreshData:(NSMutableData *)data:(NSInteger)queryMode  {
    ParseDocsOperation *parseOperation = [[ParseDocsOperation alloc] initWithData:data];
    parseOperation.docType = nil;
    [self.parseQueue addOperation:parseOperation];
    [parseOperation release];
}

- (void)setHide: (BOOL) hideValue {
    self.basedView.hidden = true;
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
    [self changePage:0];
}

- (IBAction)changePageTo:(id)sender  {
    if(scrollSegmControl.selectedSegmentIndex==1) {
    [self changePage:1];
    }
    else if(scrollSegmControl.selectedSegmentIndex==0) {
        [self changePage:0];
    }
}

- (void)orientationChanged:(NSNotification *)notification {
    
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    
    //[self showRootPopoverButtonItem:self.rootPopoverButtonItem:YES];
    
    if(UIDeviceOrientationIsLandscape(deviceOrientation)) {
        
        //self.tabBarController.view.frame = CGRectMake(0, 0, 800, 500);
        }
        
    else if (UIDeviceOrientationIsPortrait(deviceOrientation)) {
        
        //self.tabBarController.view.frame = CGRectMake(0, 0, 800, 755);    
        }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    self.DocsList = [NSMutableArray array]; 
    
    parseQueue = [NSOperationQueue new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addDocsUpdateMessage:) name:kDocsUpdateResultMsgNotif object:nil];    
    
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    
    if(UIDeviceOrientationIsLandscape(deviceOrientation)||(deviceOrientation==UIDeviceOrientationUnknown)) {
        //self.tabBarController.view.frame = CGRectMake(0, 0, 800, 500);
    }
    else if (UIDeviceOrientationIsPortrait(deviceOrientation)) {
        //self.tabBarController.view.frame = CGRectMake(0, 0, 800, 755);
    }
    
    self.DocsList = [NSMutableArray array]; 
    
    parseQueue = [NSOperationQueue new];
        
    if (paymentDoc!=nil) {
        //codeTextField.text = paymentDoc.code;
        createDateTextField.text = paymentDoc.create_date;
        importanceLevelTextField.text = paymentDoc.importance_level_name;
        respTextField.text = paymentDoc.responsible_name;
        executorTextField.text = paymentDoc.executor_name;
        baseDocTextField.text = paymentDoc.base_doc_name;
        
        self.turnAccountTextField.text = paymentDoc.turn_account_name;
        self.projectTextField.text = paymentDoc.project_name;
        self.currencyTextField.text = paymentDoc.currency_name;
        self.docSummTextField.text = paymentDoc.doc_summ;
        self.cfoTextField.text = paymentDoc.cfo_name;
        self.orgNameTextField.text = paymentDoc.organization_name;
        self.contragentTextField.text = paymentDoc.contragent_name;
        self.contractTextField.text = paymentDoc.contract_name;
        
        //[cell.cacheMoneyImage setImage:nil];    
        if (paymentDoc.payment_form_name!=nil)   {
            if([paymentDoc.payment_form_name isEqualToString:@"Наличные"])    {
                [paymentFormTextField setImage:[UIImage imageNamed:@"cache.png"]];
            }
        }
        //paymentFormTextField.text = paymentDoc.payment_form_name;
        orderTypeTextField.text = paymentDoc.order_type_name;
        statementStatusLabel.text = paymentDoc.statement_state;
        statementDateLabel.text = paymentDoc.statement_date;
        self.chargeMaxDateTextField.text = paymentDoc.charge_max_date;
        self.chargeDateTextField.text = paymentDoc.charge_date;
        if (paymentDoc.statement_state!=nil)    {
        if ([paymentDoc.statement_state isEqualToString:@"Утверждена"]||[paymentDoc.statement_state isEqualToString:@"Оплата"]||[paymentDoc.statement_state isEqualToString:@"Оплачена"])  {
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
        //if ([paymentDoc.no_include_in_pay_plan isEqualToString:@"true"])  {
        //    [notIncludeInPayPlanImageView setImage:[UIImage imageNamed:@"checked.png"]];
        //}
        //else    {
        //    [notIncludeInPayPlanImageView setImage:[UIImage imageNamed:@"unchecked.png"]];
        //}
        if (paymentDoc.over_budget!=nil) {
        if ([paymentDoc.over_budget isEqualToString:@"true"])  {
            [overBudget setImage:[UIImage imageNamed:@"over_planned.png"]];
        } }
        
        if ([paymentDoc.is_exchequer isEqualToString:@"true"])  {
            [isExchequer setImage:[UIImage imageNamed:@"checked.png"]];
        }
        else    {
            [isExchequer setImage:[UIImage imageNamed:@"unchecked.png"]];
        }        
        commentTextField.text = paymentDoc.comment;
        
    }
    //if (paymentDocScrollViewController==nil)
    //{
        paymentDocScrollViewController = [[PaymentDocViewController alloc] initWithNibName:@"PaymentDocViewController" bundle:nil];
        paymentDocScrollViewController.paymentDoc = 
            paymentDoc;
    //}
    //if (docCoordinationScrollViewController==nil)
    //{
        docCoordinationScrollViewController = [CoordinationsViewController alloc];
        
        [docCoordinationScrollViewController initWithNibName:@"CoordinationsViewController" bundle:nil];
        docCoordinationScrollViewController.coordDoc = paymentDoc;    
    //}
    
    docsSectionsScrollView.pagingEnabled = YES;
    docsSectionsScrollView.contentSize = CGSizeMake(docsSectionsScrollView.frame.size.width * kNumberOfPages, docsSectionsScrollView.frame.size.height);
    docsSectionsScrollView.showsHorizontalScrollIndicator = NO;
    docsSectionsScrollView.showsVerticalScrollIndicator = NO;
    docsSectionsScrollView.scrollsToTop = NO;  
    
    UIBarButtonItem *statButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Согласовать", @"")  style:UIBarButtonItemStyleBordered  target:self	  action:@selector(sendStatementRequest:)];
    
    self.navigationItem.rightBarButtonItem = statButton;
    
    [self loadScrollViewWithPage:0 :docCoordinationScrollViewController]; 
    [self loadScrollViewWithPage:1 :paymentDocScrollViewController];
       
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.docsSectionsScrollView = nil;
    self.scrollSegmControl = nil;
    self.codeTextField = nil;
    self.orderTypeTextField = nil;
    self.respTextField = nil;
    self.executorTextField = nil;
    self.importanceLevelTextField = nil;
    self.cfoTextField = nil;
    self.turnAccountTextField = nil;
    self.projectTextField = nil;
    self.currencyTextField = nil;
    self.docSummTextField = nil;
    self.orgNameTextField = nil;
    self.contractTextField = nil;
    self.contragentTextField = nil;
    self.baseDocTextField = nil;
    self.commentTextField = nil;
    self.createDateTextField = nil;
    self.statementDateLabel = nil;
    self.statementStatusLabel = nil;
    self.statementSetButton = nil;
    self.paymentFormTextField = nil;
    self.notIncludeInPayPlanImageView = nil;
    self.overBudget = nil;
    self.isExchequer = nil;
    self.chargeDateTextField = nil;
    self.chargeMaxDateTextField = nil;
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

    if ([systemMessage.doc_id isEqualToString:paymentDoc.doc_id])  {
        
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
        [alertView show];
        [alertView release];
    
    if ([systemMessage.message_caption isEqualToString:@"Успешно проведено согласование"]) {
        statementStatusLabel.text = systemMessage.message_text;
        paymentDoc.statement_state = systemMessage.message_text;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"Y-MM-dd hh:mm:ss"];
        
        NSString *currentDateTime = [formatter stringFromDate:[NSDate date]];
        statementDateLabel.text = currentDateTime;
        paymentDoc.statement_date = currentDateTime;
        [formatter release];        
        
        if (paymentDoc.statement_state!=nil)    {
            if ([paymentDoc.statement_state isEqualToString:@"Утверждена"])  {
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
    }
    
}

- (void)addDocsUpdateMessage:(NSNotification *)notif {
    assert([NSThread isMainThread]);
    
    [self showSystemMessage:[[notif userInfo] valueForKey:kDocsUpdateMsgResultKey]];
}

@end
