//
//  AskHuiViewController.m
//  HUI
//
//  Created by Joaquin Giraldez on 3/12/15.
//  Copyright © 2015 Giraldez Lopez SL. All rights reserved.
//

#import "AskHuiViewController.h"
#import "Manager.h"
#import "StatusViewModel.h"


@interface AskHuiViewController (){
    //TODO, MUTE

    CoreServices* _coreServices;
    
    IBOutlet UILabel * _responseTitle;
    IBOutlet UILabel * _testLabel;
    IBOutlet UITextView* _textView;
    
    StatusViewModel* _statusViewModel;
    Manager* _manager;
    
    BOOL _isReadingAgain;
    
    BOOL _moveToBottom;
    
    BOOL _isDiagnostic;
    BOOL _isNewPlant;
}

@end

//const unsigned char SpeechKitApplicationKey[] = {0x2b, 0x68, 0xea, 0x70, 0x07, 0x01, 0xc0, 0xff, 0xea, 0xb5, 0x2b, 0xb4, 0x60, 0xea, 0xb5, 0x4a, 0xba, 0xed, 0x7f, 0x1a, 0xd3, 0x3e, 0x53, 0x4d, 0xbc, 0x6a, 0x61, 0xcb, 0xf2, 0xc0, 0xe2, 0x1d, 0x29, 0xcc, 0x8d, 0x30, 0xcd, 0x4e, 0x2f, 0xb7, 0x03, 0x5a, 0x6b, 0x63, 0x44, 0x20, 0xae, 0xfe, 0x0d, 0x2d, 0x19, 0xe1, 0x6c, 0x6c, 0x2e, 0x28, 0xd7, 0x90, 0xf3, 0xc9, 0x50, 0xd5, 0xe7, 0x79};

const unsigned char SpeechKitApplicationKey[] = {0xea, 0xb5, 0x52, 0x00, 0x8d, 0xb0, 0x76, 0x88, 0x86, 0xe8, 0xdc, 0x7e, 0x24, 0x60, 0xd8, 0x23, 0xab, 0x7e, 0x3a, 0x6e, 0x66, 0x8f, 0x33, 0x25, 0x8e, 0x6c, 0x12, 0xda, 0x1e, 0x8d, 0x34, 0x08, 0x43, 0x86, 0x09, 0xd0, 0x37, 0x7f, 0x58, 0xbd, 0x67, 0x34, 0x3b, 0x8b, 0x94, 0x13, 0xae, 0x3f, 0x91, 0xe8, 0xad, 0xf7, 0x78, 0xe0, 0x1d, 0x06, 0x4d, 0x2f, 0xe0, 0x6b, 0xbc, 0x14, 0x74, 0xff};


@implementation AskHuiViewController

@synthesize recordButton
            , searchBox
            , vuMeter
            , voiceSearch
            , speakButton
            , diagnosticStatus = _diagnosticStatus
            , plantViewModel = _plantViewModel
            , newPlantStatus = _newPlantStatus
            , huiViewModel = _huiViewModel
            , sensor = _sensor
            , vocalizer;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _coreServices = [[CoreServices alloc] init];
    [_coreServices setDelegate:self];
    
    [_responseTitle setAlpha: 0.0f];
    [speakButton setAlpha: 0.0f];
    
    [SpeechKit setupWithID:@"NMDPTRIAL_jjm_growandhelp_com20160317044052"
                      host:@"sslsandbox.nmdp.nuancemobility.net"
                      port:443
                    useSSL:YES
                  delegate:self];
    
    // Set earcons to play
    SKEarcon* earconStart	= [SKEarcon earconWithName:@"Robot1.wav"];
    SKEarcon* earconStop	= [SKEarcon earconWithName:@"Robot2.wav"];
    SKEarcon* earconCancel	= [SKEarcon earconWithName:@"Cancel.wav"];
    
    [SpeechKit setEarcon:earconStart forType:SKStartRecordingEarconType];
    [SpeechKit setEarcon:earconStop forType:SKStopRecordingEarconType];
    [SpeechKit setEarcon:earconCancel forType:SKCancelRecordingEarconType];
    
    if( !_statusViewModel ){
        _statusViewModel  = [[StatusViewModel alloc ] init];
    }
    
    if( !_manager ){
        _manager  = [[Manager alloc ] init];
    }
    
    _statusViewModel = [_manager getStatus];
    
    [_textView setText:@""];
    [_textView setDelegate: self];
    _isReadingAgain = NO;
    searchBox.text = @"";
    searchBox.placeholder = NSLocalizedString(@"Tap to write or press record button", nil);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ ( AskHuiViewController* )instantiate{
    
    return [[AskHuiViewController alloc] initWithNibName:[self viewToDevice:@"AskHuiView"] bundle:nil];
}

#pragma mark - ACTIONS

- (void) clearContent{
    [_textView setText:@""];
    
    searchBox.text = @"";
    searchBox.placeholder = NSLocalizedString(@"Tap to write or press record button", nil);
    
    if (isSpeaking) {
        [vocalizer cancel];
        isSpeaking = NO;
        _isReadingAgain = NO;
    }
    
    [speakButton setAlpha:0.0];
    
    self.newPlantStatus = NO;
}

- (IBAction)onBackTouchUpInside:(id)sender{

    [self clearContent];
    [self.delegate onBackAskTouchUpInside];
}

#pragma mark -
#pragma mark Actions

- (IBAction)recordButtonAction: (id)sender {
    
    self.diagnosticStatus = NO;
    
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

- (IBAction)speakOrStopActionButtonTouchUpInside: (id) sender {
    _isReadingAgain = YES;
    [self speakOrStopAction: sender];

}

- (IBAction)speakOrStopAction: (id) sender {
    
    if (isSpeaking) {
        [vocalizer cancel];
        isSpeaking = NO;
        _isReadingAgain = NO;
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
        [vocalizer speakString:_labelToRead.text];
        
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
   
    
    transactionState = TS_RECORDING;
    [recordButton setImage:[UIImage imageNamed:@"mic_on.png"] forState:UIControlStateNormal];
    
    [self performSelector:@selector(updateVUMeter) withObject:nil afterDelay:0.05];
}

- (void)recognizerDidFinishRecording:(SKRecognizer *)recognizer
{
   
    _isReadingAgain = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateVUMeter) object:nil];
    [self setVUMeterWidth:0.];
    transactionState = TS_PROCESSING;
    [recordButton setImage:[UIImage imageNamed:@"mic_processing.png"] forState:UIControlStateNormal];
}

#pragma mark RECOGNIZER - DIAGNOSTIC

- (void)recognizer:(SKRecognizer *)recognizer didFinishWithResults:(SKRecognition *)results
{
    
    long numOfResults = [results.results count];
    
    transactionState = TS_IDLE;
    [recordButton setImage:[UIImage imageNamed:@"mic_off.png"] forState:UIControlStateNormal];
    
    if (numOfResults > 0){
        searchBox.text = [results firstResult];
        
        if([searchBox.text isEqualToString: @"What's wrong"]){
            
            _labelToRead.text = NSLocalizedString(@"Select your plant." , nil);
            _isDiagnostic = YES;
             _isNewPlant = NO;
            
            [self speakOrStopAction:nil];
            
            [self.delegate diagnosticPhase];
            
        } else if([searchBox.text isEqualToString: @"New plant"]){
            
            _isDiagnostic = NO;
            _isNewPlant = YES;
            
            [self.delegate newPlantPhase];
            
        } else {
            // send to server the question
            
            if( self.diagnosticStatus ){
                [_coreServices diagnostic: self.plantViewModel
                             withHuiModel: [_manager getHuiWithId:[self.plantViewModel getHuiId]]
                               withSpeech: searchBox.text
                               withStatus: _statusViewModel];
            }else if(self.newPlantStatus){
                
                [self.delegate filterPlant: searchBox.text
                                withSensor: self.sensor
                                   withHUI: self.huiViewModel];
                
                [self clearContent];
                
            }else{
                [_coreServices postQuestion:searchBox.text andStatus:_statusViewModel];
            }
        }
    }
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
    
    [_responseTitle setAlpha:1];
    
    _textView.layoutManager.allowsNonContiguousLayout = NO;
    
    if(!_isReadingAgain) {
        if([_textView.text isEqualToString:@""]){
            _textView.text = [_textView.text stringByAppendingString: [NSString stringWithFormat:@"\n - \"%@\"\n\n",searchBox.text]];
        }else{
            _textView.text = [_textView.text stringByAppendingString: [NSString stringWithFormat:@"\n\n - \"%@\"\n\n",searchBox.text]];
        }
        
    }
    
    [Utils fadeIn: _responseTitle completion:^(BOOL finished){
        
        if(!_isReadingAgain) {
            _textView.text = [_textView.text stringByAppendingString: _labelToRead.text];
            
            [Utils scrollToBottomAnimate:_textView completion:nil];
            
        }
        
        [speakButton setAlpha: 1.0f];
    }];
    
    [speakButton setTitle:@"Stop" forState:UIControlStateNormal];
}

- (void)vocalizer:(SKVocalizer *)vocalizer willSpeakTextAtCharacter:(NSUInteger)index ofString:(NSString *)text {
    NSLog(@"Session id [%@].", [SpeechKit sessionID]); // for debugging purpose: printing out the speechkit session id
}

- (void)vocalizer:(SKVocalizer *)vocalizer didFinishSpeakingString:(NSString *)text withError:(NSError *)error {
    isSpeaking = NO;
    [speakButton setTitle:@"Read it again" forState:UIControlStateNormal];
}


#pragma mark -
#pragma mark UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == searchBox)
    {
        [searchBox resignFirstResponder];
        [_coreServices postQuestion:searchBox.text andStatus:_statusViewModel];
    }
    return YES;
}


#pragma  mark - CoreServicesDelegate


- ( void )answerFromServer:( NSDictionary * )response {

    if ([response objectForKey:@"speechResult"]){
        _labelToRead.text = [response objectForKey:@"speechResult"];
        
        
        if ([_labelToRead.text isEqualToString:@"ERROR"] ){
            _labelToRead.text = NSLocalizedString(@"Sorry, I can't process this question", nil);
        }
        
        [self speakOrStopAction:nil];
    }

}

#pragma mark textview Delegate methods

- (void)textViewDidChange:(UITextView *)textView {
    if (_moveToBottom) {
        int y = textView.contentSize.height + _textView.contentInset.bottom + _textView.contentInset.top;
        if(y > 0) {
            [textView setContentOffset:CGPointMake(0, y) animated:YES];
        }
        _moveToBottom = NO;
    }
    else {
        [textView scrollRangeToVisible:NSMakeRange([textView.text length]-1, 1)];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"] && range.location == [textView.text length]) {
        _moveToBottom = YES;
    }
    return YES;
}

#pragma mark DiagnosticMethod

- (void) onSelectPlantToDiagnosticReturnBack{
    
    [self recordButtonAction:nil];
    
    self.diagnosticStatus = YES;
    
}

- (void) onNewPlantReturnBack{
    
    self.newPlantStatus = YES;
    
    _labelToRead.text = NSLocalizedString(@"What do you want to plant?", nil);
    
    [self speakOrStopAction:nil];

}


@end
