//
//  RunloopViewController.m
//  DMRunloop
//
//  Created by leoliu on 2018/6/27.
//  Copyright © 2018年 lbq. All rights reserved.
//

#import "RunloopViewController.h"

@interface RunloopViewController ()
{
    CFRunLoopRef threadRunloopRef;
}
@property (nonatomic, strong) NSThread *thread;


@end

@implementation RunloopViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self test1];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self performSelector:@selector(threadCall) onThread:self.thread withObject:nil waitUntilDone:NO];
}

- (void)test1
{
    NSThread *subThread = [[NSThread alloc] initWithTarget:self selector:@selector(startRunloopSourceCustomMode) object:nil];
    self.thread = subThread;
    [self.thread start];
}

- (void)threadCall
{
    NSLog(@"call in %@", [NSThread currentThread]);
}

- (void)startRunloop
{
    NSLog(@"%s",__func__);
    threadRunloopRef = CFRunLoopGetCurrent();
    @autoreleasepool{
        [[NSRunLoop currentRunLoop] addPort:[NSPort port] forMode:NSDefaultRunLoopMode];
        [[NSRunLoop currentRunLoop] run];
    }
    NSLog(@"after:%s",__func__);
}

- (void)startRunloopSource
{
    CFRunLoopSourceContext context = {0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL};
    CFRunLoopSourceRef source = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
    // 给runloop添加一个自定义source
    CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
    [self addObserverForMode:kCFRunLoopDefaultMode];
}

- (void)startRunloopTimer
{
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFRunLoopTimerContext context = {0, NULL, NULL, NULL, NULL};
    //每隔5s被唤醒一次
    CFRunLoopTimerRef timer = CFRunLoopTimerCreate(kCFAllocatorDefault, 0.1, 15, 0, 0,
                                                   &myCFTimerCallback, &context);
    CFRunLoopAddTimer(runLoop, timer, kCFRunLoopCommonModes);
    [self addObserverForMode:kCFRunLoopCommonModes];
}

- (void)startRunloopSourceCustomMode
{
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFRunLoopSourceContext context = {0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL};
    CFRunLoopSourceRef source = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
    // 给runloop添加一个自定义source
    CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
    
    CFStringRef string = CFStringCreateWithFormat(NULL, NULL, CFSTR("kDMCustomMode"));
    CFRunLoopAddSource(runLoop, source, string);
    [self addObserverForMode:string];
}
- (void)startRunloopTimerCustomMode
{
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFRunLoopTimerContext context = {0, NULL, NULL, NULL, NULL};
    //每隔5s被唤醒一次
    CFRunLoopTimerRef timer = CFRunLoopTimerCreate(kCFAllocatorDefault, 0.1, 5, 0, 0,
                                                   &myCFTimerCallback, &context);
    
    CFStringRef string = CFStringCreateWithFormat(NULL, NULL, CFSTR("kDMCustomMode"));
    CFRunLoopAddTimer(runLoop, timer, string);
    [self addObserverForMode:string];
}

- (void)addObserverForMode:(CFRunLoopMode)mode
{
    // 给runloop添加一个状态监听者
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        NSString *reference = @"";
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
    });
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, mode);
//    CFRunLoopRun();
//    //10s后退出runloop
    CFRunLoopRunInMode(mode, 10, YES);
    CFRelease(observer);
    NSLog(@"Runloop finish");
}

static void myCFTimerCallback(CFRunLoopTimerRef timer, void *info)
{
    NSLog(@"timer====%@",[NSThread currentThread]);
}

@end
