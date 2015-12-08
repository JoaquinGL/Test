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
    
    UIImage* deleteImage = [UIImage imageNamed:@"trash.png"];
    CGRect frameimg = CGRectMake(0, 0, deleteImage.size.width - 10, deleteImage.size.height - 13);
    UIButton *deleteButton = [[UIButton alloc] initWithFrame:frameimg];
    [deleteButton setBackgroundImage:deleteImage forState:UIControlStateNormal];
    
    [deleteButton addTarget:self action:@selector(onDeletePlantTouchUpInside:)
         forControlEvents:UIControlEventTouchUpInside];
    
    [deleteButton setShowsTouchWhenHighlighted:YES];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithCustomView: deleteButton];
    self.navigationItem.rightBarButtonItem = rightButton;
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
