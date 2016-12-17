/*
  Version: 1.1
 */

#import <UIKit/UIKit.h>
#import "SubstitutableDetailViewController.h"
#import "DocTypeListTableViewController.h"

@interface AllDocTypesViewController : UIViewController <SubstitutableDetailViewController, UIPopoverControllerDelegate, UIActionSheetDelegate, UISplitViewControllerDelegate, UIPickerViewDelegate> {

    UIToolbar *toolbar;    
    UIBarButtonItem *rootPopoverButtonItem;
    UIView *filterView;
    UIPopoverController *popoverController;
    UIDatePicker *startDatePicker;
    NSInteger currentDateField;
    UITextField *startDateTextField;
    UITextField *endDateTextField;
    UIButton *onlyNonStatButton;
    UIButton *notShowClosedButton;
    NSDateFormatter *formatter;
    NSDateFormatter *canonicalFormatter;
    NSString *currentFilter;
    UISegmentedControl *docTypeSelectSegmControl;
    UIButton *hidePickerButton;
    UIView *datePickerView;
}

@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) UIBarButtonItem *rootPopoverButtonItem;
@property (nonatomic, retain) IBOutlet UIButton *hidePickerButton;
@property (nonatomic, retain) IBOutlet UIView *datePickerView;
@property (nonatomic, retain) UIView *filterView;
@property (nonatomic, retain) UIPopoverController *popoverController;
@property (nonatomic, retain) IBOutlet UIDatePicker *startDatePicker;
@property (nonatomic, retain) IBOutlet UITextField *startDateTextField;
@property (nonatomic, retain) IBOutlet UITextField *endDateTextField;
@property (nonatomic, retain) IBOutlet UIButton *onlyNonStatButton;
@property (nonatomic, retain) IBOutlet UIButton *notShowClosedButton;
@property (nonatomic, retain) NSDateFormatter *formatter;
@property (nonatomic, retain) NSDateFormatter *canonicalFormatter;
@property (nonatomic, retain) NSString *currentFilter;
@property (nonatomic, retain) IBOutlet UISegmentedControl *docTypeSelectSegmControl;

- (IBAction) filterItemTapped: (id) sender;
- (IBAction) startFilterDateTouch: (id) sender;
- (void)createDatePicker;
- (IBAction) endFilterDateTouch:(id) sender;
- (void) showDateSetActionSheet;
- (IBAction) datePickerTouch:(id) sender;
- (IBAction) touchOnlyStat:(id) sender;
- (IBAction) touchNotShowPaymed:(id) sender;
- (void) setCurrentParams;
- (IBAction) touchDocTypeSelect:(id) sender;
- (IBAction) byFilterSelect:(id) sender;
- (IBAction) exitFromDateSet:(id) sender;

@end
