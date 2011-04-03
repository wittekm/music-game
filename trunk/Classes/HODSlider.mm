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
	
	CGPoint start = ccp(hs->x, hs->y); //CGPointMake(hs->x * 1.0, hs->y * 1.0);
	[curve setPoint: start atIndex: 0];
		
	if(points.size() == 1) {
		CGPoint end = ccp(points.at(0).first, points.at(0).second);
		[curve setPoint: ccpLerp(start, end, 1/2.f) atIndex:1];
		[curve setPoint: end atIndex: 2];
	}
	
	
	else {
		for(uint i = 0; i < points.size(); i++) {
			std::pair<int, int> pointPair = points.at(i);
			NSLog(@"%d: %d %d ", i+1, pointPair.first, pointPair.second);
			CGPoint point = ccp(pointPair.first, pointPair.second);
			//CGPoint point = ccp(pointPair.first - hs->x, pointPair.second - hs->y); //CGPointMake((pointPair.first - hs->x) * 1.0, (pointPair.second - hs->y) * 1.0);
			//point = [[CCDirector sharedDirector] convertToGL: point];
			[curve setPoint:point atIndex: i+1];
		}
	}
	
	[curve invalidate];
	
}

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
	
	
	// trace the end-button as well
	// originates at hitObject.x and y....
	std::pair<int, int>& end = ((HitSlider*)hitObject)->sliderPoints.back();
	//circ.position = ccp(hitObject->x -end.first, hitObject->y - end.second);
	//circ.position = ccp(end.first - hitObject->x, end.second - hitObject->y);
	HitObject * endHO = new HitObject(end.first, end.second, -1, 1, -1);
	endHO->setRepeat();
	HODCircle * circTwo = [[HODCircle alloc] initWithHitObject:endHO red:red green:green blue:blue initialScale:initialScale];
	[circTwo justDisplay];
	[circTwo visit];
	 
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
		// USED TO BE LAGRANGE, IS NOW BEZIER
		// USED TO BE CUBIC NOW QUADRATIC
		curve = [[FRCurve curveFromType:kFRCurveBezier order:kFRCurveQuadratic segments:64] retain]; // MAY NEED RETAIN
		// 74 is the default size of the inner part.
		[curve setWidth: 70.0f * s];
		[curve setShowControlPoints:true];
		ccColor3B curveColor = { r, g, b};
		[curve setColor:curveColor];
		[self addPoints];
		
		[curve setBlendFunc: (ccBlendFunc){GL_SRC_ALPHA,GL_ONE_MINUS_SRC_ALPHA}]; 
		
		 
				
		// Stuff cribbed from HODCircle
		size = CGSizeMake(120, 120);
		
		ring = [CCSprite spriteWithFile:@"button.ring.png"];
		ring.color = curveColor;
		ring.position = ccp(hitObject->x, hitObject->y);
				
		// Create the fadein texture and the corresponding CCSprite
		fadeinTex = [[self createFadeinTexture] retain];
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
	//[curve release];
	//[ring release];
	NSLog(@"derp");
	//[[CCTextureCache sharedTextureCache] removeTexture: [slider texture] ];
	NSLog(@"underp");
	[super dealloc];

}


@end
