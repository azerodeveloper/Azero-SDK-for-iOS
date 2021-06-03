//
//  SaiPlaySoundManager.h
//  HeIsComing
//
//  Created by silk on 2020/8/18.
//  Copyright © 2020 soundai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SaiPlaySoundManager : NSObject
singleton_h(PlaySoundManager)
- (void)playSoundWithSource:(NSString *)source;
@end

NS_ASSUME_NONNULL_END
