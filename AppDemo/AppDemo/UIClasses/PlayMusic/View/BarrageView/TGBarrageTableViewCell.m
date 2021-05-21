//
//  TGBarrageCell.m
//  TGBarrageViewDemo
//
//  Created by tsaievan on 21/10/2018.
//  Copyright © 2018 tsaievan. All rights reserved.
//

#import "TGBarrageTableViewCell.h"
#import "TGBarrageCell.h"

@interface TGBarrageTableViewCell () <TGBarrageCellDelegate>

@property (nonatomic, strong) TGBarrageCell *contentCell;

@end

@implementation TGBarrageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    self.backgroundColor = UIColor.clearColor;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.contentCell];
    [self makeConstraints];
}

- (void)makeConstraints {
    [self.contentCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(15);
        make.top.mas_equalTo(self.contentView);
        make.width.mas_offset(100);
        make.bottom.mas_offset(kSCRATIO(-16));

    }];
    
    
}

- (TGBarrageCell *)contentCell {
    if (!_contentCell) {
        _contentCell = [[TGBarrageCell alloc] init];
        _contentCell.delegate = self;
    }
    return _contentCell;
}
-(void)setBaseModelContents:(WXBaseModelContentsExtCommentFirstPage *)baseModelContents{
    _baseModelContents=baseModelContents;
    _contentCell.baseModelContents = baseModelContents;

}

 
- (void)barrageCell:(TGBarrageCell *)barrageCell updateConstraintsWithWidth:(CGSize)size {
    
    [barrageCell mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_offset(size.width);
    }];
  
}

//- (void)didTouchContentCellAction:(UIControl *)sender {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(barrageTableViewCell:didTouchAction:)]) {
//        [self.delegate barrageTableViewCell:self didTouchAction:sender];
//    }
//}


@end

