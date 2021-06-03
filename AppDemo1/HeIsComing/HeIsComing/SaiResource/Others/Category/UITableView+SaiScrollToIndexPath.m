//
//  UITableView+SaiScrollToIndexPath.m
//  SaiIntelligentSpeakers
//
//  Created by silk on 2018/12/5.
//  Copyright © 2018 soundai. All rights reserved.
//

#import "UITableView+SaiScrollToIndexPath.h"

@implementation UITableView (SaiScrollToIndexPath)
-(void)ty_scrollToBottomAnimated:(BOOL)animated{
    
    //  workaround for really long messages not scrolling
    //  if last message is too long, use scroll position bottom for better appearance, else use top
    //  possibly a UIKit bug, see #480 on GitHub
    NSUInteger finalRow = MAX(0, [self numberOfRowsInSection:0]-1);
    NSIndexPath *finalIndexPath = [NSIndexPath indexPathForRow:finalRow inSection:0];
    
    [self ty_scrollToIndexPath:finalIndexPath atScrollPosition:UITableViewScrollPositionTop Animated:animated];
}

- (void)ty_scrollToIndexPath:(NSIndexPath*)indexPath Animated:(BOOL)animated{
    
    [self ty_scrollToIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom Animated:animated];
    
}

- (void)ty_scrollToIndexPath:(NSIndexPath *)indexPath atScrollPosition:(UITableViewScrollPosition)postion Animated:(BOOL)animated{
    
    
    if ([self numberOfSections] == 0) {
        return;
    }
    
    if ([self numberOfRowsInSection:0] == 0) {
        return;
    }
    
    //    CGFloat tableViewContentHeight = self.contentSize.height;
    //    BOOL isContentTooSmall = (tableViewContentHeight < CGRectGetHeight(self.frame));
    //    if (isContentTooSmall) {
    //        //  workaround for the first few messages not scrolling
    //        //  when the collection view content size is too small, `scrollToItemAtIndexPath:` doesn't work properly
    //        //  this seems to be a UIKit bug, see #256 on GitHub
    //        [self scrollRectToVisible:CGRectMake(0.0, tableViewContentHeight - 1.0f, 1.0f, 1.0f)
    //                         animated:animated];
    //        return;
    //    }
    
    
    [self scrollToRowAtIndexPath:indexPath atScrollPosition:postion animated:animated];
    
}

@end
