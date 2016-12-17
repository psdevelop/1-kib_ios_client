//
//  DocTypeListTableViewController.m
//  MultipleDetailViews
//
//  Created by MacMini on 09.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DocTypeListPortraitTableViewController.h"
#import "DocTypeTableViewCell.h"
#import "AllDocTypesViewController.h"
#import "ParseDocTypesOperation.h"
#import "DocsListTableViewController.h"

// forward declarations
@interface DocTypeListPortraitTableViewController ()

//@property (nonatomic, retain) NSURLConnection *earthquakeFeedConnection;
@property (nonatomic, retain) NSMutableData *earthquakeData;    // the data returned from the NSURLConnection
@property (nonatomic, retain) NSOperationQueue *parseQueue;     // the queue that manages our NSOperation for parsing earthquake data

- (void)addDocTypesToList:(NSArray *)earthquakes;
- (void)handleError:(NSError *)error;
@end

@implementation DocTypeListPortraitTableViewController

@synthesize DocTypesList, splitViewController, popoverController,rootPopoverButtonItem;
@synthesize earthquakeData, parseQueue;

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
    
    //self.tableView.rowHeight = 150.0;
    self.DocTypesList = [NSMutableArray array]; 
    self.contentSizeForViewInPopover = CGSizeMake(255.0, 240.0);  
    //self.splitViewController.accessibilityFrame = CGRectMake(0, 0, 100, 100);
    //self.splitViewController.
    //self.splitViewController.navigationController.navigationBar.contentStretch = CGRectMake(0, 0, 100, 100);
    //self.splitViewController.
    //self.splitViewController.navigationController.navigationBar.superview.frame = CGRectMake(0, 0, 100, 100);
    //[self.navigationController.navigationBar setFrame:CGRectMake(0,0, 50, 500)];
    [self.view setFrame:CGRectMake(100,0, 50, 500)];
    self.tableView.contentSize = CGSizeMake(10.0, 400);
    //self.splitViewController.navigationController.navigationBar.frame = CGRectMake(self.splitViewController.navigationController.navigationBar.frame.origin.x, self.splitViewController.navigationController.navigationBar.frame.origin.y, 100, self.splitViewController.navigationController.navigationBar.frame.size.height);
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    // KVO: listen for changes to our earthquake data source for table view updates
    self.earthquakeData = [NSData dataWithContentsOfFile: @"/INET/selected/UniOneCClient/DocTypeSampleXML.xml"];
    parseQueue = [NSOperationQueue new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addDocTypes:) name:kAddEarthquakesNotif object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(earthquakesError:) name:kEarthquakesErrorNotif object:nil];
    
    ParseDocTypesOperation *parseOperation = [[ParseDocTypesOperation alloc] initWithData:self.earthquakeData];
    [self.parseQueue addOperation:parseOperation];
    [parseOperation release];   
    // once added to the NSOperationQueue it's retained, we don't need it anymore
    
    // earthquakeData will be retained by the NSOperation until it has finished executing,
    // so we no longer need a reference to it in the main thread.
    self.earthquakeData = nil;    
    [self addObserver:self forKeyPath:@"DocTypesList" options:0 context:NULL];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.DocTypesList = nil;
    
    [self removeObserver:self forKeyPath:@"DocTypesList"];
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

- (void)splitViewController:(UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController:(UIPopoverController*)pc {
    
    // Keep references to the popover controller and the popover button, and tell the detail view controller to show the button.
    barButtonItem.title = @"Список типов документов";
    self.popoverController = pc;
    self.rootPopoverButtonItem = barButtonItem;
    UIViewController <SubstitutableDetailViewController> *detailViewController = [splitViewController.viewControllers objectAtIndex:1];
    [detailViewController showRootPopoverButtonItem:rootPopoverButtonItem:NO];
}


- (void)splitViewController:(UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    
    // Nil out references to the popover controller and the popover button, and tell the detail view controller to hide the button.
    UIViewController <SubstitutableDetailViewController> *detailViewController = [splitViewController.viewControllers objectAtIndex:1];
    [detailViewController invalidateRootPopoverButtonItem:rootPopoverButtonItem];
    self.popoverController = nil;
    self.rootPopoverButtonItem = nil;
}

#pragma mark -
#pragma mark KVO support

- (void)insertEarthquakes:(NSArray *)earthquakes
{
    // this will allow us as an observer to notified (see observeValueForKeyPath)
    // so we can update our UITableView
    //
    self.DocTypesList = [NSMutableArray array];    
    [self willChangeValueForKey:@"DocTypesList"];
    [self.DocTypesList addObjectsFromArray:earthquakes];
    [self didChangeValueForKey:@"DocTypesList"];
}

// listen for changes to the earthquake list coming from our app delegate.
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (keyPath==@"DocTypesList") {
        [self.tableView reloadData];
    }
    //[self.splitViewController ];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    //return 2;
    return [DocTypesList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Each subview in the cell will be identified by a unique tag.
    /*static NSUInteger const kLocationLabelTag = 2;
    static NSUInteger const kDateLabelTag = 3;
    static NSUInteger const kMagnitudeLabelTag = 4;
    static NSUInteger const kMagnitudeImageTag = 5;
    
    // Declare references to the subviews which will display the earthquake data.
    UILabel *locationLabel = nil;
    UILabel *dateLabel = nil;
    UILabel *magnitudeLabel = nil;
    UIImageView *magnitudeImage = nil;*/
    
    static NSString *CellIdentifier = @"DocTypeCellID";
    
    DocTypeTableViewCell *cell = 
        (DocTypeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[DocTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];  

        //[cell.imageView setImage:[UIImage imageNamed:@"5.0.png"]];
        
    } else {
        // A reusable cell was available, so we just need to get a reference to the subviews
        // using their tags.
        //
        /*locationLabel = (UILabel *)[cell.contentView viewWithTag:kLocationLabelTag];
        dateLabel = (UILabel *)[cell.contentView viewWithTag:kDateLabelTag];
        magnitudeLabel = (UILabel *)[cell.contentView viewWithTag:kMagnitudeLabelTag];
        magnitudeImage = (UIImageView *)[cell.contentView viewWithTag:kMagnitudeImageTag];
         */
    }
    DocType *docType = [DocTypesList objectAtIndex:indexPath.row];
    cell.label.text = docType.name;
    cell.textView.text = docType.description;
    // Configure the cell...
    
    // Get the specific earthquake for this row.
	//Earthquake *earthquake = [earthquakeList objectAtIndex:indexPath.row];
    
    // Set the relevant data for each subview in the cell.
    //locationLabel.text = earthquake.location;
    //locationLabel.text = @"location";   
    //cell.label.text = @"location";    
    //dateLabel.text = [NSString stringWithFormat:@"%@", [self.dateFormatter stringFromDate:earthquake.date]];
    //magnitudeLabel.text = [NSString stringWithFormat:@"%.1f", earthquake.magnitude];
    //magnitudeImage.image = [self imageForMagnitude:earthquake.magnitude];
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = indexPath.row;
    
    UIViewController <SubstitutableDetailViewController> *detailViewController = nil;
    UITableViewController <UISplitViewControllerDelegate> *navViewController = nil;

        DocsListTableViewController *newNavViewController = [[DocsListTableViewController alloc] initWithNibName: @"DocsListTableViewController" bundle:nil];
        
        navViewController = newNavViewController;        
        //detailViewController.recipe = recipe;
        DocType *docType = [DocTypesList objectAtIndex:indexPath.row];
        newNavViewController.docType = docType;
        newNavViewController.splitViewController = self.splitViewController;
    
        newNavViewController.popoverController = 
        self.popoverController;
    
        newNavViewController.rootPopoverButtonItem = 
        self.rootPopoverButtonItem;
            
        [self.navigationController pushViewController:navViewController animated:true];
        
        AllDocTypesViewController *newDetailViewController = [[AllDocTypesViewController alloc] initWithNibName:@"AllDocTypesDetailView" bundle:nil];        
        detailViewController = newDetailViewController;
    
    // Update the split view controller's view controllers array.
    NSArray *viewControllers = [[NSArray alloc] initWithObjects:self.navigationController, detailViewController, nil];
    splitViewController.viewControllers = viewControllers;
    [viewControllers release];
    
    // Dismiss the popover if it's present.
    if (popoverController != nil) {
        [popoverController dismissPopoverAnimated:YES];
    }
    
    // Configure the new view controller's popover button (after the view has been displayed and its toolbar/navigation bar has been created).
    if (rootPopoverButtonItem != nil) {
        [detailViewController showRootPopoverButtonItem:self.rootPopoverButtonItem:NO];
    }
    
    [detailViewController release];
}

// Handle errors in the download by showing an alert to the user. This is a very
// simple way of handling the error, partly because this application does not have any offline
// functionality for the user. Most real applications should handle the error in a less obtrusive
// way and provide offline functionality to the user.
//
- (void)handleError:(NSError *)error {
    NSString *errorMessage = [error localizedDescription];
    UIAlertView *alertView =
    [[UIAlertView alloc] initWithTitle:
     NSLocalizedString(@"Error Title",
                       @"Title for alert displayed when download or parse error occurs.")
                               message:errorMessage
                              delegate:nil
                     cancelButtonTitle:@"OK"
                     otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

// Our NSNotification callback from the running NSOperation to add the earthquakes
//
- (void)addDocTypes:(NSNotification *)notif {
    assert([NSThread isMainThread]);
    
    [self addDocTypesToList:[[notif userInfo] valueForKey:kEarthquakeResultsKey]];
}

// Our NSNotification callback from the running NSOperation when a parsing error has occurred
//
- (void)earthquakesError:(NSNotification *)notif {
    assert([NSThread isMainThread]);
    
    [self handleError:[[notif userInfo] valueForKey:kEarthquakesMsgErrorKey]];
}

// The NSOperation "ParseOperation" calls addEarthquakes: via NSNotification, on the main thread
// which in turn calls this method, with batches of parsed objects.
// The batch size is set via the kSizeOfEarthquakeBatch constant.
//
- (void)addDocTypesToList:(NSArray *)earthquakes {
    
    // insert the earthquakes into our rootViewController's data source (for KVO purposes)
    
    [self insertEarthquakes:earthquakes];
}

@end
