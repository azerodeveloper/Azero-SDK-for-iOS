//
//  FTCoreTextStyle.m
//  FTCoreText
//
//  Created by Francesco Freezone <cescofry@gmail.com> on 20/07/2011.
//  Copyright 2011 Fuerte International. All rights reserved.
//

#import "FTCoreTextStyle.h"

@implementation FTCoreTextStyle

@synthesize name = _name;
@synthesize appendedCharacter = _appendedCharacter;
@synthesize font = _font;
@synthesize color = _color;
@synthesize underlined = _underlined;
@synthesize textAlignment = _textAlignment;
@synthesize paragraphInset = _paragraphInset;
@synthesize applyParagraphStyling = _applyParagraphStyling;
@synthesize bulletCharacter = _bulletCharacter;
@synthesize bulletFont = _bulletFont;
@synthesize bulletColor = _bulletColor;
@synthesize leading = _leading;
@synthesize maxLineHeight = _maxLineHeight;
@synthesize minLineHeight = _minLineHeight;

- (id)init
{
	self = [super init];
	if (self) {
        self.name = @"_default";
        self.bulletCharacter = @"•";
        self.appendedCharacter = @"";
        self.font = [UIFont qk_PingFangSCRegularFontwithSize:15];
        self.color = [UIColor colorWithRed:86/255.0 green:86/255.0 blue:86/255.0 alpha:1.00f];
        self.underlined = NO;
        self.textAlignment = FTCoreTextAlignementLeft;
        self.maxLineHeight = 0;
        self.minLineHeight = 0;
        self.paragraphInset = UIEdgeInsetsZero;
        self.applyParagraphStyling = YES;
        self.leading = 10;
	}
	return self;
}

+ (id)styleWithName:(NSString *)name {
    FTCoreTextStyle *style = [[FTCoreTextStyle alloc] init];
    [style setName:name];
    return style;
}

- (UIFont *)bulletFont
{
	if (_bulletFont == nil) {
		return _font;
	}
	return _bulletFont;
}

- (UIColor *)bulletColor
{
	if (_bulletColor == nil) {
		return _color;
	}
	return _bulletColor;
}

- (id)copyWithZone:(NSZone *)zone
{
	FTCoreTextStyle *style = [[FTCoreTextStyle alloc] init];
	style.name = [self.name copy];
	style.bulletCharacter = self.bulletCharacter;
	style.appendedCharacter = [self.appendedCharacter copy];
	style.font = [UIFont fontWithName:self.font.fontName size:self.font.pointSize];
	style.color = self.color;
	style.underlined = self.isUnderLined;
    style.textAlignment = self.textAlignment;
	style.maxLineHeight = self.maxLineHeight;
	style.minLineHeight = self.minLineHeight;
	style.paragraphInset = self.paragraphInset;
	style.applyParagraphStyling = self.applyParagraphStyling;
	style.leading = self.leading;
	return style;
}

- (void)setParagraphInset:(UIEdgeInsets)paragraphInset
{
	_paragraphInset = paragraphInset;
}

- (void)dealloc
{    
//    [_name release];
//	[_bulletCharacter release];
//    [_appendedCharacter release];
//    [_font release];
//    [_color release];
//	[_bulletColor release];
//	[_bulletFont release];
//    [super dealloc];
}

#pragma GCC diagnostic warning "-Wdeprecated-declarations"

@end
