//
//  UITapGestureRecognizer+Cancel.m
//  XTrackPad-iOS
//
//  Created by xuzhaocheng on 2021/1/6.
//

#import "UITapGestureRecognizer+Cancel.h"

@implementation UITapGestureRecognizer (Cancel)

- (void)cancel {
    self.enabled = NO;
    self.enabled = YES;
}

@end
