//
//  CoordinationsTableViewController.m
//  MultipleDetailViews
//
//  Created by MacMini on 15.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CoordinationsTableViewController.h"
#import "CoordinationTableViewCell.h"
#import "AppDelegate.h"
#import "ParseDocProperties.h"
#import "CoordinationElement.h"

@implementation CoordinationsTableViewController

@synthesize coordDoc, parseQueue, loadIndicator;

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
    [coordDoc release];
    [loadIndicator release];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addDocProp:) name:kAddDocsCoordNotif object:nil];
    [self removeObserver:self forKeyPath:@"addProps"];    
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)sendDocPropertiesRequest {
    [self.coordDoc.coordinateSolutions setArray:nil];
    
    MainHTTPConnection *docPropHTTPConn = [[MainHTTPConnection alloc] init];
    docPropHTTPConn.destController = self;
    docPropHTTPConn.loadIndicator = loadIndicator;
    
    NSString *docTypeIdStr = [NSString stringWithFormat:@"%d",coordDoc.doc_type_id];
    
    [docPropHTTPConn sendRequestWithAuth: [[[[kPHPProxiesBaseAdress stringByAppendingString:@"getDocProperties.php?data_type=vises&doc_id="]  stringByAppendingString:coordDoc.doc_id] stringByAppendingString:@"&doc_type_id="] stringByAppendingString:docTypeIdStr] : kCurrentHTTPLogin :kCurrentHTTPPassword];
    
    [docPropHTTPConn release];    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    parseQueue = [NSOperationQueue new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addDocProp:) name:kAddDocsCoordNotif object:nil];
    
    [self addObserver:self forKeyPath:@"addProps" options:0 context:NULL];
    
    [self.coordDoc.coordinateSolutions setArray:nil];
    
    if (kDEMOMode)  {
        NSString *docTypeIdStr = [NSString stringWithFormat:@"%d",coordDoc.doc_type_id];
        
        NSString *filepath = [[NSBundle mainBundle] pathForResource: [@"getDocPropertiesVises" stringByAppendingString: docTypeIdStr] ofType:@"xml"];
        
        NSMutableData *DocsData = [NSMutableData dataWithContentsOfFile:filepath];
        if (DocsData==nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка получения данных" message:@"Не найден файл с данными для DEMO-режима!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];	
            [alert release];
        }  
        else    {
            [self refreshData:DocsData:kQueryModeCoordDocs];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.coordDoc.coordinateSolutions count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CoordinationCellID";
    
    CoordinationTableViewCell *cell = 
    (CoordinationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[CoordinationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];  
        
    } else {

    }
    CoordinationElement *coordElm = [self.coordDoc.coordinateSolutions objectAtIndex:indexPath.row];
    cell.numLabel.text = [NSString stringWithFormat:@"%d",indexPath.row+1];
    cell.viseTextView.text = coordElm.vise_name;
    cell.postTextView.text = coordElm.actor_post_name;
    cell.personNamesTextView.text = coordElm.person_name;
    cell.solutionTextField.text = coordElm.statement_solution_value;
    cell.solutionActorTextField.text = coordElm.solution_actor_name;
    cell.setDateTextField.text = coordElm.set_date;
    cell.maxSetDateTextField.text = coordElm.max_set_date;
    
    if (coordElm.setManual) {
        [cell.setManualImageView setImage:[UIImage imageNamed:@"checked.png"]];    
    }
    else    {
        [cell.setManualImageView setImage:[UIImage imageNamed:@"unchecked.png"]];
    }
    
    cell.commentTextView.text = coordElm.comment;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)refreshData:(NSMutableData *)data:(NSInteger)queryMode  {
    if ((CFGetRetainCount(self)>1)||kDEMOMode)   {
    ParseDocProperties *parseOperation = [[ParseDocProperties alloc] initWithData:data];
    //parseOperation.docType = docType;
    [self.parseQueue addOperation:parseOperation];
    [parseOperation release]; 
    }
}

- (void)insertProps:(NSArray *)props
{
    // this will allow us as an observer to notified (see observeValueForKeyPath)
    // so we can update our UITableView
    //
    [self willChangeValueForKey:@"addProps"];
    [self.coordDoc.coordinateSolutions addObjectsFromArray:props];
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
    
    [self addPropsToList:[[notif userInfo] valueForKey:kDocCoordResultsKey]];
}

// The NSOperation "ParseOperation" calls NSNotification, on the main thread
- (void)addPropsToList:(NSArray *)props {
    
    [self insertProps:props];
}

@end
