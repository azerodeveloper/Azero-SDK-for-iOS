//
//  SaiMusicListModel.h
//  HeIsComing
//
//  Created by silk on 2020/2/27.
//  Copyright © 2020 soundai. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SaiMusicListModel : NSObject
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,assign) BOOL showDetails;
@property (nonatomic ,assign) NSNumber *position;
@property (nonatomic ,copy) NSString *header;
@property (nonatomic ,strong) NSDictionary *art;
@property (nonatomic ,strong) NSDictionary *provider;
@property (nonatomic ,copy) NSString *pic_url;

@end

NS_ASSUME_NONNULL_END
