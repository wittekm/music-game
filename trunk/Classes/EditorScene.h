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
}

+(id) sceneWithMediaItem: (MPMediaItemCollection*)item;
-(void)startSceneWithMediaItem: (MPMediaItemCollection*)item;

@end
