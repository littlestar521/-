//
//  SelectCityViewController.m
//  最美周末
//
//  Created by scjy on 16/1/6.
//  Copyright © 2016年 马娟娟. All rights reserved.
//

#import "SelectCityViewController.h"

@interface SelectCityViewController ()

@end

@implementation SelectCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title =  @"切换城市";
    self.navigationController.navigationBar.tintColor = MineColor;
    self.view.backgroundColor = [UIColor yellowColor];
    [self showBackBtn];
    
    
}
- (void)backBtnAction:(UIButton *)btn{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
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

@end
