//
//  Manager.h
//  HUI
//
//  Created by Joaquin Giraldez on 10/12/15.
//  Copyright © 2015 Giraldez Lopez SL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PlantViewModel.h"
#import "HUIViewModel.h"
#import "StatusViewModel.h"
#import <CoreData/CoreData.h>


@interface Manager : NSObject


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

//-------------------------------------------------------------------------------------- Plants Methods
- (NSMutableArray* ) getPlantsFromBBDD;
- (void) setPlant:(PlantViewModel* )plantViewModel;
- (void) removePlant:(PlantViewModel* )plantViewModel;
- (void) removePlantWithId:(NSString *) plantId;
- (void) removePlantInHUISensor: (PlantViewModel* )plantViewModel;

- (void) setStatusPlant:(NSString *)status
                inPlant:(PlantViewModel*) plantViewModel;
//-------------------------------------------------------------------------------------- HUI Methods
- (NSMutableArray* ) getHuisFromBBDD;
- (HUIViewModel*) getHuiWithName:(NSString* )huiName;
- (HUIViewModel*) getHuiWithId:(NSString* )huiId;
- (int) getHuiSensorFree:(NSString* )huiId;

- (void)    setHUI: ( HUIViewModel* )huiViewModel
withPlantViewModel: ( PlantViewModel* )plantViewModel
        withSensor: ( int )sensor;

- (void) updateHui:(HUIViewModel* )huiViewModel
withPlantViewModel:(PlantViewModel *)plantViewModel
          inSensor:(int)sensor;
//-------------------------------------------------------------------------------------- Status Methods
- (void) setInitialStatus;
- (void) updateStatusWithRegistrationToken:(NSString* )registrationToken;
- (void) updateStatus:(StatusViewModel* )statusViewModel;
- (StatusViewModel*) getStatus;

@end
