//
//  DMAutoreleaseViewController.m
//  DMRunloop
//
//  Created by lbq on 2018/6/27.
//  Copyright © 2018年 lbq. All rights reserved.
//

#import "DMAutoreleaseViewController.h"

@interface DMAutoreleaseViewController ()

@end

@implementation DMAutoreleaseViewController
__weak id reference = nil;
- (void)viewDidLoad {
    [super viewDidLoad];
//    NSString *a = @"a"; // a的地址：0x10be1f340
//    NSString *b = [@"a" mutableCopy]; // b的地址：0x6080002542b0
//    NSString *c = [b copy];
    NSString *string = [NSString stringWithFormat:@"hhh"];
    reference = string;
    NSLog(@"reference = %@",reference);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear:%@",reference);
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear:%@",reference);
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
