//
//  BaseViewController.m
//  HUI
//
//  Created by Joaquin Giraldez on 26/11/15.
//  Copyright © 2015 Giraldez Lopez SL. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onCloseButtonTouchUpInside:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


/* Posible animations */

- ( void )fadeIn: ( UIView* )view withDuration:( float )duration completion: ( void ( ^ )( BOOL finished ) )completion
{
    [ UIView animateWithDuration: duration
                      animations: ^{ view.alpha= 1.0; }
                      completion: completion ];
}

- ( void )fadeOut: ( UIView* )view withDuration:( float )duration completion: ( void ( ^ )( BOOL finished ) )completion
{
    [ UIView animateWithDuration: duration
                      animations: ^{ view.alpha= 0.0; }
                      completion: completion ];
}


- ( void )fadeIn: ( float )duration completion: ( void ( ^ )( BOOL finished ) )completion
{
    [ UIView animateWithDuration: duration
                      animations: ^{ self.view.alpha= 1.0; }
                      completion: completion ];
}

- ( void )fadeOut: ( float )duration completion: ( void ( ^ )( BOOL finished ) )completion
{
    [ UIView animateWithDuration: duration
                      animations: ^{ self.view.alpha= 0.0; }
                      completion: completion ];
}



@end
