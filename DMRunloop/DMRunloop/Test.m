//
//  Test.m
//  DMRunloop
//
//  Created by lbq on 2018/5/29.
//  Copyright © 2018年 lbq. All rights reserved.
//

#import "Test.h"
@interface Test()
@property (nonatomic) NSString *aa;
@property (nonatomic) NSArray *bb;
@end

@implementation Test
- (void)method
{
    
    self.bb = [NSMutableArray array];
    
    [(NSMutableArray *)self.bb addObject:@"111"];
    
//    self.aa = @"";
//    self.bb = @[];
//    void(^block1)(void) = ^(){
//            self.aa = nil;
//    };
//
//    void(^block2)(void) = ^(){
//        block1();
//    };
//    block2();
}
@end
