//
//  UIButton+EnlargeEdge.h
//  bcdTest
//
//  Created by zengqiang xing on 2018/6/3.
//  Copyright © 2018年 zengqiang xing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface UIButton (EnlargeEdge)

// 设置可点击范围到按钮边缘的距离
-(void)setEnLargeEdge:(CGFloat)size;

// 设置可点击范围到按钮上、右、下、左的距离
-(void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;

@end
