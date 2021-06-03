//
//  UITextField+MSAdd.m
//  SoundAi
//
//  Created by silk on 2019/11/20.
//  Copyright © 2019 soundai. All rights reserved.
//

#import "UITextField+MSAdd.h"


@implementation UITextField (MSAdd)

-(NSRange)selectedRange{ 
    NSInteger location = [self offsetFromPosition:self.beginningOfDocument toPosition:self.selectedTextRange.start];
    NSInteger length = [self offsetFromPosition:self.selectedTextRange.start toPosition:self.selectedTextRange.end];
    return NSMakeRange(location, length);
}

-(void)setSelectedRange:(NSRange)selectedRange{
    UITextPosition *startPosition = [self positionFromPosition:self.beginningOfDocument offset:selectedRange.location];
    UITextPosition *endPosition = [self positionFromPosition:self.beginningOfDocument offset:selectedRange.location + selectedRange.length];
    UITextRange *selectedTextRange = [self textRangeFromPosition:startPosition toPosition:endPosition];
    [self setSelectedTextRange:selectedTextRange];
}


-(void)changePlaceholderColor{
    if (@available(iOS 13.0, *)) {
        if (self.font == nil || self.placeholder == nil) {

        }else{
            NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:self.placeholder attributes:
            @{NSForegroundColorAttributeName:[UIColor lightGrayColor],
                         NSFontAttributeName:self.font
                 }];
            self.attributedPlaceholder = attrString;
        }
        self.textColor = [UIColor blackColor];
    }
    
}

@end
