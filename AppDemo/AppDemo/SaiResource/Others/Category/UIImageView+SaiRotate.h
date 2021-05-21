//
//  UIImageView+SaiRotate.h
//  SaiIntelligentSpeakers
//
//  Created by silk on 2018/11/30.
//  Copyright © 2018 soundai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (SaiRotate)
-(void) startRotating;
-(void) stopRotating;
-(void) resumeRotate;
@end

NS_ASSUME_NONNULL_END
