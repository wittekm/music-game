//
//  Scoreboard.h
//  musicGame
//
//  Created by Max Kolasinski on 3/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//
#import "cocos2d.h"
#import <Foundation/Foundation.h>


@interface Scoreboard : NSObject {
	NSInteger score;
	NSInteger combo;
	CCSprite* dig5;
	CCSprite* dig4;
	CCSprite* dig3;
	CCSprite* dig2;
	CCSprite* dig1;
	CCSprite* dig0;
}

@property NSInteger score;
@property NSInteger combo;
@property (retain) CCSprite* dig5;
@property (retain) CCSprite* dig4;
@property (retain) CCSprite* dig3;
@property (retain) CCSprite* dig2;
@property (retain) CCSprite* dig1;
@property (retain) CCSprite* dig0;

@end
