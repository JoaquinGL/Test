//
//  PlantViewModel.m
//  HUI
//
//  Created by Joaquin Giraldez on 9/12/15.
//  Copyright © 2015 Giraldez Lopez SL. All rights reserved.
//
#import "PlantViewModel.h"


@implementation PlantViewModel


- (NSNumber*)getStatus
{
    return [ self.innerState valueForKey: @"status" ];
}

- (NSNumber* )getSunStatus{
    return [ self.innerState valueForKey: @"sunStatus" ];
}

- (NSNumber* )getWaterStatus{
    return [ self.innerState valueForKey: @"waterStatus" ];
}

- (NSNumber* )getTemperatureStatus{
    return [ self.innerState valueForKey: @"temperatureStatus" ];
}

- (NSNumber*) getIdentify{
    return [ self.innerState valueForKey: @"identify" ];
}

- (NSString* )getSunValue{
    return [ self.innerState valueForKey: @"sunValue" ];
}

- (NSString* )getWaterValue{
    return [ self.innerState valueForKey: @"waterValue" ];
}

- (NSString* )getTemperatureValue{
    return [ self.innerState valueForKey: @"temperatureValue" ];
}

- (NSString*)getName
{
    return [ self.innerState valueForKey: @"name" ];
}

- (UIImage*)getImage
{
    return [ self.innerState valueForKey: @"image" ];
}

/* POSIBLE TO REMOVE */

- (UIImage* )getWaterImage{
    UIImage* returnValue;
    
    if([[self getWaterStatus] intValue] == 0){
        returnValue = [UIImage imageNamed:@"thumb_up.png"];
    }else if([[self getWaterStatus] intValue] == 1){
        returnValue = [UIImage imageNamed:@"thumb_down.png"];
    }
    
    return returnValue;
}

- (UIImage* )getSunImage{
    UIImage* returnValue;
    
    if([[self getSunStatus] intValue] == 0){
        returnValue = [UIImage imageNamed:@"thumb_up.png"];
    }else if([[self getSunStatus] intValue] == 1){
        returnValue = [UIImage imageNamed:@"thumb_down.png"];
    }
    
    return returnValue;
}

- (UIImage* )getTemperatureImage{

    UIImage* returnValue;
    
    if([[self getTemperatureStatus] intValue] == 0){
        returnValue = [UIImage imageNamed:@"thumb_up.png"];
    }else if([[self getTemperatureStatus] intValue] == 1){
        returnValue = [UIImage imageNamed:@"thumb_down.png"];
    }
    
    return returnValue;
    
}


@end
