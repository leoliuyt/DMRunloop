//
//  ViewController.m
//  DMRunloop
//
//  Created by lbq on 2018/5/29.
//  Copyright © 2018年 lbq. All rights reserved.
//

#import "ViewController.h"
#import <CoreFoundation/CoreFoundation.h>

static NSInteger count = 0;
@interface ViewController ()

@property (weak, nonatomic) IBOutlet UILabel *timerLabel;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.timer) {
//        __weak typeof(self) weakSelf = self;
        
//        self.timer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
//           
//             count++;
//            dispatch_async(dispatch_get_main_queue(), ^{
//                weakSelf.timerLabel.text = [NSString stringWithFormat:@"%tu",count];
//            });
//        }];
        
        CFRunLoopRef currentRunloop = CFRunLoopGetCurrent();
        
//        CFRunLoopAddTimer(currentRunloop, (CFRunLoopTimerRef)self.timer, kCFRunLoopDefaultMode);
//        CFRunLoopAddCommonMode(currentRunloop, kCFRunLoopDefaultMode);
        
//        CFRunLoopMode customMode = (CFRunLoopMode)@"CustomeMode";
//        CFRunLoopAddTimer(currentRunloop, (CFRunLoopTimerRef)self.timer, kCFRunLoopCommonModes);
//        CFRunLoopAddCommonMode(currentRunloop, customMode);
//        CFRunLoopObserverRef
//        CFRunLoopAddObserver(currentRunloop, CFRunLoopObserverRef observer, customMode)
        
//         CFRunLoopRunInMode(customMode, 1, NO);
        CFOptionFlags activities = (kCFRunLoopAllActivities);
//        CFRunLoopObserverContext context = {
//            0,           // version
//            (__bridge void *)transactionGroup,  // info
//            &CFRetain,   // retain
//            &CFRelease,  // release
//            NULL         // copyDescription
//        };
        CFRunLoopObserverRef observerRef = CFRunLoopObserverCreate(NULL, activities, YES, INT_MAX, &dm_ObserverCallBack, NULL);
        CFRunLoopAddObserver(currentRunloop, observerRef, kCFRunLoopCommonModes);
        
//        [self.timer fire];
        CFRelease(observerRef);
    }
}



static void dm_ObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
    //kCFRunLoopBeforeWaiting 32
    //kCFRunLoopBeforeTimers 2
    NSLog(@"%tu----%@",activity,info);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
