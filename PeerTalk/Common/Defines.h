//
//  Defines.h
//  VTrackPad-iOS
//
//  Created by xuzhaocheng on 2020/12/26.
//

typedef NS_ENUM(UInt8, MouseEventType) {
    MouseEventTypeNone = 0,
    MouseEventTypeMove,
    MouseEventTypeSingleClick,
    MouseEventTypeDoubleClick,
    MouseEventTypeRightClick,
    MouseEventTypeScroll,
    MouseEventTypeBeginDrag,
    MouseEventTypeEndDrag,
};

typedef struct _PTEventFrame {
    MouseEventType type;
    float x;
    float y;
} PTEventFrame;
