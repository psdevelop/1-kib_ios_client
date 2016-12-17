//
//  DocsListTableViewController.m
//  MultipleDetailViews
//
//  Created by MacMini on 10.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DocsListTableViewController.h"
#import "DocsTableViewCell.h"
#import "ParseDocsOperation.h"
#import "Doc.h"
#import "PaymentDoc.h"
#import "TabbedPaymentDocViewController.h"
#import "TabbedPaymentPlanDocViewController.h"
#import "AppDelegate.h"
#import "ParseDocProperties.h"
#import "AllDocsViewController.h"

NSString *criticalKey = @"Critical";
NSString *importantKey = @"Important";
NSString *freeKey = @"Free";

// forward declarations
@interface DocsListTableViewController ()

@property (nonatomic, retain) NSMutableData *DocsData;    // the data returned from the NSURLConnection
@property (nonatomic, retain) NSOperationQueue *parseQueue;     
    // the queue that manages our NSOperation for parsing docs data

- (void)addDocsToList:(NSArray *)docs;
@end

@implementation DocsListTableViewController

@synthesize parseQueue, docType, DocsData, DocsList, splitViewController, popoverController,rootPopoverButtonItem, PortraitMode, filterParamsStr, loadIndicator, showAlways, isChildController, impGroupedDocs, impGroupedKeys, currentPlanDoc;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    //[DocsList release];
    [DocsData release];
    [parseQueue release];
    [filterParamsStr release];
    [loadIndicator release];
    [docType release];
    [impGroupedDocs release];
    [impGroupedKeys release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAddDocsNotif object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDocsUpdateResultMsgNotif object:nil];    
    
    [self removeObserver:self forKeyPath:@"DocsList"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAddDocsIncludeNotif object:nil]; 
    [self removeObserver:self forKeyPath:@"addProps"];    
    
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 480.0);
    
    self.DocsList = [NSMutableArray array]; 
    
    parseQueue = [NSOperationQueue new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addDocs:) name:kAddDocsNotif object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addDocsUpdateMessage:) name:kDocsUpdateResultMsgNotif object:nil];
    
    [self addObserver:self forKeyPath:@"DocsList" options:0 context:NULL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addDocProp:) name:kAddDocsIncludeNotif object:nil];
    
    [self addObserver:self forKeyPath:@"addProps" options:0 context:NULL];    
    
    //if (!kDEMOMode)
    if (self.PortraitMode)   {
        [loadIndicator setFrame: CGRectMake(330, 90,100,100)];
    }   else    {
        [loadIndicator setFrame: CGRectMake(110, 150,100,100)];
    }

    [self.view addSubview:loadIndicator];
    
    //NSString *importanceGroupedPath = [[NSBundle mainBundle] pathForResource: @"ImportanceGroupedDocsList" ofType:@"plist"];
    //NSDictionary *igDict = [[NSDictionary alloc] initWithContentsOfFile:importanceGroupedPath];
    //NSDictionary *igDict = [[NSDictionary alloc] init];
     
    //[igDict setValue:[NSMutableArray array] forKey:@"Free"];
    self.impGroupedDocs = [NSMutableArray array];
    [self.impGroupedDocs addObject:[NSMutableArray array]];
    [self.impGroupedDocs addObject:[NSMutableArray array]];
    [self.impGroupedDocs addObject:[NSMutableArray array]];
    //[igDict release];
    
    self.impGroupedKeys = [[NSArray alloc] initWithObjects:criticalKey, importantKey, freeKey, nil];
    //self.impGroupedKeys = [[impGroupedDocs allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    if (!isChildController) 
    {
        if (!kDEMOMode)  {
            [self docsRequest:NO];
        }
        else
        {

            NSString *docTypeIdStr = [NSString stringWithFormat:@"%d",docType.doc_type_id];
            
            NSString *filepath = [[NSBundle mainBundle] pathForResource: [@"getPaymentDocsType" stringByAppendingString: docTypeIdStr] ofType:@"xml"];

            self.DocsData = [NSData dataWithContentsOfFile:filepath];
            if (self.DocsData==nil) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка получения данных" message:@"Не найден файл с данными для DEMO-режима!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                 [alert show];	
                 [alert release];
            }  
            else    {
                if (docType.doc_type_id==1)
                    [self refreshData:self.DocsData:kQueryModePaymentDocs];
                else if (docType.doc_type_id==2)
                    [self refreshData:self.DocsData:kQueryModePubPaymentDocs];
                else if (docType.doc_type_id==3)
                    [self refreshData:self.DocsData:kQueryModePlanDocs];
                else
                    [self refreshData:self.DocsData:kQueryModePaymentDocs];                
            }
        }
    }

    self.DocsData = nil; 
    
}

- (void)docsRequest:(BOOL)isPart {
    if (kDEMOMode)  {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ограничение" message:@"Данная операция недоступна для DEMO-режима!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];	
        [alert release];        
    }   else    {    
    NSString *docTypeIdStr = [NSString stringWithFormat:@"%d",docType.doc_type_id];
    if (filterParamsStr==nil)   {
        filterParamsStr=@" ";
    }
    
    if(!isPart) {
        MainHTTPConnection *requestHTTPConn = [[MainHTTPConnection alloc] init];
        requestHTTPConn.destTableController=self;
        requestHTTPConn.loadIndicator = self.loadIndicator;
        
        if (docType.doc_type_id==1)
            requestHTTPConn.queryMode = kQueryModePaymentDocs;
        else if (docType.doc_type_id==2)
            requestHTTPConn.queryMode = kQueryModePubPaymentDocs;
        else if (docType.doc_type_id==3)
            requestHTTPConn.queryMode = kQueryModePlanDocs;
        else
            requestHTTPConn.queryMode = kQueryModePaymentDocs;  
        
        /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"UIAlertView" message:[[[kPHPProxiesBaseAdress stringByAppendingString: @"getPaymentDocs.php?empty_param&doc_type_id="] stringByAppendingString:docTypeIdStr] stringByAppendingString:filterParamsStr] delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];	
        [alert release];*/
        
        [requestHTTPConn sendRequestWithAuth: [[[kPHPProxiesBaseAdress stringByAppendingString: @"getPaymentDocs.php?empty_param&doc_type_id="] stringByAppendingString:docTypeIdStr] stringByAppendingString:filterParamsStr] : kCurrentHTTPLogin :kCurrentHTTPPassword];
        [requestHTTPConn release];
    }
    else {
        MainHTTPConnection *requestHTTPConn = [[MainHTTPConnection alloc] init];
        requestHTTPConn.destTableController=self;
        requestHTTPConn.loadIndicator = self.loadIndicator; 
        
        if (docType.doc_type_id==1)
            requestHTTPConn.queryMode = kQueryModePaymentDocs;
        else if (docType.doc_type_id==2)
            requestHTTPConn.queryMode = kQueryModePubPaymentDocs;
        else if (docType.doc_type_id==3)
            requestHTTPConn.queryMode = kQueryModePlanDocs;
        else
            requestHTTPConn.queryMode = kQueryModePaymentDocs;        
        
        [requestHTTPConn sendRequestWithAuth: [[[[kPHPProxiesBaseAdress stringByAppendingString: @"getPaymentDocs.php?empty_param"] stringByAppendingString:@"&partial_load&doc_type_id="] stringByAppendingString:docTypeIdStr] stringByAppendingString:filterParamsStr] : kCurrentHTTPLogin :kCurrentHTTPPassword];
        
        [requestHTTPConn release];
    }
    }
}

- (void)refreshData:(NSMutableData *)data:(NSInteger)queryMode  {
    if (queryMode==kQueryModeIncludeDocs)   {
        ParseDocProperties *parseOperation = [[ParseDocProperties alloc] initWithData:data];
        [self.parseQueue addOperation:parseOperation];
        [parseOperation release];        
    }   else    {
        ParseDocsOperation *parseOperation = [[ParseDocsOperation alloc] initWithData:data];
        parseOperation.docType = docType;
        [self.parseQueue addOperation:parseOperation];
        [parseOperation release]; 
    }
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.DocsList = nil;
    self.loadIndicator = nil;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    rootPopoverButtonItem.title = @"Список документов";
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark -
#pragma mark KVO support

- (void) assingGroupedDicts {
    Doc *currentDoc;
    for (currentDoc in self.DocsList) {
        if (currentDoc.importance_level_name!=nil)  {
            if ([currentDoc.importance_level_name isEqualToString:@"Высокая"])  {
                [[self.impGroupedDocs objectAtIndex:0] addObject:currentDoc];
            }            
            else if ([currentDoc.importance_level_name isEqualToString:@"Средняя"])   {
                [[self.impGroupedDocs objectAtIndex:1] addObject:currentDoc];
            }
            else    {
                [[self.impGroupedDocs objectAtIndex:2] addObject:currentDoc];
            }
        }
        else    {
            [[self.impGroupedDocs objectAtIndex:2] addObject:currentDoc];
        }
    }
}

- (void)insertDocs:(NSArray *)docs
{
    // this will allow us as an observer to notified (see observeValueForKeyPath)
    // so we can update our UITableView
    //
    [self willChangeValueForKey:@"DocsList"];
    [self.DocsList addObjectsFromArray:docs];
    [self assingGroupedDicts];
    [self.loadIndicator stopAnimating];
    [self didChangeValueForKey:@"DocsList"];
}

// listen for changes to the earthquake list coming from our app delegate.
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (keyPath==@"DocsList") {
        [self.tableView reloadData];
    } 
    else if (keyPath==@"addProps") {
        [self.tableView reloadData];
    }     
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    //return 1;
    if (docType.doc_type_id==3) {
        return [DocsList count];
    } else   
    return [impGroupedKeys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //return [DocsList count];
    //NSString *impGrKey = [impGroupedKeys objectAtIndex:section];
    if (docType.doc_type_id==3) {
        //if (childNavController.visibleViewController==self) {
        PaymentPlanDoc *planDoc = [DocsList objectAtIndex:section];
            return [[[planDoc paymentOrderList] paymentDocs] count]; 
        //}
        //else
        //    return 0;
        //return 1;
    } else    
        return [[impGroupedDocs objectAtIndex:section] count];
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section    {
    //return [impGroupedKeys objectAtIndex:section];
    if (docType.doc_type_id==3) {
        return nil;
    }
    else    {
        if (section==0) {
            return @"Критично";
        }   else if (section==1)    {
            return @"Важно";
        }   else
            return @"Свободно";
    }
}

- (CGFloat) tableView:(UITableView *) tableView heightForHeaderInSection:(NSInteger)section {
    if (docType.doc_type_id==3) {
        return 45;
    }
    else if (docType.doc_type_id==2) {
        return 0;
    }    else
        return 30;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //if (docType.doc_type_id==3) {
    //    return 40;
    //}
    //else
        return 96;
}

- (IBAction)sendDocPropertiesRequest:(id)sender {
    UIButton *touchButton = sender;
    currentPlanDoc = [DocsList objectAtIndex:touchButton.tag];    
    [touchButton setHidden:YES];
    [touchButton setEnabled:NO];
    touchButton.hidden = YES;
    
    [currentPlanDoc.paymentOrderList.paymentDocs setArray:nil];
    
    if (kDEMOMode)  {
        
        NSString *filepath = [[NSBundle mainBundle] pathForResource: @"getDocPropertiesInclDocs"  ofType:@"xml"];
        
        NSMutableData *demoDocsData = [NSData dataWithContentsOfFile:filepath];
        if (demoDocsData==nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка получения данных" message:@"Не найден файл с данными для DEMO-режима!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];	
            [alert release];
        }  
        else    {
            [self refreshData:demoDocsData:kQueryModeIncludeDocs];
        }    
        //[DocsData release];
    }
    else        {
        MainHTTPConnection *docPropHTTPConn = [[MainHTTPConnection alloc] init];
        docPropHTTPConn.destController = self;
        docPropHTTPConn.loadIndicator = loadIndicator;
        docPropHTTPConn.queryMode = kQueryModeIncludeDocs;
        //NSString *docTypeIdStr = [NSString stringWithFormat:@"%d",doc.doc_type_id];
    
        //if (paymentDoc.doc_type_id==1)  {
        [docPropHTTPConn sendRequestWithAuth: [[kPHPProxiesBaseAdress stringByAppendingString:@"getDocProperties.php?doc_type_id=3&data_type=include_docs&doc_id="]  stringByAppendingString:currentPlanDoc.doc_id] : kCurrentHTTPLogin :kCurrentHTTPPassword];
    
        [docPropHTTPConn release];
    }
}

- (IBAction)sendStatementRequest:(id)sender {
    UIButton *touchButton = sender;
    currentPlanDoc = [DocsList objectAtIndex:touchButton.tag];
    
    if (kDEMOMode)  {
        
        //statementStatusLabel.text = @"Утвержден";
        currentPlanDoc.statement_state = @"Утвержден";
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"Y-MM-dd hh:mm:ss"];
        
        NSString *currentDateTime = [formatter stringFromDate:[NSDate date]];
        //statementDateLabel.text = currentDateTime;
        currentPlanDoc.statement_date = currentDateTime;
        [formatter release];
        
        if (currentPlanDoc.statement_state!=nil)    {
            if ([currentPlanDoc.statement_state isEqualToString:@"Утвержден"])  {
                //statementSetButton.enabled = NO;
                //statementSetButton.title = @"Согласовано";
                //[statusImageView setImage:[UIImage imageNamed:@"checked.png"]];            
            }
            else    {
                //statementSetButton.enabled = YES;
                //statementSetButton.title = @"Согласовать";
                //[statusImageView setImage:[UIImage imageNamed:@"unchecked.png"]];            
            }
        }
        
        [self.tableView reloadData];
        //if (parentTableViewController!=nil)  {
        //    [parentTableViewController.tableView reloadData];
        //}
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Успешно проведено согласование" message:@"Данная операция является показательной для данного режима!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];	
        [alert release];        
    }   else    {    
        MainHTTPConnection *mainConn = [[MainHTTPConnection alloc] init];
        mainConn.destController = self;
        mainConn.queryMode = kQueryModeStatementSet;
        
        [mainConn sendRequestWithAuth: [[kPHPProxiesBaseAdress stringByAppendingString:@"setDocProperties.php?doc_type_id=3&doc_id="]  stringByAppendingString:currentPlanDoc.doc_id] : kCurrentHTTPLogin :kCurrentHTTPPassword];
        [mainConn release];
    }
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section   {
    if (docType.doc_type_id==3) {
        PaymentPlanDoc *planDoc = [DocsList objectAtIndex:section];
        UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 750, 60)] autorelease];
        UILabel *docOrgName = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 400, 20)];
        docOrgName.backgroundColor = [UIColor clearColor];
        docOrgName.baselineAdjustment= UIBaselineAdjustmentAlignCenters;
        docOrgName.lineBreakMode             =  UILineBreakModeWordWrap;
        //docOrgName.textAlignment             = UITextAlignmentCenter;
        docOrgName.shadowColor               = [UIColor whiteColor];
        docOrgName.shadowOffset              = CGSizeMake(0.0, 1.0);
        docOrgName.font                      = [UIFont systemFontOfSize:16];
        docOrgName.textColor                 = [UIColor whiteColor];
        
        UILabel *docSummLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 250, 20)];
        docSummLabel.backgroundColor = [UIColor clearColor];
        docSummLabel.baselineAdjustment= UIBaselineAdjustmentAlignCenters;
        docSummLabel.lineBreakMode             =  UILineBreakModeWordWrap;
        //docOrgName.textAlignment             = UITextAlignmentCenter;
        docSummLabel.shadowColor               = [UIColor whiteColor];
        docSummLabel.shadowOffset              = CGSizeMake(0.0, 1.0);
        docSummLabel.font                      = [UIFont systemFontOfSize:16];
        docSummLabel.textColor                 = [UIColor whiteColor];
        
        [headerView addSubview:docOrgName];
        [headerView addSubview:docSummLabel];
        
        //planDoc 
        docOrgName.text = [[[planDoc create_date] stringByAppendingString:@" "] stringByAppendingString:[planDoc organization_name]];
        docSummLabel.text = [planDoc doc_summ];
        
        UIButton *statSetButton = [[UIButton alloc] initWithFrame:CGRectMake(410, 5, 200, 35)];
        //statSetButton set
        UIColor *bgColor = [[UIColor alloc] initWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        statSetButton.backgroundColor = bgColor; 
        UIColor *titleColor = [[UIColor alloc] initWithRed:1.0 green:0.0 blue:0.0 alpha:1.0];
        [statSetButton setTitleColor:titleColor forState:UIControlStateNormal];
        
        statSetButton.tag = section;
        [statSetButton addTarget:self action:@selector(sendStatementRequest:) forControlEvents:UIControlEventTouchDown];
        
        [statSetButton setTitle:@"Согласовать" forState:UIControlStateNormal];
        if (planDoc.statement_state!=nil)    {
            if ([planDoc.statement_state isEqualToString:@"Утвержден"])  {
                UIColor *titleColor = [UIColor greenColor];
                [statSetButton setTitleColor:titleColor forState:UIControlStateNormal];                
                [statSetButton setTitle:@"Согласовано" forState:UIControlStateNormal];
            }
            else    {
           
            }
        }        
        [statSetButton setContentEdgeInsets:UIEdgeInsetsMake(20, 20, 20, 20)];
        //[introButton setContentEdgeInsets: forState:UIControlStateNormal];
        
        UIImage *buttonBackground = [UIImage imageNamed:@"whiteButton.png"];
        UIImage *buttonBackgroundPressed = [UIImage imageNamed:@"blueButton.png"];
        
        //CGRect button_frame = CGRectMake(182.0, 5.0, kStdButtonWidth, kStdButtonHeight);
        
        // or you can do this:
        //		UIButton *button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        
        statSetButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        statSetButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        //[hidePickerButton setTitle:@"OK" forState:UIControlStateNormal];	
        
        //[hidePickerButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        UIImage *newImage = [buttonBackground stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
        [statSetButton setBackgroundImage:newImage forState:UIControlStateNormal];
        
        UIImage *newPressedImage = [buttonBackgroundPressed stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
        [statSetButton setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];
        
        self.navigationItem.title = @"Даты";	
        //[button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
        
        // in case the parent view draws with a custom color or gradient, use a transparent color
        statSetButton.backgroundColor = [UIColor clearColor];
        
        [headerView addSubview:statSetButton];
        
        UIButton *loadDocsButton = [[UIButton alloc] initWithFrame:CGRectMake(620, 1, 35, 45)]; 
        [loadDocsButton setBackgroundImage:[UIImage imageNamed:@"low_importance.png"] forState:UIControlStateNormal];
        loadDocsButton.tag = section;
        [loadDocsButton addTarget:self action:@selector(sendDocPropertiesRequest:) forControlEvents:UIControlEventTouchDown];        
        
        [headerView addSubview:loadDocsButton];
        
        
        UIButton *showPlanDocDetailButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure]; 
        [showPlanDocDetailButton setFrame:CGRectMake(670, 3, 35, 45)];        
        //[loadDocsButton setBackgroundImage:[UIImage imageNamed:@"low_importance.png"] forState:UIControlStateNormal];
        showPlanDocDetailButton.tag = section;
        //showPlanDocDetailButton 
        [showPlanDocDetailButton addTarget:self action:@selector(showPlanDocDetail:) forControlEvents:UIControlEventTouchDown];        
        
        [headerView addSubview:showPlanDocDetailButton];        
        //UIBarButtonItem *statButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Согласовать", @"")  style:UIBarButtonItemStyleBordered  target:self	  action:@selector(sendStatementRequest:)];        
        //docSummLabel.text = [@"Сумма по реестру: " stringByAppendingString:[planDoc doc_summ]];// stringByAppendingString:@" "] stringByAppendingString:[planDoc currency_name]];
        headerView.backgroundColor = [UIColor darkGrayColor];
        headerView.alpha = 0.5;        
        return headerView;
    }
    else    {
        return nil;
        //if (section==0) {
        //    return @"Критично";
        //}   else if (section==1)    {
        //    return @"Важно";
        //}   else
        //    return @"Свободно";
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
       
    
        //static NSString *CellIdentifier = @"PlanDocCell";
        //UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        /*if(cell==nil)   {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        
        PaymentDoc *paymentDoc = [[[[DocsList objectAtIndex:[indexPath section]] paymentOrderList] paymentDocs] objectAtIndex:[indexPath row]];
        
        UILabel *orgCaptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
        orgCaptionLabel.text = @"Организация: ";
        orgCaptionLabel.font = [UIFont boldSystemFontOfSize:13];
        //[UIFont fontWithName:@"Helvetica" size:13];
        [orgCaptionLabel setTextColor:[UIColor blueColor]];
        
        UILabel *statusCaptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(370, 10, 60, 20)];
        statusCaptionLabel.text = @"Статус: ";
        statusCaptionLabel.font = [UIFont boldSystemFontOfSize:13];
        //[UIFont fontWithName:@"Helvetica" size:13];
        [statusCaptionLabel setTextColor:[UIColor blueColor]];
        
        UILabel *summCaptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(510, 10, 60, 20)];
        summCaptionLabel.text = @"Сумма: ";
        summCaptionLabel.font = [UIFont boldSystemFontOfSize:13];
        //[UIFont fontWithName:@"Helvetica" size:13];
        [summCaptionLabel setTextColor:[UIColor blueColor]];        
        
        UILabel *docSummLabel = [[UILabel alloc] initWithFrame:CGRectMake(575, 10, 100, 20)];
        UILabel *docStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(435, 10, 70, 20)];        
        UILabel *docOrgLabel = [[UILabel alloc] initWithFrame:CGRectMake(105, 10, 200, 20)];
        docOrgLabel.text = paymentDoc.organization_name;
        docSummLabel.text = [[paymentDoc.doc_summ stringByAppendingString:@" "] stringByAppendingString:paymentDoc.currency_name]; 
        docStatusLabel.text = paymentDoc.statement_state;
        [cell addSubview:orgCaptionLabel];
        [cell addSubview:docOrgLabel];
        [cell addSubview:statusCaptionLabel]; 
        [cell addSubview:docStatusLabel];        
        [cell addSubview:summCaptionLabel];        
        [cell addSubview:docSummLabel];        
        return cell;*/
    //}
    //else {
        static NSString *CellIdentifier = @"Cell";         
        DocsTableViewCell *cell = (DocsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        if (PortraitMode) {
            cell = [[[DocsTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];        }
        else {
        cell = [[[DocsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }  
    }
    
    Doc *doc = nil;    
    // Configure the cell...
    if (docType.doc_type_id==3) {
        doc = [[[[DocsList objectAtIndex:[indexPath section]] paymentOrderList] paymentDocs] objectAtIndex:[indexPath row]];    
    }    
    else 
    { 
        doc = [[impGroupedDocs objectAtIndex:[indexPath section]] objectAtIndex:indexPath.row]; 
    }
    //[DocsList objectAtIndex:indexPath.row];
    cell.numLabel.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
    cell.codeLabel.text = 
        doc.code;
    cell.create_date_label.text = 
        doc.create_date;
    cell.importance_label.text = 
        doc.importance_level_name;
    cell.org_name_label.text = 
        doc.organization_name;
    cell.executor_name_label.text = 
        doc.executor_name;
    cell.responsible_name_label.text = 
        doc.responsible_name;
    cell.order_type_label.text = 
        doc.order_type_name;   
    cell.statement_state_label.text = 
        doc.statement_state;
    cell.cfo_label.text = 
        doc.cfo_name;
    cell.currencyLabel.text = doc.currency_name;
    cell.projectLabel.text = doc.project_name;
    cell.docSummLabel.text = doc.doc_summ;
    cell.turnAccountLabel.text = doc.turn_account_name;
    cell.paymentDate.text = doc.charge_date;
    cell.maxPaymentDate.text = doc.charge_max_date;
    
    [cell.overPlanImage setImage:nil];    
    if (doc.over_budget!=nil)   {
        if([doc.over_budget isEqualToString:@"true"])    {
            [cell.overPlanImage setImage:[UIImage imageNamed:@"over_planned.png"]];
        }
    }
    
    [cell.cacheMoneyImage setImage:nil];    
    if (doc.payment_form_name!=nil)   {
        if([doc.payment_form_name isEqualToString:@"Наличные"])    {
            [cell.cacheMoneyImage setImage:[UIImage imageNamed:@"cache.png"]];
        }
    }
        
        
    cell.docsCellView.backgroundColor = [UIColor colorWithRed:0xFF/255.0 green:0xFF/255.0 blue:0xFF/255.0 alpha:1.0];
    [cell.statement_image setImage:[UIImage imageNamed:@"unchecked.png"]];
    if([doc.statement_state isEqualToString:@"Утверждена"])  {
        cell.docsCellView.backgroundColor = [UIColor colorWithRed:0x99/255.0 green:0xCC/255.0 blue:0xFF/255.0 alpha:1.0];
        [cell.statement_image setImage:[UIImage imageNamed:@"checked.png"]]; 
        }
    else if([doc.statement_state isEqualToString:@"Утвержден"])  {
        cell.docsCellView.backgroundColor = [UIColor colorWithRed:0x99/255.0 green:0xCC/255.0 blue:0xFF/255.0 alpha:1.0];
        [cell.statement_image setImage:[UIImage imageNamed:@"checked.png"]]; 
        }    
    else if([doc.statement_state isEqualToString:@"Оплата"])  {
            cell.docsCellView.backgroundColor = [UIColor colorWithRed:0xCC/255.0 green:0xFF/255.0 blue:0x99/255.0 alpha:1.0]; 
            [cell.statement_image setImage:[UIImage imageNamed:@"checked.png"]];
    }
    else if([doc.statement_state isEqualToString:@"Оплачена"])  {
        cell.docsCellView.backgroundColor = [UIColor colorWithRed:0x33/255.0 green:0xFF/255.0 blue:0x00/255.0 alpha:1.0];
        [cell.statement_image setImage:[UIImage imageNamed:@"checked.png"]];
    }       
    else if (NO)  {
        if ((indexPath.row % 2)==1)  {
            cell.docsCellView.backgroundColor = [UIColor colorWithRed:0xCC/255.0 green:0xCC/255.0 blue:0xCC/255.0 alpha:1.0];        
        }
        else {
            cell.docsCellView.backgroundColor = [UIColor colorWithRed:0xFF/255.0 green:0xFF/255.0 blue:0xFF/255.0 alpha:1.0];
        }
    }
    cell.statement_date.text = 
        doc.statement_date;    
    
    return cell;
    //}
    /*else
    {
        static NSString *CellIdentifier = @"moreCell";
        UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
                cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
                UILabel *moreLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 150, 20)];
                [cell addSubview:moreLabel];
                moreLabel.text = @"Больше...";
        }
        
        return cell;
    }*/
}

- (void) selectByRowNumber:(NSMutableArray*) ObjList : (NSUInteger) row
{
    
}

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
    }
    
    NSUInteger currentRowOffset = 0;
    if([[self.tableView indexPathsForVisibleRows] count]>0) {
        currentRowOffset = [[[self.tableView indexPathsForVisibleRows] objectAtIndex:0] row];
    }
    if (PortraitMode)   {
        [loadIndicator setFrame: CGRectMake(330, 90+(currentRowOffset*self.tableView.rowHeight),100,100)];
    }   else    {
        [loadIndicator setFrame: CGRectMake(110, 150+(currentRowOffset*self.tableView.rowHeight),100,100)];
    }    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSUInteger currentRowOffset = 0;
    if([[self.tableView indexPathsForVisibleRows] count]>0) {
        currentRowOffset = [[[self.tableView indexPathsForVisibleRows] objectAtIndex:0] row];
    }
    if (PortraitMode)   {
        [loadIndicator setFrame: CGRectMake(330, 90+(currentRowOffset*self.tableView.rowHeight),100,100)];
    }   else    {
        [loadIndicator setFrame: CGRectMake(110, 150+(currentRowOffset*self.tableView.rowHeight),100,100)];
    }
}

- (IBAction)showPlanDocDetail:(id)sender {
    UIButton *touchButton = sender;
    //currentPlanDoc = [DocsList objectAtIndex:touchButton.tag];    
    UIViewController <SubstitutableDetailViewController> *detailViewController = nil;    
    
    TabbedPaymentPlanDocViewController *newDetailViewController = [[TabbedPaymentPlanDocViewController alloc] initWithNibName: @"TabbedPaymentPlanDocViewController" bundle:nil];
    
    newDetailViewController.parentTableViewController = self;
    
    newDetailViewController.splitViewController = self.splitViewController;
    
    newDetailViewController.popoverController = self.popoverController;
    
    newDetailViewController.rootPopoverButtonItem = self.rootPopoverButtonItem;
    
    PaymentPlanDoc *paymentPlanDoc = [DocsList objectAtIndex:touchButton.tag];
    newDetailViewController.paymentPlanDoc = paymentPlanDoc;
    detailViewController = newDetailViewController;

    if (detailViewController!=nil) {
    
        if ([[childNavController viewControllers] count]>2) {
            [childNavController popViewControllerAnimated:NO];
        }
    
        [childNavController pushViewController:detailViewController animated:true];
    
        // Dismiss the popover if it's present.
        if (popoverController != nil) {
        [popoverController dismissPopoverAnimated:YES];
        }
    
        // Configure the new view controller's popover 
        if (rootPopoverButtonItem != nil) {
        [detailViewController showRootPopoverButtonItem:self.rootPopoverButtonItem:NO];
        }
    }

    [detailViewController release];
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row;
    //if (row<[DocsList count]) {
    //[self selectByRowNumber:  : row];
    
    UIViewController <SubstitutableDetailViewController> *detailViewController = nil;
    
    //Doc *doc = [[impGroupedDocs objectAtIndex:[indexPath section]] objectAtIndex:row];
    if ((docType.doc_type_id==1)||(docType.doc_type_id==2)) {
        TabbedPaymentDocViewController *newDetailViewController = [[TabbedPaymentDocViewController alloc] initWithNibName: @"TabbedPaymentDocViewController" bundle:nil];
        
        newDetailViewController.parentTableViewController = self;
        
        newDetailViewController.splitViewController = self.splitViewController;
        
        newDetailViewController.popoverController = self.popoverController;
        
        newDetailViewController.rootPopoverButtonItem = self.rootPopoverButtonItem;
        
        PaymentDoc *paymentDoc = [[impGroupedDocs objectAtIndex:[indexPath section]] objectAtIndex:row];
        newDetailViewController.paymentDoc = paymentDoc;
        detailViewController = newDetailViewController;
    }
    if (docType.doc_type_id==3) {
        TabbedPaymentDocViewController *newDetailViewController = [[TabbedPaymentDocViewController alloc] initWithNibName: @"TabbedPaymentDocViewController" bundle:nil];
        
        newDetailViewController.parentTableViewController = self;
        
        newDetailViewController.splitViewController = self.splitViewController;
        
        newDetailViewController.popoverController = self.popoverController;
        
        newDetailViewController.rootPopoverButtonItem = self.rootPopoverButtonItem;        
        
        PaymentDoc *paymentDoc = [[[[DocsList objectAtIndex:[indexPath section]] paymentOrderList] paymentDocs] objectAtIndex:[indexPath row]];
        newDetailViewController.paymentDoc = paymentDoc;
        detailViewController = newDetailViewController;        
        //TabbedPaymentPlanDocViewController *newDetailViewController = [[TabbedPaymentPlanDocViewController alloc] initWithNibName: @"TabbedPaymentPlanDocViewController" bundle:nil];
        
        //newDetailViewController.parentTableViewController = self;
        
        //newDetailViewController.splitViewController = self.splitViewController;
        
        //newDetailViewController.popoverController = self.popoverController;
        
        //newDetailViewController.rootPopoverButtonItem = self.rootPopoverButtonItem;
        
        //PaymentPlanDoc *paymentPlanDoc = [DocsList objectAtIndex:[indexPath section]];
        //newDetailViewController.paymentPlanDoc = paymentPlanDoc;
        //detailViewController = newDetailViewController;
    }
    
    if (detailViewController!=nil) {
        
        if ([[childNavController viewControllers] count]>2) {
            [childNavController popViewControllerAnimated:NO];
        }
        
        [childNavController pushViewController:detailViewController animated:true];
        
        // Dismiss the popover if it's present.
        if (popoverController != nil) {
            [popoverController dismissPopoverAnimated:YES];
        }
        
        // Configure the new view controller's popover 
        if (rootPopoverButtonItem != nil) {
            [detailViewController showRootPopoverButtonItem:self.rootPopoverButtonItem:NO];
        }
    }
    
    [detailViewController release];    
}

- (void) moreDocsTapped {
    [self docsRequest:YES];
}

// Our NSNotification callback from the running NSOperation to add the docs
//
- (void)addDocs:(NSNotification *)notif {
    assert([NSThread isMainThread]);
    AllDocsViewController *currAllDoc = childDetailViewController;
    if (currAllDoc.DocsListController==self)  {
        [self addDocsToList:[[notif userInfo] valueForKey:kDocResultsKey]];
    }
}

// The NSOperation "ParseOperation" calls NSNotification, on the main thread
- (void)addDocsToList:(NSArray *)docs {

    [self insertDocs:docs];
}

- (void)showSystemMessage:(SystemMessage *)systemMessage {
    if ([systemMessage.doc_id isEqualToString:currentPlanDoc.doc_id])  {  
        
        //[[docCoordinationScrollViewController coordListController] sendDocPropertiesRequest];
        
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
            //statementStatusLabel.text = systemMessage.message_text;
            currentPlanDoc.statement_state = systemMessage.message_text;
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"Y-MM-dd hh:mm:ss"];
            
            NSString *currentDateTime = [formatter stringFromDate:[NSDate date]];
            //statementDateLabel.text = currentDateTime;
            currentPlanDoc.statement_date = currentDateTime;
            [formatter release];
            
            //if (paymentPlanDoc.statement_state!=nil)    {
            //    if ([currentPlanDoc.statement_state isEqualToString:@"Утвержден"])  {
            //        statementSetButton.enabled = NO;
            //        statementSetButton.title = @"Согласовано";
            //        [statusImageView setImage:[UIImage imageNamed:@"checked.png"]];            
            //    }
            //    else    {
            //        statementSetButton.enabled = YES;
            //        statementSetButton.title = @"Согласовать";
            //        [statusImageView setImage:[UIImage imageNamed:@"unchecked.png"]];            
            //    }
            //}
            
            //if (parentTableViewController!=nil)  {
            //    [parentTableViewController.tableView reloadData];
            //}
            [self.tableView reloadData];
        }
        [alertView show];
        [alertView release];
    }
}

- (void)addDocsUpdateMessage:(NSNotification *)notif {
    assert([NSThread isMainThread]);
    if (childNavController.visibleViewController == childDetailViewController)  {
        [self showSystemMessage:[[notif userInfo] valueForKey:kDocsUpdateMsgResultKey]];
    }
}

- (void)insertProps:(NSArray *)props
{
    // this will allow us as an observer to notified (see observeValueForKeyPath)
    // so we can update our UITableView
    //
    [self willChangeValueForKey:@"addProps"];
    [self.currentPlanDoc.paymentOrderList.paymentDocs addObjectsFromArray:props];
    [self.loadIndicator stopAnimating];    
    [self didChangeValueForKey:@"addProps"];
}

// listen for changes to the earthquake list coming from our app delegate.
//- (void)observeValueForKeyPath:(NSString *)keyPath
//                      ofObject:(id)object
//                        change:(NSDictionary *)change
//                       context:(void *)context
//{
//    if (keyPath==@"addProps") {
//        [self.tableView reloadData];
//    }  
//    
//}
// Our NSNotification callback from the running NSOperation to add the earthquakes
//
- (void)addDocProp:(NSNotification *)notif {
    assert([NSThread isMainThread]);
    if (childNavController.visibleViewController == childDetailViewController)  {
        [self addPropsToList:[[notif userInfo] valueForKey:kDocIncludeResultsKey]];
    }
}

// The NSOperation "ParseOperation" calls NSNotification, on the main thread
- (void)addPropsToList:(NSArray *)props {
    
    [self insertProps:props];
}

@end
