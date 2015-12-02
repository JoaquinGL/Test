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

@synthesize navigationController = _navigationController;

- (void)viewDidLoad {
    [super viewDidLoad];
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


@end
