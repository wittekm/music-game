//
//  HODSlider.h
//  Cocos2dLesson1
//
//  Created by Max Wittek on 3/16/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"
#import "HitObjectDisplay.h.mm"
#import "Circle.h"
#import "FRCurve.h"
#import "FRLines.h"

@interface HODSlider : HitObjectDisplay {
	FRCurve * curve;
	CGSize size;
	
	CCRenderTexture * fadeinTex;
	CCSprite * slider;
	CCSprite * ring;
}


- (CCRenderTexture*) createFadeinTexture;

@end
