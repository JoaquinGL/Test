//
//  AskHuiViewController.h
//  HUI
//
//  Created by Joaquin Giraldez on 3/12/15.
//  Copyright © 2015 Giraldez Lopez SL. All rights reserved.
//

#import "BaseViewController.h"

@protocol AskHuiViewControllerDelegate <NSObject>

@required

-(void)onBackAskTouchUpInside;

@end

@interface AskHuiViewController : BaseViewController

@property (nonatomic, assign) id <AskHuiViewControllerDelegate> delegate;

+ ( AskHuiViewController* )instantiate;

@end
