//
//  PlantViewModel.h
//  HUI
//
//  Created by Joaquin Giraldez on 9/12/15.
//  Copyright © 2015 Giraldez Lopez SL. All rights reserved.
//

#import "BaseViewModel.h"

@interface PlantViewModel : BaseViewModel

@property ( nonatomic, retain, getter = getStatus ) NSNumber* status;
@property ( nonatomic, retain, getter = getPosition, setter=setPosition:) NSNumber* position;
@property ( nonatomic, retain, getter = getSunStatus ) NSNumber* sunStatus;
@property ( nonatomic, retain, getter = getWaterStatus ) NSNumber* waterStatus;
@property ( nonatomic, retain, getter = getTemperatureStatus ) NSNumber* temperatureStatus;

@property ( nonatomic, retain, getter = getName ) NSString* name;

@property (nonatomic, assign, getter = getIdentify) NSString* identify;
@property (nonatomic, assign, getter = getSunValue) NSString* sunValue;
@property (nonatomic, assign, getter = getWaterValue) NSString* waterValue;
@property (nonatomic, assign, getter = getTemperatureValue) NSString* temperatureValue;
@property (nonatomic, assign, getter = getHuiId, setter = setHuiId:) NSString* huiId;

@property ( nonatomic, retain, getter = getImage ) UIImage* image;
@property (nonatomic, assign, getter = getWaterImage) IBOutlet UIImage* waterImage;
@property (nonatomic, assign, getter = getTemperatureImage) IBOutlet UIImage* temperatureImage;
@property (nonatomic, assign, getter = getSunImage) IBOutlet UIImage* sunImage;

+ (PlantViewModel* )initEmptyPlantWithName:(NSString* )name andPosition:(NSNumber* )position;
+ (PlantViewModel* )getPlantFromObject:(id) object;

@end
