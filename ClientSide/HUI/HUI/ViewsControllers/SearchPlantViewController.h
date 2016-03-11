//
//  SearchPlantViewController.h
//  HUI
//
//  Created by Joaquin Giraldez on 26/11/15.
//  Copyright © 2015 Giraldez Lopez SL. All rights reserved.
//

#import "BaseViewController.h"
#import "CoreServices.h"
#import "HUIViewModel.h"

@protocol SearchPlantViewControllerDelegate <NSObject>

@required

-(void)onSelectPlant:(NSDictionary*) plantObject
    withHuiViewModel:(HUIViewModel* )huiViewModel
            inSensor:(int) sensor
         plantStatus:(NSString* ) status;

@end

@interface SearchPlantViewController : BaseViewController<CoreServicesDelegate, MBProgressHUDDelegate>{

    NSString * _filter;
    
}

@property (nonatomic, assign) id <SearchPlantViewControllerDelegate> delegate;
@property (nonatomic) NSMutableArray* data;

@property (nonatomic, retain) HUIViewModel* huiViewModel;
@property (nonatomic, assign) int sensor;
@property (nonatomic, retain) NSString* filter;

+ ( SearchPlantViewController* )instantiate;

@end
