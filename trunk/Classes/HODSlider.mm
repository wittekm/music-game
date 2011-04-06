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
#import "GameScene.h"
#import "CCSequenceHelper.h"

@implementation HODSlider

- (void) addPoints {
	HitSlider * hs = (HitSlider*)hitObject; // cast shortcut
	
	typedef std::vector<std::pair<int, int> > pointsList;
	pointsList points = hs->sliderPoints;
	if(points.size() > 32) return; // that's crazy man, come on
	
	// order = number of points between start and end.
	// e.g. start, pt, end = 1 (quadratic); start, pt, pt, end = 2 (cubic)
	if(points.size() > 2)
		[curve setOrder: (FRCurveOrder)(points.size()-1)];
	
	// add the hitobject position as the start
	CGPoint start = ccp(hs->x, hs->y);
	[curve setPoint: start atIndex: 0];
	
	// if this is a straight line, make a control point in the middle
	// (no order-0 bezier curves...)
	if(points.size() == 1) {
		CGPoint end = ccp(points.at(0).first, points.at(0).second);
		[curve setPoint: ccpLerp(start, end, 1/3.f) atIndex:1];
		[curve setPoint: ccpLerp(start, end, 2/3.f) atIndex:2];
		[curve setPoint: end atIndex: 3];
	}
	
	else {
		for(uint i = 0; i < points.size(); i++) {
			std::pair<int, int> pointPair = points.at(i);
			CGPoint point = ccp(pointPair.first, pointPair.second);
			[curve setPoint:point atIndex: i+1];
		}
		//NSLog(@"\n\n ORDER: %d", [curve order]);
	}
	
	// tells the curve we're done adding points
	[curve invalidate];
	
}

- (CCRenderTexture*) createFadeinTexture
{
	CCRenderTexture * target = 
	[[CCRenderTexture renderTextureWithWidth:480. height:320.] retain];
	target.position = ccp(480./2.,320./2.);
	
	curve.position = ccp(0, 0);
	ccColor3B colorCopy = curve.color;
	
	HODCircle * circ = [[HODCircle alloc] initWithHitObject:hitObject red:red green:green blue:blue initialScale:initialScale];
	circ.position = ccp(0, 0);
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
	
	// do the begin-button
	[circ visit];
	
	 
	//NSLog(@"abotu to end");
	[target end];
	
	//NSLog(@"about to release");
	[circ release];
	//NSLog(@"about to return");
	
	return target;
}



- (id) initWithHitObject:(HitObject*)hitObject_ red:(int)r green:(int)g blue:(int)b initialScale: (double)s {
	
	if( (self = [super initWithHitObject:hitObject_ red:r green:g blue:b initialScale: s]) ) {
		
		
		// Set up the curve
		// USED TO BE LAGRANGE, IS NOW BEZIER
		// USED TO BE CUBIC NOW QUADRATIC
		curve = [[FRCurve curveFromType:kFRCurveBezier order:kFRCurveQuadratic segments:50] retain]; // MAY NEED RETAIN
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



- (void) appearWithDuration:(double)duration {
	self.visible = true;
	ring.visible = true;
	ring.scale = initialScale;
	
	id actionFadeIn = [CCFadeIn actionWithDuration:duration];
	id actionScaleHalf = [CCScaleBy actionWithDuration:duration scale:0.5];
	
	/* now do the crazy hitslider action stuff */
	HitSlider * hs = (HitSlider*)hitObject; // cast shortcut
	typedef std::vector<std::pair<int, int> > pointsList;
	pointsList points = hs->sliderPoints;
	
	double& beatLength = [(GameScene*)[self parent] beatmap]->beatLength;
	double AbsoluteSliderVelocity = (10000. / 100.) * 2.8 / beatLength; // osupixels per second
	double slideDuration = (hs->sliderLengthPixels / AbsoluteSliderVelocity) / 1000. ; // make it in s not ms
	
	/*
	//NSMutableArray * slidesArray = [[NSMutableArray alloc] initWithCapacity:((HitSlider*)hitObject)->repeatCount];
	NSMutableArray * slidesArray = [[NSMutableArray alloc] initWithCapacity:1];

	for(int i = 0; i < [slidesArray count]; i++) {
		ccBezierConfig config;

		if(i % 2 == 0) {
			if(points.size() == 3)
				config = (ccBezierConfig){[curve pointAtIndex: 3], [curve pointAtIndex:1], [curve pointAtIndex:2]};
			else if(points.size() == 2)
				config = (ccBezierConfig){[curve pointAtIndex: 2], ccpLerp([curve pointAtIndex: 0], [curve pointAtIndex:1], 2./3.), ccpLerp([curve pointAtIndex: 1], [curve pointAtIndex:2], 1./3.)};
			else if(points.size() == 1)
				config = (ccBezierConfig){[curve pointAtIndex: 1], ccpLerp([curve pointAtIndex: 0], [curve pointAtIndex:1], 1./3.), ccpLerp([curve pointAtIndex: 0], [curve pointAtIndex:1], 2./3.)};

			// do a forwards slide
		} else {
			//backwards slide
		}
		
		[slidesArray addObject: [CCBezierTo actionWithDuration:slideDuration bezier:config] ];
	}
	 
	
	slidesAction = [CCSequenceHelper actionMutableArray:slidesArray];
	*/
	
	ccBezierConfig configForwards;
	ccBezierConfig configBackwards;

	CCFiniteTimeAction * slideForwards;
	CCFiniteTimeAction * slideBackwards;

	
	if(points.size() == 3 || points.size() == 1) {
		configForwards  = (ccBezierConfig){[curve pointAtIndex: 3], [curve pointAtIndex:1], [curve pointAtIndex:2]};
		configBackwards = (ccBezierConfig){[curve pointAtIndex: 0], [curve pointAtIndex:2], [curve pointAtIndex:1]};
		slideForwards = [CCBezierTo actionWithDuration:slideDuration bezier:configForwards];
		slideBackwards = [CCBezierTo actionWithDuration:slideDuration bezier:configBackwards];
	}
	else if(points.size() == 2) {
		configForwards  = (ccBezierConfig){[curve pointAtIndex: 2], ccpLerp([curve pointAtIndex: 0], [curve pointAtIndex:1], 2./3.), ccpLerp([curve pointAtIndex: 1], [curve pointAtIndex:2], 2./3.)};
		configBackwards = (ccBezierConfig){[curve pointAtIndex: 0], ccpLerp([curve pointAtIndex: 1], [curve pointAtIndex:2], 2./3.), ccpLerp([curve pointAtIndex: 0], [curve pointAtIndex:1], 2./3.)};
		slideForwards = [CCBezierTo actionWithDuration:slideDuration bezier:configForwards];
		slideBackwards = [CCBezierTo actionWithDuration:slideDuration bezier:configBackwards];
	}
	else if(points.size() == 1) {
		/*
		slideForwards = [CCMoveTo actionWithDuration:slideDuration position:[curve pointAtIndex:3]];
		slideForwards = [CCMoveTo actionWithDuration:slideDuration position:[curve pointAtIndex:0]];
		 */
	}
	else { 
		NSLog(@"derp");
		exit(0);
	}
	/*
	else if(points.size() == 1)
		config = (ccBezierConfig){[curve pointAtIndex: 1], ccpLerp([curve pointAtIndex: 0], [curve pointAtIndex:1], 1./3.), ccpLerp([curve pointAtIndex: 0], [curve pointAtIndex:1], 2./3.)};
	*/
	
	id untint = [CCCallBlock actionWithBlock:^{
		ring.color = (ccColor3B){255,255,255};
		ring.scale = ring.scale * 1.1;
	}];
	
	id backAndForth = [CCRepeat actionWithAction:[CCSequence actions: slideForwards, slideBackwards, nil] times: 3 ]; 
	//slidesAction = [CCSpawn actions: untint, backAndForth, nil];
	
	[self runAction: [CCSequence actions:actionFadeIn, nil]];
	[ring runAction: [CCSequence actions:actionScaleHalf, untint, backAndForth, nil]];
	
	
	
}

- (void) dealloc {
	NSLog(@"derp");
	[[CCTextureCache sharedTextureCache] removeTexture: [slider texture] ];
	NSLog(@"underp");
	[super dealloc];
}

- (BOOL) wasHeld:(CGPoint)location atTime:(NSTimeInterval)time {
	
}

- (int) disappearTime {
	// slider movement: sliderMultiplier * 100 pixels / beatLength
	//return hitObject->startTimeMs + ;
	if(disappearTimeMs == -1) {
		HitSlider* hs = ((HitSlider*)hitObject);
		double& beatLength = [(GameScene*)[self parent] beatmap]->beatLength;
		
		/* thinkin bout slidermultiplier
		 1.7 = 170 pixels / beatLength
		 1.7 = 170 pixels 
		 */
		
		double AbsoluteSliderVelocity = (10000. / 100.) * 2.8 / beatLength; // osupixels per second
		double added = (hs->repeatCount * hs->sliderLengthPixels / AbsoluteSliderVelocity);
		disappearTimeMs = hitObject->startTimeMs + added + [[self gsParent] durationMs] + [[self gsParent] timeAllowanceMs];
		NSLog(@":::::::::: %f", added);
	}
	return disappearTimeMs;
}


@end
