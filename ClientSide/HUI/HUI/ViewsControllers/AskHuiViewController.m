//
//  AskHuiViewController.m
//  HUI
//
//  Created by Joaquin Giraldez on 3/12/15.
//  Copyright © 2015 Giraldez Lopez SL. All rights reserved.
//

#import "AskHuiViewController.h"

@interface AskHuiViewController ()

@end

@implementation AskHuiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

+ ( AskHuiViewController* )instantiate{
    return [[AskHuiViewController alloc] initWithNibName:@"AskHuiView" bundle:nil];
}

#pragma mark - ACTIONS

- (IBAction)onBackTouchUpInside:(id)sender{
    [self.delegate onBackAskTouchUpInside];
}

@end
