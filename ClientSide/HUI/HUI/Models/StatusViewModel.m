//
//  StatusViewModel.m
//  HUI
//
//  Created by Joaquin Giraldez on 29/2/16.
//  Copyright © 2016 Giraldez Lopez SL. All rights reserved.
//

#import "StatusViewModel.h"

@implementation StatusViewModel
/*
 @property (nonatomic, assign, getter = getLanguage, setter= setLanguage:) NSString* language;
 @property (nonatomic, assign, getter = getMeasures, setter= setMeasures:) NSString* measures;
 @property (nonatomic, assign, getter = getDistances, setter= setDistances:) NSString* distances;
 @property (nonatomic, assign, getter = getCity, setter= setCity:) NSString* city;
 @property (nonatomic, assign, getter = getCountry, setter= setCountry:) NSString* country;
 @property (nonatomic, assign, getter = getLongitude, setter= setLongitude:) NSString* longitude;
 @property (nonatomic, assign, getter = getLatitude, setter= setLatitude:) NSString* latitude;
 @property (nonatomic, assign, getter = getTimeZone, setter= setTimeZone:) NSString* timeZone;
 @property (nonatomic, assign, getter = getWaterAlarm, setter= setWaterAlarm:) NSString* waterAlarm;
 */


- (NSString*)getLanguage
{
    return [ self.innerState valueForKey: @"language" ];
}
- (NSString*)getMeasures
{
    return [ self.innerState valueForKey: @"measures" ];
}
- (NSString*)getCity
{
    return [ self.innerState valueForKey: @"city" ];
}
- (NSString*)getCountry
{
    return [ self.innerState valueForKey: @"country" ];
}
- (NSString*)getLongitude
{
    return [ self.innerState valueForKey: @"longitude" ];
}
- (NSString*)getLatitude
{
    return [ self.innerState valueForKey: @"latitude" ];
}
- (NSString*)getTimeZone
{
    return [ self.innerState valueForKey: @"timeZone" ];
}
- (NSString*)getWaterAlarm
{
    return [ self.innerState valueForKey: @"waterAlarm" ];
}
- (NSString*)getIdentify{
    return [ self.innerState valueForKey: @"id" ];
}
- (NSString*)getKeyGTM{
    return [ self.innerState valueForKey: @"keyGTM" ];
}
- (NSString*)getDistances{
    return [ self.innerState valueForKey: @"distances" ];
}

- (void)setIdentify:(NSString *)identify
{
    [ self.innerState setObject:identify forKey:@"id"];
}
- (void)setLanguage:(NSString *)language
{
    [ self.innerState setObject:language forKey:@"language"];
}
- (void)setMeasures:(NSString *)measures
{
    [ self.innerState setObject:measures forKey:@"measures"];
}
- (void)setDistances:(NSString *)distances
{
    [ self.innerState setObject:distances forKey:@"distances"];
}
- (void)setCity:(NSString *)city
{
    [ self.innerState setObject:city forKey:@"city"];
}
- (void)setCountry:(NSString *)country
{
    [ self.innerState setObject:country forKey:@"country"];
}
- (void)setLongitude:(NSString *)longitude
{
    [ self.innerState setObject:longitude forKey:@"longitude"];
}
-(void)setLatitude:(NSString *)latitude{
    [ self.innerState setObject:latitude forKey:@"latitude"];
}
-(void)setWaterAlarm:(NSString *)waterAlarm{
    [ self.innerState setObject:waterAlarm forKey:@"waterAlarm"];
}
-(void)setTimeZone:(NSString *)timeZone{
    [ self.innerState setObject:timeZone forKey:@"timeZone"];
}
-(void)setKeyGTM:(NSString *)keyGTM {
    [ self.innerState setObject:keyGTM forKey:@"keyGTM"];
}

+ (StatusViewModel* )getStatusFromObject:(id) object{
    StatusViewModel * returnHUI = [[StatusViewModel alloc] init];
    
    NSDictionary* localState = @{
                                 @"id":[object valueForKey:@"id"]
                                 ,@"language":[object valueForKey:@"language"] ? [object valueForKey:@"language"] : @""
                                 ,@"measures":[object valueForKey:@"measures"] ? [object valueForKey:@"measures"] : @""
                                 ,@"distances": [object valueForKey:@"distances"] ? [object valueForKey:@"distances"] : @""
                                 ,@"city": [object valueForKey:@"city"] ? [object valueForKey:@"city"] : @""
                                 ,@"country": [object valueForKey:@"country"] ? [object valueForKey:@"country"] : @""
                                 ,@"longitude": [object valueForKey:@"longitude"] ? [object valueForKey:@"longitude"] : @""
                                 ,@"latitude": [object valueForKey:@"latitude"] ? [object valueForKey:@"latitude"] : @""
                                 ,@"timeZone": [object valueForKey:@"timeZone"] ? [object valueForKey:@"timeZone"] : @""
                                 ,@"waterAlarm": [object valueForKey:@"waterAlarm"] ? [object valueForKey:@"waterAlarm"] : @""
                                 ,@"keyGTM": [object valueForKey:@"keyGTM"] ? [object valueForKey:@"keyGTM"] : @""
                                 };
    
    [returnHUI.innerState setDictionary: localState];
    
    return returnHUI;
}

@end
