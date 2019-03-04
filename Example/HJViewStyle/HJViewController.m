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
@property (weak, nonatomic) IBOutlet UILabel *hjViewStyleLabel;

@end

@implementation HJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
 

    //代码示例
    UILabel *label = [UILabel new];
    label.frame = CGRectMake(CGRectGetWidth(self.view.frame) - 120, CGRectGetMidY(_hjViewStyleLabel.frame), 100, 100);
    label.backgroundColor = UIColor.redColor;
    label.text = @"代码View";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = UIColor.whiteColor;

    
    label.shadowRadius = 10;
    label.shadowColor = UIColor.whiteColor;
    label.shadowOffset = CGSizeMake(0, 0);
    label.shadowOpacity = 1;
    
    label.cornerRadius = 20;
    label.borderColor = UIColor.whiteColor;
    label.borderWidth = 10;

    label.gradientStyle = GradientStyleLeftToRight;
    label.gradientAColor = UIColor.redColor;
    label.gradientBColor = UIColor.purpleColor;
    [self.view addSubview:label];

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
