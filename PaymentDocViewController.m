//
//  PaymentDocViewController.m
//  MultipleDetailViews
//
//  Created by MacMini on 14.07.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PaymentDocViewController.h"


@implementation PaymentDocViewController

@synthesize paymentDoc, scenaryTextField, nomGroupTextField, currencyRateTextField, seasonTextField, addTaxSummTextField, addTaxValueTextField, payTargetTextField, payTargetManageTextField;

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
    
    [scenaryTextField release];
    [nomGroupTextField release];
    
    [currencyRateTextField release];
    [seasonTextField release];
    [addTaxSummTextField release];
    [addTaxValueTextField release];
    [payTargetManageTextField release];
    [payTargetTextField release];
    [paymentDoc release];
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

    
    self.scenaryTextField.text = paymentDoc.scenary_name;
    
    self.nomGroupTextField.text = paymentDoc.nomenclature_group_name;
    
    
    self.seasonTextField.text = paymentDoc.scenary_name; 
    
    self.addTaxSummTextField.text = paymentDoc.add_tax_summ;
    self.payTargetTextField.text = paymentDoc.pay_target;  
    self.payTargetManageTextField.text = paymentDoc.pay_target_manage;    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    
    self.scenaryTextField = nil;
    
    self.nomGroupTextField = nil;
    
    
    self.currencyRateTextField = nil;
    
    self.seasonTextField = nil;
    self.addTaxSummTextField = nil;
    self.addTaxValueTextField = nil;
    self.payTargetManageTextField = nil;
    self.payTargetTextField = nil;    
}

#pragma mark -
#pragma mark Managing the popover

- (void)showRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem: (BOOL) itIsOrientationChanging {
    
    // Add the popover button to the toolbar.
    //NSMutableArray *itemsArray = [toolbar.items mutableCopy];
    //[itemsArray insertObject:barButtonItem atIndex:0];
    //[toolbar setItems:itemsArray animated:NO];
    //[itemsArray release];
}


- (void)invalidateRootPopoverButtonItem:(UIBarButtonItem *)barButtonItem {
    
    // Remove the popover button from the toolbar.
    //NSMutableArray *itemsArray = [toolbar.items mutableCopy];
    //[itemsArray removeObject:barButtonItem];
    //[toolbar setItems:itemsArray animated:NO];
    //[itemsArray release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

@end
