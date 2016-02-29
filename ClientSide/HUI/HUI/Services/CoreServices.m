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
#define NEW_PLANT_POST_URL      [NSURL URLWithString: @"http://www.growandhelp.com/huiWebApp/HuiServer?newPlant"]
#define PLANT_STATE_POST_URL    [NSURL URLWithString: @"http://www.growandhelp.com/huiWebApp/HuiServer?getState"]

@implementation CoreServices


-(BOOL) isNetWorkAvailable{
    
    BOOL returnValue = false;
    
    Reachability *reachability = [Reachability reachabilityWithHostname:@"www.apple.com"];
    
    returnValue = [reachability currentReachabilityStatus] != NotReachable;
    
    return reachability.isReachable;

}



// HUI VOICE
/*
 
 {  
    "speech":"tell me how to plant tomatoes",
    "language":"en",
    "distanceUnit":"[centimeters]", 
    "temperatureUnit":"[Celsius]"
 }
 */

- (void) postQuestion:(NSString* )question andHUIID:(NSString* )huiId{
    
    if( [self isNetWorkAvailable]){
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: ASK_HUI_POST_URL];
        [request setHTTPMethod:@"POST"];
        
        
        NSDictionary *postDictionary = @{
                                         @"speech": question,
                                         @"language": @"en",
                                         @"distanceUnit": @"[centimeters]",
                                         @"temperatureUnit": @"[centimeters]"
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
                                              if (error){
                                                  NSLog(@"Error in the connection: %@", error);
                                              }
                                              
                                              [self.delegate answerFromServer: json];
                                              
                                          }];
        [dataTask resume];
    }else{
        [self.delegate answerFromServer: nil];
    }
}

- (void) getPlantListWithHUID:(NSString* )huiId withLanguage:(NSString *)language{
    
    if( [self isNetWorkAvailable]){
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: PLANT_LIST_POST_URL];
        [request setHTTPMethod:@"POST"];
        
        NSDictionary *postDictionary = @{
                                         @"huiID": huiId
                                         , @"language": language
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
                                              if (error){
                                                  NSLog(@"Error in the connection: %@", error);
                                              }
                                              
                                              [self.delegate answerFromServer: json];
                                              
                                          }];
        [dataTask resume];

    }else{
        [self.delegate answerFromServer: nil];
    }
}

- (void) getPlantState:(PlantViewModel* )plantViewModel withHui:(HUIViewModel* )huiViewModel withStatus:(StatusViewModel* )statusViewModel{
    
    if( [self isNetWorkAvailable]){
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: PLANT_STATE_POST_URL];
        [request setHTTPMethod:@"POST"];
        
        NSString* moisture = @"M2";
        
        if( [[plantViewModel getIdentify] isEqualToString: [huiViewModel getSensor1]]){
            moisture = @"M1";
        } else if( [[plantViewModel getIdentify] isEqualToString: [huiViewModel getSensor2]]){
            moisture = @"M2";
        } else if( [[plantViewModel getIdentify] isEqualToString: [huiViewModel getSensor3]]){
            moisture = @"M3";
        }
        
        NSDictionary *postDictionary = @{
                                         @"temperatureUnit": [statusViewModel getMeasures]
                                         , @"huiID": [huiViewModel getName]
                                         , @"language": [statusViewModel getLanguage]
                                         , @"moistureID": moisture
                                         , @"distanceUnit": [statusViewModel getDistances]
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
                                              if (error){
                                                  NSLog(@"Error in the connection: %@", error);
                                              }
                                              
                                              [self.delegate answerFromServer: json];
                                              
                                          }];
        [dataTask resume];
    }else{
        [self.delegate answerFromServer: nil];
    }
}

- (void) postNewHUI:(NSMutableDictionary* )objectToPost{
    
    if( [self isNetWorkAvailable]){
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: NEW_HUI_POST_URL];
        [request setHTTPMethod:@"POST"];
        
        NSDictionary *postDictionary = objectToPost;
        
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
                                              if (error){
                                                  NSLog(@"Error in the connection: %@", error);
                                              }
                                              
                                              [self.delegate answerFromServer: json];
                                              
                                          }];
        [dataTask resume];
    }else{
        [self.delegate answerFromServer: nil];
    }
}


- (void) postNewPlant:(PlantViewModel* )plant withHuiModel:(HUIViewModel* )huiViewModel{
    
    if( [self isNetWorkAvailable]){
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: NEW_PLANT_POST_URL];
        [request setHTTPMethod:@"POST"];
        
        
        NSString* moisture = @"M2";
        
        if( [[plant getIdentify] isEqualToString: [huiViewModel getSensor1]]){
            moisture = @"M1";
        } else if( [[plant getIdentify] isEqualToString: [huiViewModel getSensor2]]){
            moisture = @"M2";
        } else if( [[plant getIdentify] isEqualToString: [huiViewModel getSensor3]]){
            moisture = @"M3";
        }
        
        
        NSDictionary *postDictionary = @{
                                         @"plantStage": [plant getGrowing]
                                         , @"plantID": [plant getPlantId]
                                         , @"huiId": [huiViewModel getName]
                                         , @"moistureID": moisture
                                         };;
        
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
                                              if (error){
                                                  NSLog(@"Error in the connection: %@", error);
                                              }
                                              
                                              [self.delegate answerFromServer: json];
                                              
                                          }];
        [dataTask resume];
    }else{
        [self.delegate answerFromServer: nil];
    }
}




@end
