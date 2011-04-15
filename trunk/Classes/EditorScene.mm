//
//  untitled.m
//  musicGame
//
//  Created by Max Wittek on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EditorScene.h"
#import "HODCircle.h"
#import "osu-import.h.mm"


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

- (id) init {
	if ( (self = [super init]) ) {
		self.isTouchEnabled = YES;
		touchBeganAtTime = INT_MAX;
		CCSprite * skipFiveSprite = [CCSprite spriteWithFile:@"PlusFive.png"];
		CCSprite * playPauseSprite = [CCSprite spriteWithFile:@"PlayPause.png"];
		CCSprite * backFiveSprite = [CCSprite spriteWithFile:@"MinusFive.png"];
		CCMenuItemSprite *skipFive = [CCMenuItemSprite itemFromNormalSprite:skipFiveSprite selectedSprite:nil target:self selector:@selector(skip)];
		CCMenuItemSprite *playPause = [CCMenuItemSprite itemFromNormalSprite:playPauseSprite selectedSprite:nil target:self selector:@selector(play)];
		CCMenuItemSprite *backFive = [CCMenuItemSprite itemFromNormalSprite:backFiveSprite selectedSprite:nil target:self selector:@selector(back)];
		
		CCMenu * menu = [CCMenu menuWithItems:skipFive, playPause, backFive, nil];
		menu.position = ccp(48, 320/2);
		skipFive.position = ccp(0, -64);
		backFive.position = ccp(0, 64);
		[self addChild:menu];
		
		timeLabel = [CCLabelBMFont labelWithString:@"" fntFile:@"zerofourbee-32.fnt"];
		[self addChild:timeLabel];
		timeLabel.anchorPoint = ccp(0,1);
		timeLabel.position = ccp(0, 320);
	}
	return self;
}

- (void) startSceneWithMediaItem:(MPMediaItemCollection *)item {
	mediaItem = item;
	
#if !TARGET_IPHONE_SIMULATOR

	@try {
		// Music Stuff
		
		musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
		
		[musicPlayer setQueueWithItemCollection:item];
		[musicPlayer play];
		//Letterboxes
		
		/*
		CCSprite  * left_curtain = [CCSprite spriteWithFile:@"left_curtain.png"];
		CCSprite  * right_curtain = [CCSprite spriteWithFile:@"right_curtain.png"];
		left_curtain.position = ccp(40, 320/2);
		right_curtain.position = ccp(440, 320/2);
		
		[left_curtain setScale:0.5];
		[right_curtain setScale:0.5];
		[self addChild:left_curtain];
		[self addChild:right_curtain];
		 */
		// Artwork
		MPMediaItem * currentItem = musicPlayer.nowPlayingItem;
		MPMediaItemArtwork *artwork = [currentItem valueForProperty:MPMediaItemPropertyArtwork];
		UIImage * artworkImage;
		artworkImage = [artwork imageWithSize:CGSizeMake(320, 320)];
		CCSprite * albumArt = [CCSprite spriteWithCGImage:[artworkImage CGImage]];
		albumArt.position = ccp(480/2, 320/2);
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2){
			//iPhone 4
			[albumArt setScale:0.5];
		}
		[self addChild:albumArt z:0];
		
		//[musicPlayer setCurrentPlaybackTime:100]; // skip intro, usually 18
		//[musicPlayer setCurrentPlaybackTime:60];
		
		
	} @catch(NSException *e) {
		//cout << "no music playing dawg" << endl;
	}
#endif
	
	[self schedule:@selector(nextFrame:) interval: 1];
}

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch * touch = [touches anyObject];	
	CGPoint location = [self convertTouchToNodeSpace: touch];
	
	if([touches count] > 1) {
		[self play];
	} else {
		touchBeganAtTime = [musicPlayer currentPlaybackTime];
	}

}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch * touch = [touches anyObject];	
	CGPoint location = [self convertTouchToNodeSpace: touch];

	double touchEndedAtTime = [musicPlayer currentPlaybackTime];
	HitObject * ho;
	
	if(touchEndedAtTime - touchBeganAtTime < .1) {
		ho = new HitObject(location.x, location.y, touchBeganAtTime, 1, 0);
		HODCircle * hod = [[HODCircle alloc] initWithHitObject:ho red:200 green:0 blue:0];
		[self addChild:hod];
		[hod justDisplay];
		
		id removeAction = [CCCallBlock actionWithBlock:^{
			[self removeChild:hod cleanup:true];
		}];
		
		[hod runAction: [CCSequence actions:[CCFadeOut actionWithDuration:0.5], removeAction, nil]];
		// circle
	}
	
	//HitObjectDisplay * hod = [[HODCircle alloc] initWithHitObject:<#(HitObject *)hitObject_#> red:<#(int)r#> green:<#(int)g#> blue:<#(int)b#> initialScale:<#(double)s#>]
	
}




- (void) nextFrame: (ccTime)dt {
	NSTimeInterval interval = [musicPlayer currentPlaybackTime];
	long min = (long)interval / 60;    // divide two longs, truncates
	long sec = (long)interval % 60;    // remainder of long divide
	NSString* str = [[NSString alloc] initWithFormat:@"%02d:%02d", min, sec];
	
	[timeLabel setString:str];
}


- (void)skip {
	touchBeganAtTime = INT_MAX;
	[musicPlayer setCurrentPlaybackTime:[musicPlayer currentPlaybackTime] + 5];
}
- (void)play {
	if([musicPlayer playbackState] ==   MPMusicPlaybackStatePaused)
		[musicPlayer play];
	else
		[musicPlayer pause];
}
- (void)back {
	touchBeganAtTime = INT_MAX;
	int backTime = [musicPlayer currentPlaybackTime] - 5;
	if(backTime < 0) backTime = 0;
	[musicPlayer setCurrentPlaybackTime: backTime];
}

// this is generally caleld by one of the HitObjectDisplays.
- (void) removeHitObjectDisplay: (HitObjectDisplay*)hod {
	//hods.remove(hod);
	[self removeChild:hod cleanup:true];
}


@end



