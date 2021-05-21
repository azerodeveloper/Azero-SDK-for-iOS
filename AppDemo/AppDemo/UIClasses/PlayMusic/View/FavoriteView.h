//
//  FavoriteView.h
//  Douyin
//
//  Created by Qiao Shi on 2018/7/30.
//  Copyright © 2018年 Qiao Shi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoriteView : UIView

@property (nonatomic, strong) UIImageView      *favoriteBefore;
@property (nonatomic, strong) UIImageView      *favoriteAfter;
@property(nonatomic,strong)void (^isFavoriteBlock)(BOOL isFavorite) ;
@property(nonatomic,assign)BOOL isFavorite ;

- (void)resetView;

@end
