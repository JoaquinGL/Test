//
//  SearchPlantViewController.m
//  HUI
//
//  Created by Joaquin Giraldez on 26/11/15.
//  Copyright © 2015 Giraldez Lopez SL. All rights reserved.
//

/* PLANT OBJECT
 description = "Wait 24h to know if you can grow this plant";
 name = basil;
 plantID = basil;
 suitable = unknown;
 */

#import "SearchPlantViewController.h"
#import "Manager.h"
#import "StatusViewModel.h"

@interface SearchPlantViewController ()
{
    CoreServices *_coreServices;
    MBProgressHUD* _HUD;
    NSString* _status;
}

@property (assign, nonatomic) IBOutlet UITableView *tableView;


@end


@implementation SearchPlantViewController

@synthesize data = _data
            , sensor = _sensor
            , filter = _filter
            , huiViewModel = _huiViewModel;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customInit];
    
    self.title = NSLocalizedString(@"Plants list", @"");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customInit{
    
    _coreServices = [[CoreServices alloc] init];
    
    [_coreServices setDelegate: self];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_HUD];
    
    _HUD.delegate = self;
    _HUD.labelText = NSLocalizedString(@"Loading plants", nil);
    
    [_HUD show:YES];
    
    Manager* _manager = [[Manager alloc] init];
    StatusViewModel* statusViewModel = [[StatusViewModel alloc] init];
    statusViewModel = [_manager getStatus];
    
    
    if( !self.filter || [self.filter isEqualToString:@""]){
    
        [_coreServices getPlantListWithHUID: [self.huiViewModel getName]
                               withLanguage: [statusViewModel getLanguage]];
    }else{
        [_coreServices getPlantListWithFilter: self.filter
                                   withStatus: statusViewModel
                                    withHuiId: [self.huiViewModel getName]];
    }
}

#pragma mark - Instantiate method

+ ( SearchPlantViewController* )instantiate
{
    return [[ SearchPlantViewController alloc]  initWithNibName:@"SearchPlantView" bundle:nil];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data count];
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"myCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = [self.data[indexPath.row] objectForKey:@"name"];
    
    if( [[self.data[indexPath.row] objectForKey:@"name"] isEqualToString:@"unknown"] ){
        cell.imageView.image = [UIImage imageNamed:@"question_mark.png"];
    }else if( [[self.data[indexPath.row] objectForKey:@"name"] isEqualToString:@"ok"] ){
        cell.imageView.image = [UIImage imageNamed:@"thumb_up.png"];
    }else{
        cell.imageView.image = [UIImage imageNamed:@"thumb_down.png"];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];


    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:NSLocalizedString(@"Plant Status", nil)
                                  message:NSLocalizedString(@"What are you going to plant?", nil)
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:NSLocalizedString(@"Seeds", nil)
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    [alert dismissViewControllerAnimated:YES completion:nil];
                                    _status = @"germinating";
                                    
                                    [self setPlantStatus: indexPath];
                                    
                                }];
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"Shoots", nil)
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   [alert dismissViewControllerAnimated:YES completion:nil];
                                   _status = @"growing";
                                   
                                   [self setPlantStatus: indexPath];
                               }];
    
    [alert addAction:noButton];
    [alert addAction:yesButton];
    
    [self presentViewController:alert animated:YES completion:nil];


}

- (void) setPlantStatus: (NSIndexPath *)indexPath{

    [self.delegate onSelectPlant: self.data[indexPath.row]
                withHuiViewModel: self.huiViewModel
                        inSensor: self.sensor
                     plantStatus: _status];
    
    [[self navigationController] popViewControllerAnimated:YES];

}

- (void)customiseTableViewCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    //Some fancy stuff - This really isn't needed and isn't the best way to do it. Subclass UITableViewCell if you want something like this.
    UIView *backgroundColorView = [cell.contentView viewWithTag:10];
    
    CGRect backgroundFrame = CGRectMake(2, 2, cell.bounds.size.width - 4, cell.bounds.size.height - 2 - (indexPath.row == self.data.count - 1? 2:0));
    
    if (!backgroundColorView) {
        backgroundColorView = [[UIView alloc] initWithFrame:backgroundFrame];
        backgroundColorView.tag = 10;
        backgroundColorView.backgroundColor = self.view.backgroundColor;
        [cell.contentView insertSubview:backgroundColorView atIndex:0];
        cell.textLabel.backgroundColor = [UIColor clearColor];
    }
    else {
        backgroundColorView.frame = backgroundFrame;
    }
}


#pragma  mark - CoreServicesDelegate

- (void) answerFromServer:(NSDictionary *)response{
    
    self.data = [[NSMutableArray alloc] init];
    
    if ([response objectForKey:@"plantList"]){
        
        self.data = [response objectForKey:@"plantList"];
        
    }else{
        self.data = [[NSMutableArray alloc] initWithArray:@[@"apple",@"broccoli",@"endive",@"orange",@"carrot",@"Tomato",@"lettuce",@"onion",@"potato",@"lemon",@"soja"]];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [_HUD hide:YES];
    });
}




@end
