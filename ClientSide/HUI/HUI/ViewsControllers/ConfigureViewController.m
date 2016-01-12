//
//  ConfigureViewController.m
//  HUI
//
//  Created by Joaquin Giraldez on 13/12/15.
//  Copyright © 2015 Giraldez Lopez SL. All rights reserved.
//

#import "ConfigureViewController.h"
#import "Manager.h"
#import "HUIViewModel.h"

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
    
    IBOutlet UIButton* _editNameButton;
    IBOutlet UIButton* _editWifiButton;
    IBOutlet UIButton* _editKeyButton;
    IBOutlet UIButton* _editDateButton;
    
    IBOutlet UIImageView* _editNameImageView;
    IBOutlet UIImageView* _editWifiImageView;
    IBOutlet UIImageView* _editKeyImageView;
    IBOutlet UIImageView* _editDateImageView;
    
    IBOutlet UIView* _datePickerView;
    
    IBOutlet UIDatePicker* _datePicker;
    
    IBOutlet UIPickerView* _huiSelectorPickerView;
    
    IBOutletCollection(UIImageView ) NSArray *_editImagesButtons;
    IBOutletCollection(UIButton ) NSArray *_editButtons;
    
    BOOL _isEditing;
    
    HUIViewModel *_huiSelectionViewModel;
    
    NSMutableArray* _huisFromBBDD;
    
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


@synthesize  plantViewModel   = _plantViewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initConfigureView{
    
//    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
//    [self.view addSubview:_HUD];
//    _HUD.delegate = self;
//    _HUD.labelText = NSLocalizedString(@"Loading", nil);
//    [_HUD show:YES];
    
    [configureTextField setAlpha:0.0];
    [configureButton setAlpha:0.0];
    [_datePickerView setAlpha:0.0];
    
    [_huiNameLabel setAlpha:0.0];
    [_wifiNameLabel setAlpha:0.0];
    [_wifiKeyLabel setAlpha:0.0];
    [_dateLabel setAlpha:0.0];
    
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
            
            configureLabel.text = NSLocalizedString(@"Select HUI: ", nil);
        }else{
            //HUI PREVIOUS SELECTED
            _huiSelectionViewModel = self.huiViewModel;
            [self showHuiSelection];
            [_selectionHUIButton setAlpha:0.0];
        }
    }
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
            _wifiNameLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(HUI_WIFI, nil),[_huiSelectionViewModel getWifiName]];
            _wifiKeyLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(HUI_WIFIKEY, nil),[_huiSelectionViewModel getWifiKey]];
            _dateLabel.text = [NSString stringWithFormat:@"%@%@",NSLocalizedString(HUI_DATE, nil),[_huiSelectionViewModel getNotificationTime]];
            
            for (UIImageView* imageView in _editImagesButtons){
                [imageView setAlpha:1.0];
            }
            
            for (UIButton  *button in _editButtons){
                [button setAlpha:1.0];
            }
            
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
    
    [self.delegate closeConfiguration:_huiSelectionViewModel];
}

#pragma mark - Actions

-(IBAction)onCloseButtonTouchUpInside:(id)sender{
    
    // dont save
    
    [self.delegate closeConfiguration:_huiSelectionViewModel];
}

-(void) initTextField{
    if(!_isEditing){
        configureTextField.text = @"";
        [configureTextField becomeFirstResponder];
    }
}

- (IBAction)onNextButtonTouchUpInside:(id)sender{
    step ++;
    
    switch (step) {
        case 1: {
            [_huiSelectionViewModel setName: configureTextField.text];
            _huiNameLabel.text = [NSString stringWithFormat:@"%@%@", NSLocalizedString(HUI_NAME, nil), configureTextField.text];
            [Utils fadeIn:_huiNameLabel completion:^(BOOL finished){
                [self initTextField];
            }];
            configureLabel.text = NSLocalizedString(HUI_WIFI, nil);
            break;
        }
        case 2: {
            [_huiSelectionViewModel setWifiName: configureTextField.text];
            _wifiNameLabel.text = [NSString stringWithFormat:@"%@%@", NSLocalizedString(HUI_WIFI, nil), configureTextField.text];
            [Utils fadeIn:_wifiNameLabel completion:^(BOOL finished){
                [self initTextField];
            }];
            configureLabel.text = NSLocalizedString(HUI_WIFIKEY, nil);
            break;
        }
        case 3: {
            [_huiSelectionViewModel setWifiKey: configureTextField.text];
            _wifiKeyLabel.text = [NSString stringWithFormat:@"%@%@", NSLocalizedString(HUI_WIFIKEY, nil), configureTextField.text];
            [Utils fadeIn:_wifiKeyLabel completion:^(BOOL finished){
                
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
        case 4: {
            [_huiSelectionViewModel setNotificationTime: configureTextField.text];
            for (UIImageView  *imageView in _editImagesButtons){
                [imageView setAlpha:1.0];
            }
            for (UIButton  *button in _editButtons){
                [button setAlpha:1.0];
            }
            
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
    
    // hideTextField
    if(_isEditing){
        configureTextField.text = @"";
        [configureLabel setAlpha:0.0];
        [configureTextField setAlpha:0.0];
        [configureTextField resignFirstResponder];
        [configureButton setAlpha:0.0];
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
        
        [self showHuiSelection];
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
    
    if( sender == _editWifiButton){
        configureLabel.text = NSLocalizedString(HUI_WIFI, nil);
        step = 1;
    }
    
    if( sender == _editKeyButton){
        configureLabel.text = NSLocalizedString(HUI_WIFIKEY, nil);
        step = 2;
    }
    
    if( sender != _editDateButton){
        configureTextField.userInteractionEnabled = YES;
        [configureTextField becomeFirstResponder];
    }else{
        [Utils fadeIn:_datePickerView completion:nil];
        configureTextField.text = @"";
        configureTextField.userInteractionEnabled = NO;
        [self labelTitle:nil];
        configureLabel.text = NSLocalizedString(HUI_DATE, nil);
        step = 3;
    }
}

@end
