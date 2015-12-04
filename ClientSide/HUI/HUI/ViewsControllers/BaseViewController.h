//
//  BaseViewController.h
//  HUI
//
//  Created by Joaquin Giraldez on 26/11/15.
//  Copyright © 2015 Giraldez Lopez SL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"

@interface BaseViewController : UIViewController{
    enum {
        TS_IDLE,
        TS_INITIAL,
        TS_RECORDING,
        TS_PROCESSING,
    } transactionState;
}

- (IBAction)onCloseButtonTouchUpInside:(id)sender;

@end
