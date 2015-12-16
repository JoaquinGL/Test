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
}

@end

#define FRAME_NEW_PLANT CGRectMake(80, 70, 160, 160)
#define FRAME_NEW_PLANT_1_PLANT CGRectMake(80, 190, 160, 160)
#define FRAME_NEW_PLANT_2_PLANT CGRectMake(80, 200, 160, 160)
#define FRAME_NEW_PLANT_3_PLANT CGRectMake(180, 220, 120, 120)

@implementation MainViewController

@synthesize navigationController = _navigationController,
            numberOfPlants = _numberOfPlants;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customInit];
}


- (void)customInit {
    
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
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"title.png"] forBarMetrics:UIBarMetricsDefault];
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


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear: animated];
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

-(void) removePlantFromBBDDAndCollection:(NSMutableArray* )collection withId:(NSString* )plantId{
    
    for (PlantViewModel *plant in collection) {
        
        if([plant getIdentify] == plantId){
            // remove from BBDD
            [_manager removePlant:plant];
            
            // remove from NSMutableArray
            [collection removeObject: plant];
            break;
        }
    }
}

#pragma mark - Delegate DetailPlant
- (void)deletePlant:(NSNumber *)identify withId:(NSString *)plantId{
    
    int orderOfDelete = [identify intValue];
    
    [self removePlantFromBBDDAndCollection:_plantsCollection withId:plantId];
    
    switch (orderOfDelete) {
        case 0:
            if( [self.numberOfPlants intValue] == 3){
                
                _plant2ViewController.view.frame = _plant1ViewController.view.frame;
                _plant1ViewController.view.frame = _plant0ViewController.view.frame;
                
                [_plant1ViewController.plantViewModel setPosition:[NSNumber numberWithInt: 0]];
                [_plant2ViewController.plantViewModel setPosition:[NSNumber numberWithInt: 1]];
                
                [_plant0ViewController.view removeFromSuperview];
                _plant0ViewController = _plant1ViewController;
                _plant1ViewController = _plant2ViewController;
                
                _plant2ViewController = nil;
                
                [newPlantButton setFrame: FRAME_NEW_PLANT_1_PLANT];
                
            }else if( [self.numberOfPlants intValue] == 2){
            
                _plant1ViewController.view.frame = _plant0ViewController.view.frame;
                _plant1ViewController.identify =_plant0ViewController.identify;
                
                [_plant0ViewController.view removeFromSuperview];
                _plant0ViewController = _plant1ViewController;
                
                [_plant0ViewController.plantViewModel setPosition:[NSNumber numberWithInt: 0]];
                
                _plant1ViewController = nil;
                
                [_plant0ViewController.view setFrame:CGRectMake(95, 20, _plant0ViewController.view.frame.size.width, _plant0ViewController.view.frame.size.height)];
                
                [newPlantButton setFrame: FRAME_NEW_PLANT_1_PLANT];
                
            }else{
                
                [_plant0ViewController.view removeFromSuperview];
                _plant0ViewController = nil;
                
                [newPlantButton setFrame: FRAME_NEW_PLANT];
                
            }
            
            break;
            
        case 1:
            
            if( [self.numberOfPlants intValue] == 3){
                
                _plant2ViewController.view.frame = _plant1ViewController.view.frame;
                
                [_plant1ViewController.view removeFromSuperview];
                _plant1ViewController = _plant2ViewController;
                
                [_plant1ViewController.plantViewModel setPosition:[NSNumber numberWithInt: 1]];
                
                _plant2ViewController = nil;
                
            }else if( [self.numberOfPlants intValue] == 2){
                
                [_plant0ViewController.view setFrame:CGRectMake(95, 20, _plant0ViewController.view.frame.size.width, _plant0ViewController.view.frame.size.height)];
                
                [_plant0ViewController.plantViewModel setPosition:[NSNumber numberWithInt: 0]];
                
                [_plant1ViewController.view removeFromSuperview];
                _plant1ViewController = nil;
            }
            [newPlantButton setFrame: FRAME_NEW_PLANT_2_PLANT];
            
        break;
            
        case 2:
            
            [_plant2ViewController.view removeFromSuperview];
            _plant2ViewController = nil;
            
            [newPlantButton setFrame: FRAME_NEW_PLANT_2_PLANT];
        break;
    }
    
    self.numberOfPlants = [NSNumber numberWithInt:[self.numberOfPlants intValue] - 1];
    
}

#pragma mark - PlantViewsController

- (void)addNewPlant:(PlantViewModel*) plant{
    
    int localNumberOfPlants = [self.numberOfPlants intValue];
    
    // add plant to collection
    
    [_plantsCollection addObject:plant];
    
    if (localNumberOfPlants < 3){
        
        switch ([self.numberOfPlants integerValue]) {
            case 0:{
                    _plant0ViewController = [PlantViewController instantiate];
                    _plant0ViewController.delegate = self;
                    _plant0ViewController.plantName = [plant getName];
                    _plant0ViewController.position = [NSNumber numberWithInteger:[_plantsViewControllerCollection count]];
                
                    [plant setPosition: [NSNumber numberWithInteger:[_plantsViewControllerCollection count]]];
                
                    [_plant0ViewController.view setFrame:CGRectMake(95, 20, _plant0ViewController.view.frame.size.width, _plant0ViewController.view.frame.size.height)];
                
                    [newPlantButton setFrame: FRAME_NEW_PLANT_1_PLANT];
                
                    // showWithAnimationTheView
                    [self.view addSubview:_plant0ViewController.view];
                
                    [_plant0ViewController setPlantImageFromName:[plant getName]];
                    [_plant0ViewController setStatusUndefined];
                    _plant0ViewController.plantViewModel = plant;
                
                
                    // add plantsViewController to collection
                    [_plantsViewControllerCollection addObject: _plant0ViewController];
                }
                break;
                
            case 1:{
                    _plant1ViewController = [PlantViewController instantiate];
                    _plant1ViewController.plantName = [plant getName];
                    _plant1ViewController.delegate = self;
                    _plant1ViewController.position = [NSNumber numberWithInteger:[_plantsViewControllerCollection count]];
                    [_plant0ViewController.view setFrame:CGRectMake(20, 20, _plant0ViewController.view.frame.size.width, _plant0ViewController.view.frame.size.height)];
                    [_plant1ViewController.view setFrame:CGRectMake(170, 20, _plant1ViewController.view.frame.size.width, _plant1ViewController.view.frame.size.height)];
                    [newPlantButton setFrame: FRAME_NEW_PLANT_2_PLANT];
                    [plant setPosition: [NSNumber numberWithInteger:[_plantsViewControllerCollection count]]];
                    // showWithAnimationTheView
                    [self.view addSubview:_plant1ViewController.view];
                
                    [_plant1ViewController setPlantImageFromName:[plant getName]];
                    [_plant1ViewController setStatusUndefined];
                    _plant1ViewController.plantViewModel = plant;
                
                    // add plantsViewController to collection
                    [_plantsViewControllerCollection addObject: _plant1ViewController];
                }
                break;
                
            case 2:{
                    _plant2ViewController = [PlantViewController instantiate];
                    _plant2ViewController.plantName = [plant getName];
                    _plant2ViewController.delegate = self;
                    _plant2ViewController.position = [NSNumber numberWithInteger:[_plantsViewControllerCollection count]];
                    [_plant2ViewController.view setFrame:CGRectMake(20, 200, _plant2ViewController.view.frame.size.width, _plant2ViewController.view.frame.size.height)];
                    [newPlantButton setFrame: FRAME_NEW_PLANT_3_PLANT];
                
                    // showWithAnimationTheView
                    [self.view addSubview:_plant2ViewController.view];
                
                    [plant setPosition: [NSNumber numberWithInteger:[_plantsViewControllerCollection count]]];
                    [_plant2ViewController setPlantImageFromName:[plant getName]];
                    [_plant2ViewController setStatusUndefined];
                    _plant2ViewController.plantViewModel = plant;
                
                    // add plantsViewController to collection
                    [_plantsViewControllerCollection addObject: _plant2ViewController];
                }
                break;
                
            default:{
                PlantViewController* newPlantViewController = [PlantViewController instantiate];
                newPlantViewController.plantName = [plant getName];
                newPlantViewController.delegate = self;
                newPlantViewController.position = [NSNumber numberWithInteger:[_plantsViewControllerCollection count]];
                // set te positionX and Y dinamic
                //[newPlantViewController.view setFrame:CGRectMake(_positionX, _positionY, newPlantViewController.view.frame.size.width, newPlantViewController.view.frame.size.height)];
                [_plantsViewControllerCollection addObject: newPlantViewController];
                }
                break;
        }
        
        self.numberOfPlants = [NSNumber numberWithInt: localNumberOfPlants +1];
    
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
    
    for (PlantViewModel *plant in content) {
        
        [self addNewPlant:plant];
    }
}

@end
