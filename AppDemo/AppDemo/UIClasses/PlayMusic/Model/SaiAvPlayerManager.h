//
//  SaiAvPlayerManager.h
//  HeIsComing
//
//  Created by silk on 2020/8/26.
//  Copyright © 2020 soundai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SaiAvPlayerManager : NSObject
@property (nonatomic ,copy) NSString *alertUrl;
@property (nonatomic ,assign) BOOL isAnswerModel;

singleton_h(AvPlayerManager);

- (void)managerPlayUrl:(NSString *)url;

- (void)play;
- (void)stop;
@end

NS_ASSUME_NONNULL_END
