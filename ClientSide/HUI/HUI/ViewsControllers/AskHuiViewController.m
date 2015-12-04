//
//  AskHuiViewController.m
//  HUI
//
//  Created by Joaquin Giraldez on 3/12/15.
//  Copyright © 2015 Giraldez Lopez SL. All rights reserved.
//

#import "AskHuiViewController.h"

@interface AskHuiViewController (){
    //TODO, MUTE
}

@end

@implementation AskHuiViewController

@synthesize recordButton,searchBox,vuMeter,voiceSearch;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [SpeechKit setupWithID:@"NMDPPRODUCTION_Joaquin_Giraldez_HUI_20151202041237"
                      host:@"fvr.nmdp.nuancemobility.net"
                      port:443
                    useSSL:NO
                  delegate:self];
    
    // Set earcons to play
    SKEarcon* earconStart	= [SKEarcon earconWithName:@"Play.wav"];
    SKEarcon* earconStop	= [SKEarcon earconWithName:@"Robot2.wav"];
    SKEarcon* earconCancel	= [SKEarcon earconWithName:@"Cancel.wav"];
    
    [SpeechKit setEarcon:earconStart forType:SKStartRecordingEarconType];
    [SpeechKit setEarcon:earconStop forType:SKStopRecordingEarconType];
    [SpeechKit setEarcon:earconCancel forType:SKCancelRecordingEarconType];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ ( AskHuiViewController* )instantiate{
    return [[AskHuiViewController alloc] initWithNibName:@"AskHuiView" bundle:nil];
}

#pragma mark - ACTIONS

- (IBAction)onBackTouchUpInside:(id)sender{
    [self.delegate onBackAskTouchUpInside];
}

#pragma mark -
#pragma mark Actions

- (IBAction)recordButtonAction: (id)sender {
    [searchBox resignFirstResponder];
    
    if (transactionState == TS_RECORDING) {
        [voiceSearch stopRecording];
    }
    else if (transactionState == TS_IDLE) {
        SKEndOfSpeechDetection detectionType;
        NSString* recoType;
        NSString* langType;
        
        transactionState = TS_INITIAL;
        
        if (recognitionType.selectedSegmentIndex == 0) {
            /* 'Search' is selected */
            detectionType = SKShortEndOfSpeechDetection; /* Searches tend to be short utterances free of pauses. */
            recoType = SKSearchRecognizerType; /* Optimize recognition performance for search text. */
        }
        else if (recognitionType.selectedSegmentIndex == 1){
            /* 'Dictation' is selected */
            detectionType = SKLongEndOfSpeechDetection; /* Dictations tend to be long utterances that may include short pauses. */
            recoType = SKDictationRecognizerType; /* Optimize recognition performance for dictation or message text. */
        } else {
            /* 'TV' is selected */
            detectionType = SKLongEndOfSpeechDetection; /* Dictations tend to be long utterances that may include short pauses. */
            recoType = SKTvRecognizerType; /* Optimize recognition performance for dictation or message text. */
        }
        
        langType = @"en_GB";
        
        if (voiceSearch) voiceSearch = nil;
        
        voiceSearch = [[SKRecognizer alloc] initWithType:recoType
                                               detection:detectionType
                                                language:langType 
                                                delegate:self];
    }
}


#pragma mark SpeechKitDelegate methods

- (void) audioSessionReleased {
    NSLog(@"audio session released");
}

- (void) destroyed {
}

#pragma mark -
#pragma mark VU Meter

- (void)setVUMeterWidth:(float)width {
    if (width < 0)
        width = 0;
    
    CGRect frame = vuMeter.frame;
    frame.size.width = width+10;
    vuMeter.frame = frame;
}

- (void)updateVUMeter {
    float width = (90+voiceSearch.audioLevel)*5/2;
    
    [self setVUMeterWidth:width];
    [self performSelector:@selector(updateVUMeter) withObject:nil afterDelay:0.05];
}


#pragma mark -
#pragma mark SKRecognizerDelegate methods

- (void)recognizerDidBeginRecording:(SKRecognizer *)recognizer
{
    NSLog(@"Recording started.");
    
    transactionState = TS_RECORDING;
    [recordButton setTitle:@"Recording..." forState:UIControlStateNormal];
    [self performSelector:@selector(updateVUMeter) withObject:nil afterDelay:0.05];
}

- (void)recognizerDidFinishRecording:(SKRecognizer *)recognizer
{
    NSLog(@"Recording finished.");
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateVUMeter) object:nil];
    [self setVUMeterWidth:0.];
    transactionState = TS_PROCESSING;
    [recordButton setTitle:@"Processing..." forState:UIControlStateNormal];
}

- (void)recognizer:(SKRecognizer *)recognizer didFinishWithResults:(SKRecognition *)results
{
    NSLog(@"Got results.");
    NSLog(@"Session id [%@].", [SpeechKit sessionID]); // for debugging purpose: printing out the speechkit session id
    
    long numOfResults = [results.results count];
    
    transactionState = TS_IDLE;
    [recordButton setTitle:@"Speak" forState:UIControlStateNormal];
    
    if (numOfResults > 0)
        searchBox.text = [results firstResult];
    
    if (results.suggestion){
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Suggestion"
                                                                       message:results.suggestion
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
    voiceSearch = nil;
    voiceSearch = nil;
}

- (void)recognizer:(SKRecognizer *)recognizer didFinishWithError:(NSError *)error suggestion:(NSString *)suggestion
{
    NSLog(@"Got error.");
    NSLog(@"Session id [%@].", [SpeechKit sessionID]); // for debugging purpose: printing out the speechkit session id
    
    transactionState = TS_IDLE;
    [recordButton setTitle:@"Record" forState:UIControlStateNormal];
    
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:[error localizedDescription]
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
    if (suggestion) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Suggestion"
                                                                       message:suggestion
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    }
    
    
    voiceSearch = nil;
}

#pragma mark -
#pragma mark UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == searchBox)
    {
        [searchBox resignFirstResponder];
    }
    return YES;
}


@end
