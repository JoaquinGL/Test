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
    
    CoreServices* _coreServices;
    
    NSMutableDictionary* _dataFromServer;
    NSMutableDictionary* _moisture;
    NSMutableDictionary* _temperature;
    NSMutableDictionary* _light;
    
    IBOutlet UIView* _moreDetailsView;
    IBOutlet UILabel* _moreDetailsLabel;
    IBOutlet UIImageView* _moreDetailsImageView;
    IBOutlet UILabel* _moreDetailsTitleLabel;
}

@end


@implementation DetailPlantViewController

@synthesize position = _position, plantViewModel = _plantViewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customInit];
}

- (void)customInit{
    
    _coreServices = [[CoreServices alloc] init];
    
    [_coreServices setDelegate: self];
    
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
    
    [_moreDetailsView setAlpha: 0];
    
    UIFont *customFont = [UIFont fontWithName:@"Multicolore" size:14];
    
    [plantName setFont: customFont];
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
    
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_HUD];
    
    _HUD.delegate = self;
    _HUD.labelText = NSLocalizedString(@"Synchronize", nil);
    
    [_HUD show:YES];

    /* The plant must have a HUID */
    if ([self.plantViewModel getHuiId]){
        
        if(!_manager){
            _manager = [[Manager alloc] init];
        }
        if(![[self.plantViewModel getHuiId] isEqualToString:@""]){
            [_coreServices getPlantStateWithHuiName:[[_manager getHuiWithId:[self.plantViewModel getHuiId]] getName]];
        }else{
            [_HUD hide:YES];
        }
    }
}

#pragma mark - Init

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

- (void) cancelConfiguration{
    [Utils fadeOut:_configureViewController.view completion:^(BOOL finisehd){
        
    }];
}

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
            
            
            int sensorFree = [_manager getHuiSensorFree:[huiViewModel getIdentify]];
                              
            if (sensorFree != -1){
                
                [_manager setHUI: huiViewModel
              withPlantViewModel: self.plantViewModel
                      withSensor: sensorFree];
                
                [self.plantViewModel setHuiId:[huiViewModel getIdentify]];
            }else{
                // assing new plant to new sensor, the user has to select the new sensor.
                
                // TODO, do the logic, selec one of the tree selectors.
                
                sensorFree = 2;
                
                [_manager setHUI: huiViewModel
              withPlantViewModel: self.plantViewModel
                      withSensor: sensorFree];
                
                [self.plantViewModel setHuiId:[huiViewModel getIdentify]];
            }
        }
    }
    
    [Utils fadeOut:_configureViewController.view
        completion:^(BOOL completion){
            [_configureViewController.view removeFromSuperview];
            
            [_HUD show:YES];
            
            /* The plant must have a HUID */
            if ([self.plantViewModel getHuiId]){
                
                if(!_manager){
                    _manager = [[Manager alloc] init];
                }
                if(![[self.plantViewModel getHuiId] isEqualToString:@""]){
                    [_coreServices getPlantStateWithHuiName:[[_manager getHuiWithId:[self.plantViewModel getHuiId]] getName]];
                }else{
                    [_HUD hide:YES];
                }
            }
            
        }];
}


#pragma  mark - CoreServicesDelegate

- (void) answerFromServer:(NSDictionary *)response{
    
    _dataFromServer = [[NSMutableDictionary alloc] initWithDictionary:response];
    _moisture = [[NSMutableDictionary alloc] initWithDictionary:[_dataFromServer objectForKey:@"Moisture"]];
    _temperature = [[NSMutableDictionary alloc] initWithDictionary:[_dataFromServer objectForKey:@"Temperature"]];
    _light = [[NSMutableDictionary alloc] initWithDictionary:[_dataFromServer objectForKey:@"Light"]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [_HUD hide:YES];
        
        NSLog(@"PLANT STATUS: ");
        NSLog(@"Moisture ->  %@", [_dataFromServer objectForKey:@"Moisture"]);
        NSLog(@"Temperature ->  %@", [_dataFromServer objectForKey:@"Temperature"]);
        NSLog(@"Light ->  %@", [_dataFromServer objectForKey:@"Light"]);
        
        plantTemperature.text = [_temperature objectForKey:@"Measure"];
        plantSun.text = [_light objectForKey:@"Measure"];
        plantWater.text = [_moisture objectForKey:@"Measure"];
        
        // configure icon segun el alerta
        // cuando se pulsa mostrar todo el contenido desplegando o un popup con toda la info
        // metodo delegado que pone el icono en la home?
        
        [self setIconElements];
        
    });
}

-(void) setIconElements{
    
    int globalStatus = 0;
    
    if([_temperature objectForKey:@"Alert"]){
        [temperatureStatusImageView setImage:[UIImage imageNamed:@"thumb_up.png"]];
    }else{
        globalStatus = 1;
        [temperatureStatusImageView setImage:[UIImage imageNamed:@"thumb_down.png"]];
    }
    
    if([_light objectForKey:@"Alert"]){
        [sunStatusImageView setImage:[UIImage imageNamed:@"thumb_up.png"]];
    }else{
        globalStatus = 1;
        [temperatureStatusImageView setImage:[UIImage imageNamed:@"thumb_down.png"]];
    }
    
    if([_moisture objectForKey:@"Alert"]){
        [waterStatusImageView setImage:[UIImage imageNamed:@"thumb_up.png"]];
    }else{
        globalStatus = 1;
        [temperatureStatusImageView setImage:[UIImage imageNamed:@"thumb_down.png"]];
    }
    
    [self.delegate globalStatus: globalStatus withPlantViewModel:self.plantViewModel];
}


-(IBAction)onTemperatureTouchUpInside:(id)sender{
    
    _moreDetailsLabel.text = [_temperature objectForKey:@"Description"];
    [_moreDetailsLabel sizeToFit];
    _moreDetailsTitleLabel.text = NSLocalizedString(@"Temperature", nil);
    [_moreDetailsImageView setImage:[UIImage imageNamed:@"temperature.png"]];
    [_moreDetailsImageView setFrame: CGRectMake(_moreDetailsImageView.frame.origin.x, _moreDetailsImageView.frame.origin.y, temperatureStatusImageView.frame.size.width, temperatureStatusImageView.frame.size.height)];
    [Utils fadeIn:_moreDetailsView completion:nil];
}

-(IBAction)onLightTouchUpInside:(id)sender{
    
    _moreDetailsLabel.text = [_light objectForKey:@"Description"];
    [_moreDetailsLabel sizeToFit];
    _moreDetailsTitleLabel.text = NSLocalizedString(@"Light", nil);
    [_moreDetailsImageView setImage:[UIImage imageNamed:@"sun.png"]];
    [_moreDetailsImageView setFrame: CGRectMake(_moreDetailsImageView.frame.origin.x, _moreDetailsImageView.frame.origin.y, sunStatusImageView.frame.size.width, sunStatusImageView.frame.size.height)];
    [Utils fadeIn:_moreDetailsView completion:nil];
}

-(IBAction)onMoistureTouchUpInside:(id)sender{
    
    _moreDetailsLabel.text = [_moisture objectForKey:@"Description"];
    [_moreDetailsLabel sizeToFit];
    _moreDetailsTitleLabel.text = NSLocalizedString(@"Moisure", nil);
    [_moreDetailsImageView setImage:[UIImage imageNamed:@"water.png"]];
    [_moreDetailsImageView setFrame: CGRectMake(_moreDetailsImageView.frame.origin.x, _moreDetailsImageView.frame.origin.y, waterStatusImageView.frame.size.width, waterStatusImageView.frame.size.height)];
    [Utils fadeIn:_moreDetailsView completion:nil];
}

-(IBAction)onCloseMoreDetailsButtonTouchUpInside:(id)sender{
    [Utils fadeOut:_moreDetailsView completion:nil];
}


@end
