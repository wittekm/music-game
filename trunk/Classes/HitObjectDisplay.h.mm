//
//  CCHitObject.h
//  Cocos2dLesson1
//
//  Created by Max Wittek on 3/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "osu-import.h.mm"

@interface HitObjectDisplay : CCLayer {
	HitObject * hitObject;
	int red;
	int green;
	int blue;
	double initialScale;
	
}

- (id) initWithHitObject: (HitObject*)hitObject_ red: (int)r green: (int)g blue: (int)b;
- (id) initWithHitObject: (HitObject*)hitObject_ red: (int)r green: (int)g blue: (int)b initialScale: (double)s;
- (void) appearWithDuration: (double)duration;
- (void) setOpacity: (GLubyte) opacity;

- (BOOL) wasHit: (CGPoint)location atTime: (NSTimeInterval)time;
- (BOOL) wasHeld: (CGPoint)location atTime: (NSTimeInterval)time;

// stuff pertaining to touch processing

@property HitObject* hitObject;

@end
