//
//  CoordinationsTableViewController.m
//  MultipleDetailViews
//
//  Created by MacMini on 15.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PaymentOrderTableViewCell.h"
#import "PaymentOrdersTableViewController.h"
#import "AppDelegate.h"
#import "ParseDocProperties.h"


@implementation PaymentOrdersTableViewController

@synthesize paymentPlanDoc, parseQueue, loadIndicator;

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
    [parseQueue release];
    [paymentPlanDoc release];
    [loadIndicator release];
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
    
    parseQueue = [NSOperationQueue new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addDocProp:) name:kAddDocsIncludeNotif object:nil];
    
    [self addObserver:self forKeyPath:@"addProps" options:0 context:NULL];
    
    [self.paymentPlanDoc.paymentOrderList.paymentDocs setArray:nil];
    
    if (kDEMOMode)  {
        
        NSString *filepath = [[NSBundle mainBundle] pathForResource: @"getDocPropertiesInclDocs"  ofType:@"xml"];
        
        NSMutableData *DocsData = [NSData dataWithContentsOfFile:filepath];
        if (DocsData==nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка получения данных" message:@"Не найден файл с данными для DEMO-режима!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];	
            [alert release];
        }  
        else    {
            [self refreshData:DocsData:kQueryModeIncludeDocs];
        }    
        //[DocsData release];
    }
    else
        [self sendDocPropertiesRequest];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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

- (void)sendDocPropertiesRequest {
    [self.paymentPlanDoc.paymentOrderList.paymentDocs setArray:nil];
    
    MainHTTPConnection *docPropHTTPConn = [[MainHTTPConnection alloc] init];
    docPropHTTPConn.destController = self;
    docPropHTTPConn.loadIndicator = loadIndicator;
    
    //NSString *docTypeIdStr = [NSString stringWithFormat:@"%d",doc.doc_type_id];
    
    //if (paymentDoc.doc_type_id==1)  {
        [docPropHTTPConn sendRequestWithAuth: [[kPHPProxiesBaseAdress stringByAppendingString:@"getDocProperties.php?doc_type_id=3&data_type=include_docs&doc_id="]  stringByAppendingString:paymentPlanDoc.doc_id] : kCurrentHTTPLogin :kCurrentHTTPPassword];
    
    [docPropHTTPConn release];    
}

- (void)refreshData:(NSMutableData *)data:(NSInteger)queryMode  {
    if ((CFGetRetainCount(self)>1)||kDEMOMode)   {
    ParseDocProperties *parseOperation = [[ParseDocProperties alloc] initWithData:data];
    [self.parseQueue addOperation:parseOperation];
    [parseOperation release];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [paymentPlanDoc.paymentOrderList.paymentDocs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PaymentOrderListCellID";
    
    PaymentOrderTableViewCell *cell = 
    (PaymentOrderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[PaymentOrderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];  
        
    } else {

    }
    PaymentDoc *paymentDoc = [paymentPlanDoc.paymentOrderList.paymentDocs objectAtIndex:indexPath.row];
    cell.numLabel.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
    cell.orgNameLabel.text = paymentDoc.organization_name;
    cell.paymentDocNameLabel.text = paymentDoc.code;
    cell.docCurrencyLabel.text = paymentDoc.currency_name;
    cell.summLabel.text = paymentDoc.doc_summ;
    cell.statusTextView.text = paymentDoc.statement_state;
    cell.paymentFormNameLabel.text = paymentDoc.payment_form_name;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

- (void)insertProps:(NSArray *)props
{
    // this will allow us as an observer to notified (see observeValueForKeyPath)
    // so we can update our UITableView
    //
    [self willChangeValueForKey:@"addProps"];
    [self.paymentPlanDoc.paymentOrderList.paymentDocs addObjectsFromArray:props];
    [self.loadIndicator stopAnimating];    
    [self didChangeValueForKey:@"addProps"];
}

// listen for changes to the earthquake list coming from our app delegate.
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (keyPath==@"addProps") {
        [self.tableView reloadData];
    }  
    
}
// Our NSNotification callback from the running NSOperation to add the earthquakes
//
- (void)addDocProp:(NSNotification *)notif {
    assert([NSThread isMainThread]);
    
    [self addPropsToList:[[notif userInfo] valueForKey:kDocIncludeResultsKey]];
}

// The NSOperation "ParseOperation" calls NSNotification, on the main thread
- (void)addPropsToList:(NSArray *)props {
    
    [self insertProps:props];
}

@end
