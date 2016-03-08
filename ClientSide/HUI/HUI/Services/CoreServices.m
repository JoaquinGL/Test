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

#define ASK_HUI_POST_URL                [NSURL URLWithString: @"http://hui-growandhelp.rhcloud.com/huiWebApp/HuiServer?speech"]
#define NEW_HUI_POST_URL                [NSURL URLWithString: @"http://www.growandhelp.com/huiWebApp/HuiServer?newHUI"]
#define PLANT_LIST_POST_URL             [NSURL URLWithString: @"http://www.growandhelp.com/huiWebApp/HuiServer?getPlantList"]
#define NEW_PLANT_POST_URL              [NSURL URLWithString: @"http://www.growandhelp.com/huiWebApp/HuiServer?newPlant"]
#define PLANT_STATE_POST_URL            [NSURL URLWithString: @"http://www.growandhelp.com/huiWebApp/HuiServer?getState"]
#define PLANT_IMAGE_URL                 @"http://growandhelp.com/plants/%@.png"
#define CHANGE_PLANT_STATE_POST_URL     [NSURL URLWithString: @"http://www.growandhelp.com/huiWebApp/HuiServer?changePlantStage"]
#define DELETE_PLANT_POST_URL           [NSURL URLWithString: @" http://www.growandhelp.com/huiWebApp/HuiServer?removePlant"]

@implementation CoreServices


-(BOOL) isNetWorkAvailable{
    
    BOOL returnValue = false;
    
    Reachability *reachability = [Reachability reachabilityWithHostname:@"www.apple.com"];
    
    returnValue = [reachability currentReachabilityStatus] != NotReachable;
    
    return reachability.isReachable;

}


- (void) postDictionary:(NSDictionary *)dict inRequest:(NSMutableURLRequest* )request {

    NSError *error;
    NSData *postData = [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
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


}



- (void) postQuestion:(NSString* )question
            andStatus:(StatusViewModel* )status{
    
    if( [self isNetWorkAvailable]){
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: ASK_HUI_POST_URL];
        [request setHTTPMethod:@"POST"];
        
        
        NSDictionary *postDictionary = @{
                                         @"speech": question,
                                         @"language": [status getLanguage],
                                         @"distanceUnit": [status getDistances],
                                         @"temperatureUnit": [status getMeasures]
                                         };
        
        
        [self postDictionary:postDictionary inRequest:request];
        
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
        
        [self postDictionary:postDictionary inRequest:request];
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
        
        [self postDictionary:postDictionary inRequest:request];
    }else{
        [self.delegate answerFromServer: nil];
    }
}

- (void) postNewHUI:(NSMutableDictionary* )objectToPost{
    
    if( [self isNetWorkAvailable]){
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: NEW_HUI_POST_URL];
        [request setHTTPMethod:@"POST"];
        
        NSDictionary *postDictionary = objectToPost;
        
        [self postDictionary:postDictionary inRequest:request];
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
        
        [self postDictionary:postDictionary inRequest:request];
    }else{
        [self.delegate answerFromServer: nil];
    }
}



- (UIImage* )imageFromServer:(PlantViewModel* )plant {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: PLANT_IMAGE_URL, [plant getPlantId]]];
    
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    
    UIImage *tmpImage = [[UIImage alloc] initWithData:data];
    
    return tmpImage;
}


- (void) postChangeStatusPlant:(PlantViewModel* )plant withHuiModel:(HUIViewModel* )huiViewModel {
    
    if( [self isNetWorkAvailable]){
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: CHANGE_PLANT_STATE_POST_URL];
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
                                           @"plantStage": @"growing"
                                         , @"huiID": [huiViewModel getName]
                                         , @"moistureID": moisture
                                         };;
        
        [self postDictionary:postDictionary inRequest:request];
    }else{
        [self.delegate answerFromServer: nil];
    }
}

- (void) deletePlant:(PlantViewModel* )plant withHuiModel:(HUIViewModel* )huiViewModel {
    
    if( [self isNetWorkAvailable]){
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: DELETE_PLANT_POST_URL];
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
                                           @"huiID": [huiViewModel getName]
                                         , @"moistureID": moisture
                                         };;
        
        [self postDictionary:postDictionary inRequest:request];
    }else{
        [self.delegate answerFromServer: nil];
    }
}




@end
