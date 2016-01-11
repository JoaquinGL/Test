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
    
    IBOutlet UIButton* _selectionHUIButton;
    
    IBOutlet UILabel* _huiNameLabel;
    IBOutlet UILabel* _wifiNameLabel;
    IBOutlet UILabel* _wifiKeyLabel;
    IBOutlet UILabel* _dateLabel;
    
    IBOutlet UIView* _datePickerView;
    
    IBOutlet UIDatePicker* _datePicker;
    
    IBOutlet UIPickerView* _huiSelectorPickerView;
    
    NSMutableDictionary *_huiSelection;
    
    NSArray* _huisFromBBDD;
    
    Manager *_manager;
    
    int step;
}


@end


#define HUI_CONTINUE @"Next"
#define HUI_DONE @"Done"
#define HUI_CLOSE @"Close"

#define HUI_NAME    @"HUI name: "
#define HUI_WIFI    @"Wifi name: "
#define HUI_WIFIKEY @"Wifi key: "
#define HUI_DATE    @"Notification time: "


@implementation ConfigureViewController


- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initConfigureView{
    
    [configureTextField setAlpha:0.0];
    [configureButton setAlpha:0.0];
    [_datePickerView setAlpha:0.0];
    
    [_huiNameLabel setAlpha:0.0];
    [_wifiNameLabel setAlpha:0.0];
    [_wifiKeyLabel setAlpha:0.0];
    [_dateLabel setAlpha:0.0];
    
    _huisFromBBDD = @[@"HUIA", @"HUIB", @"New HUI"];
    
    _huiSelection = [[NSMutableDictionary alloc] initWithDictionary:@{
                                                                      @"name": @"HUIA",
                                                                      @"wifi": @"ITCROM",
                                                                      @"wifikey": @"1234",
                                                                      @"date": @"12:00 AM"
                                                                      }];
    
    [configureLabel setAlpha:1.0];
    
    configureLabel.text = NSLocalizedString(@"Select HUI: ", nil);
    
    [_huiSelectorPickerView setAlpha:1.0f];
    [_selectionHUIButton setAlpha:1.0f];
    
    if( _huisFromBBDD.count == 0){
        [self showConfigureNewHUI];
    }
}

- (void) showConfigureNewHUI{
    
    dispatch_async(dispatch_get_main_queue(), ^{
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
        
        [configureTextField setDelegate:self];
    });
    
}

- (void) showHuiSelection{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [Utils fadeOut:_huiSelectorPickerView completion:^(BOOL finished){
            _huiNameLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(HUI_NAME, nil),[_huiSelection objectForKey:@"name"] ];
            _wifiNameLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(HUI_WIFI, nil),[_huiSelection objectForKey:@"wifi"]];
            _wifiKeyLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(HUI_WIFIKEY, nil),[_huiSelection objectForKey:@"wifikey"]];
            _dateLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(HUI_DATE, nil),[_huiSelection objectForKey:@"date"]];
            
            [Utils fadeIn:_huiNameLabel completion:nil];
            [Utils fadeIn:_wifiNameLabel completion:nil];
            [Utils fadeIn:_wifiKeyLabel completion:nil];
            [Utils fadeIn:_dateLabel completion:nil];
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

#pragma mark - Save Data

-(void)saveHuiData{
    
    [self.delegate closeConfiguration:nil];
}

#pragma mark - Actions

-(IBAction)onCloseButtonTouchUpInside:(id)sender{
    
    // dont save
    [self.delegate closeConfiguration:nil];
}

- (IBAction)onNextButtonTouchUpInside:(id)sender{
    step ++;
    
    switch (step) {
        case 1: {
            _huiNameLabel.text = [NSString stringWithFormat:@"%@%@", NSLocalizedString(HUI_NAME, nil), configureTextField.text];
            [Utils fadeIn:_huiNameLabel completion:^(BOOL finished){
                configureTextField.text = @"";
                [configureTextField becomeFirstResponder];
            }];
            configureLabel.text = NSLocalizedString(@"Wifi Name: ", nil);
            break;
        }
        case 2: {
            _wifiNameLabel.text = [NSString stringWithFormat:@"%@%@", NSLocalizedString(HUI_WIFI, nil), configureTextField.text];
            [Utils fadeIn:_wifiNameLabel completion:^(BOOL finished){
                configureTextField.text = @"";
                [configureTextField becomeFirstResponder];
            }];
            configureLabel.text = NSLocalizedString(@"Wifi Key: ", nil);
            break;
        }
        case 3: {
            _wifiKeyLabel.text = [NSString stringWithFormat:@"%@%@", NSLocalizedString(HUI_WIFIKEY, nil), configureTextField.text];
            [Utils fadeIn:_wifiKeyLabel completion:^(BOOL finished){
                [Utils fadeIn:_datePickerView completion:nil];
                configureTextField.text = @"";
                configureTextField.userInteractionEnabled = NO;
                [self labelTitle:nil];
            }];
            configureLabel.text = NSLocalizedString(@"Notification Date: ", nil);
            [configureButton setTitle:HUI_DONE forState:UIControlStateNormal];
            
            break;
        }
        case 4: {
            _dateLabel.text = [NSString stringWithFormat:@"%@%@", NSLocalizedString(HUI_DATE, nil), configureTextField.text];
            [Utils fadeIn:_dateLabel completion:^(BOOL finished){
                configureTextField.text = @"";
                [Utils fadeOut:configureTextField completion:nil];
                [Utils fadeOut:configureLabel completion:nil];
                [Utils fadeOut:_datePickerView completion:nil];
                [configureTextField resignFirstResponder];
            }];
            [configureButton setAlpha:0];
            break;
        }
        default:
            [self saveHuiData];
            break;
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
    NSString *title = _huisFromBBDD[row];
    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    return attString;
    
}

#pragma mark -
#pragma mark PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{
    NSLog(@"Selection: %@", _huisFromBBDD[row]);
    [_huiSelection setObject:_huisFromBBDD[row] forKey:@"name"];
}


-(IBAction)onSelectorTouchUpInside:(id)sender{
    if([[_huiSelection objectForKey:@"name"] isEqualToString:@"New HUI"]){
        [self showConfigureNewHUI];
    }else{
        // set configureHUI dictionary
        
        [self showHuiSelection];
    }
    
    [_selectionHUIButton setAlpha:0.0];
}

@end
