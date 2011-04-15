//
//  CCHitObject.m
//  Cocos2dLesson1
//
//  Created by Max Wittek on 3/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HitObjectDisplay.h.mm"


@implementation HitObjectDisplay

@synthesize hitObject;

- (id) initWithHitObject: (HitObject*)hitObject_ red: (int)r green: (int)g blue: (int)b {
	return [self initWithHitObject: hitObject_ red: r green: g blue: b initialScale: 1.0];
}

- (id) initWithHitObject: (HitObject*)hitObject_ red: (int)r green: (int)g blue: (int)b initialScale: (double)s{
	if( (self=[super init]) ) {
		hitObject = hitObject_;
		red = r;
		green = g;
		blue = b;
		initialScale = s;
		disappearTimeMs = -1;
		//self.position = CGPointMake(hitObject->x * 1.0, hitObject->y * 1.0);
	}
	return self;
}


- (void) appearWithDuration: (double)duration {
	[self doesNotRecognizeSelector:_cmd];
}

- (void) setOpacity: (GLubyte) opacity {
	for( CCNode *node in [self children] )
	{
		if( [node conformsToProtocol:@protocol( CCRGBAProtocol)] )
		{
			[(id<CCRGBAProtocol>) node setOpacity: opacity];
		}
	}
}


- (void) dealloc {
	//delete hitObject; // WOOPSSSSS
	[self removeAllChildrenWithCleanup:true];
	[super dealloc];
}

- (BOOL) wasHit: (CGPoint)location atTime: (NSTimeInterval) time {
	double dist = sqrt( pow(hitObject->x - location.x, 2) + pow(hitObject->y - location.y, 2));
	if(dist > (46. * initialScale)) {
		return false;
	} else {
		return true;
	}
}

- (BOOL) wasHeld: (CGPoint)location atTime: (NSTimeInterval)time {
	return true; // doesn't matter for most of them
}

- (void) wasReleased { }

- (int) disappearTime {
	return INT_MAX;
}
- (int) pointsAtDisappearTime {
	return 0;
}


- (GameScene*) gsParent {
	return (GameScene*)[self parent];
}

@end
