//
//  Utils.h
//  HUI
//
//  Created by Joaquin Giraldez on 3/12/15.
//  Copyright © 2015 Giraldez Lopez SL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Utils : NSObject

+ (void) fadeIn: (UIView* )view completion:(void (^)(BOOL finished))completion;
+ (void) fadeOut: (UIView* )view completion:(void (^)(BOOL finished))completion;


@end
