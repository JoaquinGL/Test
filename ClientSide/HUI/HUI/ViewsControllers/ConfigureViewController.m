//
//  ConfigureViewController.m
//  HUI
//
//  Created by Joaquin Giraldez on 13/12/15.
//  Copyright © 2015 Giraldez Lopez SL. All rights reserved.
//

#import "ConfigureViewController.h"
#import "Manager.h"

@interface ConfigureViewController ()
{
    IBOutlet UITextField* configureTextField;
    IBOutlet UILabel* configureLabel;
    IBOutlet UIButton* configureButton;
    
    IBOutlet UILabel* _huiNameLabel;
    IBOutlet UILabel* _wifiNameLabel;
    IBOutlet UILabel* _wifiKeyLabel;
    
    Manager *_manager;
    
    int step;
}


@end

#define HUI_NAME @"Hui Name: "
#define HUI_WIFI @"Wifi Name: "
#define HUI_KEY @"Wifi Key: "
#define HUI_CONTINUE @"Next"
#define HUI_DONE @"Done"
#define HUI_CLOSE @"Close"


@implementation ConfigureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initConfigureView{
    
    configureLabel.text = HUI_NAME;
    [configureButton setTitle:HUI_CONTINUE forState:UIControlStateNormal];
    step = 0;
    
    [configureTextField setAlpha:1.0];
    [configureLabel setAlpha:1.0];
    
    [_huiNameLabel setAlpha:0.0];
    [_wifiNameLabel setAlpha:0.0];
    [_wifiKeyLabel setAlpha:0.0];
}


#pragma mark - Instantiate method

+ ( ConfigureViewController* )instantiate
{
    return [[ ConfigureViewController alloc]  initWithNibName:@"ConfigureView" bundle:nil];
}

#pragma mark -
#pragma mark UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == configureTextField)
    {
        [configureTextField resignFirstResponder];
        [self onNextButtonTouchUpInside:nil];
    }
    return YES;
}

#pragma mark - Actions

-(IBAction)onCloseButtonTouchUpInside:(id)sender{
   [self.delegate closeConfiguration];
}

- (IBAction)onNextButtonTouchUpInside:(id)sender{
    step ++;
    
    switch (step) {
        case 1: {
            _huiNameLabel.text = [NSString stringWithFormat:@"Name: %@", configureTextField.text];
            [Utils fadeIn:_huiNameLabel completion:^(BOOL finished){
                configureTextField.text = @"";
            }];
            configureLabel.text = HUI_WIFI;
            break;
        }
        case 2: {
            _wifiNameLabel.text = [NSString stringWithFormat:@"Wifi name: %@", configureTextField.text];
            [Utils fadeIn:_wifiNameLabel completion:^(BOOL finished){
                configureTextField.text = @"";
            }];
            configureLabel.text = HUI_KEY;
            [configureButton setTitle:HUI_DONE forState:UIControlStateNormal];
            break;
        }
        case 3: {
            _wifiKeyLabel.text = [NSString stringWithFormat:@"Wifi Key: %@", configureTextField.text];
            [Utils fadeIn:_wifiKeyLabel completion:^(BOOL finished){
                configureTextField.text = @"";
                [Utils fadeOut:configureTextField completion:nil];
                [Utils fadeOut:configureLabel completion:nil];
                [configureTextField resignFirstResponder];
            }];
            [configureButton setTitle:HUI_CLOSE forState:UIControlStateNormal];
            
            break;
        }
        default:
            [self.delegate closeConfiguration];
            break;
    }
}


@end
