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
#import "HUIViewModel.h"
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
    
    MBProgressHUD* _HUD;
    
    CoreServices* _coreServices;
    
    NSMutableDictionary* _dataFromServer;
    NSMutableDictionary* _moisture;
    NSMutableDictionary* _temperature;
    NSMutableDictionary* _light;
    
    IBOutlet UIView* _moreDetailsView;
    IBOutlet UIImageView* _moreDetailsImageView;
    IBOutlet UILabel* _moreDetailsTitleLabel;
    
    IBOutlet UILabel* _sensorLabel;
    IBOutlet UILabel* _huiNameLabel;
    
    IBOutlet UILabel* _growingLabel;
    IBOutlet UISwitch* _growingSwitch;
    
    IBOutlet UITextView* _descriptionTextView;
    
    NSString* _huiNotificationTimeString;
}

@end


@implementation DetailPlantViewController

@synthesize position = _position,
plantViewModel = _plantViewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customInit];
}

- (void)customInit{
    
    [_growingLabel setAlpha: 0.0f];
    [_growingSwitch setAlpha: 0.0f];
    
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
    
    [_moreDetailsView setAlpha: 0];
    
    UIFont *customFont = [UIFont fontWithName:@"Multicolore" size:14];
    
    [plantName setFont: customFont];
    
    [_huiNameLabel setFont: customFont];
    [_sensorLabel setFont: customFont];
    
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
        
        // if HUI is configurate
        if(![[self.plantViewModel getHuiId] isEqualToString:@""]){
            
            HUIViewModel* huiViewModel = [_manager getHuiWithId:[self.plantViewModel getHuiId]];
            StatusViewModel* statusViewModel = [[StatusViewModel alloc] init];
            
            statusViewModel = [_manager getStatus];
            
            [_coreServices getPlantState:self.plantViewModel withHui: huiViewModel withStatus: statusViewModel];
            
            if( [[self.plantViewModel getIdentify] isEqualToString:[huiViewModel getSensor1]]){
                _sensorLabel.text = @"1";
            }else if( [[self.plantViewModel getIdentify] isEqualToString:[huiViewModel getSensor2]]){
                _sensorLabel.text = @"2";
            }else if( [[self.plantViewModel getIdentify] isEqualToString:[huiViewModel getSensor3]]){
                _sensorLabel.text = @"3";
            }
            
            _huiNameLabel.text = [NSString stringWithFormat:@"%@_M%@", [huiViewModel getName], _sensorLabel.text];
            
            _huiNotificationTimeString = [huiViewModel getNotificationTime];
            
        // this case never happend
        }else{
            [_HUD hide:YES];
        }
    }
}

#pragma mark - Init

- (void) initPlantContent{
    
    plantName.text = [self.plantViewModel getName];

    [self setPlantImageFromServer];
    
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
    return [[ DetailPlantViewController alloc]  initWithNibName:[self viewToDevice:@"DetailPlantView"] bundle:nil];
}

#pragma mark - Actions

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

-(void) setPlantImageFromServer {
    CoreServices* coreServices = [[CoreServices alloc] init];
    [plantImageView setImage:[UIImage imageNamed:@"plant.png"]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIImage *image = [coreServices imageFromServer: self.plantViewModel];
        
        if(!image){
            image = [UIImage imageNamed:@"plant.png"];
        }
        [plantImageView setImage:image];
        [_moreDetailsImageView setImage:image];
    });
    
}

- (UIImage *)getPlantImageFromName:(NSString* )imageName{
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",imageName]];
    
    if(!image){
        image = [UIImage imageNamed:@"plant.png"];
    }
    
    return image;
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
    
    if([[_temperature objectForKey:@"Alert"] isEqualToString:@"unknown"]){
        globalStatus = -1;
        [temperatureStatusImageView setImage:[UIImage imageNamed:@"question_mark.png"]];
    }else{
        if(![[_temperature objectForKey:@"Alert"] isEqualToString:@"true"]){
            [temperatureStatusImageView setImage:[UIImage imageNamed:@"thumb_up.png"]];
        }else{
            globalStatus = 1;
            [temperatureStatusImageView setImage:[UIImage imageNamed:@"thumb_down.png"]];
        }
    }
    
    if([[_light objectForKey:@"Alert"] isEqualToString:@"unknown"]){
        globalStatus = -1;
        [sunStatusImageView setImage:[UIImage imageNamed:@"question_mark.png"]];
    }else{
        if(![[_light objectForKey:@"Alert"] isEqualToString:@"true"]){
            [sunStatusImageView setImage:[UIImage imageNamed:@"thumb_up.png"]];
        }else{
            globalStatus = 1;
            [sunStatusImageView setImage:[UIImage imageNamed:@"thumb_down.png"]];
        }
    }
    
    if([[_moisture objectForKey:@"Alert"] isEqualToString:@"unknown"]){
        globalStatus = -1;
        [waterStatusImageView setImage:[UIImage imageNamed:@"question_mark.png"]];
    }else{
        if(![[_moisture objectForKey:@"Alert"] isEqualToString:@"true"]){
            [waterStatusImageView setImage:[UIImage imageNamed:@"thumb_up.png"]];
        }else{
            globalStatus = 1;
            [waterStatusImageView setImage:[UIImage imageNamed:@"thumb_down.png"]];
        }
    }
    
    [self.delegate globalStatus: globalStatus withPlantViewModel:self.plantViewModel];
}


#pragma mark IBACTIONS

- (void) setMoreDetailsViewWithImageName: ( NSString *)imageName
                                   title: ( NSString *)title
                             description: ( NSString *)description {
    
    _moreDetailsTitleLabel.text = title;
    
    if( ![imageName isEqualToString:@"NO"])
        [_moreDetailsImageView setImage:[UIImage imageNamed: imageName]];
    
    [_moreDetailsImageView setFrame:
                CGRectMake(_moreDetailsImageView.frame.origin.x
                           , _moreDetailsImageView.frame.origin.y
                           , temperatureStatusImageView.frame.size.width
                           , temperatureStatusImageView.frame.size.height)];
    
    [Utils fadeIn:_moreDetailsView completion:nil];
    
    [_descriptionTextView setText:@""];
    [_descriptionTextView setText: description];
}

- ( IBAction )onHUITouchUpInside:(id)sender {
    HUIViewModel* huiViewModel = [_manager getHuiWithId:[self.plantViewModel getHuiId]];
    
    [self setMoreDetailsViewWithImageName: @"huiNormal.png"
                                    title: _huiNameLabel.text
                              description: [NSString stringWithFormat:@"%@%@ \n%@%@ \n%@%@"
                                            , NSLocalizedString(@"Number: ", nil)
                                            , [huiViewModel getNumber]
                                            , NSLocalizedString(@"Sensor: ", nil)
                                            , _sensorLabel.text
                                            , NSLocalizedString(@"Notification time: ", nil)
                                            , _huiNotificationTimeString
                                            ]];
}

- ( IBAction )onPlantDescriptionTouchUpInside:(id)sender {
    
    [self setMoreDetailsViewWithImageName: @"NO"
                                    title: [self.plantViewModel getName]
                              description: [self.plantViewModel getDescriptionPlant]];
    
    
    if([[self.plantViewModel getGrowing] isEqualToString: @"germinating"]){
        
        _growingLabel.text = NSLocalizedString(@"Growth phase :", nil);
        [_growingSwitch setOn:NO];
        [_growingLabel setAlpha: 1.0f];
        [_growingSwitch setAlpha: 1.0f];
    }else{
        [_growingLabel setAlpha: 0.0f];
        [_growingSwitch setAlpha: 0.0f];
    }
    
}

- ( IBAction )onTemperatureTouchUpInside:(id)sender {
    
    [self setMoreDetailsViewWithImageName: @"temperature.png"
                                    title: NSLocalizedString(@"Temperature", nil)
                              description: [_temperature objectForKey:@"Description"]];
    
}

- ( IBAction )onLightTouchUpInside:(id)sender {
    
    [self setMoreDetailsViewWithImageName: @"sun.png"
                                    title: NSLocalizedString(@"Light", nil)
                              description: [_light objectForKey:@"Description"]];
}

- ( IBAction )onMoistureTouchUpInside:(id)sender {
    
    [self setMoreDetailsViewWithImageName: @"water.png"
                                    title: NSLocalizedString(@"Moisure", nil)
                              description: [_moisture objectForKey:@"Description"]];
}

- ( IBAction )onCloseMoreDetailsButtonTouchUpInside:(id)sender{
    [Utils fadeOut:_moreDetailsView completion:nil];
}

- (IBAction) onSwitchTouchUpInside:(id)sender{
    
    [Utils fadeOut:_growingSwitch completion:^(BOOL finished){
        _growingLabel.text = NSLocalizedString(@"Congrats,\nyour plant is growing!", nil);
    }];
    
    [self.plantViewModel setGrowing:@"growing"];
    
    //SAVE PLANT IN BBDD
    [_manager setGrowing:@"growing" inPlant:self.plantViewModel];
    
    
    HUIViewModel* huiViewModel = [_manager getHuiWithId:[self.plantViewModel getHuiId]];
    
    if(!_coreServices){
        _coreServices = [[CoreServices alloc] init];
    }
    
    //SEND TO SERVER THE CHANGE
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [_coreServices postChangeStatusPlant:self.plantViewModel withHuiModel:huiViewModel];
    });
    
}

@end
