//
//  HODSlider.m
//  Cocos2dLesson1
//
//  Created by Max Wittek on 3/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HODSlider.h"
#import "osu-import.h.mm"
#import "HODCircle.h"
#import <vector>

@implementation HODSlider

- (void) addPoints {
	HitSlider * hs = (HitSlider*)hitObject;
	typedef std::vector<std::pair<int, int> > pointsList;
	pointsList points = hs->sliderPoints;
	if(points.size() > 50) return;
	
	CGPoint start = CGPointMake(hs->x * 1.0, hs->y * 1.0);
	[curve setPoint: start atIndex: 0];
	
	
	//I have a crazy belief that curves need at least 4 points.
	
	if(points.size() == 1) {
		CGPoint end = ccp(points.at(0).first, points.at(0).second);
		[curve setPoint: ccpLerp(start, end, 1/3.f) atIndex:1];
		[curve setPoint:ccpLerp(start, end, 2/3.f) atIndex:2];
		[curve setPoint: end atIndex: 3];
	}
	
	else if(points.size() == 2) {
		CGPoint mid = ccp(points.at(0).first, points.at(0).second);
		CGPoint end = ccp(points.at(1).first, points.at(1).second);
		[curve setPoint: ccpLerp(start, mid, 1/2.f) atIndex:1];
		[curve setPoint: mid atIndex: 2];
		[curve setPoint:ccpLerp(mid, end, 1/2.f) atIndex:3];
		[curve setPoint: end atIndex: 4];
	}
	else {
		
		for(uint i = 0; i < points.size(); i++) {
			std::pair<int, int> pointPair = points.at(i);
			NSLog(@"%d: %d %d ", i+1, pointPair.first, pointPair.second);
			CGPoint point = CGPointMake((pointPair.first - hs->x) * 1.0, (pointPair.second - hs->y) * 1.0);
			//point = [[CCDirector sharedDirector] convertToGL: point];
			[curve setPoint:point atIndex: i+1];
		}
	}
	
	[curve invalidate];
	
}

/*
- (CCRenderTexture*) createFadeinTexture
{
	CCRenderTexture * target = 
	[[CCRenderTexture renderTextureWithWidth:480.*2 height:320.*2] retain];
	target.position = ccp(0,0);
	
	curve.position = ccp(480, 320);
	ccColor3B colorCopy = curve.color;
	
	HODCircle * circ = [[HODCircle alloc] initWithHitObject:hitObject red:red green:green blue:blue initialScale:initialScale];
	circ.position = ccp(480, 320);
	[circ justDisplay];
	
	// Begin tracing onto the RenderTexture
	[target begin];
	
	// create the white outline
	//[curve setOpacity: 200];
	[curve setWidth: [curve width] * 1.15];
	[curve setColor: ccWHITE];
	[curve visit];
	
	// fill inside color
	//[curve setOpacity: 150];
	[curve setWidth: [curve width] / 1.15];
	[curve setColor: colorCopy];
	[curve visit];
	
	// do the begin-button
	[circ visit];
	
	// trace the end-button as well
	std::pair<int, int> end = ((HitSlider*)hitObject)->sliderPoints.back();
	circ.position = ccp(480 + (end.first - hitObject->x), 320 + (end.second - hitObject->y));
	[circ visit];
	
	[target end];
	
	[circ release];
	
	return target;
}
*/


- (CCRenderTexture*) createFadeinTexture
{
	NSLog(@"abotu to make target");
	CCRenderTexture * target = 
	[[CCRenderTexture renderTextureWithWidth:480. height:320.] retain];
	target.position = ccp(480./2.,320./2.);
	
	curve.position = ccp(0, 0);
	ccColor3B colorCopy = curve.color;
	
	NSLog(@"abotu to make circle");
	HODCircle * circ = [[HODCircle alloc] initWithHitObject:hitObject red:red green:green blue:blue initialScale:initialScale];
	circ.position = ccp(0, 0);
	[circ justDisplay];
	
	NSLog(@"abotu to begin");
	// Begin tracing onto the RenderTexture
	[target begin];
	
	NSLog(@"abotu to visit curve 1");
	// create the white outline
	//[curve setOpacity: 200];
	[curve setWidth: [curve width] * 1.15];
	[curve setColor: ccWHITE];
	[curve visit];
	 
	NSLog(@"abotu to visit curve 2");
	// fill inside color
	//[curve setOpacity: 150];
	[curve setWidth: [curve width] / 1.15];
	[curve setColor: colorCopy];
	[curve visit];
	
	NSLog(@"abotu to visit circ 1");
	// do the begin-button
	[circ visit];
	
	/*
	// trace the end-button as well
	std::pair<int, int>& end = ((HitSlider*)hitObject)->sliderPoints.back();
	circ.position = ccp(end.first - hitObject->x, end.second - hitObject->y);
	[circ visit];
	 */
	NSLog(@"abotu to end");
	[target end];
	
	NSLog(@"about to release");
	[circ release];
	NSLog(@"about to return");
	
	return target;
}



- (id) initWithHitObject:(HitObject*)hitObject_ red:(int)r green:(int)g blue:(int)b initialScale: (double)s {
	
	if( (self = [super initWithHitObject:hitObject_ red:r green:g blue:b initialScale: s]) ) {
		
		// Set up the curve
		curve = [[FRCurve curveFromType:kFRCurveLagrange order:kFRCurveCubic segments:64] retain]; // MAY NEED RETAIN
		// 74 is the default size of the inner part.
		[curve setWidth: 70.0f * s];
		//[curve setShowControlPoints:true];
		ccColor3B curveColor = { r, g, b};
		[curve setColor:curveColor];
		[self addPoints];
		
		[curve setBlendFunc: (ccBlendFunc){GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA}]; 
		
				
		// Stuff cribbed from HODCircle
		size = CGSizeMake(120, 120);
		
		ring = [CCSprite spriteWithFile:@"button.ring.png"];
		ring.color = ccORANGE;
		ring.position = ccp(hitObject->x, hitObject->y);
				
		// Create the fadein texture and the corresponding CCSprite
		fadeinTex = [self createFadeinTexture];
		slider = [CCSprite spriteWithTexture:[[fadeinTex sprite] texture] ];
		slider.position = ccp(480/2, 320/2);
		slider.flipY = true;
		[self addChild: slider];
		
		
		[self addChild: ring];
		
		ring.scale = initialScale;
		
		[self setOpacity:0];
		
	}
	return self;
}

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"derp derpensteinberg");
}


- (void) appearWithDuration:(double)duration {
	self.visible = true;
	ring.visible = true;
	ring.scale = initialScale;
	
	id actionFadeIn = [CCFadeIn actionWithDuration:duration];
	id actionScaleHalf = [CCScaleBy actionWithDuration:duration scale:0.5];
	
	[self runAction: [CCSequence actions:actionFadeIn, nil]];
	[ring runAction: [CCSequence actions:actionScaleHalf,  nil]];
	
	// apparently needed
	//[fadeinTex runAction:[CCSequence actions:actionFadeIn, nil]];
	//[[fadeinTex sprite] runAction:[CCSequence actions:actionFadeIn, nil]];
	
	//[slider runAction: [CCSequence actions: actionFadeIn, nil]];
	//[ring runAction: [CCSpawn actions:actionFadeIn, actionScaleHalf, nil]];
	
}

- (void) dealloc {
	/*
	[fadeinTexture release];
	[ring release];
	[curve release]; // dealloc instead?
	 */
	[self removeAllChildrenWithCleanup:true];
	//[curve release];
	//[ring release];
	[super dealloc];
}


@end
