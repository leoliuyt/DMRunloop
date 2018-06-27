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

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSThread *thread;


@end

@implementation ViewController

//- (id)initWithCoder:(NSCoder *)aDecoder
//{
//     [self addObserverForRunloop];
//    return [super initWithCoder:aDecoder];
//}


- (void)testDemo1
{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"线程开始");
        //获取到当前线程
        self.thread = [NSThread currentThread];
        NSRunLoop *runloop = [NSRunLoop currentRunLoop];
        //添加一个Port，同理为了防止runloop没事干直接退出
        [runloop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];

        //运行一个runloop，[NSDate distantFuture]：很久很久以后才让它失效
        [runloop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];

        NSLog(@"线程结束");
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //在我们开启的异步线程调用方法
        [self performSelector:@selector(recieveMsg) onThread:self.thread withObject:nil waitUntilDone:NO];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //在我们开启的异步线程调用方法
        [self performSelector:@selector(recieveMsg) onThread:self.thread withObject:nil waitUntilDone:NO];
    });
}
- (void)recieveMsg
{
//    @autoreleasepool{
        NSLog(@"收到消息了，在这个线程：%@==%@",[NSThread currentThread],self.name);
//    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self test1];
//    [self testDemo1];
//    [self addObserverForRunloop];
//
    
//    NSThread *thread1 = [[NSThread alloc] init];
//    self.thread = thread1;
//    [self performSelector:@selector(threadCall) onThread:thread1 withObject:nil waitUntilDone:NO];
//    [self performSelector:@selector(threadCall) withObject:nil afterDelay:0 inModes:@[NSDefaultRunLoopMode]];
    
    
//     [self performSelector:@selector(threadCall) onThread:thread1 withObject:nil waitUntilDone:NO];
//
//    [thread1 start];
//
    
//    NSThread *subThread = [[NSThread alloc] initWithTarget:self selector:@selector(threadCall) object:nil];
//
//
//    [subThread start];
    
    
}

- (void)test1
{
//    self.thread = [[NSThread alloc] initWithBlock:^{
//        [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
//        [[NSRunLoop currentRunLoop] run];
//    }];
    NSThread *subThread = [[NSThread alloc] initWithTarget:self selector:@selector(startRunloop) object:nil];
    self.thread = subThread;
    [self.thread start];
}

- (void)startRunloop
{
    [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
    [[NSRunLoop currentRunLoop] run];
}


- (void)threadCall
{
     NSLog(@"%@", [NSThread currentThread]);
//    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
//    //添加一个Port，同理为了防止runloop没事干直接退出
//    [runloop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
//
//    //运行一个runloop，[NSDate distantFuture]：很久很久以后才让它失效
//    [runloop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
     [self performSelector:@selector(threadCall) onThread:self.thread withObject:nil waitUntilDone:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

//    NSLog(@"%@",((Person *)reference).name);
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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
//    if (activity == kCFRunLoopEntry) {
//        NSLog(@"kCFRunLoopEntry = %@",reference);
//    } else if(activity == kCFRunLoopBeforeTimers){
//        NSLog(@"kCFRunLoopBeforeTimers = %@",reference);
//    } else if(activity == kCFRunLoopBeforeSources){
//        NSLog(@"kCFRunLoopBeforeSources = %@",reference);
//    } else if(activity == kCFRunLoopBeforeWaiting){
//        NSLog(@"kCFRunLoopBeforeWaiting = %@",reference);
//    } else if(activity == kCFRunLoopAfterWaiting){
//        NSLog(@"kCFRunLoopAfterWaiting = %@",reference);
//    } else {
//        NSLog(@"kCFRunLoopExit = %@",reference);
//    }
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
