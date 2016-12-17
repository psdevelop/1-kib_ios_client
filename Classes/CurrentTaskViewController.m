//
//  CurrentTaskViewController.m
//  Uni1CCLient
//
//  Created by MacMini on 02.09.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CurrentTaskViewController.h"
#import "AppDelegate.h"
#import "ParseIndicatorsOperation.h"
#import "Indicator.h"
#import "AllDocsViewController.h"
#import "DocType.h"

NSString *kHightImportanceValue = @"СуммаСВысокойВажностью";
NSString *kMediumLowImportanceValue = @"СуммаСоСреднейИлиНизкойВажностью";
NSString *kOverBudjetValue = @"СуммаСверхБюджета";
NSString *kPlanDocsValue = @"РеестрыПлатежейНеутвержденные";

@implementation CurrentTaskViewController

@synthesize rootPopoverButtonItem, splitViewController, loadIndIndicator, parseQueue, indicatorsArray, heightImpotanceCountLabel, overBudjetCountLabel, mediumLowImpotanceCountLabel, canonicalFormatter, indicatorStartDate, heightImpotanceButton, overBudjetButton, mediumLowImpotanceButton, moneyUseReportButton, paymentPlanButton, notStatPlanDocCountLabel, paymentPlanStartDate;

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
    [heightImpotanceCountLabel release];
    [overBudjetCountLabel release];
    [mediumLowImpotanceCountLabel release];
    [notStatPlanDocCountLabel release];
    [heightImpotanceButton release];
    [mediumLowImpotanceButton release];
    [overBudjetButton release];
    [paymentPlanButton release];
    [moneyUseReportButton release];
    [loadIndIndicator release];
    [canonicalFormatter release];
    [parseQueue release];
    [indicatorsArray release];
    [indicatorStartDate release];
    [paymentPlanStartDate release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kAddIndicatorsNotif object:nil];
    
    [self removeObserver:self forKeyPath:@"addIndicators"];
    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void) requestIndicators   {
    MainHTTPConnection *newConnection = [[MainHTTPConnection alloc] init];
    MainHTTPConnection *indicatorsHTTPConn = newConnection;
    indicatorsHTTPConn.destController = self;
    indicatorsHTTPConn.loadIndicator = loadIndIndicator;
    
    self.heightImpotanceCountLabel.text = @"(---)";
    self.mediumLowImpotanceCountLabel.text = @"(---)"; 
    self.overBudjetCountLabel.text = @"(---)";
    self.notStatPlanDocCountLabel.text = @"(---)";
    
    self.indicatorsArray = [NSMutableArray array];
    
    [indicatorsHTTPConn sendRequestWithAuth: [kPHPProxiesBaseAdress stringByAppendingString:@"getUserTasks.php"] : kCurrentHTTPLogin :kCurrentHTTPPassword];
    
    [indicatorsHTTPConn release];
}

- (void) touchRefreshIndicators:(id) sender {
    if (kDEMOMode)  {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Сообщение" message:@"В DEMO-режиме не требуется обновления!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];	
        [alert release];
        
    }   else {
        [self requestIndicators];
    }
}

-(void) rewriteIndicatorsButtons    {
    Indicator *indicator;
    
    NSMutableString *alertStr= [NSMutableString string];
    int badgeNumber = 0;
    
    for (indicator in indicatorsArray)
    {
        
        if([indicator.message isEqualToString:kHightImportanceValue])  {
            
            self.heightImpotanceCountLabel.text = [[@"(" stringByAppendingString:indicator.counter] stringByAppendingString:@")"];
            
            NSDateFormatter *indicatorFormatter = [[NSDateFormatter alloc] init];
            [indicatorFormatter setDateFormat:@"Y-MM-dd hh:mm:ss"];
            
            if (indicator.min_date!=nil)    {
                self.indicatorStartDate = [canonicalFormatter stringFromDate:indicator.min_date];
                
                if (![indicator.counter isEqualToString:@"0"])    {
                    [alertStr appendString:[@"Дата наиболее ранней заявки: " stringByAppendingString: [indicatorFormatter stringFromDate:indicator.min_date]]];
                    [self.heightImpotanceButton setEnabled:YES];
                    badgeNumber+=[indicator.counter intValue];
                                                            
                }
                else    {
                    [alertStr appendString:@"Нет заявок."];
                    [self.heightImpotanceButton setEnabled:NO];
                }
                
            }
            
            [indicatorFormatter release];
        }
        else if([indicator.message isEqualToString:kMediumLowImportanceValue])  {
            self.mediumLowImpotanceCountLabel.text = [[@"(" stringByAppendingString:indicator.counter] stringByAppendingString:@")"]; 
            
            if (![indicator.counter isEqualToString:@"0"])    {
                [self.mediumLowImpotanceButton setEnabled:YES];
                badgeNumber+=[indicator.counter intValue];
            }
            else    { 
                [self.mediumLowImpotanceButton setEnabled:NO];                
            }              
        } 
        else if([indicator.message isEqualToString:kOverBudjetValue])  {
            self.overBudjetCountLabel.text = [[@"(" stringByAppendingString:indicator.counter] stringByAppendingString:@")"];
            
            if (![indicator.counter isEqualToString:@"0"])    {
                [self.overBudjetButton setEnabled:YES];
                badgeNumber+=[indicator.counter intValue];                
            }
            else    { 
                [self.overBudjetButton setEnabled:NO];                
            }            
        }
        else if([indicator.message isEqualToString:kPlanDocsValue])  {
            self.notStatPlanDocCountLabel.text = [[@"(" stringByAppendingString:indicator.counter] stringByAppendingString:@")"];
            
            NSDateFormatter *indicatorFormatter = [[NSDateFormatter alloc] init];
            [indicatorFormatter setDateFormat:@"Y-MM-dd hh:mm:ss"];
            
            if (indicator.min_date!=nil)    {
                self.paymentPlanStartDate = [canonicalFormatter stringFromDate:indicator.min_date];
                
                if (![indicator.counter isEqualToString:@"0"])    {
                    [alertStr appendString:[@" Дата наиболее раннего реестра: " stringByAppendingString: [indicatorFormatter stringFromDate:indicator.min_date]]];
                    [self.paymentPlanButton setEnabled:YES];
                    badgeNumber+=[indicator.counter intValue];
                }
                else    {
                    [alertStr appendString:@" Нет реестров."]; 
                    [self.paymentPlanButton setEnabled:NO];                
                }
                    
                
            }
            
            [indicatorFormatter release];
        }        
        else    {
            
        }
        
    }
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = badgeNumber;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Информация" message:alertStr  delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];	
    [alert release];    
}

- (void) loadDocsList:(NSString *)filterStr :(NSUInteger) doc_type_num {
    
    //[childDocListController release];
    [childDetailViewController release]; 
    
    //childDocListController = nil;
    childDetailViewController = nil;
    
    AllDocsViewController *newDetailViewController = [[AllDocsViewController alloc] initWithNibName:@"AllDocsViewController" bundle:nil];
    childDetailViewController = newDetailViewController;
    
    newDetailViewController.rootPopoverButtonItem = self.rootPopoverButtonItem;
    
    DocsListTableViewController *docsListPortraitController = [DocsListTableViewController alloc];
    
    docsListPortraitController.PortraitMode = YES;
    
    [docsListPortraitController initWithNibName:@"DocsListTableViewController"  bundle:nil];
    
    docsListPortraitController.filterParamsStr = [filterStr copy];
    
    docsListPortraitController.showAlways = YES;
    
    newDetailViewController.DocsListController=docsListPortraitController;    
    //[childNavController popToRootViewControllerAnimated:false];    
    
    DocType *docType = [[DocType alloc] init];
    docType.doc_type_id = doc_type_num;
    docsListPortraitController.docType = docType;
    [docType release];
    
    docsListPortraitController.splitViewController = self.splitViewController;
    
    docsListPortraitController.rootPopoverButtonItem = 
        self.rootPopoverButtonItem;

    [childNavController pushViewController:newDetailViewController animated:true];    
    
    NSArray *viewControllers = [[NSArray alloc] initWithObjects:[splitViewController.viewControllers objectAtIndex:0], childNavController, nil];
        //splitViewController.viewControllers = viewControllers;
        [viewControllers release];     
    
    if (self.rootPopoverButtonItem != nil) {
        [newDetailViewController showRootPopoverButtonItem:self. rootPopoverButtonItem:NO];
    }
    
    //[newDetailViewController release];
    //[docsListPortraitController release];

}

- (IBAction) touchHightImportanceButton:(id) sender {
    //NSTimeInterval secondsPerDay = 24 * 60 * 60;
    
    [self loadDocsList:[@"&importance=hight&after_date=" stringByAppendingString:[indicatorStartDate stringByAppendingString:@"000000"]] :1];
}

- (IBAction) touchMediumLowImportanceButton:(id) sender {
    //NSTimeInterval secondsPerDay = 24 * 60 * 60;
    
    [self loadDocsList:[@"&importance=medium_low&after_date=" stringByAppendingString: [self.indicatorStartDate stringByAppendingString:@"000000"]] :1];
}

- (IBAction) touchOverBudjetImportanceButton:(id) sender    {
    //NSTimeInterval secondsPerDay = 24 * 60 * 60;
    
    [self loadDocsList:[@"&over_budjet=true&after_date=" stringByAppendingString:[self.indicatorStartDate stringByAppendingString:@"000000"]] :1];    

}

- (IBAction) touchPaymentPlanButton:(id) sender {
    [self loadDocsList:[@"&no_has_status=statemented&after_date=" stringByAppendingString:[self.paymentPlanStartDate stringByAppendingString:@"000000"]] :3];
}

- (IBAction) touchMoneyUseReportButton:(id) sender  {
    
}

- (void)refreshData:(NSMutableData *)data:(NSInteger)queryMode  {
    ParseIndicatorsOperation *parseOperation = [[ParseIndicatorsOperation alloc] initWithData:data];
    [self.parseQueue addOperation:parseOperation];

    [parseOperation release]; 
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.parseQueue = [NSOperationQueue new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addIndicators:) name:kAddIndicatorsNotif object:nil];
    
    [self addObserver:self forKeyPath:@"addIndicators" options:0 context:NULL];
    
    [loadIndIndicator setFrame: CGRectMake(330, 90,100,100)]; 
    [self.view addSubview:loadIndIndicator];
    
    NSDateFormatter *newFormatter = [[NSDateFormatter alloc] init];    
    self.canonicalFormatter = newFormatter;
    [newFormatter release];
    [self.canonicalFormatter setDateFormat:@"YMMdd"];
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    
    self.indicatorStartDate = [[self.canonicalFormatter stringFromDate:[[NSDate alloc] initWithTimeIntervalSinceNow:-secondsPerDay*90]] stringByAppendingString:@"000000"];
    
    self.paymentPlanStartDate = [[self.canonicalFormatter stringFromDate:[[NSDate alloc] initWithTimeIntervalSinceNow:-secondsPerDay*90]] stringByAppendingString:@"000000"];
    
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Обновить индикаторы", @"")  style:UIBarButtonItemStyleBordered  target:self	  action:@selector(touchRefreshIndicators:)];
    
    self.navigationItem.rightBarButtonItem = refreshButton;
    self.navigationItem.title = @"Показатели";
    
    if (kDEMOMode)  {
        
        [self.heightImpotanceButton setEnabled:YES];
        [self.mediumLowImpotanceButton setEnabled:YES];
        [self.overBudjetButton setEnabled:YES];
        
        NSString *filepath = [[NSBundle mainBundle] pathForResource: @"getUserTasks"  ofType:@"xml"];
        
        NSMutableData *DocsData = [NSData dataWithContentsOfFile:filepath];
        if (DocsData==nil) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Ошибка получения данных" message:@"Не найден файл с данными для DEMO-режима!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];	
            [alert release];
        }  
        else    {
            self.indicatorsArray = [NSMutableArray array];            
            [self refreshData:DocsData:kQueryModeIndicators];
        }    
        //[DocsData release];
    } 
    else
        [self requestIndicators];    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    //self.toolbar = nil;
    self.loadIndIndicator = nil;
    self.heightImpotanceCountLabel = nil;
    self.mediumLowImpotanceCountLabel = nil;
    self.overBudjetCountLabel = nil;
    self.heightImpotanceButton = nil;
    self.mediumLowImpotanceButton = nil;
    self.overBudjetButton = nil;
    self.paymentPlanButton = nil;
    self.moneyUseReportButton = nil; 
    self.notStatPlanDocCountLabel = nil;
    
    //[self removeObserver:self forKeyPath:@"addIndicators"]; 
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

#pragma mark -
#pragma mark Managing the popover

- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem : (BOOL) itIsOrientationChanging {
    
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    
    if (deviceOrientation==UIDeviceOrientationUnknown)  {
        deviceOrientation=startOrientation;
    }
    
    //NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:2];
    //[buttons addObject:self.navigationItem.backBarButtonItem];
    //[buttons addObject:barButtonItem];
    
    //UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Обновить индикаторы", @"")  style:UIBarButtonItemStyleBordered  target:self	  action:@selector(touchRefreshIndicators:)];
    
    //UIToolbar *tools = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 150, 45)];
    //[tools setItems:buttons animated:NO];
    
    //UIBarButtonItem *rightButtons = [[UIBarButtonItem alloc] initWithCustomView:tools];    
    if (!UIDeviceOrientationIsLandscape(deviceOrientation))  {
        if (self.navigationItem.leftBarButtonItem==nil)
            self.navigationItem.leftBarButtonItem = barButtonItem;
    }
}


- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    
    // Remove the popover button from the toolbar.
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)insertIndicators:(NSArray *)indicators
{
    // this will allow us as an observer to notified (see observeValueForKeyPath)
    // so we can update our UITableView
    //
    [self willChangeValueForKey:@"addIndicators"];
    [self.indicatorsArray addObjectsFromArray:indicators];
    [self.loadIndIndicator stopAnimating];
    [self didChangeValueForKey:@"addIndicators"];
}

// listen for changes to the earthquake list coming from our app delegate.
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if (keyPath==@"addIndicators") {
        
        [self rewriteIndicatorsButtons];
    }  
    
}
// Our NSNotification callback from the running NSOperation to add the earthquakes
//
- (void)addIndicators:(NSNotification *)notif {
    assert([NSThread isMainThread]);
    
    [self addIndicatorsToList:[[notif userInfo] valueForKey:kIndicatorsResultsKey]];
}

// The NSOperation "ParseOperation" calls NSNotification, on the main thread
- (void)addIndicatorsToList:(NSArray *)indicators {
    
    [self insertIndicators:indicators];
}

@end
