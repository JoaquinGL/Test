//
//  SettingsViewController.m
//  HUI
//
//  Created by Joaquin Giraldez on 1/3/16.
//  Copyright © 2016 Giraldez Lopez SL. All rights reserved.
//

#import "SettingsViewController.h"
#import "Manager.h"


#define MEASURE_CELSIUS @"[Celsius]"
#define MEASURE_FAHRENHEIT @"[Fahrenheit]"

#define MEASURE_CENTIMETERS @"[centimeters]"
#define MEASURE_INCHES @"[inches]"

@interface SettingsViewController () {
    
    IBOutlet UISegmentedControl* _distanceSegmented;
    IBOutlet UISegmentedControl* _temperatureSegmented;
    IBOutlet UISegmentedControl* _languageSegmented;
    
    StatusViewModel* _statusViewModel;
    
    Manager* _manager;
}

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _statusViewModel = [[StatusViewModel alloc] init];
    _manager = [[Manager alloc] init];
    _statusViewModel = [_manager getStatus];
    
    
    if( [[_statusViewModel getMeasures] isEqualToString: MEASURE_CELSIUS]){
        [_temperatureSegmented setSelectedSegmentIndex:0];
    }else if( [[_statusViewModel getMeasures] isEqualToString: MEASURE_FAHRENHEIT]){
        [_temperatureSegmented setSelectedSegmentIndex:1];
    }
    
    if( [[_statusViewModel getDistances] isEqualToString: MEASURE_CENTIMETERS]){
        [_distanceSegmented setSelectedSegmentIndex:0];
    }else if( [[_statusViewModel getDistances] isEqualToString: MEASURE_INCHES]){
        [_distanceSegmented setSelectedSegmentIndex:1];
    }
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Instantiate method

+ ( SettingsViewController* )instantiate
{
    return [[ SettingsViewController alloc]  initWithNibName:@"SettingsView" bundle:nil];
}


#pragma mark - close actions

- (IBAction) onCloseSettings:(id)sender{
    
    if(_distanceSegmented.selectedSegmentIndex == 0){
        //centimeters
        [_statusViewModel setDistances:MEASURE_CENTIMETERS];
    }else if(_distanceSegmented.selectedSegmentIndex == 1){
        //inches
        [_statusViewModel setDistances:MEASURE_INCHES];
    }
    
    if(_temperatureSegmented.selectedSegmentIndex == 0){
        //celsius
        [_statusViewModel setMeasures:MEASURE_CELSIUS];
    }else if(_temperatureSegmented.selectedSegmentIndex == 1){
        //Fahrenheit
        [_statusViewModel setMeasures:MEASURE_FAHRENHEIT];
    }
    
    [_manager updateStatus: _statusViewModel];
    [Utils fadeOut:self.view completion:nil];
}

@end
