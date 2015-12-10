//
//  HUIViewModel.h
//  HUI
//
//  Created by Joaquin Giraldez on 10/12/15.
//  Copyright © 2015 Giraldez Lopez SL. All rights reserved.
//

#import "BaseViewModel.h"

@interface HUIViewModel : BaseViewModel


@property (nonatomic, assign, getter = getIdentify) NSString* identify;
@property (nonatomic, assign, getter = getStatus) NSNumber* status;
@property (nonatomic, assign, getter = getWifiName) NSString* wifiName;
@property (nonatomic, assign, getter = getWifiKey) NSString* wifiKey;

@end
