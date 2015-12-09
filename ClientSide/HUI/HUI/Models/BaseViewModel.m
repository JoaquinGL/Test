//
//  BaseViewModel.m
//  HUI
//
//  Created by Joaquin Giraldez on 9/12/15.
//  Copyright © 2015 Giraldez Lopez SL. All rights reserved.
//

#import "BaseViewModel.h"

@implementation BaseViewModel

- ( id )init
{
    self = [ super init ];
    self.innerState = [[NSDictionary alloc] init];
    return self;
}

@end
