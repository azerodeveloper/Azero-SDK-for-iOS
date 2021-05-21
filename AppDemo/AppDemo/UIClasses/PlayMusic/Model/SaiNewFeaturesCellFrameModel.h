//
//  SaiNewFeaturesCellFrameModel.h
//  HeIsComing
//
//  Created by silk on 2020/11/21.
//  Copyright © 2020 soundai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SaiNewFeaturesCellFrameModel : NSObject
@property (nonatomic ,copy) NSString *featuresText;
@property (nonatomic, assign, readonly) CGRect bubbleImageViewFrame;
@property (nonatomic, assign, readonly) CGRect textRectFrame;
@property (nonatomic, assign) CGFloat cellHeight;

@end

NS_ASSUME_NONNULL_END
