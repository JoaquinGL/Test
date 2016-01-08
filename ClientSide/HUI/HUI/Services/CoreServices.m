//
//  CoreServices.m
//  HUI
//
//  Created by Joaquin Giraldez on 23/12/15.
//  Copyright © 2015 Giraldez Lopez SL. All rights reserved.
//

/*
 
 JSON EXAMPLE
 
    {
        "speech":"tell me how to plant tomatoes",
        "id":"HUIA"
    }
*/


#import "CoreServices.h"

#define kBgQueue dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1

// post server

#define ASK_HUI_POST_URL        [NSURL URLWithString: @"http://www.growandhelp.com/huiWebApp/HuiServer?speech"]
#define NEW_HUI_POST_URL        [NSURL URLWithString: @"http://www.growandhelp.com/huiWebApp/HuiServer?newHUI"]
#define PLANT_LIST_POST_URL     [NSURL URLWithString: @"http://www.growandhelp.com/huiWebApp/HuiServer?getPlantList"]
#define NEW_PLANT_POST_URL      [NSURL URLWithString: @"http://www.growandhelp.com/huiWebApp/HuiServer?newHUI"]
#define PLANT_STATE_POST_URL    [NSURL URLWithString: @"http://www.growandhelp.com/huiWebApp/HuiServer?getState"]

@implementation CoreServices


- (void) postQuestion:(NSString* )question andHUIID:(NSString* )huiId{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: ASK_HUI_POST_URL];
    [request setHTTPMethod:@"POST"];
    
    NSDictionary *postDictionary = @{
                        @"speech": question,
                        @"id": huiId
                        };
    
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:postDictionary options:0 error:&error];
    [request setHTTPBody:postData];
   

    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                                               options:kNilOptions
                                                                                                 error:&error];
                                          if (!error){
                                              NSLog(@"Data: %@", json);
                                              [self.delegate answerFromServer: json];
                                              
                                          }else{
                                              NSLog(@"Error in the connection: %@", error);
                                          }
                                          
                                      }];
    [dataTask resume];
    
}

- (void) getPlantListWithHUID:(NSString* )huiId{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: PLANT_LIST_POST_URL];
    [request setHTTPMethod:@"POST"];
    
    NSDictionary *postDictionary = @{
                                     @"suitablePlants": @"false",
                                     @"huiID": huiId
                                     };
    
    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:postDictionary options:0 error:&error];
    [request setHTTPBody:postData];
    
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data
                                                                                               options:kNilOptions
                                                                                                 error:&error];
                                          if (!error){
                                              [self.delegate answerFromServer: json];
                                          }else{
                                              NSLog(@"Error in the connection: %@", error);
                                          }
                                          
                                      }];
    [dataTask resume];

}


@end
