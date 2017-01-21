//
//  AdvertVC.m
//  SnookerScoreLite
//
//  Created by andrew glew on 21/01/2017.
//  Copyright © 2017 andrew glew. All rights reserved.
//

#import "AdvertVC.h"

@interface AdvertVC ()

@end

@implementation AdvertVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self.navigationController setToolbarHidden:YES animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage =[UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    
    
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithRed:237.0f/255.0f green:229.0f/255.0f blue:182.0f/255.0f alpha:1.0] }];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backnav"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self.navigationController
                                                                  action:@selector(popViewControllerAnimated:)];
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor colorWithRed:237.0f/255.0f green:229.0f/255.0f blue:182.0f/255.0f alpha:1.0];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)closePressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];

    
    
}
- (IBAction)openAppStore:(id)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms://itunes.com/apps/SnookerScoreMaster"]];
}

@end
