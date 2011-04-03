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

 // fwd decl
class MPMusicPlayerController;

// HelloWorld Layer
@interface GameScene : CCLayer
{
	BOOL paused;
	Beatmap * beatmap;
	MPMusicPlayerController * musicPlayer;
	CCLabelTTF * pausedLabel;
	double timeAllowanceMs;
	double durationMs;
}

// returns a Scene that contains the HelloWorld as the only child
+(id) scene;

- (void) removeHitObjectDisplay: (HitObjectDisplay*)hod;

- (void) spawnReaction: (int)type pos: (CGPoint)pos;

@property Beatmap * beatmap;
@property double timeAllowanceMs;
@property double durationMs;

@end
