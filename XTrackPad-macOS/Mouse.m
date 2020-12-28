//
//  Mouse.m
//  VTrackPad
//
//  Created by xuzhaocheng on 2020/12/25.
//

#import "Mouse.h"

@interface Mouse()

@property (nonatomic, assign) BOOL dragEnabled;

@end

@implementation Mouse

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static Mouse *_instance = nil;
    dispatch_once(&onceToken, ^{
        _instance = [[Mouse alloc] init];
    });
    return _instance;
}

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self setupDragCallback];
            [self setupDebugCallback];
        });
    });
}

+ (void)setupDebugCallback {
    CGEventMask mask = CGEventMaskBit(kCGEventKeyUp);
    CFMachPortRef eventTap = CGEventTapCreate(kCGHIDEventTap,
                                              kCGHeadInsertEventTap,
                                              kCGEventTapOptionDefault,
                                              mask,
                                              keyUpEventCallback,
                                              nil);
    if (!eventTap) {
        NSLog(@"failed to create event tap");
        return;
    }

    // Create a run loop source.
    CFRunLoopSourceRef runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0);


    // Add to the current run loop.
    CFRunLoopAddSource(CFRunLoopGetCurrent(),
                       runLoopSource,
                       kCFRunLoopCommonModes);


    // Enable the event tap.
    CGEventTapEnable(eventTap, true);
}

+ (void)setupDragCallback {
    CGEventMask mask = CGEventMaskBit(kCGEventMouseMoved);
    CFMachPortRef eventTap = CGEventTapCreate(kCGHIDEventTap,
                                              kCGHeadInsertEventTap,
                                              kCGEventTapOptionDefault,
                                              mask,
                                              moveEventCallback,
                                              nil);
    if (!eventTap) {
        NSLog(@"failed to create event tap");
        return;
    }

    // Create a run loop source.
    CFRunLoopSourceRef runLoopSource = CFMachPortCreateRunLoopSource(kCFAllocatorDefault, eventTap, 0);


    // Add to the current run loop.
    CFRunLoopAddSource(CFRunLoopGetCurrent(),
                       runLoopSource,
                       kCFRunLoopCommonModes);


    // Enable the event tap.
    CGEventTapEnable(eventTap, true);
}

+ (NSRect)screenFrame {
    return [[NSScreen mainScreen] frame];
}

+ (NSPoint)currentMouseLocation {
    NSPoint loc = NSEvent.mouseLocation;
    loc.y = NSHeight([self screenFrame]) - loc.y;
    return loc;
}

+ (void)move:(CGPoint)delta {
    NSPoint loc = [self currentMouseLocation];

    NSPoint newLoc = CGPointMake(loc.x - delta.x, loc.y + delta.y);
    CGFloat height = NSHeight([self screenFrame]);
    CGFloat width = NSWidth([self screenFrame]);
    newLoc.x = MIN(MAX(newLoc.x, 0), width);
    newLoc.y = MIN(MAX(newLoc.y, 0), height);
    CGEventRef event = CGEventCreateMouseEvent(NULL,
                                               kCGEventMouseMoved,
                                               newLoc,
                                               kCGMouseButtonLeft);
    CGEventPost(kCGHIDEventTap, event);
    CGWarpMouseCursorPosition(newLoc);
    CFRelease(event);
}

+ (void)down {
    NSPoint loc = [self currentMouseLocation];
    CGEventRef event = CGEventCreateMouseEvent(NULL,
                                               kCGEventLeftMouseDown,
                                               loc,
                                               kCGMouseButtonLeft);
    CGEventPost(kCGHIDEventTap, event);
    CFRelease(event);
}

+ (void)up {
    NSPoint loc = [self currentMouseLocation];
    CGEventRef event = CGEventCreateMouseEvent(NULL,
                                               kCGEventLeftMouseUp,
                                               loc,
                                               kCGMouseButtonLeft);
    CGEventPost(kCGHIDEventTap, event);
    CFRelease(event);
}

+ (void)singleClick {
    NSPoint loc = [self currentMouseLocation];
    CGEventRef event = CGEventCreateMouseEvent(NULL,
                                               kCGEventLeftMouseDown,
                                               loc,
                                               kCGMouseButtonLeft);
    CGEventPost(kCGHIDEventTap, event);
    CGEventSetType(event, kCGEventLeftMouseUp);
    CGEventPost(kCGHIDEventTap, event);
    CFRelease(event);
}

+ (void)doubleClick {
    NSPoint loc = [self currentMouseLocation];
    CGEventRef event = CGEventCreateMouseEvent(NULL, kCGEventLeftMouseDown, loc, kCGMouseButtonLeft);
    CGEventSetIntegerValueField(event, kCGMouseEventClickState, 2);
    CGEventPost(kCGHIDEventTap, event);
    CGEventSetType(event, kCGEventLeftMouseUp);
    CGEventPost(kCGHIDEventTap, event);
    CGEventSetType(event, kCGEventLeftMouseDown);
    CGEventPost(kCGHIDEventTap, event);
    CGEventSetType(event, kCGEventLeftMouseUp);
    CGEventPost(kCGHIDEventTap, event);
    CFRelease(event);
}

+ (void)rightClick {
    NSPoint loc = [self currentMouseLocation];
    CGEventRef event = CGEventCreateMouseEvent(NULL,
                                               kCGEventRightMouseDown,
                                               loc,
                                               kCGMouseButtonRight);
    CGEventPost(kCGHIDEventTap, event);
    CGEventSetType(event, kCGEventRightMouseUp);
    CGEventPost(kCGHIDEventTap, event);
    CFRelease(event);
}

+ (void)scroll:(CGPoint)delta {
    CGFloat x = delta.x;
    CGFloat y = delta.y;
    CGEventRef event = CGEventCreateScrollWheelEvent(NULL,
                                                     kCGScrollEventUnitPixel,
                                                     2,
                                                     y,
                                                     x);
    CGEventPost(kCGHIDEventTap, event);
    CFRelease(event);
}

+ (void)drag:(CGPoint)delta {
    NSPoint loc = [self currentMouseLocation];
    loc.y = loc.y + delta.y;
    CGEventRef event = CGEventCreateMouseEvent(NULL,
                                               kCGEventLeftMouseDragged,
                                               loc, 0);
    CGEventPost(kCGHIDEventTap, event);
    CFRelease(event);
}

+ (void)beginDrag {
    [self down];
    [[self sharedInstance] setDragEnabled:YES];
}

+ (void)endDrag {
    [[self sharedInstance] setDragEnabled:NO];
    [self up];
}

CGEventRef moveEventCallback(CGEventTapProxy proxy, CGEventType type,
                  CGEventRef event, void *refcon)
{
    if ([[Mouse sharedInstance] dragEnabled]) {
        CGEventSetType(event, kCGEventLeftMouseDragged);
    }
    return event;
}

CGEventRef keyUpEventCallback(CGEventTapProxy proxy, CGEventType type,
                              CGEventRef event, void *refcon)
{
    [Mouse move:CGPointMake(2, 0)];
    return event;
}

@end
