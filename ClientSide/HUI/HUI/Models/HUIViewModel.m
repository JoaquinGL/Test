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

- (NSString*)getNumber
{
    return [ self.innerState valueForKey: @"number" ];
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
- (NSString*)getNotificationTime
{
    return [ self.innerState valueForKey: @"notification" ];
}

- (NSString*)getSensor1
{
    return [ self.innerState valueForKey: @"sensor1" ];
}

- (NSString*)getSensor2
{
    return [ self.innerState valueForKey: @"sensor2" ];
}

- (NSString*)getSensor3
{
    return [ self.innerState valueForKey: @"sensor3" ];
}

#pragma mark - SETTERS

- (void)setName:(NSString*) name
{
    [ self.innerState setObject:name forKey:@"name"];
}

- (void)setNumber:(NSString *)number
{
    [ self.innerState setObject:number forKey:@"number"];
}

- (void)setWifiName:(NSString *)wifiName
{
    [ self.innerState setObject:wifiName forKey:@"wifiName"];
}

- (void)setWifiKey:(NSString *)wifiKey
{
    [ self.innerState setObject:wifiKey forKey:@"wifiKey"];
}

- (void)setNotificationTime:(NSString *)notificationTime
{
    [ self.innerState setObject:notificationTime forKey:@"notification"];
}

- (void)setHuiId:(NSString *)identify
{
    [ self.innerState setObject:identify forKey:@"id"];
}

- (void)setSensor1:(NSString *)sensor1
{
    [ self.innerState setObject:sensor1 forKey:@"sensor1"];
}

- (void)setSensor2:(NSString *)sensor2
{
    [ self.innerState setObject:sensor2 forKey:@"sensor2"];
}

- (void)setSensor3:(NSString *)sensor3
{
    [ self.innerState setObject:sensor3 forKey:@"sensor3"];
}


+ (HUIViewModel* )getHUIFromObject:(id) object{
    HUIViewModel * returnHUI = [[HUIViewModel alloc] init];
    
    NSDictionary* localState = @{
                                 @"id":[object valueForKey:@"id"]
                                 ,@"name":[object valueForKey:@"name"]
                                 ,@"number":[object valueForKey:@"number"]
                                 ,@"status": [object valueForKey:@"status"]
                                 ,@"wifiName": [object valueForKey:@"wifiName"]
                                 ,@"wifiKey": [object valueForKey:@"wifiKey"]
                                 ,@"notification": [object valueForKey:@"notification"]
                                 ,@"sensor1": [object valueForKey:@"sensor1"] ? [object valueForKey:@"sensor1"] : @""
                                 ,@"sensor2": [object valueForKey:@"sensor2"] ? [object valueForKey:@"sensor2"] : @""
                                 ,@"sensor3": [object valueForKey:@"sensor3"] ? [object valueForKey:@"sensor3"] : @""
                                 };
    
    [returnHUI.innerState setDictionary: localState];
    
    return returnHUI;
}


@end
