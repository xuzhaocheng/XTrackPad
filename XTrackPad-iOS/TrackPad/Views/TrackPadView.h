//
//  TrackPadView.h
//  VTrackPad-iOS
//
//  Created by xuzhaocheng on 2020/12/26.
//

#import <UIKit/UIKit.h>

#import "TrackPadActionConsumerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface TrackPadView : UIView

@property (nonatomic, weak) id<TrackPadActionConsumerProtocol> delegate;

@end

NS_ASSUME_NONNULL_END
