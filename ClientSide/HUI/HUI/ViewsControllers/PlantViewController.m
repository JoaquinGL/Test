//
//  PlantViewController.m
//  HUI
//
//  Created by Joaquin Giraldez on 27/11/15.
//  Copyright © 2015 Giraldez Lopez SL. All rights reserved.
//

#import "PlantViewController.h"
#import "CoreServices.h"

@interface PlantViewController (){

    IBOutlet UIButton* _plantButton;
    IBOutlet UILabel*  _plantNameLabel;
}

@end

@implementation PlantViewController

@synthesize identify         = _identify,
            plantName        = _plantName,
            plantStatus      = _plantStatus,
            plantSun         = _plantSun,
            plantImage       = _plantImage,
            waterImage       = _waterImage,
            sunImage         = _sunImage,
            temperatureImage = _temperatureImage,
            status           = _status,
            position         = _position,
            plantViewModel   = _plantViewModel,
            plantWater       = _plantWater;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _plantNameLabel.text = self.plantName;
    
    UIFont *customFont = [UIFont fontWithName:@"Multicolore" size:14];
    
    [_plantNameLabel setFont: customFont];
    
    [self.plantImage setImage:[UIImage imageNamed:@"plant.png"]];
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
    [self setPlantImageFromServer];
    [self.delegate showPlantDetail:self.plantViewModel];
}


#pragma mark - Set up Images

-(void) setPlantImageFromServer {
    CoreServices* coreServices = [[CoreServices alloc] init];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIImage *image = [coreServices imageFromServer: self.plantViewModel];
        
        if(!image){
            image = [UIImage imageNamed:@"plant.png"];
        }
        
        [self.plantImage setImage:image];
    });

}

- (void)setPlantImageFromName:(NSString* )imageName{
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",imageName]];
    
    if(!image){
        image = [UIImage imageNamed:@"plant.png"];
    }
    
    [self.plantImage setImage: image];
}

- (void)setStatusUndefined{
     UIImage *image = [UIImage imageNamed:@"question_mark.png"];
    [self.status setImage: image];
}

- (void)setStatusOk{
     UIImage *image  = [UIImage imageNamed:@"thumb_up.png"];
        [self.status setImage: image];
}

- (void)setStatusKo{
    UIImage *image = [UIImage imageNamed:@"thumb_down.png"];
        [self.status setImage: image];
}


@end
