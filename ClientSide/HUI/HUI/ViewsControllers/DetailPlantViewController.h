//
//  DetailPlantViewController.h
//  HUI
//
//  Created by Joaquin Giraldez on 26/11/15.
//  Copyright © 2015 Giraldez Lopez SL. All rights reserved.
//

#import "BaseViewController.h"
#import "PlantViewModel.h"

@protocol DetailPlantViewControllerDelegate <NSObject>

@required

-(void)deletePlant:(NSNumber*) identify;

@end


@interface DetailPlantViewController : BaseViewController{
}

@property (nonatomic, assign) id <DetailPlantViewControllerDelegate> delegate;
@property (nonatomic, assign) NSNumber* identify;
@property (nonatomic, retain) PlantViewModel* plantViewModel;


+ ( DetailPlantViewController* )instantiate;


@end
