//
//  PlantViewController.m
//  HUI
//
//  Created by Joaquin Giraldez on 27/11/15.
//  Copyright © 2015 Giraldez Lopez SL. All rights reserved.
//

#import "PlantViewController.h"

@interface PlantViewController (){

    IBOutlet UIButton* _plantButton;
    IBOutlet UILabel*  _plantNameLabel;
}

@end

@implementation PlantViewController

@synthesize plantName        = plantName,
            plantStatus      = _plantStatus,
            plantSun         = _plantSun,
            plantImage       = _plantImage,
            waterImage       = _waterImage,
            sunImage         = _sunImage,
            temperatureImage = _temperatureImage,
            plantWater       = _plantWater;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _plantNameLabel.text = self.plantName;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Instantiate method

+ ( PlantViewController* )instantiate
{
    return [[ PlantViewController alloc]  initWithNibName:@"PlantView" bundle:nil];
}

#pragma mark - Actions

- (IBAction) onPlantButtonTouchUpInside:(id)sender{
    
    NSDictionary* plantDictionary = @{@"name":self.plantName};
    
    [self.delegate showPlantDetail:plantDictionary ];

}


@end
