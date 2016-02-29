//
//  DetailPlantViewController.h
//  HUI
//
//  Created by Joaquin Giraldez on 26/11/15.
//  Copyright © 2015 Giraldez Lopez SL. All rights reserved.
//

#import "BaseViewController.h"
#import "PlantViewModel.h"
#import "CoreServices.h"
#import "StatusViewModel.h"

@protocol DetailPlantViewControllerDelegate <NSObject>

@required

-(void)deletePlant:(NSNumber*) identify withId:(NSString* ) plantId;

-(void)globalStatus:(int) status withPlantViewModel:(PlantViewModel* )plantViewModel;

@end

@interface DetailPlantViewController : BaseViewController < UIAlertViewDelegate
                                                            ,MBProgressHUDDelegate
                                                            ,CoreServicesDelegate >{
}

@property (nonatomic, assign) id <DetailPlantViewControllerDelegate> delegate;
@property (nonatomic, assign) NSNumber* position;
@property (nonatomic, retain) PlantViewModel* plantViewModel;


+ ( DetailPlantViewController* )instantiate;


@end
