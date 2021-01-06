//
//  TrackPadView.m
//  VTrackPad-iOS
//
//  Created by xuzhaocheng on 2020/12/26.
//

#import "TrackPadView.h"
#import "ClientConnectionManager.h"
#import "MouseEvent.h"
#import "TrackModeFSM.h"
#import "UITapGestureRecognizer+Cancel.h"

@interface TrackPadView()

@property (nonatomic, strong) TrackModeFSM *fsm;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
@property (nonatomic, strong) UITapGestureRecognizer *rightTap;

@end

@implementation TrackPadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.fsm = [[TrackModeFSM alloc] init];
        self.userInteractionEnabled = YES;
        self.multipleTouchEnabled = YES;
        [self setupGestures];
    }
    return self;
}

- (void)setupGestures {
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.numberOfTouchesRequired = 1;
    singleTap.numberOfTapsRequired = 1;
    self.singleTap = singleTap;
    [self addGestureRecognizer:singleTap];

    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.numberOfTouchesRequired = 1;
    self.doubleTap = doubleTap;
    [self addGestureRecognizer:doubleTap];

    UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightTap)];
    rightTap.delaysTouchesEnded = NO;
    rightTap.numberOfTouchesRequired = 2;
    rightTap.numberOfTapsRequired = 1;
    self.rightTap = rightTap;
    [self addGestureRecognizer:rightTap];

}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender {
#if DEBUG_TRACK_MODE
    NSLog(@"Single tap!");
#endif
    [self.delegate handleSingleClickEvent];
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)sender {
#if DEBUG_TRACK_MODE
    NSLog(@"Double tap!");
#endif
    [self.delegate handleDoubleClickEvent];
}

- (void)handleRightTap {
#if DEBUG_TRACK_MODE
    NSLog(@"Right tap!");
#endif
    [self.delegate handleRightClickEvent];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self reset];
    [self.fsm setTrackModeWithTouchCount:touches.count];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.fsm.curMode.type != TrackModeTypeDrag) {
        [self.fsm setTrackModeWithTouchCount:touches.count];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint cur = [touch locationInView:self];
    CGPoint prev = [touch previousLocationInView:self];
    CGPoint delta = CGPointMake(prev.x - cur.x, cur.y - prev.y);

    BOOL isMoved = !CGPointEqualToPoint(cur, prev);
    if (isMoved) {
        [self.singleTap cancel];
        [self.doubleTap cancel];
        [self.rightTap cancel];
    }

    [self.fsm accpetTouchCount:touches.count];

    TrackModeType curType = self.fsm.curMode.type;
    if (curType == TrackModeTypeDrag || curType == TrackModeTypeMove) {
        [self.delegate handleMoveEventWithDelta:delta];
    } else if (curType == TrackModeTypeScroll) {
        [self.delegate handleScrollEventWithDelta:delta];
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self reset];
}

- (void)reset {
    [self.fsm reset];
}

@end
