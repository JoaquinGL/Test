//
//  PlantViewController.h
//  HUI
//
//  Created by Joaquin Giraldez on 27/11/15.
//  Copyright © 2015 Giraldez Lopez SL. All rights reserved.
//  This view is for the plant view controller in the main view. This view have a button and 3 imageViews to set the indicators of the plant

#import "BaseViewController.h"
#import "PlantViewModel.h"

@protocol PlantViewControllerDelegate <NSObject>

@required

-(void)showPlantDetail:(PlantViewModel*) plantViewModel;

@end

@interface PlantViewController : BaseViewController{

}

@property (nonatomic, assign) id <PlantViewControllerDelegate> delegate;
@property (nonatomic, assign) NSNumber* identify;
@property (nonatomic, assign) NSString* plantName;
@property (nonatomic, assign) NSNumber* plantStatus;
@property (nonatomic, assign) NSNumber* plantSun;
@property (nonatomic, assign) NSNumber* plantWater;
@property (nonatomic) IBOutlet UIImageView* plantImage;
@property (nonatomic, assign) IBOutlet UIImageView* waterImage;
@property (nonatomic, assign) IBOutlet UIImageView* temperatureImage;
@property (nonatomic, assign) IBOutlet UIImageView* sunImage;
@property (nonatomic, assign) IBOutlet UIImageView* status;


+ ( PlantViewController* )instantiate;


- (void)setPlantImageFromName:(NSString* )imageName;
- (void)setStatusUndefined;
- (void)setStatusOk;
- (void)setStatusKo;

@end
