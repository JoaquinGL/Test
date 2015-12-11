//
//  PlantViewModel.m
//  HUI
//
//  Created by Joaquin Giraldez on 9/12/15.
//  Copyright © 2015 Giraldez Lopez SL. All rights reserved.
//
#import "PlantViewModel.h"


@implementation PlantViewModel

+ (PlantViewModel* )initEmptyPlantWithName:(NSString* )name andPosition:(NSNumber* )position{
    PlantViewModel * emptyPlant = [[PlantViewModel alloc] init];
    
    NSDictionary* localState = @{
                              @"id":[[NSUUID UUID] UUIDString]
                              ,@"name":name
                              ,@"position": position
                              ,@"image": [UIImage imageNamed:@"plant.png"]
                              ,@"sunValue": @"undefined"
                              ,@"waterValue": @"undefined"
                              ,@"temperatureValue": @"undefined"
                              ,@"sunStatus": [NSNumber numberWithInt:0]
                              ,@"waterStatus": [NSNumber numberWithInt:1]
                              ,@"temperatureStatus": [NSNumber numberWithInt:0]
                              };
    
    [emptyPlant.innerState setDictionary: localState];
    
    return emptyPlant;
}

-(void)setPosition:(NSNumber *)position{
    [self.innerState setObject: position forKey:@"position"];
}

- (NSNumber*)getStatus
{
    return [ self.innerState valueForKey: @"status" ];
}

- (NSNumber*)getPosition
{
    return [ self.innerState valueForKey: @"position" ];
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
    return [ self.innerState valueForKey: @"id" ];
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
