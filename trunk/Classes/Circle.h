//
//  Circle.h
//  Cocos2dLesson1
//
//  Created by Max Wittek on 3/7/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "HitObjectDisplay.h.mm"

@interface Circle : HitObjectDisplay {
	CGSize size;
	CCSprite * button;
	CCSprite * ring;
}

- (CCRenderTexture*) createCircleTexture: (int)red :(int)green :(int)blue;
- (CCRenderTexture*) createCircleTexture: (int)red :(int)green :(int)blue :(BOOL)doNumber;
- (void) justDisplay;



@property (readwrite, nonatomic, retain) CCSprite * ring;

@end
