/*
    File: AppDelegate.m
 Abstract: Application delegate to add the split view controller's view to the window.
 
  Version: 1.1
 
 */

#import "AppDelegate.h"
#import "DocTypesRootViewController.h"
#import "SystemMessage.h"
#import "ParseDocsOperation.h"

NSString *kCurrentHTTPLogin = @"";
NSString *kCurrentHTTPPassword = @"";
BOOL kDEMOMode;
NSString *kWebServerBaseAdress = @"http://192.168.0.1/";
NSString *kWebServicesAdressPrefix = @"FinansDemo/ws/";
NSString *kWebServicesBaseAdress = @"http://192.168.0.1/FinansDemo/ws/";

//NSString *kPHPProxiesBaseAdress = @"http://192.168.0.1/WSS/";
NSString *kPHPProxiesBaseAdress;
NSString *kPHPProxiesHTTPSBaseAdress = @"https://192.168.0.1:443/WSS/";
//UIViewController <SubstitutableDetailViewController>
AllDocTypesViewController *allDTDetailViewController;
UITableViewController <UISplitViewControllerDelegate> *allDocTypesListController;

//UITableViewController<UISplitViewControllerDelegate> *childDocListController;
UIViewController <SubstitutableDetailViewController> * childDetailViewController;
UINavigationController *childNavController;
NSUInteger currentDocTypeIndex=1;

NSInteger kDefaultLandscapeWidth = 500;
NSInteger kDefaultPortraitWidth = 800;

NSString *kStartDate=@"20110601000000";
NSString *kEndDate=@"20110901000000";

NSString *kServAdrPrefNameKey=@"server_adress";
NSString *kDemoModePrefNameKey=@"demo_mode";

BOOL kNoHasClosedStatus=false;
BOOL kNoHasStatementStatus=false;
UIDeviceOrientation startOrientation=UIDeviceOrientationUnknown;

@implementation AppDelegate

@synthesize window, splitViewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions { 
    
    [self setupByPreferences];
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    
    NSDateFormatter *canonicalFormatter = [[NSDateFormatter alloc] init];
    [canonicalFormatter setDateFormat:@"YMMdd"];
    
    kStartDate = [[[canonicalFormatter stringFromDate:[[NSDate alloc] initWithTimeIntervalSinceNow:-secondsPerDay*90]] stringByAppendingString:@"000000"] retain];
    
    kEndDate = [[[canonicalFormatter stringFromDate:[NSDate date]] stringByAppendingString:@"235959"] retain];
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    childNavController = [splitViewController.viewControllers objectAtIndex:1];
    
    allDTDetailViewController = [[AllDocTypesViewController alloc] initWithNibName:@"AllDocTypesDetailView" bundle:nil];
    
    [window addSubview:splitViewController.view];
    
    //UINavigationController *master = [splitViewController.viewControllers objectAtIndex:0];
    //UIViewController *detail = [splitViewController.viewControllers objectAtIndex:1];
    
    //master.view.hidden = YES;
    
    //splitViewController.
    //[master.view setFrame:CGRectMake(0, 0, 0, 0)];
    //[detail.view setFrame:CGRectMake(0, 0, 1000, 800)];    
    //detail.view.frame = splitViewController.view.bounds;
    
    //splitViewController.modalPresentationStyle = UIModalPresentationPageSheet; 
    //[splitViewController presentModalViewController:[[splitViewController viewControllers] objectAtIndex:1] animated:YES];  
    
    //[[[splitViewController viewControllers] objectAtIndex:1] dismissModalViewControllerAnimated:YES];
    //or use master and detail lenght    
    //[UIDevice currentDevice] 
    
    //[[splitViewController.viewControllers objectAtIndex:0] setFrame:CGRectMake(0, 0, 0, 1000)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addDocsMessage:) name:kDocsResultMsgNotif object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DocsError:) name:kDocsErrorNotif object:nil]; 
    
    [window makeKeyAndVisible];
    
    //[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	
	return YES;
}

- (void)setupByPreferences
{
    NSString *testValue = [[NSUserDefaults standardUserDefaults] stringForKey:kServAdrPrefNameKey];
    
    //NSLog(@"Ошибка! Тест...");
    
	if ((testValue == nil))
	{
        NSString *servAdrDefault = @"http://85.175.100.4:8080/WSS/";
        NSString *demoModeDefault=@"YES";
        NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys: servAdrDefault, kServAdrPrefNameKey, demoModeDefault, kDemoModePrefNameKey,                                 nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
        [[NSUserDefaults standardUserDefaults] synchronize];    
        
        @try {    
            NSUserDefaults *appSettings = [NSUserDefaults standardUserDefaults];
            [appSettings setValue:@"YES" forKey:kDemoModePrefNameKey];
        
            [appSettings setValue:@"http://85.175.100.4:8080/WSS/" forKey:kServAdrPrefNameKey];
        } 
        @catch (NSException * exc) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Исключение" message:@"Неудачная установка настроек по умолчанию!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];	
            [alert release];
        }   
    
        kPHPProxiesBaseAdress = @"http://85.175.100.4:8080/WSS/";
        kDEMOMode = YES;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Сообщение" message:@"Установлены настройки по умолчанию!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];	
        [alert release];
        
		// no default values have been set, create them here based on what's in our Settings bundle info
		//
		//NSString *pathStr = [[NSBundle mainBundle] bundlePath];
		//NSString *settingsBundlePath = [pathStr stringByAppendingPathComponent:@"Settings.bundle"];
		//NSString *finalPath = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
        
		//NSDictionary *settingsDict = [NSDictionary dictionaryWithContentsOfFile:finalPath];
		//NSArray *prefSpecifierArray = [settingsDict objectForKey:@"PreferenceSpecifiers"];
        
		//NSString *servAdrDefault = @"http://85.175.100.4:8080/WSS/";
		//Boolean demoModeDefault = YES;
        //NSB
		
		/*NSDictionary *prefItem;
         for (prefItem in prefSpecifierArray)
         {
         NSString *keyValueStr = [prefItem objectForKey:@"Key"];
         id defaultValue = [prefItem objectForKey:@"DefaultValue"];
         
         if ([keyValueStr isEqualToString:kServAdrPrefNameKey])
         {
         servAdrDefault = defaultValue;
         }
         else if ([keyValueStr isEqualToString:kDemoModePrefNameKey])
         {
         //demoModeDefault = defaultValue;
         }
         
         }*/
        
		// since no default values have been set (i.e. no preferences file created), create it here		
		//NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
        //                             servAdrDefault, kServAdrPrefNameKey,
        //                             demoModeDefault,
        //                             kDemoModePrefNameKey,
        //                              nil];
        
		//[[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
		//[[NSUserDefaults standardUserDefaults] synchronize];
	}
    else
    {
        NSUserDefaults *appSettings = [NSUserDefaults standardUserDefaults];
        kPHPProxiesBaseAdress = [appSettings stringForKey:kServAdrPrefNameKey];
        NSString *demoPref= [appSettings stringForKey:kDemoModePrefNameKey];              
        if (demoPref!=nil)  {
        if ([demoPref isEqualToString:@"YES"])    {
            kDEMOMode = YES;
        } else
            kDEMOMode = NO; 
        }
        else
            kDEMOMode = YES;
    }
	
	// we're ready to go, so lastly set the key preference values
}
- (void)orientationChanged:(NSNotification *)notification {
    
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    
    if (deviceOrientation!=UIDeviceOrientationUnknown)
        startOrientation = deviceOrientation;
    
    if(UIDeviceOrientationIsLandscape(deviceOrientation)) {
        
    }
    else if (UIDeviceOrientationIsPortrait(deviceOrientation)) {
            
    }
}

- (void)dealloc {
    [splitViewController release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDocsResultMsgNotif object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kDocsErrorNotif object:nil];    
    
    [window release];
    [super dealloc];
}

- (void)showSystemMessage:(SystemMessage *)systemMessage {
    BOOL to_show = !systemMessage.isShowed;
    systemMessage.isShowed = YES;
    if (to_show)  {
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
    }
}

- (void)addDocsMessage:(NSNotification *)notif {
    assert([NSThread isMainThread]);
    //if (parentTableViewController==nil)  {
        [self showSystemMessage:[[notif userInfo] valueForKey:kDocsMsgResultKey]];
    //}
}

- (void)handleError:(NSError *)error {
    NSString *errorMessage = [error localizedDescription];
    UIAlertView *alertView =
    [[UIAlertView alloc] initWithTitle:
     NSLocalizedString(@"Ошибка парсинга XML! Возможно проблемы с соединением!",
                       @"Ошибка разбора ответа сервера! Возможно проблемы с соединением!")
                               message:errorMessage
                              delegate:nil
                     cancelButtonTitle:@"OK"
                     otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

// Our NSNotification callback from the running NSOperation when a parsing error has occurred
//
- (void)DocsError:(NSNotification *)notif {
    assert([NSThread isMainThread]);
    //if (parentTableViewController==nil)  {
        [self handleError:[[notif userInfo] valueForKey:kDocsMsgErrorKey]];    
    //}
}


@end
