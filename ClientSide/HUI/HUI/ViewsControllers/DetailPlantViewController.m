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
    IBOutlet UIImageView* statusSun;
    IBOutlet UIImageView* statusWater;
    IBOutlet UIImageView* statusTemperature;
    IBOutlet UIButton* configureHUIButton;
}

@end


@implementation DetailPlantViewController

@synthesize identify = _identify, plant = _plant;

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
    
    [self.delegate deletePlant: self.identify];
    
    [[self navigationController] popViewControllerAnimated:YES];

}


#pragma mark - Plant methods

- (void) initPlantContent{

    plantName.text = [self.plant objectForKey:@"name"];
    
    [plantImageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@.png",[self.plant objectForKey:@"name"]]]];
    
    if ([[self.plant objectForKey:@"status_sun"] intValue] == 1){
        [statusSun setImage:[UIImage imageNamed:@"thumb_up.png"]];
    }else if ([[self.plant objectForKey:@"status_sun"] intValue] == 0){
        [statusSun setImage:[UIImage imageNamed:@"thumb_down.png"]];
    }
    
    if ([[self.plant objectForKey:@"status_water"] intValue] == 1){
        [statusWater setImage:[UIImage imageNamed:@"thumb_up.png"]];
    }else if ([[self.plant objectForKey:@"status_water"] intValue] == 0){
        [statusWater setImage:[UIImage imageNamed:@"thumb_down.png"]];
    }
    
    if ([[self.plant objectForKey:@"status_temperature"] intValue] == 1){
        [statusTemperature setImage:[UIImage imageNamed:@"thumb_up.png"]];
    }else if ([[self.plant objectForKey:@"status_temperature"] intValue] == 0){
        [statusTemperature setImage:[UIImage imageNamed:@"thumb_down.png"]];
    }
    
    plantSun.text = [self.plant objectForKey:@"sun"];
    plantWater.text = [self.plant objectForKey:@"water"];
    plantTemperature.text = [self.plant objectForKey:@"temperature"];
    
}

/*
    OBJECT PLANT
 
    plant = {
        id: number,
        name: string,
        sun: string,
        water: string,
        temperature: string,
        status_sun: number,
        status_water: number,
        status_temperature: number,
        HUI_identity: string
    }
 */




@end
