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


@interface MainViewController (){
    SearchPlantViewController* _searchPlantViewController;
    DetailPlantViewController* _detailPlantViewController;
    
    PlantViewController* _plant0ViewController;
    PlantViewController* _plant1ViewController;
    PlantViewController* _plant2ViewController;
    
    AskHuiViewController* _askHuiViewController;
    
    IBOutlet UIButton* newPlantButton;
    
    MBProgressHUD* _HUD;
    
    Manager* _manager;
    
    NSMutableArray* _plantsCollection;
    NSMutableArray* _plantsViewControllerCollection;
    
    NSInteger _positionX;
    NSInteger _positionY;
    
}

@end

#define WIDTH_PLANT 160
#define HEIGHT_PLANT 160
#define INITIAL_POINT_X 20
#define INITIAL_POINT_Y 80
#define FRAME_NEW_PLANT CGRectMake(80, 130, WIDTH_PLANT, HEIGHT_PLANT)
#define FRAME_NEW_PLANT_1_PLANT CGRectMake(80, 260, WIDTH_PLANT, HEIGHT_PLANT)
#define FRAME_NEW_PLANT_2_PLANT CGRectMake(80, 260, WIDTH_PLANT, HEIGHT_PLANT)
#define FRAME_NEW_PLANT_3_PLANT CGRectMake(180, 260, 120, 120)

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
    
    
    /* GET CONTENT FROM BBDD */
    [self initializeContent];
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
    
    [self.navigationController pushViewController:_searchPlantViewController animated:YES];
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
    
    [_plantsCollection addObject: plantViewModel];
    
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

#pragma mark - PlantViewsController

- (void)addNewPlant:(PlantViewModel*) plant{
    
    int localNumberOfPlants = [self.numberOfPlants intValue];
    
    // add plant to collection
    
    if (localNumberOfPlants < 3){
        
        PlantViewController* newPlantViewController = [PlantViewController instantiate];
        newPlantViewController.plantName = [plant getName];
        newPlantViewController.delegate = self;
        newPlantViewController.position = [NSNumber numberWithInteger:[_plantsViewControllerCollection count]];

        // calculate the correct position
        if([self.numberOfPlants integerValue] == 0)
        {
            _positionX = INITIAL_POINT_X + 70;
            _positionY = INITIAL_POINT_Y;
        }else if ([self.numberOfPlants integerValue] % 2)
        {
            [((PlantViewController*) [_plantsViewControllerCollection objectAtIndex:0]).view setFrame:CGRectMake(INITIAL_POINT_X, INITIAL_POINT_Y, newPlantViewController.view.frame.size.width, newPlantViewController.view.frame.size.height)];
            _positionX = INITIAL_POINT_X + WIDTH_PLANT - 7;
            _positionY = INITIAL_POINT_Y;
        
        }else{
            _positionX = INITIAL_POINT_X;
            _positionY = _positionY + HEIGHT_PLANT + 10;
        }

        [_plantsCollection addObject:plant];
        [_plantsViewControllerCollection addObject: newPlantViewController];
        
        [plant setPosition: [NSNumber numberWithInteger:[_plantsViewControllerCollection count]]];
        
        [newPlantViewController.view setFrame:CGRectMake(_positionX, _positionY, newPlantViewController.view.frame.size.width, newPlantViewController.view.frame.size.height)];
        
        // showWithAnimationTheView
        [self.view addSubview:newPlantViewController.view];
        
        [newPlantViewController setPlantImageFromName:[plant getName]];
        [newPlantViewController setStatusUndefined];
        newPlantViewController.plantViewModel = plant;
        
        // add plantsViewController to collection
        [_plantsViewControllerCollection addObject: newPlantViewController];
        
        self.numberOfPlants = [NSNumber numberWithInt: localNumberOfPlants + 1];
       
        // calculate newPlantButton Frame
        if ([self.numberOfPlants integerValue]==0){
            [newPlantButton setFrame: FRAME_NEW_PLANT_1_PLANT];
        }else if ([self.numberOfPlants integerValue] < 2){
            [newPlantButton setFrame: FRAME_NEW_PLANT_2_PLANT];
        }else if ([self.numberOfPlants integerValue] == 3){
            [newPlantButton setFrame: FRAME_NEW_PLANT_3_PLANT];
        }else{
            [newPlantButton setFrame: FRAME_NEW_PLANT_1_PLANT];
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

@end
