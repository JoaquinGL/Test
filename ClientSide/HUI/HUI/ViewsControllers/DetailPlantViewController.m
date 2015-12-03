//
//  DetailPlantViewController.m
//  HUI
//
//  Created by Joaquin Giraldez on 26/11/15.
//  Copyright © 2015 Giraldez Lopez SL. All rights reserved.
//

#import "DetailPlantViewController.h"
#import "SearchPlantViewController.h"

@interface DetailPlantViewController ()

@end


@implementation DetailPlantViewController

@synthesize identify = _identify;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customInit];
}

- (void)customInit{
    UIBarButtonItem *deleteButton = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStylePlain
                                                                     target:self action:@selector(onDeletePlantTouchUpInside:)];
    self.navigationItem.rightBarButtonItem = deleteButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Instantiate method

+ ( DetailPlantViewController* )instantiate
{
    return [[ DetailPlantViewController alloc]  initWithNibName:@"DetailPlantView" bundle:nil];
}

- (IBAction)onSelectPlantTouchUpInside:(id)sender{
    
    UIViewController* plantViewController = [[SearchPlantViewController alloc] initWithNibName:@"SearchPlantView" bundle:nil];
    
    [self.navigationController pushViewController:plantViewController animated:YES];
}

- (IBAction)onDeletePlantTouchUpInside:(id)sender{
    
    [self.delegate deletePlant: self.identify];
    
    [[self navigationController] popViewControllerAnimated:YES];

}


@end
