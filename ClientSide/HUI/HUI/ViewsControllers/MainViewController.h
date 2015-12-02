//
//  MainViewController.h
//  HUI
//
//  Created by Joaquin Giraldez on 28/11/15.
//  Copyright © 2015 Giraldez Lopez SL. All rights reserved.
//

#import "BaseViewController.h"
#import "WalkThroughViewController.h"
#import "SearchPlantViewController.h"
#import "PlantViewController.h"

@interface MainViewController : BaseViewController <
                                    WalkthroughViewControllerDelegate
                                    , SearchPlantViewControllerDelegate
                                    , PlantViewControllerDelegate
                                >

@property (nonatomic, assign) UINavigationController* navigationController;
@property (nonatomic, assign) NSNumber* numberOfPlants;

+ ( MainViewController* )instantiate;

@end
