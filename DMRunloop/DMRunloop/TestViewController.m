//
//  TestViewController.m
//  DMRunloop
//
//  Created by lbq on 2018/6/2.
//  Copyright © 2018年 lbq. All rights reserved.
//

#import "TestViewController.h"
static BOOL stop = NO;
@interface TestViewController ()
{
    CFRunLoopRef threadRunloopRef;
}
@property (nonatomic, strong) NSThread *thread;



@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    stop = NO;
    // Do any additional setup after loading the view.
    [self test1];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self performSelector:@selector(threadCall) onThread:self.thread withObject:nil waitUntilDone:YES];
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

- (void)threadCall
{
    NSLog(@"%@", [NSThread currentThread]);
    stop = YES;
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

- (void)startRunloop1
{
    CFRunLoopSourceContext context = {0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL};
    CFRunLoopSourceRef source = CFRunLoopSourceCreate(kCFAllocatorDefault, 0, &context);
    // 给runloop添加一个自定义source
    CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
    // 给runloop添加一个状态监听者
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        switch (activity) {
            case kCFRunLoopBeforeWaiting:
                NSLog(@"即将进入睡眠");
                // 当runloop进入空闲时，即方法执行完毕后，判断runloop的开关，如果关闭就执行关闭操作
            {
                if (stop) {
                    NSLog(@"关闭runloop");
                    // 移除runloop的source
                    CFRunLoopRemoveSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
                    CFRelease(source);
                    // 没有source的runloop是可以通过stop方法关闭的
                    CFRunLoopStop(CFRunLoopGetCurrent());
                }
            }
                break;
            case kCFRunLoopExit:
                NSLog(@"退出");
                break;
            default:
                break;
        }
    });
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopCommonModes);
    CFRunLoopRun();
    CFRelease(observer);
    NSLog(@"Runloop finish");
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    CFRunLoopStop(threadRunloopRef);
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    CFRunLoopStop(threadRunloopRef);
}

- (void)dealloc {
    NSLog(@"Thread isExecuting: %tu", [self.thread isExecuting]);
    NSLog(@"Thread isFinished: %tu", [self.thread isFinished]);
    NSLog(@"Thread isCancelled: %tu", [self.thread isCancelled]);
    NSLog(@"dealloc");
}

@end
