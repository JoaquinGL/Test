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
                                 };
    
    [returnHUI.innerState setDictionary: localState];
    
    return returnHUI;
}


@end
