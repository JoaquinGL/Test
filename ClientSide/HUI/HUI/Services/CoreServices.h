//
//  CoreServices.h
//  HUI
//
//  Created by Joaquin Giraldez on 23/12/15.
//  Copyright © 2015 Giraldez Lopez SL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "PlantViewModel.h"
#import "HUIViewModel.h"
#import "StatusViewModel.h"

@protocol CoreServicesDelegate <NSObject>

@required

-(void)answerFromServer:(NSDictionary* )response;


@end


@interface CoreServices : NSObject


@property (nonatomic, assign) id <CoreServicesDelegate> delegate;

- (void) postQuestion:(NSString* )question
            andStatus:(StatusViewModel* )status;

- (void) getPlantListWithHUID:(NSString* )huiId
                 withLanguage:(NSString* )language;

- (void) getPlantListWithFilter:(NSString* )filter
                     withStatus:(StatusViewModel* )status
                      withHuiId:(NSString* )huiID;

- (void) getPlantState:(PlantViewModel* )plantViewModel
               withHui:(HUIViewModel* )huiViewModel
            withStatus:(StatusViewModel* )statusViewModel;

- (void) postNewHUI:(NSMutableDictionary* )objectToPost;

- (void) postNewPlant:(PlantViewModel* )plant
         withHuiModel:(HUIViewModel* )huiViewModel;

- (UIImage* )imageFromServer:(PlantViewModel* )plant;

- (void) postChangeStatusPlant:(PlantViewModel* )plant
                  withHuiModel:(HUIViewModel* )huiViewModel;

- (void) deletePlant:(PlantViewModel* )plant
        withHuiModel:(HUIViewModel* )huiViewModel;

- (void) diagnostic:(PlantViewModel* )plant withHuiModel:(HUIViewModel* )huiViewModel
         withSpeech:(NSString* )speech
         withStatus:( StatusViewModel* )status;

@end
