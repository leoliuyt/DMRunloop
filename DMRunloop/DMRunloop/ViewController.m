//
//  ViewController.m
//  DMRunloop
//
//  Created by lbq on 2018/5/29.
//  Copyright © 2018年 lbq. All rights reserved.
//

#import "ViewController.h"
#import <CoreFoundation/CoreFoundation.h>
#import "Person.h"
//#import <UIKit/UIKit.h>
//static NSInteger count = 0;
@interface ViewController ()
//
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
//
//@property (nonatomic, strong) NSTimer *timer;


@end

@implementation ViewController

//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//     [self addObserverForRunloop];
//    return [super initWithCoder:aDecoder];
//}
__weak id reference = nil;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self addObserverForRunloop];
    
    @autoreleasepool{
        NSString *string = [NSString stringWithFormat:@"hhh"];
        reference = string;
        NSLog(@"");
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        CFRunLoopRunResult res = CFRunLoopRunInMode(kCFRunLoopDefaultMode, 100, YES);
        NSString *string = [NSString stringWithFormat:@"hhh"];
        reference = string;
        
        NSLog(@"%@",reference);
        
        switch (res) {
            case kCFRunLoopRunHandledSource:
                NSLog(@"kCFRunLoopRunHandledSource");
                break;
            case kCFRunLoopRunFinished:
                NSLog(@"kCFRunLoopRunFinished");
                break;
            default:
                NSLog(@"other");
                break;
        }
        
        

    });
    
    
    
    
    
//    CFRunLoopRef currentRunLoop = CFRunLoopGetCurrent();
////    NSLog(@"touch currentRunLoop = %@",currentRunLoop);
//    NSMutableArray *arr = [NSMutableArray array];
//    // 场景 1
////    NSString *string = nil;
////    @autoreleasepool{
//        NSString *string = [NSString stringWithFormat:@"leoliu"];
//        reference = string;
////    }

//    NSLog(@"%@",reference);
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    NSLog(@"viewWillAppear:%@",reference);
//    NSLog(@"%@",((Person *)reference).name);
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    NSLog(@"viewDidAppear%@",reference);
//    NSLog(@"%@",((Person *)reference).name);
}

- (void)addObserverForRunloop
{
    CFRunLoopRef currentRunLoop = CFRunLoopGetCurrent();
//    NSLog(@"currentRunLoop = %@",currentRunLoop);
    CFOptionFlags flags = kCFRunLoopAllActivities;
    CFRunLoopObserverRef observerRef = CFRunLoopObserverCreate(NULL, flags, YES, INT_MAX, &dm_ObserverCallBack, NULL);
    CFRunLoopAddObserver(currentRunLoop, observerRef, kCFRunLoopCommonModes);
}

static void dm_ObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
//    NSLog(@"%@")
//    kCFRunLoopEntry = (1UL << 0),
//    kCFRunLoopBeforeTimers = (1UL << 1),
//    kCFRunLoopBeforeSources = (1UL << 2),
//    kCFRunLoopBeforeWaiting = (1UL << 5),
//    kCFRunLoopAfterWaiting = (1UL << 6),
//    kCFRunLoopExit = (1UL << 7),
//    kCFRunLoopAllActivities = 0x0FFFFFFFU
    //0x14e283c0
    if (activity == kCFRunLoopEntry) {
        NSLog(@"kCFRunLoopEntry = %@",reference);
    } else if(activity == kCFRunLoopBeforeTimers){
        NSLog(@"kCFRunLoopBeforeTimers = %@",reference);
    } else if(activity == kCFRunLoopBeforeSources){
        NSLog(@"kCFRunLoopBeforeSources = %@",reference);
    } else if(activity == kCFRunLoopBeforeWaiting){
        NSLog(@"kCFRunLoopBeforeWaiting = %@",reference);
    } else if(activity == kCFRunLoopAfterWaiting){
        NSLog(@"kCFRunLoopAfterWaiting = %@",reference);
    } else {
        NSLog(@"kCFRunLoopExit = %@",reference);
    }
}


//
//- (void)addObserverForRunloop
//{
//    if (!self.timer) {
//        //        __weak typeof(self) weakSelf = self;
//
//        //        self.timer = [NSTimer timerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        //
//        //             count++;
//        //            dispatch_async(dispatch_get_main_queue(), ^{
//        //                weakSelf.timerLabel.text = [NSString stringWithFormat:@"%tu",count];
//        //            });
//        //        }];
//
//        CFRunLoopRef currentRunloop = CFRunLoopGetCurrent();
//
//        //        CFRunLoopAddTimer(currentRunloop, (CFRunLoopTimerRef)self.timer, kCFRunLoopDefaultMode);
//        //        CFRunLoopAddCommonMode(currentRunloop, kCFRunLoopDefaultMode);
//
//        //        CFRunLoopMode customMode = (CFRunLoopMode)@"CustomeMode";
//        //        CFRunLoopAddTimer(currentRunloop, (CFRunLoopTimerRef)self.timer, kCFRunLoopCommonModes);
//        //        CFRunLoopAddCommonMode(currentRunloop, customMode);
//        //        CFRunLoopObserverRef
//        //        CFRunLoopAddObserver(currentRunloop, CFRunLoopObserverRef observer, customMode)
//
//        //         CFRunLoopRunInMode(customMode, 1, NO);
//        CFOptionFlags activities = (kCFRunLoopAllActivities);
//        //        CFRunLoopObserverContext context = {
//        //            0,           // version
//        //            (__bridge void *)transactionGroup,  // info
//        //            &CFRetain,   // retain
//        //            &CFRelease,  // release
//        //            NULL         // copyDescription
//        //        };
//        CFRunLoopObserverRef observerRef = CFRunLoopObserverCreate(NULL, activities, YES, INT_MAX, &dm_ObserverCallBack, NULL);
//        CFRunLoopAddObserver(currentRunloop, observerRef, kCFRunLoopCommonModes);
//
//        //        [self.timer fire];
//        CFRelease(observerRef);
//    }
//}
//
//
//static void dm_ObserverCallBack(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info){
//    //kCFRunLoopBeforeWaiting 32
//    //kCFRunLoopBeforeTimers 2
//    NSLog(@"%tu----%@",activity,info);
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//


@end
