//
//  SaiCustomaltview.m
//  HeIsComing
//
//  Created by silk on 2020/8/6.
//  Copyright © 2020 soundai. All rights reserved.
//

#import "SaiCustomaltview.h"

@implementation SaiCustomaltview

- (void)creatAltWithAltTile:(NSString *)title content:(NSString *)content{
    _view = [[UIView alloc] init];
    UILabel *altTitleLabel = [[UILabel alloc] init];
    altTitleLabel.text = title;
    [altTitleLabel setTextAlignment:NSTextAlignmentCenter];
    [altTitleLabel setFont:[UIFont qk_PingFangSCRegularFontwithSize:20.0f]];
    [altTitleLabel setTextColor:[UIColor colorWithRed:0.3f green:0.3f blue:0.3f alpha:1.0]];
    [altTitleLabel setFrame:CGRectMake(0, 10, _altwidth, 30)];
    [_view addSubview:altTitleLabel];
    
    UILabel *altContent = [[UILabel alloc] init];
    [altContent setText:content];
    [altContent setFont:[UIFont qk_PingFangSCRegularFontwithSize:18.0f]];
    [altContent setTextAlignment:NSTextAlignmentLeft];
    [altContent setTextColor:[UIColor colorWithRed:0.3f green:0.3f blue:0.3f alpha:1.0]];
    [altContent setLineBreakMode:NSLineBreakByCharWrapping];
    CGSize size = [SaiUIUtils getSizeWithLabel:altContent.text withFont:[UIFont systemFontOfSize:15.0f] withSize:CGSizeMake(_altwidth-20, 700.0f)];
    [altContent setFrame:CGRectMake(10, 30, _altwidth-20, (int)size.height+35+20)];
    altContent.numberOfLines = (int)size.height/20+1;
    _altHeight = 35+altContent.frame.size.height;
    altContent.textAlignment = NSTextAlignmentCenter;
    [_view addSubview:altContent];
    
//    UIButton *altbtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    [altbtn setTitle:@"取消" forState:UIControlStateNormal];
//    [altbtn setBackgroundColor:[UIColor grayColor]];
//    [altbtn setTag:0];
//    [altbtn setFrame:CGRectMake(50, _altHeight, (_altwidth-50*2), 35)];
//    [altbtn addTarget:self action:@selector(checkbtn:) forControlEvents:UIControlEventTouchUpInside];
//    altbtn.layer.masksToBounds = YES;
//    altbtn.layer.cornerRadius = 3.0f;
//    [_view addSubview:altbtn];
    
//    _altHeight+=20;
    [_view setFrame:CGRectMake((320-_altwidth)/2, ([UIScreen mainScreen].bounds.size.height-_altHeight)/2-64, _altwidth , _altHeight)];
    _view.center = CGPointMake(self.center.x, self.center.y - 50);
    _view.layer.masksToBounds = YES;
    _view.layer.cornerRadius = 6.0;
    [_view setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0]];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.33];
    [self addSubview:_view];
}

#pragma Delegate
-(void)alertview:(id)altview clickbuttonIndex:(NSInteger)index
{
    [_delegate alertview:self clickbuttonIndex:index];
}
#pragma SELECTOR
-(void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    [self hide];
}
-(void)checkbtn:(UIButton *)sender
{
    [_delegate alertview:self clickbuttonIndex:sender.tag];
}
#pragma Instance method
-(void)show
{
    if(_view==nil)
    {
        _view=[[UIView alloc] init];
    }
    [_view setHidden:NO];
    [self setHidden:NO];
}
-(void)hide
{
    if(_view==nil)
    {
        _view=[[UIView alloc] init];
    }
    [_view setHidden:YES];
    [self setHidden:YES];
}

@end
