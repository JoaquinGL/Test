//
//  PlantViewController.h
//  HUI
//
//  Created by Joaquin Giraldez on 27/11/15.
//  Copyright © 2015 Giraldez Lopez SL. All rights reserved.
//  This view is for the plant view controller in the main view. This view have a button and 3 imageViews to set the indicators of the plant

#import "BaseViewController.h"

@protocol PlantViewControllerDelegate <NSObject>

@required

-(void)showPlantDetail:(NSDictionary*) plantDictionary;

@end

@interface PlantViewController : BaseViewController{

}

@property (nonatomic, assign) id <PlantViewControllerDelegate> delegate;

@property (nonatomic, assign) IBOutlet NSString*  plantName;
@property (nonatomic, assign) NSInteger* plantStatus;
@property (nonatomic, assign) NSInteger* plantSun;
@property (nonatomic, assign) NSInteger* plantWater;
@property (nonatomic, assign) IBOutlet UIImageView* plantImage;
@property (nonatomic, assign) IBOutlet UIImageView* waterImage;
@property (nonatomic, assign) IBOutlet UIImageView* temperatureImage;
@property (nonatomic, assign) IBOutlet UIImageView* sunImage;


+ ( PlantViewController* )instantiate;

@end
