//
//  DetailPlantViewController.m
//  HUI
//
//  Created by Joaquin Giraldez on 26/11/15.
//  Copyright © 2015 Giraldez Lopez SL. All rights reserved.
//

#import "DetailPlantViewController.h"
#import "SearchPlantViewController.h"

@interface DetailPlantViewController (){

    IBOutlet UILabel* plantName;
    IBOutlet UILabel* plantSun;
    IBOutlet UILabel* plantWater;
    IBOutlet UILabel* plantTemperature;
    IBOutlet UIImageView* plantImageView;
    IBOutlet UIImageView* sunStatusImageView;
    IBOutlet UIImageView* waterStatusImageView;
    IBOutlet UIImageView* temperatureStatusImageView;
    IBOutlet UIButton* configureHUIButton;
}

@end


@implementation DetailPlantViewController

@synthesize identify = _identify, plantViewModel = _plantViewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customInit];
}

- (void)customInit{
    
    UIImage* deleteImage = [UIImage imageNamed:@"trash.png"];
    CGRect frameimg = CGRectMake(0, 0, deleteImage.size.width - 10, deleteImage.size.height - 13);
    UIButton *deleteButton = [[UIButton alloc] initWithFrame:frameimg];
    [deleteButton setBackgroundImage:deleteImage forState:UIControlStateNormal];
    
    [deleteButton addTarget:self action:@selector(onDeletePlantTouchUpInside:)
         forControlEvents:UIControlEventTouchUpInside];
    
    [deleteButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView: deleteButton];
    self.navigationItem.rightBarButtonItem = rightButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear: animated];
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initPlantContent];
}

#pragma mark - Instantiate method

+ ( DetailPlantViewController* )instantiate
{
    return [[ DetailPlantViewController alloc]  initWithNibName:@"DetailPlantView" bundle:nil];
}

- (IBAction)onSelectPlantTouchUpInside:(id)sender{
    
    UIViewController* plantViewController = [[SearchPlantViewController alloc] initWithNibName:@"SearchPlantView" bundle:nil];
    
    [self.navigationController pushViewController:plantViewController animated:YES];
}

- (IBAction)onDeletePlantTouchUpInside:(id)sender{
    
    [self.delegate deletePlant: [self.plantViewModel getIdentify]];
    
    [[self navigationController] popViewControllerAnimated:YES];

}


#pragma mark - Plant methods

- (void) initPlantContent{

    plantName.text = [self.plantViewModel getName];
    
    [plantImageView setImage:[self.plantViewModel getImage]];

    [sunStatusImageView setImage:[self.plantViewModel getSunImage]];
    [waterStatusImageView setImage:[self.plantViewModel getWaterImage]];
    [temperatureStatusImageView setImage:[self.plantViewModel getTemperatureImage]];
    
    plantSun.text = [self.plantViewModel getSunValue];
    plantWater.text = [self.plantViewModel getWaterValue];
    plantTemperature.text = [self.plantViewModel getTemperatureValue];
    
}

@end
