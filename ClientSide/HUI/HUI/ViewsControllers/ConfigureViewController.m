//
//  ConfigureViewController.m
//  HUI
//
//  Created by Joaquin Giraldez on 13/12/15.
//  Copyright © 2015 Giraldez Lopez SL. All rights reserved.
//

//HUIA35 0135

#import "ConfigureViewController.h"
#import "Manager.h"
#import "HUIViewModel.h"
#import "Comunicator.h"
#import "Reachability.h"
#import <NetworkExtension/NetworkExtension.h>


@interface ConfigureViewController ()
{
    IBOutlet UITextField* configureTextField;
    IBOutlet UILabel* configureLabel;
    IBOutlet UIButton* configureButton;
    
    IBOutlet UIButton* _selectionHUIButton;
    
    IBOutlet UILabel* _huiNameLabel;
    IBOutlet UILabel* _huiIdLabel;
    IBOutlet UILabel* _wifiNameLabel;
    IBOutlet UILabel* _wifiKeyLabel;
    IBOutlet UILabel* _dateLabel;
    
    IBOutlet UIButton* _editNameButton;
    IBOutlet UIButton* _editNumberButton;
    IBOutlet UIButton* _editWifiButton;
    IBOutlet UIButton* _editKeyButton;
    IBOutlet UIButton* _editDateButton;
    IBOutlet UIButton* _doneButton;
    
    IBOutlet UIImageView* _editNameImageView;
    IBOutlet UIImageView* _editNumberImageView;
    IBOutlet UIImageView* _editWifiImageView;
    IBOutlet UIImageView* _editKeyImageView;
    IBOutlet UIImageView* _editDateImageView;
    
    IBOutlet UIView* _datePickerView;
    
    IBOutlet UIDatePicker* _datePicker;
    
    IBOutlet UIPickerView* _huiSelectorPickerView;
    
    IBOutletCollection(UIImageView ) NSArray *_editImagesButtons;
    IBOutletCollection(UIButton ) NSArray *_editButtons;
    
    IBOutlet UIView *_parametersView;
    
    IBOutlet UIView *_configurationView;
    
    IBOutlet UIView *_sensorConfigureView;
    IBOutlet UIButton *_sensor1Button;
    IBOutlet UIButton *_sensor2Button;
    IBOutlet UIButton *_sensor3Button;
    IBOutlet UIButton *_continueSensorButton;
    
    BOOL _isEditing;
    
    HUIViewModel *_huiSelectionViewModel;
    
    NSMutableArray* _huisFromBBDD;
    
    Manager *_manager;
    
    int step;
    
    int sensorToSave;
    
    MBProgressHUD* _HUD;
    
    Communicator *_comunicator;
    
    BOOL isConfigurationMode;
    BOOL exitWithNoEditing;
}


@end


#define HUI_CONTINUE @"Next"
#define HUI_DONE @"Done"
#define HUI_CLOSE @"Close"

#define HUI_NAME    @"HUI name: "
#define HUI_ID      @"HUI number: "
#define HUI_WIFI    @"Wifi name: "
#define HUI_WIFIKEY @"Wifi key: "
#define HUI_DATE    @"Notification time: "


@implementation ConfigureViewController


@synthesize  plantViewModel   = _plantViewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initConfigureView{
    
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_HUD];
    _HUD.delegate = self;
    _HUD.labelText = NSLocalizedString(@"Syncronize", nil);

    isConfigurationMode = NO;
    
    [configureTextField setAlpha:0.0];
    [configureButton setAlpha:0.0];
    [_datePickerView setAlpha:0.0];
    
    [_configurationView setAlpha:0.0];
    
    [_huiNameLabel setAlpha:0.0];
    [_huiIdLabel setAlpha:0.0];
    [_wifiNameLabel setAlpha:0.0];
    [_wifiKeyLabel setAlpha:0.0];
    [_dateLabel setAlpha:0.0];
    [_doneButton setAlpha:0.0];
    
    [_parametersView setAlpha:0.0];
    [_sensorConfigureView setAlpha:0.0];
    [_continueSensorButton setAlpha:0.0];
    
    _manager = [[Manager alloc]init];
    
    // return HuiViewModel
    _huisFromBBDD = [_manager getHuisFromBBDD];
    
    _huiSelectionViewModel = [[HUIViewModel alloc] init];
    
    [_huiSelectionViewModel setName:NSLocalizedString(@"New HUI", nil)];
    [_huisFromBBDD addObject:_huiSelectionViewModel];
    
    [_huiSelectorPickerView reloadAllComponents];
    
    for (UIImageView  *imageView in _editImagesButtons){
        [imageView setAlpha:0.0];
    }
    for (UIButton  *button in _editButtons){
        [button setAlpha:0.0];
    }
    
    [configureTextField setDelegate:self];
    
    if( (_huisFromBBDD.count == 1) && (!self.huiViewModel)){
        _isEditing = NO;
        [_selectionHUIButton setAlpha: 0.0];
        [self showConfigureNewHUI];
    }else{
        
        if(!self.huiViewModel)
        {
            [_huiSelectorPickerView setAlpha:1.0f];
            [_selectionHUIButton setAlpha:1.0f];
            [configureLabel setAlpha:1.0];
            _huiSelectionViewModel = _huisFromBBDD[0];
            configureLabel.text = NSLocalizedString(@"Select HUI: ", nil);
        }else{
            //HUI PREVIOUS SELECTED
            _huiSelectionViewModel = self.huiViewModel;
            [self showHuiSelection];
            [_selectionHUIButton setAlpha:0.0];
        }
    }
    
    sensorToSave = 2;
    
    [_sensor1Button setSelected: NO];
    [_sensor2Button setSelected: NO];
    [_sensor3Button setSelected: NO];
    [_sensor1Button setHighlighted: NO];
    [_sensor2Button setHighlighted: NO];
    [_sensor3Button setHighlighted: NO];
}

- (void) showConfigureNewHUI{
    
    _isEditing = NO;
    configureLabel.text = NSLocalizedString(HUI_NAME, nil);
    [configureButton setTitle:HUI_CONTINUE forState:UIControlStateNormal];
    step = 0;
    
    [configureTextField setAlpha:1.0];
    [configureButton setAlpha:1.0];
    
    [Utils fadeIn:configureTextField completion:nil];
    [Utils fadeIn:configureLabel completion:nil];
    [Utils fadeIn:configureButton completion:nil];
    
    configureTextField.userInteractionEnabled = YES;
    [configureTextField becomeFirstResponder];
    
    [_huiSelectorPickerView setAlpha: 0.0];
    
    _datePicker.datePickerMode=UIDatePickerModeTime;
    [_datePicker addTarget:self action:@selector(labelTitle:) forControlEvents:UIControlEventValueChanged];
}

- (void) showHuiSelection{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [Utils fadeOut:_huiSelectorPickerView completion:^(BOOL finished){
            _huiNameLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(HUI_NAME, nil),[_huiSelectionViewModel getName] ];
            _huiIdLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(HUI_ID, nil),[_huiSelectionViewModel getNumber] ];
            _wifiNameLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(HUI_WIFI, nil),[_huiSelectionViewModel getWifiName]];
            _wifiKeyLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(HUI_WIFIKEY, nil),[_huiSelectionViewModel getWifiKey]];
            _dateLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(HUI_DATE, nil),[_huiSelectionViewModel getNotificationTime]];
            
            for (UIImageView* imageView in _editImagesButtons){
                [imageView setAlpha:1.0];
            }
            
            for (UIButton  *button in _editButtons){
                [button setAlpha:1.0];
            }
            
            [Utils fadeIn:_parametersView completion:nil];
            
            [Utils fadeIn:_huiNameLabel completion:nil];
            [Utils fadeIn:_huiIdLabel completion:nil];
            [Utils fadeIn:_wifiNameLabel completion:nil];
            [Utils fadeIn:_wifiKeyLabel completion:nil];
            [Utils fadeIn:_dateLabel completion:nil];
            
            [Utils fadeIn:_doneButton completion:nil];
            [Utils fadeIn:_configurationView completion:nil];
            
            [configureLabel setAlpha:0.0];
            
        }];
    });
}

- (void) labelTitle:(id)sender
{
    NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
    dateFormat.dateStyle=NSDateFormatterMediumStyle;
    [dateFormat setDateFormat:@"hh:mm a"];
    NSString *str=[NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:_datePicker.date]];
    //assign text to label
    configureTextField.text = str;
}

#pragma mark - Instantiate method

+ ( ConfigureViewController* )instantiate
{
    return [[ ConfigureViewController alloc]  initWithNibName:[self viewToDevice:@"ConfigureView"] bundle:nil];
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

#pragma mark - Save Data

-(void)saveHuiData{
    
    [self.delegate closeConfiguration:_huiSelectionViewModel withSensor: sensorToSave];
}

#pragma mark - Delegate Actions

-(IBAction)onCloseButtonTouchUpInside:(id)sender{
    
    [_huiSelectorPickerView reloadAllComponents];
    [_huiSelectorPickerView selectRow:0 inComponent:0 animated:YES];
    [self.delegate closeConfiguration:_huiSelectionViewModel withSensor:sensorToSave];
}

-(IBAction)onCancelButtonTouchUpInside:(id)sender{
    
    [_huiSelectorPickerView reloadAllComponents];
    [_huiSelectorPickerView selectRow:0 inComponent:0 animated:YES];
    
    [configureTextField resignFirstResponder];
    [self.delegate cancelConfiguration];
}



-(void) initTextField{
    if(!_isEditing){
        configureTextField.text = @"";
        [configureTextField becomeFirstResponder];
    }
}

- (IBAction)onNextButtonTouchUpInside:(id)sender{
    
    if(![configureTextField.text isEqualToString:@""]){
        step ++;
        [Utils fadeIn:_configurationView completion:nil];
        switch (step) {
            case 1: {
                [_huiSelectionViewModel setName: configureTextField.text];
                _huiNameLabel.text = [NSString stringWithFormat:@"%@%@", NSLocalizedString(HUI_NAME, nil), [configureTextField.text uppercaseString]];
                [Utils fadeIn:_huiNameLabel completion:^(BOOL finished){
                    [self initTextField];
                }];
                configureLabel.text = NSLocalizedString(HUI_ID, nil);
                
                break;
            }
            case 2:{
                
                [_huiSelectionViewModel setNumber: configureTextField.text];
                _huiIdLabel.text = [NSString stringWithFormat:@"%@%@", NSLocalizedString(HUI_ID, nil), [configureTextField.text uppercaseString]];
                
                [Utils fadeIn:_huiIdLabel completion:^(BOOL finished){
                    
                    if(!_isEditing){
                        [Utils fadeIn:_datePickerView completion:nil];
                        configureTextField.text = @"";
                        configureTextField.userInteractionEnabled = NO;
                        [self labelTitle:nil];
                        
                    }
                }];
                configureLabel.text = NSLocalizedString(HUI_DATE, nil);
                [configureButton setTitle:HUI_DONE forState:UIControlStateNormal];
                
                break;
            }
            case 3: {
                [_huiSelectionViewModel setNotificationTime: configureTextField.text];
                
                // provisional
                [_huiSelectionViewModel setWifiKey:@"undefined"];
                [_huiSelectionViewModel setWifiName:@"undefined"];
                
                for (UIImageView  *imageView in _editImagesButtons){
                    [imageView setAlpha:1.0];
                }
                for (UIButton  *button in _editButtons){
                    [button setAlpha:1.0];
                }
                
                [Utils fadeIn:_parametersView completion:nil];
                
                _dateLabel.text = [NSString stringWithFormat:@"%@%@", NSLocalizedString(HUI_DATE, nil), configureTextField.text];
                [Utils fadeIn:_dateLabel completion:^(BOOL finished){
                    configureTextField.text = @"";
                    [Utils fadeOut:configureTextField completion:nil];
                    [Utils fadeOut:configureLabel completion:nil];
                    [Utils fadeOut:_datePickerView completion:nil];
                    [Utils fadeIn:_doneButton completion:nil];
                    [configureTextField resignFirstResponder];
                    
                }];
                [configureButton setAlpha:0];
                break;
                
            }
            default:
                [self saveHuiData];
                break;
        }
        
        // hideTextField
        if(_isEditing){
            configureTextField.text = @"";
            [configureLabel setAlpha:0.0];
            [configureTextField setAlpha:0.0];
            [configureTextField resignFirstResponder];
            [configureButton setAlpha:0.0];
        }
    }
}


#pragma mark -
#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return _huisFromBBDD.count;
}


- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title = [_huisFromBBDD[row] getName];
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    return attString;
    
}

#pragma mark -
#pragma mark PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    NSLog(@"Selection: %@", _huisFromBBDD[row]);
    
    _huiSelectionViewModel = _huisFromBBDD[row];

}


-(IBAction)onSelectorTouchUpInside:(id)sender{
    if([[_huiSelectionViewModel getName] isEqualToString:@"New HUI"]){
        [self showConfigureNewHUI];
    }else{
        // set configureHUI dictionary
        if( ![[_huiSelectionViewModel getSensor1] isEqualToString:@""]){
            [_sensor1Button setHighlighted:YES];
        }
        
        if( ![[_huiSelectionViewModel getSensor2] isEqualToString:@""]){
            [_sensor2Button setHighlighted:YES];
        }
        
        if( ![[_huiSelectionViewModel getSensor3] isEqualToString:@""]){
            [_sensor3Button setHighlighted:YES];
        }

        [Utils fadeIn:_sensorConfigureView completion:nil];
    }
    
    [_selectionHUIButton setAlpha:0.0];
}

#pragma mark - Edit Button Action

-(IBAction)onEditTouchUpInside:(id)sender{
    
    _isEditing = YES;
    
    [configureButton setAlpha:1.0f];
    [configureButton setTitle:HUI_DONE forState:UIControlStateNormal];
    
    [configureTextField setAlpha:1.0f];
    [configureLabel setAlpha:1.0f];
    
    if( sender == _editNameButton){
      configureLabel.text = NSLocalizedString(HUI_NAME, nil);
        step = 0;
    }
    
    if( sender == _editNumberButton){
        configureLabel.text = NSLocalizedString(HUI_ID, nil);
        step = 1;
    }
    
//    if( sender == _editWifiButton){
//        configureLabel.text = NSLocalizedString(HUI_WIFI, nil);
//        step = 2;
//    }
//    
//    if( sender == _editKeyButton){
//        configureLabel.text = NSLocalizedString(HUI_WIFIKEY, nil);
//        step = 3;
//    }
    
    if( sender != _editDateButton){
        configureTextField.userInteractionEnabled = YES;
        [configureTextField becomeFirstResponder];
    }else{
        [Utils fadeIn:_datePickerView completion:nil];
        configureTextField.text = @"";
        configureTextField.userInteractionEnabled = NO;
        [self labelTitle:nil];
        configureLabel.text = NSLocalizedString(HUI_DATE, nil);
        step = 2;
    }
}

#pragma mark - Configure http HUI

-(IBAction) onSetParametersTouchUpInside:(id)sender{
    
    NSString *alertmessage = [NSString stringWithFormat:NSLocalizedString(@"To setup the HUI, you have to choose HUI wifi. The key is: %@%@. It has been already copy, so only paste the code in the wifi key", nil), [_huiSelectionViewModel getName], [_huiSelectionViewModel getNumber]];
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:NSLocalizedString(@"Attention", nil)
                                  message:alertmessage
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:NSLocalizedString(@"Go to settings", nil)
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    [alert dismissViewControllerAnimated:YES completion:nil];
                                    
                                    //configurationMode
                                    isConfigurationMode = YES;
                                    
                                    [_HUD show:YES];
                                    
                                    // Paste the Wifi key
                                    [UIPasteboard generalPasteboard].string = [NSString stringWithFormat:@"%@%@", [_huiSelectionViewModel getName], [_huiSelectionViewModel getNumber]];
                                    
                                    // Registering as observer from one object
                                    [[NSNotificationCenter defaultCenter] addObserver:self
                                                                             selector:@selector(onbackToBackground)
                                                                                 name:@"notification_back_from_background"
                                                                               object:nil];
                                    
                                    if (UIApplicationOpenSettingsURLString != NULL) {
                                        NSURL *appSettings = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                                        [[UIApplication sharedApplication] openURL:appSettings];
                                    }
                                }];
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"Cancel", nil)
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                   [self testWifiConnection];
                                   
                               }];
    
    [alert addAction:noButton];
    [alert addAction:yesButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark back from Background

-(void) onbackToBackground{
    
    // Remove Observer back_from_background
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: @"notification_back_from_background"
                                                  object: nil];
    
    if ( isConfigurationMode ){
        isConfigurationMode = NO;
        
        Reachability *reachability = [Reachability reachabilityForInternetConnection];
        [reachability startNotifier];
        
        NetworkStatus status = [reachability currentReachabilityStatus];
        
        if(status == NotReachable)
        {
            //No internet
        }
        else if (status == ReachableViaWiFi)
        {
            
            [self performSelector:@selector(closeSocket) withObject:self afterDelay:10.0];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                //WiFi
                _comunicator = [[Communicator alloc] init];
                _comunicator->host = @"192.168.5.1";
                //_comunicator->host = @"http://apple.com";
                _comunicator->port = 80;
                
                [_comunicator setup];
                [_comunicator open];
                
                
                NSString *haystack = _wifiNameLabel.text;
                NSString *haystackPrefix = @"Wifi name: ";
                NSRange needleRange = NSMakeRange(haystackPrefix.length,
                                                  haystack.length - haystackPrefix.length);
                NSString *needle = [haystack substringWithRange:needleRange];
                NSLog(@"needle: %@", needle);
                
                
                NSString* wifiName = needle;
                
                
                haystack = _wifiKeyLabel.text;
                haystackPrefix = @"Wifi key: ";
                needleRange = NSMakeRange(haystackPrefix.length,
                                                  haystack.length - haystackPrefix.length);
                needle = [haystack substringWithRange:needleRange];
                NSLog(@"needle: %@", needle);
                
                
                NSString* wifiKey = needle;
                
                
                //"HUI:**red**\n**clave**\n"
                NSString *messageToSetupHUI = [NSString stringWithFormat:@"HUI:%@\n%@\n", wifiName, wifiKey];
                
                
                
                NSLog(@"HUI MESSAGE CONFIGURATION: %@", messageToSetupHUI);
                
                [_comunicator writeOut:messageToSetupHUI];
                
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(closeSocket) object:nil];
                
                [_comunicator close];
                
                //[_HUD hide:YES];
            });
            
            
        }
        else if (status == ReachableViaWWAN)
        {
            //3G
        }
    }
}

-(void) closeSocket{
    [_comunicator close];
    [_HUD hide:YES];
    
    NSLog(@"TIME OUT");
}


-(void) testWifiConnection{

    NSArray * networkInterfaces = [NEHotspotHelper supportedNetworkInterfaces];
    NSLog(@"Networks %@",networkInterfaces);
}


#pragma mark - SENSOR METHODS

- (IBAction) onContinueSensorTouchUpInside:(id)sender{
    
    [Utils fadeOut:_sensorConfigureView completion:^(BOOL finished){
        [self showHuiSelection];
    } ];
}


- (IBAction)onSensorTouchUpInside:(id)sender{
    
    NSString* sensor1Selected = [_huiSelectionViewModel getSensor1];
    NSString* sensor2Selected = [_huiSelectionViewModel getSensor2];
    NSString* sensor3Selected = [_huiSelectionViewModel getSensor3];
    
    [Utils fadeIn:_continueSensorButton completion:nil];
    
    if (sender == _sensor1Button){
        [_sensor1Button setSelected: YES];
        [_sensor2Button setSelected: NO];
        [_sensor3Button setSelected: NO];
        sensorToSave = 1;
        if (! [sensor1Selected isEqualToString:@""]){
            //show Alert, sensor already taken
            [self showSensorAlert: sensorToSave];
        }
        
    } else if (sender == _sensor2Button){
        [_sensor2Button setSelected: YES];
        [_sensor1Button setSelected: NO];
        [_sensor3Button setSelected: NO];
        sensorToSave = 2;
        if (! [sensor2Selected isEqualToString:@""]){
            //show Alert, sensor already taken
            [self showSensorAlert: sensorToSave];
        }
        
    } else if (sender == _sensor3Button){
        [_sensor3Button setSelected: YES];
        [_sensor1Button setSelected: NO];
        [_sensor2Button setSelected: NO];
        sensorToSave = 3;
        if (! [sensor3Selected isEqualToString:@""]){
            //show Alert, sensor already taken
            [self showSensorAlert: sensorToSave];
        }
    }
}

- (void) showSensorAlert:(int)sensor{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:NSLocalizedString(@"Attention", nil)
                                  message:NSLocalizedString(@"The selected sensor has one plant assign, ¿Do you want to remove the previous plant? this action can't undo", nil)
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:NSLocalizedString(@"Yes, remove the plant", nil)
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    [alert dismissViewControllerAnimated:YES completion:nil];
                                    
                                    switch (sensor) {
                                        case 1:
                                            [self.delegate removePlantInSensor:[_huiSelectionViewModel getSensor1]];
                                            break;
                                        case 2:
                                            [self.delegate removePlantInSensor:[_huiSelectionViewModel getSensor2]];
                                            break;
                                        case 3:
                                            [self.delegate removePlantInSensor:[_huiSelectionViewModel getSensor3]];
                                            break;
                                            
                                        default:
                                            break;
                                    }
                                    
                                
                                }];
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"No, I select other sensor", nil)
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                   [_sensor1Button setSelected:NO];
                                   [_sensor2Button setSelected:NO];
                                   [_sensor3Button setSelected:NO];
                                   
                                   if( ![[_huiSelectionViewModel getSensor1] isEqualToString:@""]){
                                       [_sensor1Button setHighlighted:YES];
                                   }
                                   
                                   if( ![[_huiSelectionViewModel getSensor2] isEqualToString:@""]){
                                       [_sensor2Button setHighlighted:YES];
                                   }
                                   
                                   if( ![[_huiSelectionViewModel getSensor3] isEqualToString:@""]){
                                       [_sensor3Button setHighlighted:YES];
                                   }
                                   
                                   [Utils fadeOut:_continueSensorButton completion:nil];
                               }];
    
    [alert addAction:noButton];
    [alert addAction:yesButton];
    
    [self presentViewController:alert animated:YES completion:nil];

}


@end
