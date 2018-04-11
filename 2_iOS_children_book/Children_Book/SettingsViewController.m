//
//  SettingsViewController.m
//  Children_Book
//
//  Created by Samantha Cannillo on 4/10/18.
//  Copyright © 2018 Samantha Cannillo. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Print to see all user defaults
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] dictionaryRepresentation]);
    
    [self.mySwitch addTarget:self
                      action:@selector(stateChanged:) forControlEvents:UIControlEventValueChanged];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSUserDefaults *defaults= [NSUserDefaults standardUserDefaults];
    
    // Check to see if there already exists a preference in UserDefaults
    if([[[defaults dictionaryRepresentation] allKeys] containsObject:@"SwitchPreference"]){
                
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"SwitchPreference"]) {
            self.settingLabel.text = @"Auto Read is On";
            [self.mySwitch setOn:YES animated:NO];
        } else {
            self.settingLabel.text = @"Auto Read is Off";
            [self.mySwitch setOn:NO animated:NO];
        }
        
    // If no preference is already set, set the default to 'False'
    } else {
        [defaults setBool:NO forKey:@"SwitchPreference"];
        self.settingLabel.text = @"Auto Read is Off";
        [self.mySwitch setOn:NO animated:NO];
    }
}

// Changes the label on-screen to represent user 'Read' preferences
- (void)stateChanged:(UISwitch *)switchState
{
    if ([switchState isOn]) {
        self.settingLabel.text = @"Auto Read is On";
    } else {
        self.settingLabel.text = @"Auto Read is Off";
    }
}

// Update switch image. Stores 'Read' preferences to UserDefaults
- (IBAction)tapSwitch:(UISwitch *)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"Switch Value:%d", sender.isOn);
    if ([self.mySwitch isOn]) {
        [self.mySwitch setOn:NO animated:YES];
    } else {
        [self.mySwitch setOn:YES animated:YES];
    }
    
    [defaults setBool:sender.isOn forKey:@"SwitchPreference"];
    [defaults synchronize];
}
@end
