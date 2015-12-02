//
//  MainViewController.m
//  HUI
//
//  Created by Joaquin Giraldez on 28/11/15.
//  Copyright © 2015 Giraldez Lopez SL. All rights reserved.
//

#import "MainViewController.h"
#import "DetailPlantViewController.h"
#import "WalkThroughViewController.h"
#import "WalkthroughPageViewController.h"
#import "CustomPageViewController.h"


@interface MainViewController (){
    SearchPlantViewController* _searchPlantViewController;
    DetailPlantViewController* _detailPlantViewController;
    
    PlantViewController* _plant0ViewController;
    PlantViewController* _plant1ViewController;
    PlantViewController* _plant2ViewController;
}

@end

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
    
    _searchPlantViewController.delegate = self;
    
    self.title = @"HUI";
    
    self.numberOfPlants = [NSNumber numberWithInt: 0];
    
    /* TODO: comprobar la lógica de plantas guardadas en el movil. Para que se quede guardado en BBDD
     Aqui hay que tener el sistema de notificaciones para poder añadir los botones si se selecciona una planta nueva. 
     Tambien hay que controlar la lógica cuando ya hay 3 plantas seleccionadas y se ha llegado al máximo, para indicar al usuario que ya no puede añadir
     más, que tiene que editar una planta ya creada. 
     
     La logica es 0 botones, 1 boton, 2 botones, 3 botones (caso que no se permite añadir mas plantas)
     
     De BBDD tiene que venir el numero de plantas guardadas con su estatus. Nombre/ultimo estatus guardado, para poder asignarselo antes de mostrar la vista. 
     Se puede hacer un sistema de loading si se pide de servidor. Si no hay conexion, se tira de BBDD. 
     
     Si se ha sincronizado ok, se guarda el estatus y la hora en la BBDD.
     
     Si no se hace un sistma de notificaciones que es chungo de controlar, mejor un delegado, como el que ya tenemos en los sliders.
     
     */
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

#pragma - ACTIONS BUTTONS

- (IBAction)showDetailPlantOnTouchUpInside:(id)sender{
    
    [self.navigationController pushViewController:_detailPlantViewController animated:YES];
}

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

#pragma - DELEGATE Walk

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

#pragma - Delegate Search

- (void)onSelectPlant:(NSString*) plantName{
    
    NSLog(@"Plant Name: %@", plantName);
    
    [self addNewPlantWithName: plantName];
}

#pragma - Delegate PlantView

-(void)showPlantDetail:(NSDictionary*) plantDictionary{
    
    NSLog(@"Plant to show: %@", [plantDictionary objectForKey:@"name"]);
    
    _detailPlantViewController.title = [plantDictionary objectForKey:@"name"];
    
    [self.navigationController pushViewController:_detailPlantViewController animated:YES];
}


#pragma - PlantViewsController

- (void)addNewPlantWithName:(NSString*) plantName{
    
    int localNumberOfPlants = [self.numberOfPlants integerValue];
    
    if (localNumberOfPlants < 3){
        
        switch ([self.numberOfPlants integerValue]) {
            case 0:
                _plant0ViewController = [PlantViewController instantiate];
                _plant0ViewController.delegate = self;
                _plant0ViewController.plantName = plantName;
                
                [_plant0ViewController.view setFrame:CGRectMake(50, 100, _plant0ViewController.view.frame.size.width, _plant0ViewController.view.frame.size.height)];
                
                // showWithAnimationTheView
                [self.view addSubview:_plant0ViewController.view];
                break;
                
            case 1:
                _plant1ViewController = [PlantViewController instantiate];
                _plant1ViewController.plantName = plantName;
                _plant1ViewController.delegate = self;
                
                [_plant1ViewController.view setFrame:CGRectMake(200, 100, _plant1ViewController.view.frame.size.width, _plant1ViewController.view.frame.size.height)];
                
                // showWithAnimationTheView
                [self.view addSubview:_plant1ViewController.view];
                break;
                
            default:
                _plant2ViewController = [PlantViewController instantiate];
                _plant2ViewController.plantName = plantName;
                _plant2ViewController.delegate = self;
                
                [_plant2ViewController.view setFrame:CGRectMake(50, 300, _plant2ViewController.view.frame.size.width, _plant2ViewController.view.frame.size.height)];
                
                // showWithAnimationTheView
                [self.view addSubview:_plant2ViewController.view];
                break;
        }
        
        self.numberOfPlants = [NSNumber numberWithInt: localNumberOfPlants +1];
    
    }else{
        NSLog(@"Limit exceeded, you have to delete or modify a plant before add new one");
    }
}




@end
