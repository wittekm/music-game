//
//  ResultsScreen.h
//  musicGame
//
//  Created by Max Wittek on 4/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "osu-import.h.mm"
#import "Scoreboard.h"

@interface ResultsScreen : CCLayer {
	Beatmap * beatmap;
	Scoreboard * scoreboard;
	CCSprite *beatnik;
	CCSprite *speechBubble;
}

+(id) sceneWithBeatmap: (Beatmap*)beatmap_ scoreboard: (Scoreboard*)scoreboard_;

- (void) begin;

@property Beatmap * beatmap;
@property (retain) Scoreboard * scoreboard;

@end
