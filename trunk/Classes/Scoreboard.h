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
	NSInteger hit;
	NSInteger miss;
	CCLabelBMFont * scoreDisplay;
	CCLabelBMFont * comboDisplay;
	CCSprite * scoreBackground;
	CCSprite * comboBackground;
}

- (void)hitWith: (int) points;
- (void)updateScore;
- (void)resetCombo;

@property NSInteger score;
@property NSInteger combo;
@property NSInteger hit;
@property NSInteger miss;
@property (retain) CCLabelBMFont * scoreDisplay;
@property (retain) CCSprite * scoreBackground;
@property (retain) CCSprite * comboBackground;
@property (retain) CCLabelBMFont * comboDisplay;


@end
