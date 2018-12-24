//
//  HJViewController.m
//  HJViewStyle
//
//  Created by Johnny on 12/19/2018.
//  Copyright (c) 2018 Johnny. All rights reserved.
//

#import "HJViewController.h"
#import "UIView+HJViewStyle.h"

@interface HJViewController ()

@end

@implementation HJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    /*
     示例
    self.view.shadowColor = [UIColor whiteColor];
    self.view.shadowOffset = CGSizeMake(0, 2);
    self.view.cornerRadius = 10;
    self.view.borderColor = [UIColor blackColor];
    self.view.borderWidth = 4;
    self.view.backgroundColor = [UIColor redColor];
    */
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

@end
