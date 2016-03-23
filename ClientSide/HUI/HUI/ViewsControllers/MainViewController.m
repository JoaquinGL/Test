//
//  MainViewController.m
//  HUI
//
//  Created by Joaquin Giraldez on 28/11/15.
//  Copyright © 2015 Giraldez Lopez SL. All rights reserved.
//

#import "MainViewController.h"
#import "WalkThroughViewController.h"
#import "WalkthroughPageViewController.h"
#import "CustomPageViewController.h"
#import "AskHuiViewController.h"
#import "PlantViewModel.h"
#import "Manager.h"
#import "SocketConnectionVC.h"
#import "ConfigureViewController.h"
#import "StatusViewModel.h"
#import "SettingsViewController.h"

@interface MainViewController (){
    SearchPlantViewController* _searchPlantViewController;
    DetailPlantViewController* _detailPlantViewController;
    
    PlantViewController* _plant0ViewController;
    PlantViewController* _plant1ViewController;
    PlantViewController* _plant2ViewController;
    
    AskHuiViewController* _askHuiViewController;
    
    ConfigureViewController* _configureViewController;
    
    SettingsViewController* _settingsView;
    
    IBOutlet UIButton* newPlantButton;
    IBOutlet UIButton* _askHuiButton;
    
    MBProgressHUD* _HUD;
    
    Manager* _manager;
    
    NSMutableArray* _plantsCollection;
    NSMutableArray* _plantsViewControllerCollection;
    
    NSInteger _positionX;
    NSInteger _positionY;
    
    IBOutlet UIScrollView* plantsScrollView;
    NSInteger numberOfPages;
    NSInteger plantScrollViewControllerHeight;
    CoreServices* _coreServices;
    
    BOOL diagnosticStatus;
    BOOL newPLantStatus;
    BOOL _isDeleteMode;
    int countPlantFromServer;
}

@end

#define WIDTH_PLANT 160
#define HEIGHT_PLANT 160
#define INITIAL_POINT_X 10
#define INITIAL_POINT_Y 0
#define FRAME_NEW_PLANT CGRectMake(80, 130, WIDTH_PLANT, HEIGHT_PLANT)
#define FRAME_NEW_PLANT_1_PLANT CGRectMake(80, 260, WIDTH_PLANT, HEIGHT_PLANT)
#define FRAME_NEW_PLANT_2_PLANT CGRectMake(80, 260, WIDTH_PLANT, HEIGHT_PLANT)
#define FRAME_NEW_PLANT_3_PLANT CGRectMake(180, 260, 120, 120)
#define FRAME_NEW_PLANT_4_PLANT CGRectMake(15, 475, 80, 80)
#define FRAME_ASK_HUI_BUTTON_FIRST_POSITION CGRectMake(85, 475, 150, 55)
#define FRAME_ASK_HUI_BUTTON_FINAL_POSITION CGRectMake(150, 490, 150, 55)
// ------------------------------------------------------------------------------------------- 2X
#define FRAME_ASK_HUI_BUTTON_FIRST_POSITION_2X CGRectMake(110, 550, 150, 55)
#define FRAME_ASK_HUI_BUTTON_FINAL_POSITION_2X CGRectMake(180, 550, 150, 55)
#define FRAME_NEW_PLANT_2X CGRectMake(107, 130, WIDTH_PLANT, HEIGHT_PLANT)
#define FRAME_NEW_PLANT_1_PLANT_2X CGRectMake(107, 280, WIDTH_PLANT, HEIGHT_PLANT)
#define FRAME_NEW_PLANT_2_PLANT_2X CGRectMake(107, 280, WIDTH_PLANT, HEIGHT_PLANT)
#define FRAME_NEW_PLANT_3_PLANT_2X CGRectMake(210, 300, 120, 120)
#define FRAME_NEW_PLANT_4_PLANT_2X CGRectMake(50, 520, 100, 100)
// ------------------------------------------------------------------------------------------- 3X
#define FRAME_ASK_HUI_BUTTON_FIRST_POSITION_3X CGRectMake(127, 550, 150, 55)
#define FRAME_ASK_HUI_BUTTON_FINAL_POSITION_3X CGRectMake(200, 550, 150, 55)
#define FRAME_NEW_PLANT_3X CGRectMake(120, 130, WIDTH_PLANT, HEIGHT_PLANT)
#define FRAME_NEW_PLANT_1_PLANT_3X CGRectMake(120, 280, WIDTH_PLANT, HEIGHT_PLANT)
#define FRAME_NEW_PLANT_2_PLANT_3X CGRectMake(120, 280, WIDTH_PLANT, HEIGHT_PLANT)
#define FRAME_NEW_PLANT_3_PLANT_3X CGRectMake(230, 280, 120, 120)
#define FRAME_NEW_PLANT_4_PLANT_3X CGRectMake(70, 520, 100, 100)

@implementation MainViewController

@synthesize navigationController = _navigationController,
            numberOfPlants = _numberOfPlants;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customInit];
}


- (void)customInit {
    countPlantFromServer = 0;
    
    //add notification observer
    [self addNotificationObserver];
    
    diagnosticStatus = NO;
    _isDeleteMode = NO;
    _positionX = 95;
    _positionY = 20;
    
    _searchPlantViewController = [SearchPlantViewController instantiate];
    _detailPlantViewController = [DetailPlantViewController instantiate];
    _askHuiViewController = [AskHuiViewController instantiate];
    
    _askHuiViewController.delegate = self;
    _detailPlantViewController.delegate = self;
    _searchPlantViewController.delegate = self;
    
    //init collections
    
    _plantsCollection = [[NSMutableArray alloc] init];
    _plantsViewControllerCollection = [[NSMutableArray alloc] init];
    
    self.title = NSLocalizedString(@"My Garden", @"");
    
    self.numberOfPlants = [NSNumber numberWithInt: 0];
    
    _askHuiViewController = [AskHuiViewController instantiate];
    _askHuiViewController.delegate = self;
    [_askHuiViewController.view setFrame: self.view.frame];
    
    /* New Plant Button */
    newPlantButton = [[UIButton alloc] initWithFrame: FRAME_NEW_PLANT];
    [newPlantButton addTarget:self action:@selector(onNewPlantTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [newPlantButton setBackgroundImage:[UIImage imageNamed:@"plant_something_new.png"] forState:UIControlStateNormal];
    
    
    _askHuiButton = [[UIButton alloc] initWithFrame: FRAME_ASK_HUI_BUTTON_FIRST_POSITION];
    [_askHuiButton addTarget:self action:@selector(onAskHuiTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [_askHuiButton setBackgroundImage:[UIImage imageNamed:@"askHuiButton"] forState:UIControlStateNormal];
    
    [self.view addSubview: newPlantButton];
    [self.view addSubview: _askHuiButton];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    [[UINavigationBar appearance] setTranslucent: YES];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,
                                                            nil]];
    
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

    UIImage* deleteImage = [UIImage imageNamed:@"info.png"];
    CGRect frameimg = CGRectMake(0, 0, deleteImage.size.width, deleteImage.size.height);
    UIButton *infoButton = [[UIButton alloc] initWithFrame:frameimg];
    [infoButton setBackgroundImage:deleteImage forState:UIControlStateNormal];
    
    [infoButton addTarget:self action:@selector(showWalkthrough:)
           forControlEvents:UIControlEventTouchUpInside];
    
    [infoButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView: infoButton];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    UIImage* settingImage = [UIImage imageNamed:@"settingsInfo.png"];
    UIButton *settingButton = [[UIButton alloc] initWithFrame:frameimg];
    [settingButton setBackgroundImage:settingImage forState:UIControlStateNormal];
    
    [settingButton addTarget:self action:@selector(showSettingView:)
         forControlEvents:UIControlEventTouchUpInside];
    
    [settingButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithCustomView: settingButton];
    self.navigationItem.leftBarButtonItem = leftButton;

    UIFont *customFont = [UIFont fontWithName:@"GrandHotel-Regular" size:30];
    
    NSShadow* shadow = [NSShadow new];
    shadow.shadowOffset = CGSizeMake(0.0f, 1.0f);
    shadow.shadowColor = [UIColor clearColor];
    [[UINavigationBar appearance] setTitleTextAttributes: @{
                                                            NSForegroundColorAttributeName: [UIColor whiteColor],
                                                            NSFontAttributeName: customFont,
                                                            NSShadowAttributeName: shadow
                                                            }];
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                 style:UIBarButtonItemStylePlain
                                                                target:nil
                                                                action:nil];
    
    [self.navigationItem setBackBarButtonItem:backItem];
    
    /* GET CONTENT FROM BBDD */
    [self initializeContent];
    
    
    plantScrollViewControllerHeight = 0;
    
    // Registering as observer from one object
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onbackToBackground)
                                                 name:@"notification_back_from_background"
                                               object:nil];
    
    
    //reset alerts
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
}

-(void) onbackToBackground{
    countPlantFromServer = 0;
    // Remove Observer back_from_background
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: @"notification_back_from_background"
                                                  object: nil];

    NSMutableArray* content = [_manager getPlantsFromBBDD];
    
    if([content count] != 0){
        
        for (PlantViewModel *plant in content) {

            //call service to update the plant status.
            [self updatePlantStatus: plant];
        }
    }
}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Instantiate method

+ ( MainViewController* )instantiate
{
    return [[ MainViewController alloc]  initWithNibName:[MainViewController viewToDevice:@"MainView"] bundle:nil];
}

#pragma mark - ACTIONS BUTTONS

- (IBAction)showSettingView:(id)sender {
    
    if( !_settingsView ){
        _settingsView = [SettingsViewController instantiate];
    }
    
    [_settingsView.view setAlpha:0.0f];
    
    [self.view addSubview: _settingsView.view];
    
    [Utils fadeIn:_settingsView.view completion:nil];
}


- (IBAction)onNewPlantTouchUpInside:(id)sender{
        
   if(!_configureViewController){
       _configureViewController = [ConfigureViewController instantiate];
       [_configureViewController setDelegate:self];
   }
   
   [_configureViewController.view setAlpha: 0.0];
   [self.navigationController.view addSubview:_configureViewController.view];
   _configureViewController.plantViewModel = nil;
   
   if(!_manager){
       _manager = [[Manager alloc] init];
   }
   
   _configureViewController.huiViewModel = nil;
   
   [_configureViewController initConfigureView];
   
   [Utils fadeIn:_configureViewController.view completion:nil];
   
}

- (IBAction)showWalkthrough:(id)sender {
    
    WalkThroughViewController *walkthrough = [WalkThroughViewController instantiate];
    
    WalkthroughPageViewController *page_one = [[WalkthroughPageViewController alloc]initWithNibName:[Utils viewToDevice:@"WalkOne"] bundle:nil];
    WalkthroughPageViewController *page_two = [[WalkthroughPageViewController alloc]initWithNibName:[Utils viewToDevice:@"WalkTwo"] bundle:nil];
    CustomPageViewController *page_three = [[CustomPageViewController alloc]initWithNibName:[Utils viewToDevice:@"WalkThree"] bundle:nil];
    WalkthroughPageViewController *page_fourth = [[WalkthroughPageViewController alloc]initWithNibName:[Utils viewToDevice:@"WalkFourth"] bundle:nil];
    CustomPageViewController *page_fifth = [[CustomPageViewController alloc]initWithNibName:[Utils viewToDevice:@"WalkFifth"] bundle:nil];
    WalkthroughPageViewController *page_zero = [[WalkthroughPageViewController alloc]initWithNibName:[Utils viewToDevice:@"WalkZero"] bundle:nil];
    
    // Attach the pages to the master
    walkthrough.delegate = self;
    
    [walkthrough addViewController:page_one];
    [walkthrough addViewController:page_two];
    [walkthrough addViewController:page_three];
    [walkthrough addViewController:page_fourth];
    [walkthrough addViewController:page_fifth];
    [walkthrough addViewController:page_zero];
    
    [self presentViewController:walkthrough animated:YES completion:nil];
}

- (void) showHUIAssistant{

    if(!_askHuiViewController){
        _askHuiViewController = [[AskHuiViewController alloc] init];
    }
    
    [_askHuiViewController.view setAlpha: 0.0];
    
    [self.navigationController.view addSubview:_askHuiViewController.view];
    
    [Utils fadeIn:_askHuiViewController.view completion:nil];
}


- (IBAction) onAskHuiTouchUpInside:(id)sender{
    
    diagnosticStatus = NO;
    newPLantStatus = NO;
    
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_HUD];
    
    _HUD.delegate = self;
    _HUD.labelText = @"Loading";
    
    [_HUD showWhileExecuting:@selector(showHUIAssistant) onTarget:self withObject:nil animated:YES];
}

#pragma mark - Delegate AskHUI

- (void) onBackAskTouchUpInside{
    
    [Utils fadeOut:_askHuiViewController.view
        completion:^(BOOL completion){
        [_askHuiViewController.view removeFromSuperview];
        [newPlantButton setEnabled: YES];
        [_askHuiButton setEnabled: YES];
    }];
}

- (void) diagnosticPhase {
    [Utils fadeOut:_askHuiViewController.view
        completion:^(BOOL completion){
        [_askHuiViewController.view removeFromSuperview];
        [newPlantButton setEnabled: NO];
        [_askHuiButton setEnabled: NO];
    }];
    diagnosticStatus = YES;
}

- (void) newPlantPhase {
    [Utils fadeOut:_askHuiViewController.view
        completion:^(BOOL completion){
            [_askHuiViewController.view removeFromSuperview];
            [newPlantButton setEnabled: YES];
            [_askHuiButton setEnabled: YES];
        }];
    newPLantStatus = YES;
    [self onNewPlantTouchUpInside:nil];
}

- (void) filterPlant:(NSString* )filterSearchText withSensor:(int)sensor withHUI:(HUIViewModel *)huiViewModel {
    
    [Utils fadeOut:_askHuiViewController.view completion:^(BOOL finisehd){
        _searchPlantViewController.sensor = sensor;
        _searchPlantViewController.huiViewModel = huiViewModel;
        _searchPlantViewController.filter = filterSearchText;
        [self.navigationController pushViewController:_searchPlantViewController animated:YES];
    }];

}

#pragma mark - Delegate Walk

- (void)walkthroughCloseButtonPressed
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)walkthroughNextButtonPressed
{
    NSLog(@"Next");
}

- (void)walkthroughPrevButtonPressed
{
    NSLog(@"Prev");
}

- (void)walkthroughPageDidChange:(NSInteger)pageNumber
{
    NSLog(@"%ld",(long)pageNumber);
}

#pragma mark - Delegate Search

- (void)onSelectPlant:(NSDictionary*) plantObject
     withHuiViewModel:(HUIViewModel *) huiViewModel
             inSensor:(int) sensor
          plantStatus:(NSString* ) status {
    
    /* create the new plant with empty values */
    PlantViewModel* plantViewModel = [[PlantViewModel alloc] init];
    plantViewModel = [PlantViewModel initEmptyPlant:plantObject andPosition: [NSNumber numberWithLong: 0]];
    
    // set newHUI with the plant in the sensor
    switch (sensor) {
        case 1:
            [huiViewModel setSensor1:[plantViewModel getIdentify]];
            break;
            
        case 2:
            [huiViewModel setSensor2:[plantViewModel getIdentify]];
            break;
            
        case 3:
            [huiViewModel setSensor3:[plantViewModel getIdentify]];
            break;
    }
    
    if(!_manager){
        _manager = [[Manager alloc] init];
    }
    
    // HUI CONFIGURATE check if HUI exists
    if([_manager getHuiWithId:[huiViewModel getIdentify]]){
        /* UPDATE DATA */
        [_manager updateHui: huiViewModel
         withPlantViewModel: plantViewModel
                   inSensor: sensor];
    }else{
        /* Save HUI DATA */
        [_manager setHUI: huiViewModel
      withPlantViewModel: plantViewModel
              withSensor: sensor];
    }
    
    // set HUI in plant
    [plantViewModel setHuiId:[huiViewModel getIdentify]];
    
    [plantViewModel setGrowing: status];
    
    [_manager setPlant: plantViewModel];
    
    [self addNewPlant: plantViewModel];
    
    // send HUI CONFIGURATION
    [self saveHUIInServer: huiViewModel];
    
    // send plant to server
    [_coreServices postNewPlant: plantViewModel withHuiModel: huiViewModel];
    
}

#pragma mark - Delegate PlantView

- (void)showPlantDetail:(PlantViewModel*) plantViewModel{
    
    if(!diagnosticStatus){
        _detailPlantViewController.title = [plantViewModel getName];
        _detailPlantViewController.plantViewModel = plantViewModel;
        _detailPlantViewController.position = [plantViewModel getPosition];
        
        [self.navigationController pushViewController:_detailPlantViewController animated:YES];
    }else{
        _askHuiViewController.diagnosticStatus = YES;
        _askHuiViewController.plantViewModel = plantViewModel;
        [self showHUIAssistant];
        [_askHuiViewController onSelectPlantToDiagnosticReturnBack];
        diagnosticStatus = NO;
    }
}

#pragma mark - DeleteFromGarden

-(void) removePlantFromBBDDAndCollectionWithId:(NSString* )plantId{
    
    for (PlantViewModel *plant in _plantsCollection) {
        
        if([[plant getIdentify] isEqualToString: plantId]){
            //remove HUI sensor
            [_manager removePlantInHUISensor:plant];
            
            // remove from BBDD
            [_manager removePlant:plant];
            
            // remove from NSMutableArray
            [_plantsCollection removeObject: plant];
            break;
        }
    }
}

#pragma mark - Delegate DetailPlant
- (void)deletePlant:(NSNumber *)identify withId:(NSString *)plantId{
    _isDeleteMode = YES;
    
    /* DELETE PLANT FROM SERVER */
    
    if(!_coreServices){
        _coreServices = [[CoreServices alloc] init];
    }
    
    if(!_manager){
        _manager = [[Manager alloc] init];
    }
    
    for (PlantViewModel *plant in _plantsCollection) {
        if([[plant getIdentify] isEqualToString: plantId]){
            
            [_coreServices deletePlant: plant withHuiModel:[_manager getHuiWithId:[plant getHuiId]]];
        }
    }
    
    [self removePlantFromBBDDAndCollectionWithId:plantId];
    
    for (PlantViewController* plantViewController in _plantsViewControllerCollection){
        
        [plantViewController.view removeFromSuperview];
    }
    
    [_plantsCollection removeAllObjects];
    [_plantsViewControllerCollection removeAllObjects];
    
    _plantsCollection = nil;
    _plantsViewControllerCollection = nil;
    
    _plantsCollection = [[NSMutableArray alloc] init];
    _plantsViewControllerCollection = [[NSMutableArray alloc] init];
    
    self.numberOfPlants = [NSNumber numberWithInt: 0];
    
    [self initializeContent];
}

-(void)globalStatus:(int)status withPlantViewModel:(PlantViewModel *)plantViewModel{

    int position = 0;

    for (PlantViewModel* plant in _plantsCollection){
        
        if( ![[plant getIdentify] isEqualToString:[plantViewModel getIdentify]]){
            position ++;
        }else{
            break;
        }
    }

    if(status == 1){
        [[_plantsViewControllerCollection objectAtIndex:position] setStatusKo ];
    }else if(status == 0){
        [[_plantsViewControllerCollection objectAtIndex:position] setStatusOk ];
    }else{
        [[_plantsViewControllerCollection objectAtIndex:position] setStatusUndefined ];
    }
    
   [_manager setStatusPlant:[NSString stringWithFormat:@"%d", status] inPlant:[_plantsCollection objectAtIndex:position]];
}


#pragma mark - PlantViewsController

- (void)addNewPlant:(PlantViewModel*) plant{
    
    int localNumberOfPlants = [self.numberOfPlants intValue];
    
    // add plant to collection
    
    if (localNumberOfPlants < 16){
        
        PlantViewController* newPlantViewController = [PlantViewController instantiate];
        newPlantViewController.plantName = [plant getName];
        newPlantViewController.delegate = self;
        newPlantViewController.position = [NSNumber numberWithInteger:[_plantsViewControllerCollection count]];

        // calculate the correct position
        if([self.numberOfPlants integerValue] == 0)
        {
            _positionX = INITIAL_POINT_X + 70;
            _positionY = INITIAL_POINT_Y;
        }else if (([self.numberOfPlants integerValue] + 1) % 2 == 0)
        {
            [((PlantViewController*) [_plantsViewControllerCollection objectAtIndex:0]).view setFrame:CGRectMake(INITIAL_POINT_X, INITIAL_POINT_Y, newPlantViewController.view.frame.size.width, newPlantViewController.view.frame.size.height)];
            _positionX = INITIAL_POINT_X + WIDTH_PLANT - 7;
        
        }else{
            _positionX = INITIAL_POINT_X;
            _positionY = _positionY + HEIGHT_PLANT + 10;
        }

        [_plantsCollection addObject:plant];
        [_plantsViewControllerCollection addObject: newPlantViewController];
        
        [plant setPosition: [NSNumber numberWithInteger:[_plantsViewControllerCollection count]]];
        
        [newPlantViewController.view setFrame:CGRectMake(_positionX, _positionY, newPlantViewController.view.frame.size.width, newPlantViewController.view.frame.size.height)];
        
        [plantsScrollView addSubview:newPlantViewController.view];
        
        if ((([self.numberOfPlants integerValue]+ 1) % 5 == 0) || (([self.numberOfPlants integerValue]+ 1) % 7 == 0)){
            plantScrollViewControllerHeight = plantScrollViewControllerHeight + HEIGHT_PLANT;
            
            [plantsScrollView setContentSize:CGSizeMake(plantsScrollView.frame.size.width, plantsScrollView.frame.size.height + plantScrollViewControllerHeight)];
        }
        
        [newPlantViewController setPlantImageFromServer];
        
        if ([[plant getStatus]isEqual:@"0"]){
            [newPlantViewController setStatusOk];
        }else if ([[plant getStatus]isEqual:@"1"]){
            [newPlantViewController setStatusKo];
        }else{
            [newPlantViewController setStatusUndefined];
        }
        
        newPlantViewController.plantViewModel = plant;
        
        self.numberOfPlants = [NSNumber numberWithInt: localNumberOfPlants + 1];
       
        if(IS_STANDARD_IPHONE_6)
            [_askHuiButton setFrame: FRAME_ASK_HUI_BUTTON_FIRST_POSITION_2X];
        else if(IS_STANDARD_IPHONE_6_PLUS)
            [_askHuiButton setFrame: FRAME_ASK_HUI_BUTTON_FIRST_POSITION_3X];
        else
            [_askHuiButton setFrame: FRAME_ASK_HUI_BUTTON_FIRST_POSITION];
        
        // calculate newPlantButton Frame
        if ([self.numberOfPlants integerValue]==0){
            if( IS_STANDARD_IPHONE_6)
                [newPlantButton setFrame: FRAME_NEW_PLANT_1_PLANT_2X];
            else if( IS_STANDARD_IPHONE_6_PLUS)
                [newPlantButton setFrame: FRAME_NEW_PLANT_1_PLANT_3X];
            else
                [newPlantButton setFrame: FRAME_NEW_PLANT_1_PLANT];
        }else if ([self.numberOfPlants integerValue] < 2){
            
            if( IS_STANDARD_IPHONE_6)
                [newPlantButton setFrame: FRAME_NEW_PLANT_2_PLANT_2X];
            else if( IS_STANDARD_IPHONE_6_PLUS)
                [newPlantButton setFrame: FRAME_NEW_PLANT_2_PLANT_3X];
            else
                [newPlantButton setFrame: FRAME_NEW_PLANT_2_PLANT];
        
        }else if ([self.numberOfPlants integerValue] == 3){
            if( IS_STANDARD_IPHONE_6){
                [newPlantButton setFrame: FRAME_NEW_PLANT_3_PLANT_2X];
            }else if( IS_STANDARD_IPHONE_6_PLUS){
                [newPlantButton setFrame: FRAME_NEW_PLANT_3_PLANT_3X];
            }else{
                [newPlantButton setFrame: FRAME_NEW_PLANT_3_PLANT];
            }
        }
        else if ([self.numberOfPlants integerValue] >= 4){
            if( IS_STANDARD_IPHONE_6){
                [_askHuiButton setFrame: FRAME_ASK_HUI_BUTTON_FINAL_POSITION_2X];
                [newPlantButton setFrame: FRAME_NEW_PLANT_4_PLANT_2X];
            }else if( IS_STANDARD_IPHONE_6_PLUS){
                [_askHuiButton setFrame: FRAME_ASK_HUI_BUTTON_FINAL_POSITION_3X];
                [newPlantButton setFrame: FRAME_NEW_PLANT_4_PLANT_3X];
            }else{
                [_askHuiButton setFrame: FRAME_ASK_HUI_BUTTON_FINAL_POSITION];
                [newPlantButton setFrame: FRAME_NEW_PLANT_4_PLANT];
            }
            
            
        }
        
    }else{
        NSLog(@"Limit exceeded, you have to delete or modify a plant before add new one");
    }
}

#pragma mark - BBDD methods

- (void) initializeContent{
    
    if(!_manager)
    {
        _manager = [[Manager alloc] init];
    }
    
    NSMutableArray* content = [_manager getPlantsFromBBDD];
    
    if([content count] != 0){
    
        for (PlantViewModel *plant in content) {
        
            [self addNewPlant:plant];
        
            //call service to update the plant status.
            if(!_isDeleteMode)
                [self updatePlantStatus: plant];
            else
                _isDeleteMode = NO;
        }
    }else{
        //initialize button AddNewPlant
        
        if (IS_STANDARD_IPHONE_6){
            [newPlantButton setFrame: FRAME_NEW_PLANT_2X];
            [_askHuiButton setFrame: FRAME_ASK_HUI_BUTTON_FIRST_POSITION_2X];
        }
        else if (IS_STANDARD_IPHONE_6_PLUS){
            [newPlantButton setFrame: FRAME_NEW_PLANT_3X];
            [_askHuiButton setFrame: FRAME_ASK_HUI_BUTTON_FIRST_POSITION_3X];
        }
        else{
            [newPlantButton setFrame: FRAME_NEW_PLANT];
            [_askHuiButton setFrame: FRAME_ASK_HUI_BUTTON_FIRST_POSITION];
        }
    }
    
    // setinitialStatus if there is no status
    if(![[_manager getStatus] getLanguage]){
        [_manager setInitialStatus];
    }
}

#pragma mark -socket test

- (IBAction)onSocketTouchUpInside:(id)sender{
    SocketConnectionVC * socketVC = [[SocketConnectionVC alloc] initWithNibName:@"SocketConnectionView" bundle:nil];
    [self.navigationController pushViewController:socketVC animated:YES];
}


#pragma mark - Configure HUI Methods


-(void)closeConfiguration:(HUIViewModel*)huiViewModel withSensor:(int)sensor{
    
    if(!newPLantStatus){
        [Utils fadeOut:_configureViewController.view completion:^(BOOL finisehd){
            
            _searchPlantViewController.sensor = sensor;
            _searchPlantViewController.huiViewModel = huiViewModel;
            _searchPlantViewController.filter = @"";
            
            [self.navigationController pushViewController:_searchPlantViewController animated:YES];
        }];
    } else {
        [_configureViewController.view removeFromSuperview];
        _askHuiViewController.diagnosticStatus = NO;
        _askHuiViewController.newPlantStatus = NO;
        _askHuiViewController.huiViewModel = huiViewModel;
        _askHuiViewController.sensor = sensor;
        [self showHUIAssistant];
        [_askHuiViewController onNewPlantReturnBack];
        diagnosticStatus = NO;
        newPLantStatus = NO;
    }
}

- (void) cancelConfiguration{
    [Utils fadeOut:_configureViewController.view completion:^(BOOL finisehd){
    }];
}

- (void) removePlantInSensor:(NSString *)plantId{

    [self deletePlant:0 withId:plantId];
}

#pragma mark SERVICE METHODS

- (void) saveHUIInServer:(HUIViewModel *)huiViewModel {
    
    if (!_coreServices){
        _coreServices = [[CoreServices alloc] init];
        [_coreServices setDelegate: self];
    }
    
    // cut the last a.m
    NSString* notificationTime = [huiViewModel getNotificationTime];
    NSString *notificationTimeSort = [notificationTime substringToIndex:[notificationTime length] - 6];
    
    
    StatusViewModel* statusFromBBDD = [[StatusViewModel alloc] init];
    
    statusFromBBDD = [_manager getStatus];
    
    
    NSMutableDictionary* postNewHuiObject = [[NSMutableDictionary alloc]
                                             initWithDictionary:
                                             @{@"notificationTime": notificationTimeSort,
                                               @"deviceID": [statusFromBBDD getDeviceID],
                                               @"countryCode": [statusFromBBDD getCountry],
                                               @"huiID": [huiViewModel getName],
                                               @"waterAlarm": [statusFromBBDD getWaterAlarm],
                                               @"timeZone": [statusFromBBDD getTimeZone],
                                               @"longitude": [statusFromBBDD getLongitude],
                                               @"latitude": [statusFromBBDD getLatitude],
                                               @"keyGCM": [statusFromBBDD getKeyGTM],
                                               @"city": [statusFromBBDD getCity],
                                               @"country": [statusFromBBDD getCountry],
                                               @"huiKey": [huiViewModel getNumber]
                                               }
                                             ];
    
    [_coreServices postNewHUI: postNewHuiObject];
}

#pragma mark - sync methods from server

- (void) updatePlantStatus:(PlantViewModel* )plant{
    
    if(!_coreServices){
        _coreServices = [[CoreServices alloc] init];
        [_coreServices setDelegate: self];
    }
    
    //dispatch_async(dispatch_get_main_queue(), ^{
        [_coreServices getPlantState:plant withHui:[_manager getHuiWithId:[plant getHuiId]] withStatus:[_manager getStatus]];
    //});
}

#pragma mark - Delegate CoreServices

- (void)answerFromServer:(NSDictionary *)response{
    NSLog(@"Response from Server NEW HUI: %@", response);
    
    NSDictionary* light = [response objectForKey:@"Light"];
    NSDictionary* moisture = [response objectForKey:@"Moisture"];
    NSDictionary* temperature = [response objectForKey:@"Temperature"];
    
    if( light ){
        //update status plant
        [self updatePlantStatusFromServer:light :moisture :temperature];
    }
}

- ( void )updatePlantStatusFromServer: (NSDictionary *)light :(NSDictionary* ) moisture :(NSDictionary* ) temperature{
    
    int globalStatus = 0;
    
    if([[temperature objectForKey:@"Alert"] isEqualToString:@"unknown"]){
        globalStatus = -1;
    }else{
        if([[temperature objectForKey:@"Alert"] isEqualToString:@"true"]){
            globalStatus = 1;
        }
    }
    
    if( globalStatus == 0){
        if([[moisture objectForKey:@"Alert"] isEqualToString:@"unknown"]){
            globalStatus = -1;
        }else{
            if([[moisture objectForKey:@"Alert"] isEqualToString:@"true"]){
                globalStatus = 1;
            }
        }
    }
    
    if( globalStatus == 0){
        if([[light objectForKey:@"Alert"] isEqualToString:@"unknown"]){
            globalStatus = -1;
        }else{
            if([[light objectForKey:@"Alert"] isEqualToString:@"true"]){
                globalStatus = 1;
            }
        }
    }
    
    
    if(globalStatus == 1){
        [[_plantsViewControllerCollection objectAtIndex:countPlantFromServer] setStatusKo ];
    }else if(globalStatus == 0){
        [[_plantsViewControllerCollection objectAtIndex:countPlantFromServer] setStatusOk ];
    }else{
        [[_plantsViewControllerCollection objectAtIndex:countPlantFromServer] setStatusUndefined ];
    }
    
    [_manager setStatusPlant:[NSString stringWithFormat:@"%d", globalStatus] inPlant:[_plantsCollection objectAtIndex:countPlantFromServer]];
    
    countPlantFromServer ++;
}

#pragma mark - NOTIFICATIONS METHODS

- (void) addNotificationObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(onReciveNotificationFromServer:)
                                                 name:@"NOTIFICATION_FROM_SERVER"
                                               object:nil];
}

- (void)onReciveNotificationFromServer:(NSNotification *)notification{
    NSDictionary *userInfo = [[[notification userInfo] objectForKey:@"aps" ] objectForKey:@"alert"];
    
    NSString* alertmessage = [userInfo objectForKey:@"body"];
    NSString* titleAlert = [userInfo objectForKey:@"title"];
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle: titleAlert
                                  message: alertmessage
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:NSLocalizedString(@"Ok", nil)
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    
                                    NSInteger numberOfBadges = [UIApplication sharedApplication].applicationIconBadgeNumber;
                                    
                                    numberOfBadges -=1;
                                    
                                    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:numberOfBadges];
                                    
                                    [alert dismissViewControllerAnimated:YES completion:nil];
                                }];

    

    [alert addAction:yesButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}



@end
