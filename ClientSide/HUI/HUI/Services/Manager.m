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


-(void)setPlant:(PlantViewModel* )plantViewModel{

    NSManagedObjectContext *context = [self managedObjectContext];
    
    /* Plant object */
    NSManagedObject *plantInfo = [NSEntityDescription
                                       insertNewObjectForEntityForName:@"Plant"
                                       inManagedObjectContext:context];
    [plantInfo setValue:@"123A" forKey:@"id"];
    [plantInfo setValue:@"Tomato" forKey:@"name"];
    [plantInfo setValue:@"tomato.png" forKey:@"image"];
    [plantInfo setValue:[NSNumber numberWithInt:1] forKey:@"status"];
    [plantInfo setValue:[NSNumber numberWithInt:1] forKey:@"sunStatus"];
    [plantInfo setValue:[NSNumber numberWithInt:1] forKey:@"waterStatus"];
    [plantInfo setValue:[NSNumber numberWithInt:1] forKey:@"temperatureStatus"];
    [plantInfo setValue:@"Sun is ok" forKey:@"sunValue"];
    [plantInfo setValue:@"Water is ok" forKey:@"waterValue"];
    [plantInfo setValue:@"Temperature is ok" forKey:@"temperatureValue"];
    
    
    /* HUI object */
    NSManagedObject *huiInfo = [NSEntityDescription
                                          insertNewObjectForEntityForName:@"HUI"
                                          inManagedObjectContext:context];
    [huiInfo setValue:@"HUIA" forKey:@"id"];
    [huiInfo setValue:@"name hui" forKey:@"name"];
    [huiInfo setValue:[NSNumber numberWithInt:1] forKey:@"status"];
    [huiInfo setValue:@"123456" forKey:@"wifiKey"];
    [huiInfo setValue:@"itcrom" forKey:@"wifiName"];
    [huiInfo setValue:plantInfo forKey:@"plant"];

    
    
    [plantInfo setValue:huiInfo forKey:@"hui"];
    
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
        NSLog(@"Name: %@", [info valueForKey:@"name"]);
        
        NSManagedObject *huiInfo = [info valueForKey:@"hui"];
        NSLog(@"HUI: %@", [huiInfo valueForKey:@"name"]);
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

@end