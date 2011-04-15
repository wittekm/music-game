//
//  untitled.m
//  musicGame
//
//  Created by Max Wittek on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EditorScene.h"


@implementation EditorScene




+(id) sceneWithMediaItem: (MPMediaItemCollection*)item {
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	EditorScene *layer = [EditorScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// tell the layer we're using this beatmap, and start animation
	[layer startSceneWithMediaItem:item];
	
	// return the scene
	return scene;
}

- (void) startSceneWithMediaItem:(MPMediaItemCollection *)item {
	mediaItem = item;
	
#if !TARGET_IPHONE_SIMULATOR
	musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
#endif	
	
	[musicPlayer setQueueWithItemCollection:item];
	[musicPlayer play];
	
}








@end



