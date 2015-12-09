//
//  SearchPlantViewController.h
//  HUI
//
//  Created by Joaquin Giraldez on 26/11/15.
//  Copyright © 2015 Giraldez Lopez SL. All rights reserved.
//

#import "BaseViewController.h"

@protocol SearchPlantViewControllerDelegate <NSObject>

@required

-(void)onSelectPlant:(NSString*) plantName withId:(long) position;

@end

@interface SearchPlantViewController : BaseViewController


@property (nonatomic, assign) id <SearchPlantViewControllerDelegate> delegate;
@property (nonatomic) NSArray* data;

+ ( SearchPlantViewController* )instantiate;

@end
