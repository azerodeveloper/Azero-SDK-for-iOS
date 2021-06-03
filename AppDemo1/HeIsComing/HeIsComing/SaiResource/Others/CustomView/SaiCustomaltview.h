//
//  SaiCustomaltview.h
//  HeIsComing
//
//  Created by silk on 2020/8/6.
//  Copyright © 2020 soundai. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol CustomaltviewDelegate;

@protocol CustomaltviewDelegate <NSObject>
- (void)alertview:(id)altview clickbuttonIndex:(NSInteger)index;
@end
@interface SaiCustomaltview : UIView<CustomaltviewDelegate>
@property(nonatomic,strong)UIView *view;
@property(nonatomic,assign)float altHeight;
@property(nonatomic,assign)float altwidth;
@property(nonatomic,weak)id<CustomaltviewDelegate>delegate;

- (void)creatAltWithAltTile:(NSString*)title content:(NSString*)content;
- (void)show;
- (void)hide;
@end

NS_ASSUME_NONNULL_END
