//
//  AskHuiViewController.h
//  HUI
//
//  Created by Joaquin Giraldez on 3/12/15.
//  Copyright © 2015 Giraldez Lopez SL. All rights reserved.
//

#import "BaseViewController.h"
#import "CoreServices.h"
#import "Utils.h"
#import <SpeechKit/SpeechKit.h>
#import "PlantViewModel.h"
#import "HUIViewModel.h"

@protocol AskHuiViewControllerDelegate <NSObject>

@required

-(void) onBackAskTouchUpInside;
-(void) diagnosticPhase;
-(void) newPlantPhase;
-(void) filterPlant:(NSString* )filterSearchText withSensor:(int) sensor withHUI:(HUIViewModel*)huiViewModel;

@end

@interface AskHuiViewController : BaseViewController<SpeechKitDelegate, SKRecognizerDelegate, SKVocalizerDelegate, UITextFieldDelegate, CoreServicesDelegate, UITextViewDelegate>{
    
    IBOutlet UIButton* recordButton;
    IBOutlet UITextField* searchBox;
    IBOutlet UIView* vuMeter;
    IBOutlet UISegmentedControl* recognitionType;
    
    IBOutlet UILabel* _labelToRead;
    
    SKRecognizer* voiceSearch;
    
    // speak recognizer
    
    BOOL isSpeaking;
    IBOutlet UIButton* speakButton;
    SKVocalizer* vocalizer;
    
    BOOL _diagnosticStatus;
    BOOL _newPlantStatus;
    int _sensor;
    
}

@property(nonatomic,retain) IBOutlet UIButton* recordButton;
@property(nonatomic,retain) IBOutlet UITextField* searchBox;
@property(nonatomic,retain) IBOutlet UIView* vuMeter;
@property(readonly)         SKRecognizer* voiceSearch;

@property(nonatomic,retain) IBOutlet UIButton* speakButton;
@property(readonly)         SKVocalizer* vocalizer;
@property(nonatomic, assign) BOOL diagnosticStatus;
@property(nonatomic, assign) BOOL newPlantStatus;

@property(nonatomic, assign) int sensor;

@property (nonatomic, assign) id <AskHuiViewControllerDelegate> delegate;
@property (nonatomic, retain) PlantViewModel* plantViewModel;
@property (nonatomic, retain) HUIViewModel* huiViewModel;

- (IBAction)recordButtonAction: (id)sender;

+ ( AskHuiViewController* )instantiate;

- (void) onSelectPlantToDiagnosticReturnBack;
- (void) onNewPlantReturnBack;

@end
