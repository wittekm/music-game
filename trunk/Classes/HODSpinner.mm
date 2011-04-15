//
//  HODSpinner.mm
//  musicGame
//
//  Created by Max Kolasinski on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HODSpinner.h"
#import "cocos2d.h"

@implementation HODSpinner
@synthesize spinner;
@synthesize ring;

- (id) initWithHitObject:(HitObject*)hitObject_ red:(int)r green:(int)g blue:(int)b initialScale: (double)s
{
	if( (self = [super initWithHitObject:hitObject_ red:r green:g blue:b initialScale: s]) ) {
		self.visible = false;
		spinner = [CCSprite spriteWithFile:@"beatnik.png"];
		ring = [CCSprite spriteWithFile:@"button.ring.png"];
		ring.position = ccp(480/2,320/2);
		spinner.position = ccp(480/2,320/2);
		ring.scale = initialScale*2;
		[self setOpacity:0];
		[self addChild:spinner];
		[self addChild:ring];
	}
	NSLog(@"derpyderpderp");
	return self;
	
}
- (void) appearWithDuration: (double)duration
{
	HitSpinner * s = (HitSpinner*)hitObject;
	double scaleDuration = (s->endTimeMs - s->startTimeMs) / 1000;
	NSLog(@"scale duration is %d",scaleDuration);
	self.visible = true;
	ring.visible = true;
	
	//self.position = CGPointMake(hitObject.x, hitObject.y);
	
	self.visible = true;
	//ring.visible = true;
	//[ring setScale:initialScale];
	
	id actionFadeIn = [CCFadeIn actionWithDuration:duration];
	id actionScaleHalf = 
	[CCScaleTo actionWithDuration:scaleDuration scale: 0.0001];
	
	[self runAction: [CCSequence actions:actionFadeIn, nil]];
	[ring runAction: [CCSequence actions:actionScaleHalf,  nil]];
}
@end
