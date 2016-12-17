/*
     File: AppDelegate.h
 Abstract: Application delegate to add the split view controller's view to the window.
 
  Version: 1.1
 
 */

#import <UIKit/UIKit.h>
#import "MainHTTPConnection.h"
#import "StartViewController.h"
#import "AllDocTypesViewController.h"

extern NSString *kCurrentHTTPLogin;
extern NSString *kCurrentHTTPPassword;
extern BOOL kDEMOMode;
extern NSString *kWebServerBaseAdress;
extern NSString *kWebServicesAdressPrefix;
extern NSString *kWebServicesBaseAdress;
extern NSString *kPHPProxiesBaseAdress;
extern NSInteger kDefaultLandscapeWidth;
extern NSInteger kDefaultPortraitWidth;
extern NSString *kPHPProxiesHTTPSBaseAdress;
extern AllDocTypesViewController *allDTDetailViewController;
extern UITableViewController <UISplitViewControllerDelegate> *allDocTypesListController;

//extern UITableViewController<UISplitViewControllerDelegate> *childDocListController;
extern UIViewController <SubstitutableDetailViewController> * childDetailViewController;
extern UINavigationController *childNavController;
extern NSUInteger currentDocTypeIndex;

extern NSString *kStartDate;
extern NSString *kEndDate;

extern NSString *kServAdrPrefNameKey;
extern NSString *kDemoModePrefNameKey;

extern BOOL kNoHasClosedStatus;
extern BOOL kNoHasStatementStatus;
extern UIDeviceOrientation startOrientation;

@class DocTypeListTableViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
	UISplitViewController *splitViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UISplitViewController *splitViewController;

- (void)setupByPreferences;

@end

