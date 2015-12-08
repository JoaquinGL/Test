//
//  AskHuiViewController.h
//  HUI
//
//  Created by Joaquin Giraldez on 3/12/15.
//  Copyright © 2015 Giraldez Lopez SL. All rights reserved.
//

#import "BaseViewController.h"
#import <SpeechKit/SpeechKit.h>

@protocol AskHuiViewControllerDelegate <NSObject>

@required

-(void)onBackAskTouchUpInside;

@end

@interface AskHuiViewController : BaseViewController<SpeechKitDelegate, SKRecognizerDelegate, SKVocalizerDelegate, UITextFieldDelegate>{
    
    IBOutlet UIButton* recordButton;
    IBOutlet UITextField* searchBox;
    IBOutlet UIView* vuMeter;
    IBOutlet UISegmentedControl* recognitionType;
    
    SKRecognizer* voiceSearch;
    
    // speak recognizer
    
    BOOL isSpeaking;
    IBOutlet UITextView* textToRead;
    IBOutlet UIButton* speakButton;
    SKVocalizer* vocalizer;
    
}

@property(nonatomic,retain) IBOutlet UIButton* recordButton;
@property(nonatomic,retain) IBOutlet UITextField* searchBox;
@property(nonatomic,retain) IBOutlet UIView* vuMeter;
@property(readonly)         SKRecognizer* voiceSearch;

@property(nonatomic,retain) IBOutlet UITextView* textToRead;
@property(nonatomic,retain) IBOutlet UIButton* speakButton;
@property(readonly)         SKVocalizer* vocalizer;

@property (nonatomic, assign) id <AskHuiViewControllerDelegate> delegate;

- (IBAction)recordButtonAction: (id)sender;

+ ( AskHuiViewController* )instantiate;

@end
