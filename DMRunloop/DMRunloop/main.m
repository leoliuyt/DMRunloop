//
//  main.m
//  DMRunloop
//
//  Created by lbq on 2018/5/29.
//  Copyright © 2018年 lbq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    
    @autoreleasepool {
        CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
            NSString *reference = @"";
            if (activity == kCFRunLoopEntry) {
                NSLog(@"main-kCFRunLoopEntry = %@",reference);
            } else if(activity == kCFRunLoopBeforeTimers){
                NSLog(@"main-kCFRunLoopBeforeTimers = %@",reference);
            } else if(activity == kCFRunLoopBeforeSources){
                NSLog(@"main-kCFRunLoopBeforeSources = %@",reference);
            } else if(activity == kCFRunLoopBeforeWaiting){
                NSLog(@"main-kCFRunLoopBeforeWaiting = %@",reference);
            } else if(activity == kCFRunLoopAfterWaiting){
                NSLog(@"main-kCFRunLoopAfterWaiting = %@",reference);
            } else {
                NSLog(@"main-kCFRunLoopExit = %@",reference);
            }
        });
        CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
