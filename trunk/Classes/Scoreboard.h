//
//  Scoreboard.h
//  musicGame
//
//  Created by Max Kolasinski on 3/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "cocos2d.h"
#import <Foundation/Foundation.h>


@interface Scoreboard : CCLayer {
	NSInteger score;
	NSInteger combo;
	CCLabelTTF * scoreDisplay;
	CCLabelTTF * comboDisplay;
	CCSprite * scoreBackground;
}

- (void)hitWith: (int) points;
- (void)updateScore;

@property NSInteger score;
@property NSInteger combo;
@property (retain) CCLabelTTF * scoreDisplay;
@property (retain) CCSprite * scoreBackground;
@property (retain) CCLabelTTF * comboDisplay;


@end
