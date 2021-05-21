//
//  TGBarrageCell.h
//  TGBarrageViewDemo
//
//  Created by tsaievan on 21/10/2018.
//  Copyright © 2018 tsaievan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXBaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@class TGBarrageCell;
@protocol TGBarrageCellDelegate <NSObject>

- (void)barrageCell:(TGBarrageCell *)barrageCell updateConstraintsWithWidth:(CGSize)size;

@end

@interface TGBarrageCell : UIControl

@property(nonatomic,strong)WXBaseModelContentsExtCommentFirstPage *baseModelContents ;

@property (nonatomic, weak) id <TGBarrageCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
