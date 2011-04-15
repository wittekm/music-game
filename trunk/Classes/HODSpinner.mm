//
//  HODSpinner.mm
//  musicGame
//
//  Created by Max Kolasinski on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HODSpinner.h"
#import "cocos2d.h"
#import "GameScene.h"

@implementation HODSpinner
@synthesize spinner;
@synthesize ring;
@synthesize prevLocation;
@synthesize absoluteRotation;

- (id) initWithHitObject:(HitObject*)hitObject_ red:(int)r green:(int)g blue:(int)b initialScale: (double)s
{
	if( (self = [super initWithHitObject:hitObject_ red:r green:g blue:b initialScale: s]) ) {
		self.visible = false;
		spinner = [CCSprite spriteWithFile:@"twirl.png"];
		spinner.scale = .88;
		ring = [CCSprite spriteWithFile:@"button.ring.png"];
		ring.position = ccp(480/2,320/2);
		spinner.position = ccp(480/2,320/2);
		ring.scale = initialScale*2;
		//ring.visible = false;
		//ring.opacity = 0;
		[self addChild:spinner];
		[self addChild:ring];
		[self setOpacity:0];
		
	}
	NSLog(@"derpyderpderp");
	return self;
	
}
- (void) appearWithDuration: (double)duration
{
	HitSpinner * s = (HitSpinner*)hitObject;
	double scaleDuration = (s->endTimeMs - s->startTimeMs) / 1000.;
	NSLog(@"scale duration is %f %d",scaleDuration,(s->endTimeMs - s->startTimeMs));
	self.visible = true;
	ring.visible = true;
	
	//self.position = CGPointMake(hitObject.x, hitObject.y);
	
	self.visible = true;
	//ring.visible = true;
	//[ring setScale:initialScale];
	
	id actionFadeIn = [CCFadeIn actionWithDuration:duration];
	
	id actionScaleHalf = 
	[CCScaleTo actionWithDuration:scaleDuration scale:.1];
	
	/*
	 id ringAction = [CCCallBlock actionWithBlock:^{
	 [ring runAction: actionScaleHalf];
	 
	 }];
	 
	 id spinnerAction = [CCCallBlock actionWithBlock:^{
	 [spinner runAction: actionScaleHalf];
	 }];
	 */
	
	[self runAction: [CCSequence actions:actionFadeIn, actionScaleHalf, nil]];
	//[ring runAction: [CCSequence actions:actionScaleHalf,  nil]];
}

- (int) disappearTime
{
	double end = ((HitSpinner*)hitObject)->endTimeMs;
	
	//return end;
	disappearTimeMs = end + [[self gsParent] timeAllowanceMs] + [[self gsParent] durationMs];
	return disappearTimeMs;
}


- (BOOL) wasHit: (CGPoint)location atTime: (NSTimeInterval)time
{
	prevLocation = location;
	return true;
}

- (BOOL) wasHeld: (CGPoint)location atTime: (NSTimeInterval)time
{
	//fuck trig
	/*double prevAngle = tan((prevLocation.y - [self position].y)/(prevLocation.x - [self position].x));
	 double angle = tan((location.y-[self position].y)/(location.x-[self position].x));
	 NSLog(@"angle is %f", angle);
	 spinner.rotation -= (angle - prevAngle)*5; //-angle*180./M_PI;
	 return true;*/
	
	CGPoint firstVector = ccpSub(location, spinner.position);
    CGFloat firstRotateAngle = -ccpToAngle(firstVector);
    CGFloat previousTouch = CC_RADIANS_TO_DEGREES(firstRotateAngle);
	
    CGPoint secondVector = ccpSub(prevLocation, spinner.position);
	CGFloat rotateAngle = -ccpToAngle(secondVector);
    CGFloat currentTouch = CC_RADIANS_TO_DEGREES(rotateAngle);
	
    //keep adding the difference of the two angles to the dial rotation
	prevLocation = location;
	double prevRotation = spinner.rotation;
    spinner.rotation -= currentTouch - previousTouch;
	absoluteRotation += fabs(spinner.rotation - prevRotation);
	if (lastRotation > 0 && spinner.rotation < 0){
		absoluteRotation = absoluteRotation - 360;
	}
	lastRotation = spinner.rotation;
	NSLog(@"rotation is %f", spinner.rotation);
	NSLog(@"absolute rotation is %f", absoluteRotation);
	return true;
}

- (int) pointsAtDisappearTime {
	if(absoluteRotation > 360)
		return 1000;
	else
		return -1;
}


@end
