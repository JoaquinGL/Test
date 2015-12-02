//
//  DetailPlantViewController.h
//  HUI
//
//  Created by Joaquin Giraldez on 26/11/15.
//  Copyright © 2015 Giraldez Lopez SL. All rights reserved.
//

#import "BaseViewController.h"

@interface DetailPlantViewController : BaseViewController{
}

@property (nonatomic, assign) UINavigationController* navigationController;

+ ( DetailPlantViewController* )instantiate;

@end
