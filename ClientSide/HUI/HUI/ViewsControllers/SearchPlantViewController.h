//
//  SearchPlantViewController.h
//  HUI
//
//  Created by Joaquin Giraldez on 26/11/15.
//  Copyright © 2015 Giraldez Lopez SL. All rights reserved.
//

#import "BaseViewController.h"
#import "CoreServices.h"

@protocol SearchPlantViewControllerDelegate <NSObject>

@required

-(void)onSelectPlant:(NSString*) plantName;

@end

@interface SearchPlantViewController : BaseViewController<CoreServicesDelegate, MBProgressHUDDelegate>


@property (nonatomic, assign) id <SearchPlantViewControllerDelegate> delegate;
@property (nonatomic) NSMutableArray* data;

+ ( SearchPlantViewController* )instantiate;

@end
