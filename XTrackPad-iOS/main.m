//
//  main.m
//  XTrackPad
//
//  Created by xuzhaocheng on 2020/12/26.
//

#import <UIKit/UIKit.h>
#import "MobileAppDelegate.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([MobileAppDelegate class]);
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
