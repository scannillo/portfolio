//
//  SettingsViewController.h
//  Children_Book
//
//  Created by Samantha Cannillo on 4/10/18.
//  Copyright © 2018 Samantha Cannillo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UISwitch *mySwitch;
- (IBAction)tapSwitch:(UISwitch *)sender;
@property (strong, nonatomic) IBOutlet UILabel *settingLabel;

@end
