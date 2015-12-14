//
//  ConfigureViewController.h
//  HUI
//
//  Created by Joaquin Giraldez on 13/12/15.
//  Copyright © 2015 Giraldez Lopez SL. All rights reserved.
//

#import "BaseViewController.h"

@protocol ConfigureViewControllerDelegate <NSObject>

@required

-(void)closeConfiguration;

@end

@interface ConfigureViewController : BaseViewController<UITextFieldDelegate>

@property (nonatomic, assign) id <ConfigureViewControllerDelegate> delegate;

+ ( ConfigureViewController* )instantiate;

- (void) initConfigureView;

@end
