//
//  BaseViewModel.h
//  HUI
//
//  Created by Joaquin Giraldez on 9/12/15.
//  Copyright © 2015 Giraldez Lopez SL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BaseViewModel : NSObject

@property ( nonatomic, retain ) NSDictionary* innerState;

- (id)init;

@end
