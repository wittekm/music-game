//
//  Circle.m
//  Cocos2dLesson1
//
//  Created by Max Wittek on 3/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Circle.h"
#import "osu-import.h.mm"

@implementation Circle
@synthesize ring;

static NSMutableArray *circleTextures = nil;

// on "init" you need to initialize your instance

- (id) initWithHitObject:(HitObject*)hitObject_ red:(int)r green:(int)g blue:(int)b initialScale: (double)s
{
	if( (self = [super initWithHitObject:hitObject_ red:r green:g blue:b initialScale: s]) ) {
		self.visible = false;
		
		size = CGSizeMake(120, 120);
		
		CCRenderTexture * buttonTex;
		buttonTex = [[self createCircleTexture:r :g :b] retain];

		
		ring = [CCSprite spriteWithFile:@"button.ring.png"];		 
		ring.position = ccp(hitObject->x * 1.0, hitObject->y * 1.0);
		
		button = [CCSprite spriteWithTexture: [[buttonTex sprite] texture]];
		button.position = ccp(hitObject->x * 1.0, hitObject->y * 1.0);
		button.flipY = YES;
		
		[self addChild: button];
		[self addChild:ring];
		
		button.scale = initialScale;
		ring.scale = initialScale;
		
		[self setOpacity:0];
		
		[buttonTex release];
		
		// TODO: gotta eventually release everything in circleTextures
	}
	return self;
}

- (CCRenderTexture*) createCircleTexture: (int)red_ :(int)green_ :(int)blue_ {
	return [self createCircleTexture: red_ :green_ :blue_ :true];
}


// I should make a circle texture bank. (colorgroup -> (number -> texture) ) and 0 for no-number

// TODO: potential memory leak here???
- (CCRenderTexture*) createCircleTexture: (int)red_ :(int)green_ :(int)blue_ :(BOOL)doNumber
{
	/* NOTE: Should be Retina Display-ified */
	CCRenderTexture * target = 
	[CCRenderTexture renderTextureWithWidth:size.width height:size.height];
	target.position = ccp(0,0);
	
	CCSprite * underlayTex = [CCSprite spriteWithFile:@"button.underlay.png"];
	CCSprite * buttonTex = [CCSprite spriteWithFile:@"button.button.png"];
	CCSprite * overlayTex = [CCSprite spriteWithFile:@"button.overlay.png"];
	underlayTex.position = ccp(size.width/2,size.height/2);
	buttonTex.position = ccp(size.width/2,size.height/2);
	overlayTex.position = ccp(size.width/2,size.height/2);
	
	buttonTex.color = ccc3(red_, green_, blue_);
	
	[target begin];
	[underlayTex visit];
	[buttonTex visit];
	[overlayTex visit];
	
	if(doNumber) {
		CCLabelTTF * numberDisplay = 
		[CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", hitObject->number] 
						   fontName:@"Helvetica Neue" fontSize:48];
		numberDisplay.position = ccp(size.width/2,size.height/2);
		[numberDisplay visit];
	}
	
	[target end];
	
	return target;
}


- (void) appearWithDuration: (double)duration
{
	//self.position = CGPointMake(hitObject.x, hitObject.y);
	
	self.visible = true;
	ring.visible = true;
	[ring setScale:initialScale];
	
	id actionFadeIn = [CCFadeIn actionWithDuration:duration];
	id actionScaleHalf = [CCScaleBy actionWithDuration:duration scale: 0.5];
	
	[self runAction: [CCSequence actions:actionFadeIn, nil]];
	[ring runAction: [CCSequence actions:actionScaleHalf,  nil]];
}

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"testing 123");
	
}

- (void) justDisplay {
	ring.visible = false;
	self.visible = true;
	[self setOpacity:255];
	//[ring setOpacity: 0];
}

- (void) dealloc {
	[super dealloc];
	//[button release];
	//[ring release];
}


@end
