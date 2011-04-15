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

@interface EditorScene : CCLayer {
	MPMediaItemCollection * mediaItem;
	MPMusicPlayerController * musicPlayer;
	double touchBeganAtTime;
	CGPoint touchBeganAtLoc;
	CCLabelBMFont * timeLabel;
}

+(id) sceneWithMediaItem: (MPMediaItemCollection*)item;
-(void)startSceneWithMediaItem: (MPMediaItemCollection*)item;

- (void)skip;
- (void)play;
- (void)back;

-(void) update;

- (void) nextFrame: (ccTime)dt;


//- (void) removeHitObjectDisplay: (HitObjectDisplay*)hod;


@end
