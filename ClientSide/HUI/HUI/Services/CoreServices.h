//
//  CoreServices.h
//  HUI
//
//  Created by Joaquin Giraldez on 23/12/15.
//  Copyright © 2015 Giraldez Lopez SL. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CoreServicesDelegate <NSObject>

@required

-(void)answerFromServer:(NSDictionary* )response;


@end


@interface CoreServices : NSObject


@property (nonatomic, assign) id <CoreServicesDelegate> delegate;




- (void) postQuestion:(NSString* )question andHUIID:(NSString* )huiId;
- (void) getPlantListWithHUID:(NSString* )huiId;

@end
