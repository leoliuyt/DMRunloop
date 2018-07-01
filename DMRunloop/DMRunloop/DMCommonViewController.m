//
//  DMCommonViewController.m
//  DMRunloop
//
//  Created by leoliu on 2018/7/1.
//  Copyright © 2018年 lbq. All rights reserved.
//

#import "DMCommonViewController.h"

@interface DMCommonViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DMCommonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
//    [self startRunloopTimer];
    [self performSelector:@selector(startRunloopTimer) withObject:nil afterDelay:5];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)startRunloopTimer
{
    CFRunLoopRef runLoop = CFRunLoopGetCurrent();
    CFRunLoopTimerContext context = {0, NULL, NULL, NULL, NULL};
    //每隔5s被唤醒一次
    CFRunLoopTimerRef timer = CFRunLoopTimerCreate(kCFAllocatorDefault, 0.1, 1, 0, 0,
                                                   &myCFTimerCallback, &context);
    
    NSString *str = @"kDMCustomCommonMode";
    CFStringRef string = (__bridge CFStringRef)str;
    CFRunLoopAddTimer(runLoop, timer, string);
    
    [self addObserverForMode:string];
    
    CFRunLoopAddCommonMode(runLoop, string);
}


- (void)addObserverForMode:(CFRunLoopMode)mode
{
    [self addObserverForMode:mode runLoop:^{
        NSLog(@"runloop call");
//        CFRunLoopRun(); //默认DefaultMode下运行
        CFRunLoopRunInMode(mode, 100, NO);
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
//MARK: UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"index = %tu",indexPath.row];
    return cell;
}

@end
