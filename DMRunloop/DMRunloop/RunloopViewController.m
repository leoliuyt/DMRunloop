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
    CFRunLoopSourceContext context = {0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, &myCFSourceCallback};
    CFRunLoopSourceRef source = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
    NSString *str = kDMCustomMode;
    CFStringRef string = (__bridge CFStringRef)str;
    // 给runloop添加一个自定义source
    CFRunLoopAddSource(runLoop, source, string);
    __weak typeof(self) weakSelf = self;
    [self addObserverForMode:string runLoop:^{
        //10s后退出runloop YES执行完source后直接返回 NO 等到10s后退出runloop
        CFRunLoopRunInMode(string, 10, NO);
    } after:^{
        //防止野指针的产生
        weakSelf.thread = nil;
    }];
}
- (void)startRunloopTimerCustomMode
{
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFRunLoopTimerContext context = {0, NULL, NULL, NULL, NULL};
    //每隔5s被唤醒一次
    CFRunLoopTimerRef timer = CFRunLoopTimerCreate(kCFAllocatorDefault, 0.1, 5, 0, 0,
                                                   &myCFTimerCallback, &context);
    
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
    } after:^{
        NSLog(@"after call");
    }];
}

- (void)addObserverForMode:(CFRunLoopMode)mode runLoop:(void(^)(void))runBlock after:(void(^)(void))afterBlock
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
    
    if (runBlock) {
        runBlock();
    }
    
    NSLog(@"Runloop finish");
    CFRelease(observer);
    
    if (afterBlock) {
        afterBlock();
    }
}

static void myCFTimerCallback(CFRunLoopTimerRef timer, void *info)
{
    NSLog(@"timer====%@",[NSThread currentThread]);
}

static void myCFSourceCallback(void *info)
{
    NSLog(@"timer====%@",[NSThread currentThread]);
}


@end
