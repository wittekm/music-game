//
//  untitled.h
//  musicGame
//
//  Created by Max Wittek on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import <MediaPlayer/MediaPlayer.h>
#include <set>
#include <vector>

class HitObject;

@class HitObjectDisplay;

@interface EditorScene : CCLayer {
	MPMediaItemCollection * mediaItem;
	MPMusicPlayerController * musicPlayer;
	double touchBeganAtTime;
	CGPoint touchBeganAtLoc;
	CCLabelBMFont * timeLabel;
	NSMutableArray * hitObjectDisplays;
	//std::set<HitObject*, bool(*)(const HitObject*,const HitObject*)> HitObjects;
	std::vector<HitObject*> hitObjects;
	
	int comboIndex;
	int hoIndex;
	
	enum Mode { NORMAL, NEWCOMBO, DELETE };
	Mode mode;
	
	double disappearDurationMs;
	
	CCMenuItemLabel * newCombo;
	CCMenuItemLabel * deleter;
	CCMenuItemLabel * back;

}

+(id) sceneWithMediaItem: (MPMediaItemCollection*)item;
-(void)startSceneWithMediaItem: (MPMediaItemCollection*)item;

- (void)skip;
- (void)play;
- (void)back;
- (void)newComboMode;
- (void)deleterMode;

-(void) update;

- (void) updateTime: (ccTime)dt;
- (void) nextFrame: (ccTime)dt;

- (double) time;

- (void) informChange;

- (void)handleNewCombo: (CGPoint)location;
- (void)handleDelete:(CGPoint)location;

- (BOOL) paused;

- (void) removeHitObjectDisplay: (HitObjectDisplay*)hod;

-(void) backToMain;

@end
