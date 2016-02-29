//
//  ConfigureViewController.h
//  HUI
//
//  Created by Joaquin Giraldez on 13/12/15.
//  Copyright © 2015 Giraldez Lopez SL. All rights reserved.
//

#import "BaseViewController.h"
#import "HUIViewModel.h"
#import "PlantViewModel.h"
#import "MBProgressHUD.h"
#import "Manager.h"

@protocol ConfigureViewControllerDelegate <NSObject>

@required

-(void)closeConfiguration:(HUIViewModel* )huiViewModel withSensor:(int)sensor;
-(void)cancelConfiguration;
-(void)removePlantInSensor:(NSString* )plantId;
@end

@interface ConfigureViewController : BaseViewController<UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, MBProgressHUDDelegate>

@property (nonatomic, assign) id <ConfigureViewControllerDelegate> delegate;
@property (nonatomic, retain) PlantViewModel* plantViewModel;
@property (nonatomic, retain) HUIViewModel* huiViewModel;

+ ( ConfigureViewController* )instantiate;

- (void) initConfigureView;

@end
