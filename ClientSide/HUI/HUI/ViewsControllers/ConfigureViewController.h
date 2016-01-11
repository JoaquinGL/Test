//
//  ConfigureViewController.h
//  HUI
//
//  Created by Joaquin Giraldez on 13/12/15.
//  Copyright © 2015 Giraldez Lopez SL. All rights reserved.
//

#import "BaseViewController.h"
#import "HUIViewModel.h"

@protocol ConfigureViewControllerDelegate <NSObject>

@required

-(void)closeConfiguration:(HUIViewModel* )huiViewModel;

@end

@interface ConfigureViewController : BaseViewController<UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, assign) id <ConfigureViewControllerDelegate> delegate;

+ ( ConfigureViewController* )instantiate;

- (void) initConfigureView;

@end
