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
#import <CoreData/CoreData.h>


@interface Manager : NSObject


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)setPlant:(PlantViewModel* )plantViewModel;
- (void) setHUI:(HUIViewModel* )huiViewModel withPlantViewModel:(PlantViewModel* )plantViewModel;
- (void)removePlant:(PlantViewModel* )plantViewModel;
- (NSMutableArray* )getPlantsFromBBDD;
- (NSMutableArray* )getHuisFromBBDD;
- (HUIViewModel*) getHuiWithName:(NSString* )huiName;
- (HUIViewModel*) getHuiWithId:(NSString* )huiId;
- (void) updateHui:(HUIViewModel* )huiViewModel withPlantViewModel:(PlantViewModel *)plantViewModel;

@end
