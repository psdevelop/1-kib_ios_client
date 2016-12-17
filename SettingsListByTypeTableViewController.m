//
//  SettingsListByTypeTableViewController.m
//  Uni1CCLient
//
//  Created by MacMini on 04.08.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SettingsListByTypeTableViewController.h"
#import "AppDelegate.h"


@implementation SettingsListByTypeTableViewController

@synthesize settingsList, settings, prefDemoSwitch, prefServAdressView, prefServAdressTextField, prefServAdressSaveButton;

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
    [settings release];
    [settingsList release];
    [prefDemoSwitch release];
    [prefServAdressTextField release];
    [prefServAdressSaveButton release];
    [prefServAdressView release];
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
    [self refreshData];
    
}

- (IBAction)switchDemoPut:(id) sender {
    
    if (prefDemoSwitch.on == YES)   { 
        kDEMOMode=YES;
        [self.settings setValue:@"YES" forKey:kDemoModePrefNameKey];
    }
    else    {
        kDEMOMode=NO;
        [self.settings setValue:@"NO" forKey:kDemoModePrefNameKey];        
    }
    
    [self refreshData];
    
}

- (IBAction)serverAdressPut:(id) sender {
    
    [self.settings setValue:self.prefServAdressTextField.text forKey:kServAdrPrefNameKey];
    
    kPHPProxiesBaseAdress = self.prefServAdressTextField.text;
    
    [self refreshData];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Сообщение" message:@"Установлено!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];	
    [alert release];
}

- (void) loadDefaultPrefs {
    [self.settings setValue:@"YES" forKey:kDemoModePrefNameKey];
    
    [self.settings setValue:@"http://192.168.0.1/" forKey:kServAdrPrefNameKey];
    
    kDEMOMode = YES;
    kPHPProxiesBaseAdress = @"http://192.168.0.1/";
    
    [self refreshData];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Сообщение" message:@"Возврат произведен!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];	
    [alert release];
}

-(void) refreshData  {
    self.settingsList = [NSMutableArray array];
    
    self.settings = [NSUserDefaults standardUserDefaults];
    
    Setting *newSetting = [Setting alloc];
            newSetting.settingType = @"STRING";
            if ([self.settings objectForKey:kDemoModePrefNameKey]!=nil) {
                newSetting.settingName = @"Адрес поставщика";
                newSetting.settingStrValue = [self.settings stringForKey:kServAdrPrefNameKey];
                [self.settingsList addObject:newSetting];
            }
            else    {
                newSetting.settingName = @"Адрес поставщика";
                newSetting.settingStrValue = @"http://85.175.100.4:8080/WSS/";               
                [self.settingsList addObject:newSetting]; 
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Предупреждение" message:@"Неудачное извлечение настройки, используется адрес сервера по умолчанию!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];	
                [alert release]; 
                
                @try    {
                    [self.settings setValue:@"http://85.175.100.4:8080/WSS/" forKey:kDemoModePrefNameKey];
                } 
                @catch (NSException * exc) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Исключение" message:@"Попытка установки настройки адреса сервера!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alert show];	
                    [alert release];
                }            
            }
            //[self.settings setValue:@"ddd" forKey:kServAdrPrefNameKey]; 
    
            
            [newSetting release];
    
            newSetting = [Setting alloc];
            newSetting.settingType = @"BOOL";
            if ([self.settings objectForKey:kDemoModePrefNameKey]!=nil) {
                newSetting.settingName = @"Демо-режим";
                newSetting.settingStrValue = [self.settings stringForKey:kDemoModePrefNameKey];              
                if(newSetting.settingStrValue!=nil)                 {
                    if ([newSetting.settingStrValue isEqualToString:@"YES"])    {
                        newSetting.BOOLValue = YES;
                    } else
                        newSetting.BOOLValue = NO;
                }   else    {
                    newSetting.BOOLValue = YES;                }
                [self.settingsList addObject:newSetting];
            }
            else    {
                newSetting.settingName = @"Демо-режим";
                newSetting.settingStrValue = @"YES";              
                newSetting.BOOLValue = YES; 
                [self.settingsList addObject:newSetting]; 
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Предупреждение" message:@"Неудачное извлечение настройки, по умолчанию используется DEMO-режим!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];	
                [alert release];  
                @try    {
                    [self.settings setValue:@"YES" forKey:kDemoModePrefNameKey];
                } 
                @catch (NSException * exc) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Исключение" message:@"Попытка установки настройки демо-режима!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
                    [alert show];	
                    [alert release];
                }                
            }
            
            [newSetting release];    
    
    [self.tableView reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.prefDemoSwitch = nil;
    self.prefServAdressSaveButton = nil;
    self.prefServAdressTextField = nil;
    self.prefServAdressView = nil;    
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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	return @"Основные";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.settingsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SettingCell";
    
    SettingTableCell *cell = (SettingTableCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[SettingTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    Setting *setting = [self.settingsList objectAtIndex:indexPath.row];    
    // Configure the cell...
    cell.settingNameLabel.text = setting.settingName;
    if ([setting.settingType isEqualToString:@"STRING"])        {
        [cell addSubview:prefServAdressView];
        [prefServAdressView setFrame:CGRectMake(302, 5, 352, 35)];
        prefServAdressTextField.text = setting.settingStrValue;    
    }
    
    if ([setting.settingType isEqualToString:@"BOOL"])  {
        [cell addSubview:prefDemoSwitch];
        [prefDemoSwitch setFrame:CGRectMake(553, 7, 94, 27)];
        if (setting.BOOLValue)  
            prefDemoSwitch.on = YES;
        else
            prefDemoSwitch.on = NO;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
