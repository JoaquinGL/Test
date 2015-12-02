//
//  ViewController.m
//  HUI
//
//  Created by Joaquin Giraldez on 22/11/15.
//  Copyright © 2015 Giraldez Lopez SL. All rights reserved.
//

#import "ViewController.h"
#import "WalkThroughViewController.h"
#import "WalkthroughPageViewController.h"
#import "MainViewController.h"

// test
#import "CustomPageViewController.h"

@interface ViewController ()
{
    MainViewController* _mainViewController;
}
@end

@implementation ViewController


- (void)customInit {
    
    _mainViewController = [MainViewController instantiate];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:(BOOL)animated];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"walkthroughPresented"])
    {
        [self showWalkthrough:nil];
        
        [[NSUserDefaults standardUserDefaults] setObject:@(YES)
                                                  forKey:@"walkthroughPresented"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        //showMainView
        
        UINavigationController* navController = [[UINavigationController alloc] initWithRootViewController:_mainViewController];
        
        _mainViewController.navigationController = navController;
        
        [self presentViewController:navController animated:YES completion:nil];
        
    }
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


#pragma - DELEGATE
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


@end
