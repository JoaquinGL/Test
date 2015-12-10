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
    return [ self.innerState valueForKey: @"identify" ];
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


@end
