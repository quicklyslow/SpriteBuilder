//
//  CCBPSprite9Slice.m
//  SpriteBuilder
//
//  Created by Viktor on 12/17/13.
//
//

#import "CCBPSprite9Slice.h"
#import "AppDelegate.h"
#import "InspectorController.h"

@implementation CCBPSprite9Slice


- (void)setMargin:(float)margin
{
    //margin = clampf(margin, 0, 0.5);
	[super setMargin:margin];
}

// ---------------------------------------------------------------------

- (void)setMarginLeft:(float)marginLeft
{
    //marginLeft = clampf(marginLeft, 0, 1);
	float textureWidth = self.textureRect.size.width;
	if(textureWidth > 0 && self.marginRight + marginLeft >= textureWidth)
	{
        dispatch_async(dispatch_get_main_queue(), ^{
            [[InspectorController sharedController] refreshProperty:@"marginLeft"];
		    [[AppDelegate appDelegate] modalDialogTitle:@"Margin Restrictions" message:@"The left & right margins should add up to less than texture width"];
        });
        return;
	}

	[super setMarginLeft:marginLeft];
}

- (void)setMarginRight:(float)marginRight
{
    //marginRight = clampf(marginRight, 0, 1);
    float textureWidth = self.textureRect.size.width;
	if(textureWidth > 0 && self.marginLeft + marginRight >= textureWidth)
	{
        dispatch_async(dispatch_get_main_queue(), ^{
            [[InspectorController sharedController] refreshProperty:@"marginRight"];
            [[AppDelegate appDelegate] modalDialogTitle:@"Margin Restrictions" message:@"The left & right margins should add up to less than texture width"];
        });
        return;
	}
	
	[super setMarginRight:marginRight];
}

- (void)setMarginTop:(float)marginTop
{
    //marginTop = clampf(marginTop, 0, 1);
    float textureHeight = self.textureRect.size.height;
	if(textureHeight > 0 && self.marginBottom + marginTop >= textureHeight)
	{
        dispatch_async(dispatch_get_main_queue(), ^{
            [[InspectorController sharedController] refreshProperty:@"marginTop"];
		    [[AppDelegate appDelegate] modalDialogTitle:@"Margin Restrictions" message:@"The top & bottom margins should add up to less than texture height"];
        });
		return;
	}
	
	[super setMarginTop:marginTop];
   
}

- (void)setMarginBottom:(float)marginBottom
{
    //marginBottom = clampf(marginBottom, 0, 1);
    float textureHeight = self.textureRect.size.height;
	if(textureHeight > 0 && self.marginTop + marginBottom >= textureHeight)
	{
        dispatch_async(dispatch_get_main_queue(), ^{
            [[InspectorController sharedController] refreshProperty:@"marginBottom"];
            [[AppDelegate appDelegate] modalDialogTitle:@"Margin Restrictions" message:@"The top & bottom margins should add up to less than texture height"];
        });
		return;
	}
	
	[super setMarginBottom:marginBottom];
}

@end
