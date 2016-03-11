//
//  Manager.m
//  HUI
//
//  Created by Joaquin Giraldez on 10/12/15.
//  Copyright © 2015 Giraldez Lopez SL. All rights reserved.
//

#import "Manager.h"


@implementation Manager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "homeDevelop.HUI" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"HUI" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"HUI.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}


#pragma mark HUI MANAGER

- (void)    setHUI: ( HUIViewModel* )huiViewModel
withPlantViewModel: ( PlantViewModel* )plantViewModel
        withSensor: ( int )sensor {
    
    NSManagedObjectContext *context = [self managedObjectContext];
    NSString* huiId = [[NSUUID UUID] UUIDString];
    
    [huiViewModel setHuiId: huiId];
    
    /* HUI object */
    NSManagedObject *huiInfo = [NSEntityDescription
                                insertNewObjectForEntityForName:@"HUI"
                                inManagedObjectContext:context];
    [huiInfo setValue:huiId forKey:@"id"];
    [huiInfo setValue:[huiViewModel getName] forKey:@"name"];
    [huiInfo setValue:[huiViewModel getNumber] forKey:@"number"];
    [huiInfo setValue:[NSNumber numberWithInt:-1] forKey:@"status"];
    [huiInfo setValue:[huiViewModel getWifiKey] forKey:@"wifiKey"];
    [huiInfo setValue:[huiViewModel getWifiName] forKey:@"wifiName"];
    [huiInfo setValue:[huiViewModel getNotificationTime] forKey:@"notification"];
    
    switch (sensor) {
        case 1:
            [huiInfo setValue:[plantViewModel getIdentify] forKey:@"sensor1"];
            break;
        case 2:
            [huiInfo setValue:[plantViewModel getIdentify] forKey:@"sensor2"];
            break;
        case 3:
            [huiInfo setValue:[plantViewModel getIdentify] forKey:@"sensor3"];
            break;
    }
    
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Plant" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *info in fetchedObjects) {
        NSLog(@"id: %@", [info valueForKey:@"id"]);
        NSLog(@"Name: %@", [info valueForKey:@"name"]);
    }
    
    /* UPDATE PLANT WITH HUIID */
    if ( plantViewModel ){
        [self setHuiId:huiId inPlantViewModel:plantViewModel];
    }
}

-(void) setHuiId:(NSString* )huiId inPlantViewModel:(PlantViewModel* )plantViewModel
{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Plant" inManagedObjectContext:context]];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"id == %@", [plantViewModel getIdentify]]];
    
    NSError *error = nil;
    NSArray* results = [context executeFetchRequest:fetchRequest error:&error];
    
    if ([context save:&error] == NO) {
        NSAssert(NO, @"Save should not fail\n%@", [error localizedDescription]);
        abort();
    }else if (!error && results.count > 0) {
        for(NSManagedObject *managedObject in results){
            
            [managedObject setValue:huiId forKey:@"huiId"];
        }
        
        //Save context to write to store
        [context save:nil];
    }
}


- (void) updateHui:(HUIViewModel* )huiViewModel withPlantViewModel:(PlantViewModel *)plantViewModel inSensor:(int)sensor
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"HUI" inManagedObjectContext:context]];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"id == %@", [huiViewModel getIdentify]]];
    
    NSError *error = nil;
    NSArray* results = [context executeFetchRequest:fetchRequest error:&error];
    
    if ([context save:&error] == NO) {
        NSAssert(NO, @"Save should not fail\n%@", [error localizedDescription]);
        abort();
    }else if (!error && results.count > 0) {
        for(NSManagedObject *managedObject in results){
            [managedObject setValue:[huiViewModel getName] forKey:@"name"];
            [managedObject setValue:[NSNumber numberWithInt:-1] forKey:@"status"];
            [managedObject setValue:[huiViewModel getWifiKey] forKey:@"wifiKey"];
            [managedObject setValue:[huiViewModel getWifiName] forKey:@"wifiName"];
            [managedObject setValue:[huiViewModel getNotificationTime] forKey:@"notification"];
            
            switch (sensor) {
                case 1:
                    [managedObject setValue:[plantViewModel getIdentify] forKey:@"sensor1"];
                    break;
                case 2:
                    [managedObject setValue:[plantViewModel getIdentify] forKey:@"sensor2"];
                    break;
                case 3:
                    [managedObject setValue:[plantViewModel getIdentify] forKey:@"sensor3"];
                    break;
            }
            
            
        }
        
        //Save context to write to store
        [context save:nil];
    }
    
    if ( plantViewModel ){
        [self setHuiId:[huiViewModel getIdentify] inPlantViewModel:plantViewModel];
    }
}

- (void) removePlantInHUISensor: (PlantViewModel* )plantViewModel{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"HUI" inManagedObjectContext:context]];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"id == %@", [plantViewModel getHuiId]]];
    
    NSError *error = nil;
    NSArray* results = [context executeFetchRequest:fetchRequest error:&error];
    
    if ([context save:&error] == NO) {
        NSAssert(NO, @"Save should not fail\n%@", [error localizedDescription]);
        abort();
    }else if (!error && results.count > 0) {
        for(NSManagedObject *managedObject in results){
            
            if ([[managedObject valueForKey:@"sensor1"] isEqualToString:[plantViewModel getIdentify]]){
                [managedObject setValue:@"" forKey:@"sensor1"];
            }else if ([[managedObject valueForKey:@"sensor2"] isEqualToString:[plantViewModel getIdentify]]){
                [managedObject setValue:@"" forKey:@"sensor2"];
            }else if ([[managedObject valueForKey:@"sensor3"] isEqualToString:[plantViewModel getIdentify]]){
                [managedObject setValue:@"" forKey:@"sensor3"];
            }
            
        }
        
        //Save context to write to store
        [context save:nil];
    }
}


- (HUIViewModel*) getHuiWithName:(NSString* )huiName{
    
    HUIViewModel* huiResult = [[HUIViewModel alloc] init];
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"HUI" inManagedObjectContext:context]];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"name == %@", huiName]];
    
    NSError *error = nil;
    NSArray* results = [context executeFetchRequest:fetchRequest error:&error];
    
    if ([context save:&error] == NO) {
        NSAssert(NO, @"Save should not fail\n%@", [error localizedDescription]);
        abort();
    }else if (!error && results.count > 0) {
        for(NSManagedObject *managedObject in results){
            
            huiResult = [self getHUIFromObject: managedObject];
        }
        
        //Save context to write to store
        [context save:nil];
    }
    
    return huiResult;
}

- (int) getHuiSensorFree:(NSString* )huiId{
    
    HUIViewModel* huiResult = [[HUIViewModel alloc] init];
    
    int sensorFree = -1;
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"HUI" inManagedObjectContext:context]];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"id == %@", huiId]];
    
    NSError *error = nil;
    NSArray* results = [context executeFetchRequest:fetchRequest error:&error];
    
    if ([context save:&error] == NO) {
        NSAssert(NO, @"Save should not fail\n%@", [error localizedDescription]);
        abort();
    }else if (!error && results.count > 0) {
        for(NSManagedObject *managedObject in results){
            
            huiResult = [self getHUIFromObject: managedObject];
            
            if( [[huiResult getSensor2] isEqualToString:@""]){
                sensorFree = 2;
            } else if( [[huiResult getSensor1] isEqualToString:@""]){
                sensorFree = 1;
            }else if( [[huiResult getSensor3] isEqualToString:@""]){
                sensorFree = 3;
            }
        }
        
        //Save context to write to store
        [context save:nil];
    }
    
    return sensorFree;
}

- (HUIViewModel*) getHuiWithId:(NSString* )huiId{
    
    HUIViewModel* huiResult = [[HUIViewModel alloc] init];
    if (!huiId){
        huiResult = nil;
    }
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"HUI" inManagedObjectContext:context]];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"id == %@", huiId]];
    
    NSError *error = nil;
    NSArray* results = [context executeFetchRequest:fetchRequest error:&error];
    
    if ([context save:&error] == NO) {
        NSAssert(NO, @"Save should not fail\n%@", [error localizedDescription]);
        abort();
    }else if (!error && results.count > 0) {
        for(NSManagedObject *managedObject in results){
            
            huiResult = [self getHUIFromObject: managedObject];
        }
        
        //Save context to write to store
        [context save:nil];
    }
    
    return huiResult;
}

- (HUIViewModel* )getHUIFromObject:(NSManagedObject* )object{
    return [HUIViewModel getHUIFromObject:object];
}


- (NSMutableArray* )getHuisFromBBDD{
    NSMutableArray* returnObject = [[NSMutableArray alloc] init];
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"HUI" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *info in fetchedObjects) {
        NSLog(@"id: %@", [info valueForKey:@"id"]);
        NSLog(@"Name: %@", [info valueForKey:@"name"]);
        
        [returnObject addObject: [self getHUIFromObject:info]];
    }
    
    return returnObject;
}


#pragma mark PLANT MANAGER

-(void)setPlant:(PlantViewModel* )plantViewModel{
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    /* Plant object */
    NSManagedObject *plantInfo = [NSEntityDescription
                                  insertNewObjectForEntityForName:@"Plant"
                                  inManagedObjectContext:context];
    [plantInfo setValue:[plantViewModel getIdentify] forKey:@"id"];
    [plantInfo setValue:[plantViewModel getName] forKey:@"name"];
    [plantInfo setValue:[plantViewModel getPlantId] forKey:@"plantId"];
    //[plantInfo setValue:[plantViewModel getImage] forKey:@"image"];
    //[plantInfo setValue:[plantViewModel getStatus] forKey:@"status"];
    [plantInfo setValue:[plantViewModel getSunStatus] forKey:@"sunStatus"];
    [plantInfo setValue:[plantViewModel getWaterStatus] forKey:@"waterStatus"];
    [plantInfo setValue:[plantViewModel getTemperatureStatus] forKey:@"temperatureStatus"];
    [plantInfo setValue:[plantViewModel getSunValue] forKey:@"sunValue"];
    [plantInfo setValue:[plantViewModel getWaterValue] forKey:@"waterValue"];
    [plantInfo setValue:[plantViewModel getTemperatureValue] forKey:@"temperatureValue"];
    [plantInfo setValue:[plantViewModel getHuiId] forKey:@"huiId"];
    [plantInfo setValue:[plantViewModel getGrowing] forKey:@"growing"];
    [plantInfo setValue:[plantViewModel getDescriptionPlant] forKey:@"descriptionPlant"];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Plant" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *info in fetchedObjects) {
        NSLog(@"id: %@", [info valueForKey:@"id"]);
        NSLog(@"Name: %@", [info valueForKey:@"name"]);
        NSLog(@"Growing: %@", [info valueForKey:@"growing"]);
    }
}

- (void)setStatusPlant:(NSString* )status inPlant:(PlantViewModel*) plantViewModel{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Plant" inManagedObjectContext:context]];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"id == %@", [plantViewModel getIdentify]]];
    
    NSError *error = nil;
    NSArray* results = [context executeFetchRequest:fetchRequest error:&error];
    
    if ([context save:&error] == NO) {
        NSAssert(NO, @"Save should not fail\n%@", [error localizedDescription]);
        abort();
    }else if (!error && results.count > 0) {
        for(NSManagedObject *managedObject in results){
            
            [managedObject setValue:status forKey:@"status"];
        }
        
        //Save context to write to store
        [context save:nil];
    }
    
}

- (void)setGrowing:(NSString* )growing inPlant:(PlantViewModel*) plantViewModel{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Plant" inManagedObjectContext:context]];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"id == %@", [plantViewModel getIdentify]]];
    
    NSError *error = nil;
    NSArray* results = [context executeFetchRequest:fetchRequest error:&error];
    
    if ([context save:&error] == NO) {
        NSAssert(NO, @"Save should not fail\n%@", [error localizedDescription]);
        abort();
    }else if (!error && results.count > 0) {
        for(NSManagedObject *managedObject in results){
            
            [managedObject setValue:growing forKey:@"growing"];
        }
        
        //Save context to write to store
        [context save:nil];
    }
    
}

- (void) removePlantWithId:(NSString *) plantId{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Plant" inManagedObjectContext:context]];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"id == %@", plantId]];
    
    NSError *error = nil;
    NSArray* results = [context executeFetchRequest:fetchRequest error:&error];
    
    if ([context save:&error] == NO) {
        NSAssert(NO, @"Save should not fail\n%@", [error localizedDescription]);
        abort();
    }else if (!error && results.count > 0) {
        for(NSManagedObject *managedObject in results){
            [context deleteObject:managedObject];
        }
        
        //Save context to write to store
        [context save:nil];
    }
}


- (void) removePlant:(PlantViewModel* )plantViewModel{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Plant" inManagedObjectContext:context]];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"id == %@", [plantViewModel getIdentify]]];
    
    NSError *error = nil;
    NSArray* results = [context executeFetchRequest:fetchRequest error:&error];
    
    if ([context save:&error] == NO) {
        NSAssert(NO, @"Save should not fail\n%@", [error localizedDescription]);
        abort();
    }else if (!error && results.count > 0) {
        for(NSManagedObject *managedObject in results){
            [context deleteObject:managedObject];
        }
        
        //Save context to write to store
        [context save:nil];
    }
}


- (NSMutableArray* )getPlantsFromBBDD{
    NSMutableArray* returnObject = [[NSMutableArray alloc] init];
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Plant" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *info in fetchedObjects) {
        NSLog(@"id: %@", [info valueForKey:@"id"]);
        NSLog(@"Name: %@", [info valueForKey:@"name"]);
        
        [returnObject addObject: [self getPlantFromObject: info]];
    }
    
    return returnObject;
}


- (PlantViewModel* )getPlantFromObject:(NSManagedObject* )object{
    return [PlantViewModel getPlantFromObject:object];
}

#pragma mark STATUS METHODS

//Server API key AIzaSyDi3ZNi_LaeSWBi2UlsZ2vBt70fw1dahfQ

#define SERVER_API_KEY @"AIzaSyDi3ZNi_LaeSWBi2UlsZ2vBt70fw1dahfQ"
#define STATUS_APP_ID @"statusHUIApp"

- (void) setInitialStatus{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    /* Status object */
    NSManagedObject *statusInfo = [NSEntityDescription
                                  insertNewObjectForEntityForName:@"Status"
                                  inManagedObjectContext:context];
    
    [statusInfo setValue:STATUS_APP_ID forKey:@"id"];
    [statusInfo setValue:SERVER_API_KEY forKey:@"keyGTM"];
    
    // TODO set in the configuration view
    [statusInfo setValue:@"en" forKey:@"language"];
    [statusInfo setValue:@"[Celsius]" forKey:@"measures"];
    [statusInfo setValue:@"[centimeters]" forKey:@"distances"];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Status" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *info in fetchedObjects) {
        NSLog(@"<< Status Saved >>");
        NSLog(@"id: %@", [info valueForKey:@"id"]);
        NSLog(@"Server API KEY: %@", [info valueForKey:@"keyGTM"]);
    }
}

- (void) updateStatusWithRegistrationToken:(NSString* )registrationToken {
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Status" inManagedObjectContext:context]];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"id == %@", STATUS_APP_ID]];
    
    NSError *error = nil;
    NSArray* results = [context executeFetchRequest:fetchRequest error:&error];
    
    if ([context save:&error] == NO) {
        NSAssert(NO, @"Save should not fail\n%@", [error localizedDescription]);
        abort();
    }else if (!error && results.count > 0) {
        for(NSManagedObject *managedObject in results){
            
            [managedObject setValue:registrationToken forKey:@"deviceID"];
        }
        
        //Save context to write to store
        [context save:nil];
    }
}

- (void) updateStatus:(StatusViewModel* )statusViewModel {

    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Status" inManagedObjectContext:context]];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"id == %@", STATUS_APP_ID]];
    
    NSError *error = nil;
    NSArray* results = [context executeFetchRequest:fetchRequest error:&error];
    
    if ([context save:&error] == NO) {
        NSAssert(NO, @"Save should not fail\n%@", [error localizedDescription]);
        abort();
    }else if (!error && results.count > 0) {
        for(NSManagedObject *managedObject in results){
            [managedObject setValue:[statusViewModel getLanguage] forKey:@"language"];
            [managedObject setValue:[statusViewModel getMeasures] forKey:@"measures"];
            [managedObject setValue:[statusViewModel getDistances] forKey:@"distances"];
            [managedObject setValue:[statusViewModel getCity] forKey:@"city"];
            [managedObject setValue:[statusViewModel getCountry] forKey:@"country"];
            [managedObject setValue:[statusViewModel getLongitude] forKey:@"longitude"];
            [managedObject setValue:[statusViewModel getLatitude] forKey:@"latitude"];
            [managedObject setValue:[statusViewModel getTimeZone] forKey:@"timeZone"];
            [managedObject setValue:[statusViewModel getWaterAlarm] forKey:@"waterAlarm"];
        }
        
        //Save context to write to store
        [context save:nil];
    }
}

- (StatusViewModel* )getStatusFromObject:(NSManagedObject* )object{
    return [StatusViewModel getStatusFromObject:object];
}


- (StatusViewModel*) getStatus {
    
    StatusViewModel* statusResult = [[StatusViewModel alloc] init];
    
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Status" inManagedObjectContext:context]];
    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"id == %@", STATUS_APP_ID]];
    
    NSError *error = nil;
    NSArray* results = [context executeFetchRequest:fetchRequest error:&error];
    
    if ([context save:&error] == NO) {
        NSAssert(NO, @"Save should not fail\n%@", [error localizedDescription]);
        abort();
    }else if (!error && results.count > 0) {
        for(NSManagedObject *managedObject in results){
            
            statusResult = [self getStatusFromObject: managedObject];
        }
        
        //Save context to write to store
        [context save:nil];
    }
    
    return statusResult;
}

@end
