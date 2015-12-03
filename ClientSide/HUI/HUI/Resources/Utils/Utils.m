//
//  Utils.m
//  HUI
//
//  Created by Joaquin Giraldez on 3/12/15.
//  Copyright © 2015 Giraldez Lopez SL. All rights reserved.
//

#import "Utils.h"

@implementation Utils


+ (void) fadeIn: (UIView* )view completion:(void (^)(BOOL finished))completion{

    
    [UIView animateWithDuration: 0.3
                     animations:^{
                         view.alpha = 1.0;
                     }
                     completion:completion
     ];
    
}

+ (void) fadeOut: (UIView* )view completion:(void (^)(BOOL finished))completion{
    
    [UIView animateWithDuration: 0.3
                     animations:^{
                         view.alpha = 0.0;
                     }
                     completion:completion
     ];
    
}

@end
