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
    
    if(IS_STANDARD_IPHONE_6){
        self.view.frame = CGRectMake(0, 0, 375, 667);
    }
    
    
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
        
        navController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        
        [self presentViewController:navController animated:YES completion:nil];
        
    }
}

- (IBAction)showWalkthrough:(id)sender {
    
    WalkThroughViewController *walkthrough = [WalkThroughViewController instantiateWithNibName:[Utils viewToDevice:@"WalkThroughViewController"]];
    
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
