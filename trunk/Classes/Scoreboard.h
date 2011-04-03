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
	CCLabelBMFont * scoreDisplay;
}

@property NSInteger score;
@property NSInteger combo;
@property (retain) CCLabelBMFont * scoreDisplay;


@end
