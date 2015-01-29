# SpriteBuilder

SpriteBuilder is the first game development suite for rapidly building native iOS and Android games with Objective-C and Xcode. SpriteBuilder is free and open source (MIT licensed) and available for download in the [Mac App Store](https://itunes.apple.com/us/app/spritebuilder/id784912885?mt=12).

Core Features:

* Designer-friendly UI
* Animation editor for scenes, characters and boned animations
* Tileless editor
* User interface designer
* Asset management & sprite sheet generation
* Tools for localization

For more info, please visit [spritebuilder.com](http://spritebuilder.com).

## Getting started with the source

Change directory into the top (this) directory of SpriteBuilder and run:

    git clone https://github.com/apportable/SpriteBuilder
    cd SpriteBuilder
    git submodule update --init --recursive
    cd scripts
    ./build_distribution.py --version 1.x

You need to use the BuildDistribution.sh script the first time you build SpriteBuilder, after that you can build it from within Xcode.

## Still having trouble compiling SpriteBuilder?

It is most likely still a problem with the submodules. Edit the .git/config file and remove the lines that are referencing submodules. Then change directory into the top directory and run:

    git submodule update --init

When building SpriteBuilder, make sure that "SpriteBuilder" is the selected target (it may be some of the plug-in targets by default).

## License (MIT)
Copyright © 2011 Viktor Lidholt

Copyright © 2012-2013 Zynga Inc.

Copyright © 2013 Apportable Inc.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

SpriteBuilder: www.spritebuilder.com

Changes to compatible with Cocos2d-x:
Button:
	Add Sprite9Slice properties to CCButton; /Plugins (Nodes)/UI/CCButton/Support Files/CCBPProperties.plist, at the end of this property file, add:
	<?xml version="1.0" encoding="UTF-8"?>
	<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
	<plist version="1.0">
	<dict>
		<key>displayName</key>
		<string>CCScale9Sprite</string>
		<key>name</key>
		<string>CCSprite</string>
		<key>type</key>
		<string>Separator</string>
		<key>dontSetInEditor</key>
		<true/>
	</dict>
	</plist>
	<?xml version="1.0" encoding="UTF-8"?>
	<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
	<plist version="1.0">
	<dict>
		<key>default</key>
		<integer>0</integer>
		<key>displayName</key>
		<string>Margin left</string>
		<key>type</key>
		<string>Integer</string>
		<key>name</key>
		<string>marginLeft</string>
	</dict>
	</plist>
	<?xml version="1.0" encoding="UTF-8"?>
	<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
	<plist version="1.0">
	<dict>
		<key>default</key>
		<integer>0</integer>
		<key>displayName</key>
		<string>Margin right</string>
		<key>type</key>
		<string>Integer</string>
		<key>name</key>
		<string>marginRight</string>
	</dict>
	</plist>
	<?xml version="1.0" encoding="UTF-8"?>
	<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
	<plist version="1.0">
	<dict>
		<key>default</key>
		<integer>0</integer>
		<key>displayName</key>
		<string>Margin top</string>
		<key>type</key>
		<string>Integer</string>
		<key>name</key>
		<string>marginTop</string>
	</dict>
	</plist>
	<?xml version="1.0" encoding="UTF-8"?>
	<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
	<plist version="1.0">
	<dict>
		<key>default</key>
		<integer>0</integer>
		<key>displayName</key>
		<string>Margin bottom</string>
		<key>type</key>
		<string>Integer</string>
		<key>name</key>
		<string>marginBottom</string>
	</dict>
	</plist>
after compile there will be a new sep and four attributes of Scale9Slice's margins;

Scale9Slice's margins work differently from Scale9Sprite in cocos2d-x, one is by percent, and the other is by pixel, so changed should be made in CCSprite9Slice.m in cocos2d lib;

Adding four floats in ctor like below to calculate from percent in cocos2d to pixel in cocos2d-x
@implementation CCSprite9Slice
{
    CGSize _originalContentSize;
    float f_marginLeft;
    float f_marginRight;
    float f_marginTop;
    float f_marginBottom;
}
then the draw function:
-(void)draw:(CCRenderer *)renderer transform:(const GLKMatrix4 *)transform
{
	// Don't draw rects that were originally sizeless. CCButtons in tableviews are like this.
	// Not really sure it's intended behavior or not.
	if(_originalContentSize.width == 0 && _originalContentSize.height == 0) return;
	
	CGSize size = self.contentSizeInPoints;
	CGSize rectSize = self.textureRect.size;
	
	CGSize physicalSize = CGSizeMake(
		size.width + rectSize.width - _originalContentSize.width,
		size.height + rectSize.height - _originalContentSize.height
	);
	
	// Lookup tables for alpha coefficients.
	float scaleX = physicalSize.width/rectSize.width;
	float scaleY = physicalSize.height/rectSize.height;
	
	float alphaX2[4];
	alphaX2[0] = 0;
	alphaX2[1] = f_marginLeft / (physicalSize.width / rectSize.width);
	alphaX2[2] = 1 - f_marginRight / (physicalSize.width / rectSize.width);
	alphaX2[3] = 1;
	const float alphaX[4] = {0.0f,f_marginLeft, scaleX - f_marginRight, scaleX};
	const float alphaY[4] = {0.0f, f_marginBottom, scaleY - f_marginTop, scaleY};
	
	const float alphaTexX[4] = {0.0f, f_marginLeft, 1.0f - f_marginRight, 1.0f};
	const float alphaTexY[4] = {0.0f, f_marginBottom, 1.0f - f_marginTop, 1.0f};
	
	// Interpolation matrices for the vertexes and texture coordinates
	const CCSpriteVertexes *_verts = self.vertexes;
	GLKMatrix4 interpolatePosition = PositionInterpolationMatrix(_verts, transform);
	GLKMatrix3 interpolateTexCoord = TexCoordInterpolationMatrix(_verts);
	GLKVector4 color = _verts->bl.color;
	
	CCRenderBuffer buffer = [renderer enqueueTriangles:18 andVertexes:16 withState:self.renderState globalSortOrder:0];
	
	// Interpolate the vertexes!
	for(int y=0; y<4; y++){
		for(int x=0; x<4; x++){
			GLKVector4 position = GLKMatrix4MultiplyVector4(interpolatePosition, GLKVector4Make(alphaX[x], alphaY[y], 0.0f, 1.0f));
			GLKVector3 texCoord = GLKMatrix3MultiplyVector3(interpolateTexCoord, GLKVector3Make(alphaTexX[x], alphaTexY[y], 1.0f));
			CCRenderBufferSetVertex(buffer, y*4 + x, (CCVertex){position, GLKVector2Make(texCoord.x, texCoord.y), GLKVector2Make(0.0f, 0.0f), color});
		}
	}
	
	// Output lots of triangles.
	for(int y=0; y<3; y++){
		for(int x=0; x<3; x++){
			CCRenderBufferSetTriangle(buffer, y*6 + x*2 + 0, (y + 0)*4 + (x + 0), (y + 0)*4 + (x + 1), (y + 1)*4 + (x + 1));
			CCRenderBufferSetTriangle(buffer, y*6 + x*2 + 1, (y + 0)*4 + (x + 0), (y + 1)*4 + (x + 1), (y + 1)*4 + (x + 0));
		}
	}
}
and then the setters:
- (void)setMargin:(float)margin
{
    float f_margin = (float)margin/self.textureRect.size.width;
    _marginLeft = f_margin;
    _marginRight = f_margin;
    _marginTop = f_margin;
    _marginBottom = f_margin;
}

// ---------------------------------------------------------------------

- (void)setMarginLeft:(float)marginLeft
{
    _marginLeft = marginLeft;
    if(self.textureRect.size.width == 0)
        f_marginLeft = 0.0f;
    else
        f_marginLeft = (float)_marginLeft/self.textureRect.size.width;
    // sum of left and right margin, can not exceed 1
    // NSAssert((_marginLeft + _marginRight) <= 1, @"Sum of left and right margine, can not exceed 1");
}

- (void)setMarginRight:(float)marginRight
{
    _marginRight = marginRight;
    if(self.textureRect.size.width == 0)
        f_marginRight = 0.0f;
    else
        f_marginRight = (float)_marginRight/self.textureRect.size.width;
    // sum of left and right margin, can not exceed 1
    //NSAssert((_marginLeft + _marginRight) <= 1, @"Sum of left and right margine, can not exceed 1");
}

- (void)setMarginTop:(float)marginTop
{
    _marginTop = marginTop;
    if(self.textureRect.size.height == 0)
        f_marginRight = 0;
    else
        f_marginTop = (float)_marginTop/self.textureRect.size.height;
    // sum of top and bottom margin, can not exceed 1
    // NSAssert((_marginTop + _marginBottom) <= 1, @"Sum of top and bottom margine, can not exceed 1");
}

- (void)setMarginBottom:(float)marginBottom
{
    _marginBottom = marginBottom;
    if(self.textureRect.size.height == 0)
        f_marginBottom = 0;
    else
        f_marginBottom = (float)_marginBottom/self.textureRect.size.height;
    // sum of top and bottom margin, can not exceed 1
    // NSAssert((_marginTop + _marginBottom) <= 1, @"Sum of top and bottom margine, can not exceed 1");
}
At last, in new SpriteBuilder there is a margin check in CCBPSprite9Slice.m, change it to the cocos2d-x form:
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
this check can guarantee the margins in cocos2d-x work properly

Removing the default spriteFrame settings in /Plugins (Nodes)/UI/CCButton/Support Files/CCBPProperties.plist will save a lot work

In CCButton.m add properties handlers:
- (NSArray*) keysForwardedToSprite9
{
    return [NSArray arrayWithObjects:@"marginLeft",
            @"marginRight",
            @"marginTop",
            @"marginBottom",
            nil];
}

- (void) setValue:(id)value forKey:(NSString *)key
{
    if ([[self keysForwardedToLabel] containsObject:key])
    {
        [_label setValue:value forKey:key];
        [self needsLayout];
        return;
    }
    if ([[self keysForwardedToSprite9] containsObject:key])
    {
        [_background setValue:value forKey:key];
        [self needsLayout];
        return;
    }
    [super setValue:value forKey:key];
}

- (id) valueForKey:(NSString *)key
{
    if ([[self keysForwardedToLabel] containsObject:key])
    {
        return [_label valueForKey:key];
    }
    if ([[self keysForwardedToSprite9] containsObject:key])
    {
        return [_background valueForKey:key];
    }
    return [super valueForKey:key];
}
All is well;

Then the most difficult, let the button can add children:?

I found that in new version this is the most simple one(orz), change CCBProperties.plist file of CCButton, let canHaveChildren = YES, that's all, the only thing is that
Button had two no userObject and pluginInfo children, in the sequencer, they are all empty and null;

Add Tag property to CCNode, first change the CCNode's CCBProperties.plist, add a item after Name property:
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>default</key>
	<integer>-1</integer>
	<key>displayName</key>
	<string>Tag</string>
	<key>type</key>
	<string>Integer</string>
	<key>name</key>
	<string>tag</string>
</dict>
</plist>
In the CCNode.h add: // a tag. any number you want to assign to the node
    					NSInteger _tag;
to @Interface
and
@property(nonatomic,readwrite,assign) NSInteger tag;

In the CCNode.m, just @synthesize tag = _tag; That's all;

A fix to CCLabelBMFont.m, in setFntFile:
		self.texture = [CCTexture textureWithFile:_configuration.atlasName];
        [_childForTag removeAllObjects]; <-this
        [self removeAllChildrenWithCleanup:YES]; <- and this
		[self createFontChars];
will refresh in time after change fnt file in the editor

##
There is a problem with CCActionManger, the member value _currentTargetSalvaged is set to false at ctor, but if there is no calls like stopAction..(), then the value is always false,
and at the end of function update(), the if (this._currentTargetSalvaged && locCurrTarget.actions.length === 0) will never pass, so the function call getActionByTag() will cause a log
getActionByTag(tag = %s): Action not found 3435855873(button action, zoomWhenTouched)
