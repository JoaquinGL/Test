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

const unsigned char SpeechKitApplicationKey[] = {0x2b, 0x68, 0xea, 0x70, 0x07, 0x01, 0xc0, 0xff, 0xea, 0xb5, 0x2b, 0xb4, 0x60, 0xea, 0xb5, 0x4a, 0xba, 0xed, 0x7f, 0x1a, 0xd3, 0x3e, 0x53, 0x4d, 0xbc, 0x6a, 0x61, 0xcb, 0xf2, 0xc0, 0xe2, 0x1d, 0x29, 0xcc, 0x8d, 0x30, 0xcd, 0x4e, 0x2f, 0xb7, 0x03, 0x5a, 0x6b, 0x63, 0x44, 0x20, 0xae, 0xfe, 0x0d, 0x2d, 0x19, 0xe1, 0x6c, 0x6c, 0x2e, 0x28, 0xd7, 0x90, 0xf3, 0xc9, 0x50, 0xd5, 0xe7, 0x79};


@implementation AskHuiViewController

@synthesize recordButton
            , searchBox
            , vuMeter
            , voiceSearch
            , textToRead
            , speakButton
            , vocalizer;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [SpeechKit setupWithID:@"NMDPPRODUCTION_Joaquin_Giraldez_HUI_20151202041237"
                      host:@"fvr.nmdp.nuancemobility.net"
                      port:443
                    useSSL:NO
                  delegate:self];
    
    // Set earcons to play
    SKEarcon* earconStart	= [SKEarcon earconWithName:@"Robot1.wav"];
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


- (IBAction)speakOrStopAction: (id) sender {
    [textToRead resignFirstResponder];
    
    if (isSpeaking) {
        [vocalizer cancel];
        isSpeaking = NO;
    }
    else {
        isSpeaking = YES;
        // Initializes an english voice
        vocalizer = [[SKVocalizer alloc] initWithLanguage:@"en_US" delegate:self];
        
        // Initializes a french voice
        // vocalizer = [[SKVocalizer alloc] initWithLanguage:@"fr_FR" delegate:self];
        
        // Initializes a SKVocalizer with a specific voice
        // vocalizer = [[SKVocalizer alloc] initWithVoice:@"Samantha" delegate:self];
        
        // Speaks the string text
        [vocalizer speakString:textToRead.text];
        
        // Speaks the markup text with language For multiple languages, add <s></s> tags to markup string
        // NSString * textToReadString = [[[[NSString alloc] initWithCString:"<?xml version=\"1.0\"?> <speak version=\"1.0\" xmlns=\"http://www.w3.org/2001/10/synthesis\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.w3.org/2001/10/synthesis http://www.w3.org/TR/speech-synthesis/synthesis.xsd\" xml:lang=\"en-us\"> <s xml:lang=\"fr\"> "] stringByAppendingString:textToRead.text] stringByAppendingString:@"</s></speak>"];
        // [vocalizer speakMarkupString:textToReadString];
        
        // Speaks the markup text with voice, For multiple voices, add <voice></voice> tags to markup string.
        // NSString * textToReadString = [[[[NSString alloc] initWithCString:"<?xml version=\"1.0\"?> <speak version=\"1.0\" xmlns=\"http://www.w3.org/2001/10/synthesis\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.w3.org/2001/10/synthesis http://www.w3.org/TR/speech-synthesis/synthesis.xsd\" xml:lang=\"en-us\"> <voice name=\"Samantha\">"] stringByAppendingString:textToRead.text] stringByAppendingString:@"</voice></speak>"];
        // [vocalizer speakMarkupString:textToReadString];
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
    [recordButton setImage:[UIImage imageNamed:@"mic_on.png"] forState:UIControlStateNormal];
    
    [self performSelector:@selector(updateVUMeter) withObject:nil afterDelay:0.05];
}

- (void)recognizerDidFinishRecording:(SKRecognizer *)recognizer
{
    NSLog(@"Recording finished.");
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateVUMeter) object:nil];
    [self setVUMeterWidth:0.];
    transactionState = TS_PROCESSING;
    [recordButton setImage:[UIImage imageNamed:@"mic_processing.png"] forState:UIControlStateNormal];
}

- (void)recognizer:(SKRecognizer *)recognizer didFinishWithResults:(SKRecognition *)results
{
    NSLog(@"Got results.");
    NSLog(@"Session id [%@].", [SpeechKit sessionID]); // for debugging purpose: printing out the speechkit session id
    
    long numOfResults = [results.results count];
    
    transactionState = TS_IDLE;
    [recordButton setImage:[UIImage imageNamed:@"mic_off.png"] forState:UIControlStateNormal];
    
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
#pragma mark SKVocalizerDelegate methods

- (void)vocalizer:(SKVocalizer *)vocalizer willBeginSpeakingString:(NSString *)text {
    isSpeaking = YES;
    [speakButton setTitle:@"Stop" forState:UIControlStateNormal];
}

- (void)vocalizer:(SKVocalizer *)vocalizer willSpeakTextAtCharacter:(NSUInteger)index ofString:(NSString *)text {
    NSLog(@"Session id [%@].", [SpeechKit sessionID]); // for debugging purpose: printing out the speechkit session id
}

- (void)vocalizer:(SKVocalizer *)vocalizer didFinishSpeakingString:(NSString *)text withError:(NSError *)error {
    NSLog(@"Session id [%@].", [SpeechKit sessionID]); // for debugging purpose: printing out the speechkit session id
    isSpeaking = NO;
    [speakButton setTitle:@"Read It" forState:UIControlStateNormal];
    if (error !=nil)
    {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                       message:[error localizedDescription]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }
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
