//
//  HelloWorldLayer.h
//  Cocos2dLesson1
//
//  Created by Max Wittek on 3/4/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "osu-import.h.mm"
#import "HitObjectDisplay.h.mm"
#import "Scoreboard.h"
#import <MediaPlayer/MediaPlayer.h>

 // fwd decl

// HelloWorld Layer
@interface GameScene : CCLayer
{
	BOOL paused;
	Beatmap * beatmap;
	MPMusicPlayerController * musicPlayer;
	Scoreboard * scoreBoard;
	double timeAllowanceMs;
	double durationMs;
	int comboIndex;
	int numPopped;
}

// returns a Scene that contains the HelloWorld as the only child
+(id) sceneWithBeatmap: (Beatmap*)beatmap;

- (void) startSceneWithBeatmap:(Beatmap*)beatmap;
- (void) removeHitObjectDisplay: (HitObjectDisplay*)hod;
- (void) spawnReaction: (int)type pos: (CGPoint)pos;
- (void) modifyScore: (int)delta;


@property Beatmap * beatmap;
@property (retain) Scoreboard * scoreBoard;
@property double timeAllowanceMs;
@property double durationMs;

@end
