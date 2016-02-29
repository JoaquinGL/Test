//
//  StatusViewModel.h
//  HUI
//
//  Created by Joaquin Giraldez on 29/2/16.
//  Copyright © 2016 Giraldez Lopez SL. All rights reserved.
//

#import "BaseViewModel.h"

@interface StatusViewModel : BaseViewModel

@property (nonatomic, assign, getter = getIdentify, setter= setIdentify:) NSString* identify;
@property (nonatomic, assign, getter = getLanguage, setter= setLanguage:) NSString* language;
@property (nonatomic, assign, getter = getMeasures, setter= setMeasures:) NSString* measures;
@property (nonatomic, assign, getter = getDistances, setter= setDistances:) NSString* distances;
@property (nonatomic, assign, getter = getCity, setter= setCity:) NSString* city;
@property (nonatomic, assign, getter = getCountry, setter= setCountry:) NSString* country;
@property (nonatomic, assign, getter = getLongitude, setter= setLongitude:) NSString* longitude;
@property (nonatomic, assign, getter = getLatitude, setter= setLatitude:) NSString* latitude;
@property (nonatomic, assign, getter = getTimeZone, setter= setTimeZone:) NSString* timeZone;
@property (nonatomic, assign, getter = getWaterAlarm, setter= setWaterAlarm:) NSString* waterAlarm;
@property (nonatomic, assign, getter = getKeyGTM, setter= setKeyGTM:) NSString* keyGTM;

+ (StatusViewModel* )getStatusFromObject:(id) object;
@end
