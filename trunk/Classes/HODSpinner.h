//
//  HODSpinner.h
//  musicGame
//
//  Created by Max Kolasinski on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HitObjectDisplay.h.mm"


@interface HODSpinner : HitObjectDisplay {
	CCSprite * spinner;
	CCSprite * ring;
	CGPoint prevLocation;
	double absoluteRotation;
	double lastRotation;
}

- (BOOL) wasHit: (CGPoint)location atTime: (NSTimeInterval)time;
- (BOOL) wasHeld: (CGPoint)location atTime: (NSTimeInterval)time;
- (void) wasReleased;

@property double lastRotation;
@property double absoluteRotation;
@property CGPoint prevLocation;
@property (retain) CCSprite * spinner;
@property (retain) CCSprite * ring;
@end
