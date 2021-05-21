//
//  FTCoreTextCommon.m
//  RCS
//
//  Created by qxxw_a_n on 13-11-2.
//  Copyright (c) 2013年 feinno. All rights reserved.
//

#import "FTCoreTextCommon.h"
//#import "KBPageImageItemManager.h"
//#import "SetManager.h"
//#import "CinLogger.h"
@implementation FTCoreTextCommon

//SYNTHESIZE_SINGLETON_FOR_CLASS(FTCoreTextCommon);
singleton_m(FTCoreTextCommon);
- (id)init
{
    self = [super init];
    if (self) {

        
//        NSString *regex_http = @"((http|ftp|https)://)?(www\\.)?((([a-zA-Z0-9]+\\.)+[a-zA-Z]{2,6})|([255-0]\\.[255-0]\\.[255-0]\\.[255-0]))(:[0-9]{1,4})*(/([!-~]|[\u2E80-\u9FFF]+)*)?";
        
        
//        NSString *regex_http = @"((http|ftp|https)://)?(([a-zA-Z0-9\\._-]+\\.[a-zA-Z]{2,6})|([0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}))(:[0-9]{1,4})*(/[a-zA-Z0-9\\&%_\\./-~-]*)?";
        
//                    @"((http|ftp|https)://)?
//        (([a-zA-Z0-9_-]+\\.[a-zA-Z]{2,6})|([0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}))(:[0-9]{1,4})*(/[a-zA-Z0-9\\&%_\\./-~-]*)?"
//        NSString *regex_http = @"(http://|https://)?((?:[A-Za-z0-9]+-[A-Za-z0-9]+|[A-Za-z0-9]+)\\.)+([A-Za-z]+)[/\?\\:]?.*";
//        NSString *regex_http = @"https?://[^\\s]*";
        NSError *error = nil;
        httpRegular = [[NSRegularExpression alloc] initWithPattern:regex_http options:NSRegularExpressionCaseInsensitive error:&error];
        if (error) {
//            infoLog(@"error = %@",error);
        }
        
//        NSString *regex_phonenum = @"^(\\+86)?((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))[-|+]?\\d{4}[-|+]?\\d{4}";
//        NSString *regex_phonenum =@"\\d{3,}";
//        numberRegular = [[NSRegularExpression alloc] initWithPattern:regex_phonenum options:NSRegularExpressionCaseInsensitive error:&error];
        
        if (error) {
//            infoLog(@"error = %@",error);
        }
        
        if (error) {
//            infoLog(@"error = %@",error);
        }
        
//        NSString *regex_emoji = @"[\\uE000-\\uF8FF]|\\uD83C[\\uDF00-\\uDFFF]|\\uD83D[\\uDC00-\\uDDFF]";
        emojiRegular = [[NSRegularExpression alloc] initWithPattern:regex_emoji options:NSRegularExpressionCaseInsensitive error:&error];
        
        if (error) {
//            infoLog(@"error = %@",error);
        }
    }
    return self;
}

- (void)addFetion:(NSString **)text
{
//    NSString *cutStr ;
//    int j = -1;//找到[的位置
//    for (int i = 0; i<[*text length]; i++) {
//        if ([*text characterAtIndex:i] == '[') {
//            j = i;
//        }else if (j>=0 && [*text characterAtIndex:i] == ']') {
//            NSRange range = NSMakeRange(j, i-j+1);
//            //判断[]内是否有字符
//            if (range.length>2) {
//                //如果有字符，去飞信表情表中比对
//                cutStr = [*text substringWithRange:range];
//                NSString *imageName = [[KBPageImageItemManager sharedKBPageImageItemManager].fetionDic objectForKey:cutStr];
//                if (imageName) {
//                    NSString *imageHtml = [NSString stringWithFormat:@"[img]%@[/img]",imageName];
//                    *text = [*text stringByReplacingCharactersInRange:NSMakeRange(range.location, [cutStr length]) withString:imageHtml];
//                    i += [imageHtml length] - [cutStr length];
//                }
//                //如果找到了匹配的表情符号
//                j = -1;
//            }
//            
//        }else{
//            //开始检测表情
//            if (j>=0) {
//                continue;
//            }
//        }
//    }
    
    int j = -1;//找到[的位置
    for (int i = 0; i<[*text length]; i++) {
        if ([*text characterAtIndex:i] == '#') {
            if (i+1<[*text length] &&  [*text characterAtIndex:(i+1)] == '(') {
               j = i;
            }
            
        }else if (j>=0 && [*text characterAtIndex:i] == ')') {
            NSRange range = NSMakeRange(j, i-j+1);
            //判断[]内是否有字符
            if (range.length>3) {
                //如果有字符，去飞信表情表中比对
//                cutStr = [*text substringWithRange:range];
//                NSString *imageName = [[KBPageImageItemManager sharedKBPageImageItemManager].fetionDic objectForKey:cutStr];
//                if (imageName) {
//                    NSString *imageHtml = [NSString stringWithFormat:@"[img]%@[/img]",imageName];
//                    *text = [*text stringByReplacingCharactersInRange:NSMakeRange(range.location, [cutStr length]) withString:imageHtml];
//                    i += [imageHtml length] - [cutStr length];
//                }
                //如果找到了匹配的表情符号
                j = -1;
            }
            
        }else{
            //开始检测表情
            if (j>=0) {
                continue;
            }
        }
    }
}

- (void)addEmoji:(NSString **)text
{
//    NSArray *tempArray = [emojiRegular matchesInString:*text options:NSMatchingReportProgress range:NSMakeRange(0, [*text length])];
//    if ([tempArray count]) {
//        for (NSTextCheckingResult* b in tempArray)
//        {
////            NSRange range = b.range;
////            NSString *str = [*text substringWithRange:b.range];
////            NSString *i_transCharacter = [[KBPageImageItemManager sharedKBPageImageItemManager].signDic objectForKey:str];
////            if (i_transCharacter) {
////                NSString *imageHtml = [NSString stringWithFormat:@"[img]%@[/img]",i_transCharacter];
////                *text = [*text stringByReplacingCharactersInRange:NSMakeRange(range.location, [str length]) withString:imageHtml];
////            }
//
//        }
//    }
}

- (void)addHttpArr:(NSString **)text
{
    NSArray *tempArray = [httpRegular matchesInString:*text options:NSMatchingReportProgress range:NSMakeRange(0, [*text length])];
    if ([tempArray count]) {
        int startOffset=0;
        for (NSTextCheckingResult* b in tempArray)
        {
            NSRange range = b.range;
            NSString *str = [*text substringWithRange:NSMakeRange(range.location+startOffset,range.length)];
            if ([str rangeOfString:@".png"].location == NSNotFound)
            {
                NSString *httpHtml = [NSString stringWithFormat:@"[link]%@[/link]",str];
                *text = [*text stringByReplacingCharactersInRange:NSMakeRange(range.location+startOffset, [str length]) withString:httpHtml];
                startOffset+=13;
            }
        }
    }
}

- (void)addPhoneNumArr:(NSString **)text
{
    NSArray *tempArray = [numberRegular matchesInString:*text options:NSMatchingReportProgress range:NSMakeRange(0, [*text length])];
    NSArray *httpArray = [httpRegular matchesInString:*text options:NSMatchingReportProgress range:NSMakeRange(0, [*text length])];
    if ([tempArray count]) {
         int startOffset=0;
        for (NSTextCheckingResult* b in tempArray)
        {
            NSRange range = b.range;
            NSString *startSubString=[*text substringFromIndex:b.range.location+startOffset];
            //搜出的字符串是否是网址
            if ([startSubString rangeOfString:@"[/link]"].length==0) {
                
                NSString *str = [*text substringWithRange:NSMakeRange(range.location+startOffset,range.length)];
                NSString *httpHtml = [NSString stringWithFormat:@"[link]%@[/link]",str];
                *text = [*text stringByReplacingCharactersInRange:NSMakeRange(range.location+startOffset, [str length]) withString:httpHtml];
                startOffset+=13;
            }else{
                BOOL isHttp=NO;
                if ([httpArray count]) {
                    for (NSTextCheckingResult* h in httpArray)
                    {
                        if (h.range.location<=b.range.location&&h.range.location+h.range.length>=b.range.location+b.range.length) {
                            isHttp=YES;
                            break;
                        }
                    }
                }
                if (isHttp==NO) {
                    NSString *str = [*text substringWithRange:NSMakeRange(range.location+startOffset,range.length)];
                    NSString *httpHtml = [NSString stringWithFormat:@"[link]%@[/link]",str];
                    *text = [*text stringByReplacingCharactersInRange:NSMakeRange(range.location+startOffset, [str length]) withString:httpHtml];
                    startOffset+=13;
                }
            }
        }
    }
}

- (NSString *)getDrawTextByNormalText:(NSString *)normalText
{
    NSString *drawText = [NSString stringWithString:normalText];
    [self addFetion:&drawText];
    if (drawText.length < 1000)
    {
//        [self addEmoji:&drawText];
        [self addHttpArr:&drawText];
        [self addPhoneNumArr:&drawText];
    }
    return drawText;
}
- (NSArray *)getCorePureTextStyle{
    NSMutableArray *result = [NSMutableArray array];
    
    FTCoreTextStyle *defaultStyle = [FTCoreTextStyle new];
    defaultStyle.name = FTCoreTextTagDefault;    //thought the default name is already set to FTCoreTextTagDefault
    defaultStyle.textAlignment = FTCoreTextAlignementCenter;
    [result addObject:defaultStyle];
//    [defaultStyle release];
    
    FTCoreTextStyle *imageStyle = [FTCoreTextStyle new];
    imageStyle.paragraphInset = UIEdgeInsetsMake(0,0,0,0);
    imageStyle.font=[UIFont qk_PingFangSCRegularFontwithSize:15];
    imageStyle.name = FTCoreTextTagImage;
    imageStyle.textAlignment = FTCoreTextAlignementCenter;
    [result addObject:imageStyle];
//    [imageStyle release];
    
    FTCoreTextStyle *linkStyle = [defaultStyle copy];
    linkStyle.name = FTCoreTextTagLink;
    linkStyle.color =[UIColor colorWithRed:74.0/255.0 green:163.0/255.0 blue:227.0/255.0 alpha:1];
    linkStyle.underlined=YES;
    linkStyle.textAlignment = FTCoreTextAlignementJustified;
    [result addObject:linkStyle];
//    [linkStyle release];
    
//    FTCoreTextStyle *coloredStyle = [defaultStyle copy];
//    [coloredStyle setName:@"colored"];
//    [coloredStyle setColor:[UIColor redColor]];
//    [result addObject:coloredStyle];
//    [coloredStyle release];
    
    return result;
}

- (NSArray *)getCoreTextStyle
{
    NSMutableArray *result = [NSMutableArray array];
    
	FTCoreTextStyle *defaultStyle = [FTCoreTextStyle new];
	defaultStyle.name = FTCoreTextTagDefault;	//thought the default name is already set to FTCoreTextTagDefault
    defaultStyle.textAlignment = FTCoreTextAlignementLeft;
	[result addObject:defaultStyle];
//    [defaultStyle release];
	
	FTCoreTextStyle *imageStyle = [FTCoreTextStyle new];
	imageStyle.paragraphInset = UIEdgeInsetsMake(0,0,0,0);
    imageStyle.font=[UIFont qk_PingFangSCRegularFontwithSize:15];
	imageStyle.name = FTCoreTextTagImage;
	imageStyle.textAlignment = FTCoreTextAlignementLeft;
	[result addObject:imageStyle];
//    [imageStyle release];
	
	FTCoreTextStyle *linkStyle = [defaultStyle copy];
	linkStyle.name = FTCoreTextTagLink;
	linkStyle.color =[UIColor whiteColor];
    linkStyle.underlined=YES;
    linkStyle.textAlignment = FTCoreTextAlignementJustified;
	[result addObject:linkStyle];
//    [linkStyle release];
    
//    FTCoreTextStyle *coloredStyle = [defaultStyle copy];
//    [coloredStyle setName:@"colored"];
//    [coloredStyle setColor:[UIColor redColor]];
//	[result addObject:coloredStyle];
//    [coloredStyle release];
    
    return result;
}
- (NSArray *)getCoreTextStyleWithFont:(UIFont*)font color:(UIColor*)color
{
    (void)(assert(font)),assert(color);

    NSMutableArray *result = [NSMutableArray array];
    FTCoreTextStyle *defaultStyle = [FTCoreTextStyle new];
    defaultStyle.name = FTCoreTextTagDefault;	//thought the default name is already set to FTCoreTextTagDefault
 
    defaultStyle.font = font;
    defaultStyle.color = color ;
    defaultStyle.textAlignment = FTCoreTextAlignementLeft;
    [result addObject:defaultStyle];
//    [defaultStyle release];
    
//    FTCoreTextStyle *imageStyle = [FTCoreTextStyle new];
//    imageStyle.paragraphInset = UIEdgeInsetsMake(0,0,0,0);
//    imageStyle.font=[[TYUIFont sharedTYUIFont] getF30Font];
//    imageStyle.name = FTCoreTextTagImage;
//    imageStyle.textAlignment = FTCoreTextAlignementLeft;
//    [result addObject:imageStyle];
//    [imageStyle release];
    
    FTCoreTextStyle *linkStyle = [defaultStyle copy];
    linkStyle.name = FTCoreTextTagLink;
//    linkStyle.color = [UIColor colorWithRed:74.0/255.0 green:163.0/255.0 blue:227.0/255.0 alpha:1];
    linkStyle.color = [UIColor blueColor];
    linkStyle.underlined= YES;
    linkStyle.textAlignment = FTCoreTextAlignementJustified;
    [result addObject:linkStyle];
//    [linkStyle release];
    
    
    return result;

}

- (NSArray *)getSocialTopicCoreTextStyle
{
    NSMutableArray *result = [NSMutableArray array];
    
    FTCoreTextStyle *defaultStyle = [FTCoreTextStyle new];
    defaultStyle.name = FTCoreTextTagDefault;	//thought the default name is already set to FTCoreTextTagDefault
//    SetModel *model=[[SetManager sharedSetManager] getSetModel];
//    switch (model.fontSize) {
//        case 0:
//            defaultStyle.font = [UIFont qk_PingFangSCRegularFontwithSize:15];
//            break;
//        case 1:
//            defaultStyle.font = [UIFont qk_PingFangSCRegularFontwithSize:17];
//            break;
//        case 2:
//            defaultStyle.font = [UIFont qk_PingFangSCRegularFontwithSize:16];
//            break;
//        default:
            defaultStyle.font = [UIFont qk_PingFangSCRegularFontwithSize:15];
//            break;
//    }
    defaultStyle.textAlignment = FTCoreTextAlignementLeft;
    [result addObject:defaultStyle];
//    [defaultStyle release];
    
    FTCoreTextStyle *imageStyle = [FTCoreTextStyle new];
    imageStyle.paragraphInset = UIEdgeInsetsMake(0,2,0,0);
    imageStyle.font=[UIFont qk_PingFangSCRegularFontwithSize:15];
    imageStyle.name = FTCoreTextTagImage;
    imageStyle.textAlignment = FTCoreTextAlignementJustified;
    [result addObject:imageStyle];
//    [imageStyle release];
    
    FTCoreTextStyle *linkStyle = [defaultStyle copy];
    linkStyle.name = FTCoreTextTagLink;
    linkStyle.color = [UIColor colorWithRed:102/255. green:141/255. blue:191/255. alpha:1];
    linkStyle.underlined=YES;
    linkStyle.font = defaultStyle.font;
    linkStyle.textAlignment = FTCoreTextAlignementJustified;
    [result addObject:linkStyle];
//    [linkStyle release];
    
    return result;
}

- (NSArray *)getSocialTopicCoreTextStyleWithNormalText:(NSString *)normalText {
    NSMutableArray *result = [NSMutableArray array];
    
    FTCoreTextStyle *defaultStyle = [FTCoreTextStyle new];
    defaultStyle.name = FTCoreTextTagDefault;
//    SetModel *model=[[SetManager sharedSetManager] getSetModel];
//    switch (model.fontSize) {
//        case 0:
//            defaultStyle.font = [UIFont qk_PingFangSCRegularFontwithSize:15];
//            break;
//        case 1:
//            defaultStyle.font = [UIFont qk_PingFangSCRegularFontwithSize:17];
//            break;
//        case 2:
//            defaultStyle.font = [UIFont qk_PingFangSCRegularFontwithSize:16];
//            break;
//        default:
            defaultStyle.font = [UIFont qk_PingFangSCRegularFontwithSize:15];
//            break;
//    }
    defaultStyle.textAlignment = FTCoreTextAlignementLeft;
    [result addObject:defaultStyle];
    
    FTCoreTextStyle *imageStyle = [FTCoreTextStyle new];
    imageStyle.paragraphInset = UIEdgeInsetsMake(0,2,0,0);
    imageStyle.font=[UIFont qk_PingFangSCRegularFontwithSize:15];
    imageStyle.name = FTCoreTextTagImage;
    imageStyle.textAlignment = FTCoreTextAlignementJustified;
    [result addObject:imageStyle];
    
    FTCoreTextStyle *linkStyle = [defaultStyle copy];
    linkStyle.name = FTCoreTextTagLink;
    linkStyle.color = [UIColor colorWithRed:102/255. green:141/255. blue:191/255. alpha:1];
    //纯数字不加下划线
    NSArray *httpArray = [httpRegular matchesInString:normalText options:NSMatchingReportProgress range:NSMakeRange(0, normalText.length)];
    if (httpArray.count) {
        linkStyle.underlined = YES;
    }
    linkStyle.font = defaultStyle.font;
    linkStyle.textAlignment = FTCoreTextAlignementJustified;
    [result addObject:linkStyle];

    return result;
}

- (void)dealloc
{
    
//    [super dealloc];
}

@end
