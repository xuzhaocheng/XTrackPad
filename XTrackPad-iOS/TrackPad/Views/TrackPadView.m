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

@interface TrackPadView()

@property (nonatomic, strong) TrackModeFSM *fsm;
@property (nonatomic, assign, getter=isMoved) BOOL moved;

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
    [self addGestureRecognizer:singleTap];

    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:doubleTap];

    UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleRightTap)];
    rightTap.delaysTouchesEnded = NO;
    rightTap.numberOfTouchesRequired = 2;
    rightTap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:rightTap];

}

- (void)handleSingleTap:(UITapGestureRecognizer *)sender {
#if DEBUG_TRACK_MODE
    NSLog(@"Single tap!");
#endif
    if (!self.isMoved) {
        [self.delegate handleSingleClickEvent];
    }
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)sender {
#if DEBUG_TRACK_MODE
    NSLog(@"Double tap!");
#endif
    if (!self.isMoved) {
        [self.delegate handleDoubleClickEvent];
    }
}

- (void)handleRightTap {
#if DEBUG_TRACK_MODE
    NSLog(@"Right tap!");
#endif
    if (!self.isMoved) {
        [self.delegate handleRightClickEvent];
    }
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

    self.moved = self.isMoved || !CGPointEqualToPoint(cur, prev);

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
    self.moved = NO;
    [self.fsm reset];
}

@end
