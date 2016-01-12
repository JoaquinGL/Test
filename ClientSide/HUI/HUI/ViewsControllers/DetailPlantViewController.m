//
//  DetailPlantViewController.m
//  HUI
//
//  Created by Joaquin Giraldez on 26/11/15.
//  Copyright © 2015 Giraldez Lopez SL. All rights reserved.
//


/*
 
 TODO: set HUIViewModel and save in BBDD with plantID, in this view,
 we have to set the HUIviewModel with WifiName, HUIName, HUI GUID and WIFI key.
 
 Tomorrow: To do
 
 save the status in BBDD and get everything. 
 
 configure HUI settings in this viewm asking everything. Maybe a view with a similar form. 
 
 */

#import "DetailPlantViewController.h"
#import "SearchPlantViewController.h"
#import "Manager.h"

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
    Manager* _manager;
    ConfigureViewController* _configureViewController;
    
    MBProgressHUD* _HUD;
}

@end


@implementation DetailPlantViewController

@synthesize position = _position, plantViewModel = _plantViewModel;

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
    
    _configureViewController = [[ConfigureViewController alloc] initWithNibName:@"ConfigureView" bundle:nil];
    
    [_configureViewController setDelegate:self];
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
    

    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:NSLocalizedString(@"Warning", nil)
                                  message:NSLocalizedString(@"Are you sure you want to delete this plant?", nil)
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:NSLocalizedString(@"Yes", nil)
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    [alert dismissViewControllerAnimated:YES completion:nil];
                                    //Handel your yes please button action here
                                    [self.delegate deletePlant: self.position withId:[self.plantViewModel getIdentify]];
                                    [[self navigationController] popViewControllerAnimated:YES];
                                    
                                }];
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"No", nil)
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                   
                               }];
    
    [alert addAction:noButton];
    [alert addAction:yesButton];
    
    [self presentViewController:alert animated:YES completion:nil];

}

#pragma mark - Plant methods

- (UIImage *)getPlantImageFromName:(NSString* )imageName{
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",imageName]];
    
    if(!image){
        image = [UIImage imageNamed:@"plant.png"];
    }
    
    return image;
}

- (void) initPlantContent{

    plantName.text = [self.plantViewModel getName];
    
    [plantImageView setImage:[self getPlantImageFromName:[self.plantViewModel getName]]];

    [sunStatusImageView setImage:[self.plantViewModel getSunImage]];
    [waterStatusImageView setImage:[self.plantViewModel getWaterImage]];
    [temperatureStatusImageView setImage:[self.plantViewModel getTemperatureImage]];
    
    plantSun.text = [self.plantViewModel getSunValue];
    plantWater.text = [self.plantViewModel getWaterValue];
    plantTemperature.text = [self.plantViewModel getTemperatureValue];
    
}

-(IBAction)onConfigureTouchUpInside:(id)sender{
    
    [_configureViewController.view setAlpha: 0.0];
    [self.navigationController.view addSubview:_configureViewController.view];
    _configureViewController.plantViewModel = self.plantViewModel;
    
    if(!_manager){
        _manager = [[Manager alloc] init];
    }
    
    if(![[self.plantViewModel getHuiId] isEqualToString:@""])
    {
        _configureViewController.huiViewModel = [_manager getHuiWithId:[self.plantViewModel getHuiId]];
    }else{
        _configureViewController.huiViewModel = nil;
    }
    
    [_configureViewController initConfigureView];
    
    [Utils fadeIn:_configureViewController.view completion:nil];
    
}

#pragma mark - delegate methods

-(void)closeConfiguration:(HUIViewModel*)huiViewModel{
    
    if(huiViewModel){
        if([huiViewModel getIdentify]){
            /* UPDATE DATA */
            [_manager updateHui:huiViewModel withPlantViewModel:self.plantViewModel];
            [self.plantViewModel setHuiId:[huiViewModel getIdentify]];
        }else{
            /* Save HUI DATA */
            if(!_manager){
                _manager = [[Manager alloc] init];
            }
            
            [_manager setHUI:huiViewModel withPlantViewModel:self.plantViewModel];
            
            [self.plantViewModel setHuiId:[huiViewModel getIdentify]];
        }
    }
    
    [Utils fadeOut:_configureViewController.view
        completion:^(BOOL completion){
            [_configureViewController.view removeFromSuperview];
        }];
}


@end
