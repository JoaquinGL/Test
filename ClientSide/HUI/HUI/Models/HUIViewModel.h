//
//  HUIViewModel.h
//  HUI
//
//  Created by Joaquin Giraldez on 10/12/15.
//  Copyright © 2015 Giraldez Lopez SL. All rights reserved.
//

#import "BaseViewModel.h"

@interface HUIViewModel : BaseViewModel


@property (nonatomic, assign, getter = getIdentify, setter= setHuiId:) NSString* identify;
@property (nonatomic, assign, getter = getName, setter = setName:) NSString* name;
@property (nonatomic, assign, getter = getStatus) NSNumber* status;
@property (nonatomic, assign, getter = getWifiName, setter = setWifiName:) NSString* wifiName;
@property (nonatomic, assign, getter = getWifiKey, setter = setWifiKey:) NSString* wifiKey;
@property (nonatomic, assign, getter = getNotificationTime, setter=setNotificationTime:) NSString* notificationTime;

+ (HUIViewModel* )getHUIFromObject:(id) object;

@end
