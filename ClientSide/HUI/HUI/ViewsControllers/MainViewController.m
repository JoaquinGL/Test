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

@interface MainViewController (){
    SearchPlantViewController* _searchPlantViewController;
    DetailPlantViewController* _detailPlantViewController;
    
    PlantViewController* _plant0ViewController;
    PlantViewController* _plant1ViewController;
    PlantViewController* _plant2ViewController;
    
    AskHuiViewController* _askHuiViewController;
    
    ConfigureViewController* _configureViewController;
    
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
#define FRAME_NEW_PLANT_4_PLANT CGRectMake(10, 475, 80, 80)
#define FRAME_ASK_HUI_BUTTON_FIRST_POSITION CGRectMake(110, 475, 80, 80)
#define FRAME_ASK_HUI_BUTTON_FINAL_POSITION CGRectMake(230, 475, 80, 80)

@implementation MainViewController

@synthesize navigationController = _navigationController,
            numberOfPlants = _numberOfPlants;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customInit];
}


- (void)customInit {
    
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
    [newPlantButton addTarget:self action:@selector(showSearchPlantOnTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [newPlantButton setBackgroundImage:[UIImage imageNamed:@"plant_something_new.png"] forState:UIControlStateNormal];
    
    [self.view addSubview: newPlantButton];
    
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
    
    [_askHuiButton setFrame:FRAME_ASK_HUI_BUTTON_FIRST_POSITION];
    
    /* GET CONTENT FROM BBDD */
    [self initializeContent];
    
    
    plantScrollViewControllerHeight = 0;
    
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
    return [[ MainViewController alloc]  initWithNibName:@"MainView" bundle:nil];
}

#pragma mark - ACTIONS BUTTONS

- (IBAction)showSearchPlantOnTouchUpInside:(id)sender{
        
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
    
    WalkThroughViewController *walkthrough = [[WalkThroughViewController alloc]init];
    
    WalkthroughPageViewController *page_one = [[WalkthroughPageViewController alloc]initWithNibName:@"WalkOne" bundle:nil];
    WalkthroughPageViewController *page_two = [[WalkthroughPageViewController alloc]initWithNibName:@"WalkTwo" bundle:nil];
    CustomPageViewController *page_three = [[CustomPageViewController alloc]initWithNibName:@"WalkThree" bundle:nil];
    WalkthroughPageViewController *page_zero = [[WalkthroughPageViewController alloc]initWithNibName:@"WalkZero" bundle:nil];
    
    // Attach the pages to the master
    walkthrough.delegate = self;
    
    [walkthrough addViewController:page_one];
    [walkthrough addViewController:page_two];
    [walkthrough addViewController:page_three];
    [walkthrough addViewController:page_zero];
    
    [self presentViewController:walkthrough animated:YES completion:nil];
}

- (IBAction) onAskHuiTouchUpInside:(id)sender{
    
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_HUD];
    
    _HUD.delegate = self;
    _HUD.labelText = @"Loading";
    
    [_HUD showWhileExecuting:@selector(showHUIAssistant) onTarget:self withObject:nil animated:YES];
}

- (void) showHUIAssistant{

    [_askHuiViewController.view setAlpha: 0.0];
    [self.navigationController.view addSubview:_askHuiViewController.view];
    
    [Utils fadeIn:_askHuiViewController.view completion:nil];
}


#pragma mark - DELEGATE AskHUI

- (void) onBackAskTouchUpInside{
    
    [Utils fadeOut:_askHuiViewController.view
        completion:^(BOOL completion){
        [_askHuiViewController.view removeFromSuperview];
    }];
}

#pragma mark - DELEGATE Walk

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

- (void)onSelectPlant:(NSString*) plantName{
    
    /* create the new plant with empty values */
    
    PlantViewModel* plantViewModel = [[PlantViewModel alloc] init];
    
    plantViewModel = [PlantViewModel initEmptyPlantWithName: plantName andPosition: [NSNumber numberWithLong: 0]];
    
    /* Add empty plant*/
    if(!_manager)
    {
        _manager = [[Manager alloc] init];
    }
    
    [_manager setPlant: plantViewModel];
    
    [self addNewPlant: plantViewModel];
}

#pragma mark - Delegate PlantView

- (void)showPlantDetail:(PlantViewModel*) plantViewModel{
    
    _detailPlantViewController.title = [plantViewModel getName];
    _detailPlantViewController.plantViewModel = plantViewModel;
    _detailPlantViewController.position = [plantViewModel getPosition];
    
    [self.navigationController pushViewController:_detailPlantViewController animated:YES];
}
#pragma mark - DeleteFromGarden

-(void) removePlantFromBBDDAndCollectionWithId:(NSString* )plantId{
    
    for (PlantViewModel *plant in _plantsCollection) {
        
        if([plant getIdentify] == plantId){
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
        }
    }

    if(status == 1){
        [[_plantsViewControllerCollection objectAtIndex:position] setStatusKo ];
    }else{
        [[_plantsViewControllerCollection objectAtIndex:position] setStatusOk ];
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
        
        
        [newPlantViewController setPlantImageFromName:[plant getName]];
        
        if ([[plant getStatus]isEqual:@"0"]){
            [newPlantViewController setStatusOk];
        }else if ([[plant getStatus]isEqual:@"1"]){
            [newPlantViewController setStatusKo];
        }else{
            [newPlantViewController setStatusUndefined];
        }
        
        newPlantViewController.plantViewModel = plant;
        
        self.numberOfPlants = [NSNumber numberWithInt: localNumberOfPlants + 1];
       
        [_askHuiButton setFrame: FRAME_ASK_HUI_BUTTON_FIRST_POSITION];
        
        // calculate newPlantButton Frame
        if ([self.numberOfPlants integerValue]==0){
            [newPlantButton setFrame: FRAME_NEW_PLANT_1_PLANT];
        }else if ([self.numberOfPlants integerValue] < 2){
            [newPlantButton setFrame: FRAME_NEW_PLANT_2_PLANT];
        }else if ([self.numberOfPlants integerValue] == 3){
            [newPlantButton setFrame: FRAME_NEW_PLANT_3_PLANT];
        }
        else if ([self.numberOfPlants integerValue] >= 4){
            [_askHuiButton setFrame: FRAME_ASK_HUI_BUTTON_FINAL_POSITION];
            [newPlantButton setFrame: FRAME_NEW_PLANT_4_PLANT];
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
        }
    }else{
        //initialize button AddNewPlant
        [newPlantButton setFrame: FRAME_NEW_PLANT];
    }
}

#pragma mark -socket test

- (IBAction)onSocketTouchUpInside:(id)sender{
    SocketConnectionVC * socketVC = [[SocketConnectionVC alloc] initWithNibName:@"SocketConnectionView" bundle:nil];
    [self.navigationController pushViewController:socketVC animated:YES];
}


#pragma mark - Configure HUI Methods


-(void)closeConfiguration:(HUIViewModel*)huiViewModel{
    
    if(huiViewModel){
        if([huiViewModel getIdentify]){
            /* UPDATE DATA */
            [_manager updateHui:huiViewModel withPlantViewModel:nil];
        }else{
            /* Save HUI DATA */
            if(!_manager){
                _manager = [[Manager alloc] init];
            }
            
            
            int sensorFree = [_manager getHuiSensorFree:[huiViewModel getIdentify]];
            
            if (sensorFree != -1){
                
                [_manager setHUI: huiViewModel
              withPlantViewModel: nil
                      withSensor: sensorFree];
                
            }else{
                // assing new plant to new sensor, the user has to select the new sensor.
                
                // TODO, do the logic, selec one of the tree selectors.
                
                sensorFree = 2;
                
                [_manager setHUI: huiViewModel
              withPlantViewModel: nil
                      withSensor: sensorFree];
            }
        }
    }
    // we update or configure the HUI, now we can set the plant.
    // SHOW THE PLANTS LIST
    
    [Utils fadeOut:_configureViewController.view completion:^(BOOL finisehd){
        [self.navigationController pushViewController:_searchPlantViewController animated:YES];
    }];
    
}

- (void) cancelConfiguration{
    [Utils fadeOut:_configureViewController.view completion:^(BOOL finisehd){
    }];
}




@end
