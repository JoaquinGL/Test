//
//  HUIViewModel.m
//  HUI
//
//  Created by Joaquin Giraldez on 10/12/15.
//  Copyright © 2015 Giraldez Lopez SL. All rights reserved.
//

#import "HUIViewModel.h"

@implementation HUIViewModel


- (NSString*)getIdentify
{
    return [ self.innerState valueForKey: @"id" ];
}

- (NSString*)getName
{
    return [ self.innerState valueForKey: @"name" ];
}

- (NSNumber*)getStatus
{
    return [ self.innerState valueForKey: @"status" ];
}

- (NSString*)getWifiName
{
    return [ self.innerState valueForKey: @"wifiName" ];
}

- (NSString*)getWifiKey
{
    return [ self.innerState valueForKey: @"wifiKey" ];
}

+ (HUIViewModel* )getHUIFromObject:(id) object{
    HUIViewModel * returnHUI = [[HUIViewModel alloc] init];
    
    NSDictionary* localState = @{
                                 @"id":[object valueForKey:@"id"]
                                 ,@"name":[object valueForKey:@"name"]
                                 ,@"position": [object valueForKey:@"position"]
                                 //,@"image": [object valueForKey:@"image"]
                                 ,@"sunValue": [object valueForKey:@"sunValue"]
                                 ,@"waterValue": [object valueForKey:@"waterValue"]
                                 ,@"temperatureValue": [object valueForKey:@"temperatureValue"]
                                 ,@"sunStatus": [object valueForKey:@"sunStatus"]
                                 ,@"waterStatus": [object valueForKey:@"waterStatus"]
                                 ,@"temperatureStatus": [object valueForKey:@"temperatureStatus"]
                                 ,@"hui":[object valueForKey:@"hui"]
                                 };
    
    [returnHUI.innerState setDictionary: localState];
    
    return returnHUI;
}


@end
