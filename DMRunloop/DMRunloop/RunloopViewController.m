//
//  RunloopViewController.m
//  DMRunloop
//
//  Created by leoliu on 2018/6/27.
//  Copyright © 2018年 lbq. All rights reserved.
//

#import "RunloopViewController.h"
#import "DMThread.h"

static NSString *kDMCustomMode = @"kDMCustomMode";

@interface RunloopViewController ()
{
    CFRunLoopRef threadRunloopRef;
    CFRunLoopSourceRef sourceRef;
}
@property (nonatomic, strong) DMThread *thread;



@end

@implementation RunloopViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self test1];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%s",__func__);
    [super touchesBegan:touches withEvent:event];
//    [self performSelector:@selector(threadCall) onThread:self.thread withObject:nil waitUntilDone:NO];
//    [self performSelector:@selector(threadCall) withObject:nil afterDelay:0 inModes:@[UITrackingRunLoopMode]];
//    [self performSelector:@selector(threadCall) withObject:nil afterDelay:0 inModes:@[@"kDMCustomMode"]];
//    [self performSelector:@selector(threadCall) withObject:nil afterDelay:0 inModes:@[NSDefaultRunLoopMode]];
    
    //waitUntilDone YES 时在thread被释放后 也通用要求一直等到threadCall 执行完毕，这样就会导致阻塞
    [self performSelector:@selector(threadCall) onThread:self.thread withObject:nil waitUntilDone:NO modes:@[kDMCustomMode]];
    
}

- (void)test1
{
    self.thread = [[DMThread alloc] initWithTarget:self selector:@selector(startRunloopSourceCustomMode) object:nil];
    [self.thread start];
}

- (void)threadCall
{
    NSLog(@"call in %@==%@===%p", [NSThread currentThread],self.thread,self.thread);
    [self triggerSource];
}

//用于手动触发source0
- (void)triggerSource
{
    CFRunLoopSourceSignal(sourceRef);
    CFRunLoopWakeUp(CFRunLoopGetCurrent());
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
    CFRunLoopSourceContext context = {0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, &myCFSourceCallback};
//    CFIndex    version;
//    void *    info;
//    const void *(*retain)(const void *info);
//    void    (*release)(const void *info);
//    CFStringRef    (*copyDescription)(const void *info);
//    Boolean    (*equal)(const void *info1, const void *info2);
//    CFHashCode    (*hash)(const void *info);
//    void    (*schedule)(void *info, CFRunLoopRef rl, CFRunLoopMode mode);
//    void    (*cancel)(void *info, CFRunLoopRef rl, CFRunLoopMode mode);
//    void    (*perform)(void *info);
//    CFRunLoopSourceContext context = {
//        0,
//        NULL,
//        &CFRetain,
//        &CFRelease,
//        NULL,
//        NULL,
//        NULL,
//        NULL,
//        NULL,
//        &myCFSourceCallback
//    };
    sourceRef = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
    // 给runloop添加一个自定义source
    CFRunLoopAddSource(CFRunLoopGetCurrent(), sourceRef, kCFRunLoopDefaultMode);
    [self addObserverForMode:kCFRunLoopDefaultMode];
}

- (void)startRunloopTimer
{
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFRunLoopTimerContext context = {0, NULL, NULL, NULL, NULL};
    //每隔5s被唤醒一次
    CFRunLoopTimerRef timer = CFRunLoopTimerCreate(kCFAllocatorDefault, 0.1, 1, 0, 0,
                                                   &myCFTimerCallback, &context);
    CFRunLoopAddTimer(runLoop, timer, kCFRunLoopDefaultMode);
//    [self addObserverForMode:kCFRunLoopDefaultMode runLoop:^{
//        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 10, YES);
//        NSLog(@"Runloop finish");
//    }];
    [self addObserverForMode:kCFRunLoopDefaultMode];
}

- (void)startRunloopSourceCustomMode
{
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFRunLoopSourceContext context = {0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, &myCFSourceCallback};
//    CFRunLoopSourceRef source = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
    sourceRef = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
    NSString *str = kDMCustomMode;
    CFStringRef string = (__bridge CFStringRef)str;
    // 给runloop添加一个自定义source
    CFRunLoopAddSource(runLoop, sourceRef, string);
    __weak typeof(self) weakSelf = self;
    [self addObserverForMode:string runLoop:^{
        //10s后退出runloop YES执行完source后直接返回 NO 等到10s后退出runloop
        CFRunLoopRunInMode(string, 10, YES);
        NSLog(@"Runloop finish");
        //防止野指针的产生
        weakSelf.thread = nil;
    }];
}
- (void)startRunloopTimerCustomMode
{
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
//    CFRunLoopTimerContext context = {0, NULL, NULL, NULL, NULL};
//    //每隔5s被唤醒一次
//    CFRunLoopTimerRef timer = CFRunLoopTimerCreate(kCFAllocatorDefault, 0.1, 5, 0, 0,
//                                                   &myCFTimerCallback, &context);
    CFRunLoopTimerRef timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, 0.1, 5, 0, 0, ^(CFRunLoopTimerRef timer) {
        NSLog(@"timer====%@",[NSThread currentThread]);
    });
    
//    CFStringRef string = CFStringCreateWithFormat(NULL, NULL, CFSTR("kDMCustomMode"));
    NSString *str = kDMCustomMode;
    CFStringRef string = (__bridge CFStringRef)str;
    CFRunLoopAddTimer(runLoop, timer, string);
    [self addObserverForMode:string];
}

- (void)addObserverForMode:(CFRunLoopMode)mode
{
    [self addObserverForMode:mode runLoop:^{
        NSLog(@"runloop call");
        CFRunLoopRun(); //默认DefaultMode下运行
        NSLog(@"Runloop finish");
    }];
}

- (void)addObserverForMode:(CFRunLoopMode)mode runLoop:(void(^)(void))runBlock
{
    // 给runloop添加一个状态监听者
//    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
//    CFOptionFlags activities = (kCFRunLoopBeforeWaiting | // before the run loop starts sleeping
//                                kCFRunLoopExit);          // before exiting a runloop run
//    CFRunLoopObserverContext context = {
//        0,           // version
//        (__bridge void *)transactionGroup,  // info
//        &CFRetain,   // retain
//        &CFRelease,  // release
//        NULL         // copyDescription
//    };
//
//    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(NULL,        // allocator
//                                       activities,  // activities
//                                       YES,         // repeats
//                                       INT_MAX,     // order after CA transaction commits
//                                       &_transactionGroupRunLoopObserverCallback,  // callback
//                                       &context);   // context
//    CFRunLoopAddObserver(runLoop, observer, kCFRunLoopCommonModes);
    
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
            //
        } else if(activity == kCFRunLoopAfterWaiting){
            NSLog(@"kCFRunLoopAfterWaiting = %@",reference);
        } else {
            NSLog(@"kCFRunLoopExit = %@",reference);
        }
    });
    
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, mode);
    CFRelease(observer);
    
    if (runBlock) {
        runBlock();
    }
}

static void myCFTimerCallback(CFRunLoopTimerRef timer, void *info)
{
    NSLog(@"timer====%@",[NSThread currentThread]);
}

static void myCFSourceCallback(void *info)
{
    NSLog(@"myCFSourceCallback====%@",[NSThread currentThread]);
}


@end
