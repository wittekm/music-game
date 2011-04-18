//
//  untitled.m
//  musicGame
//
//  Created by Max Wittek on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EditorScene.hh"
#import "HODCircle.h"
#import "osu-import.h.mm"
#import "CCNodeExtension.h"
#import "MenuScene.h"
#import "GameScene.h"
#import "SqlHandler.h"

#include <sstream>
#include <iostream>
using std::ostringstream;
using std::cout;
using std::endl;

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
		
		disappearDurationMs = 1000;
		self.isTouchEnabled = YES;
		touchBeganAtTime = INT_MAX;
		CCSprite * skipFiveSprite = [CCSprite spriteWithFile:@"PlusFive.png"];
		CCSprite * playPauseSprite = [CCSprite spriteWithFile:@"PlayPause.png"];
		CCSprite * backFiveSprite = [CCSprite spriteWithFile:@"MinusFive.png"];
		CCMenuItemSprite *skipFive = [CCMenuItemSprite itemFromNormalSprite:skipFiveSprite selectedSprite:nil target:self selector:@selector(skip)];
		CCMenuItemSprite *playPause = [CCMenuItemSprite itemFromNormalSprite:playPauseSprite selectedSprite:nil target:self selector:@selector(play)];
		CCMenuItemSprite *backFive = [CCMenuItemSprite itemFromNormalSprite:backFiveSprite selectedSprite:nil target:self selector:@selector(back)];
		newCombo = [CCMenuItemLabel itemWithLabel:[CCLabelBMFont labelWithString:@"COM" fntFile:@"zerofourbee-32.fnt"] target: self selector:@selector(newComboMode)] ;
		deleter = [CCMenuItemLabel itemWithLabel:[CCLabelBMFont labelWithString:@"DEL" fntFile:@"zerofourbee-32.fnt"] target: self selector:@selector(deleterMode)];		
		back = [CCMenuItemLabel itemWithLabel:[CCLabelBMFont labelWithString:@"BACK" fntFile:@"zerofourbee-32.fnt"] target: self selector:@selector(backToMain)];
		save = [CCMenuItemLabel itemWithLabel:[CCLabelBMFont labelWithString:@"SAVE" fntFile:@"zerofourbee-32.fnt"] target: self selector:@selector(handleSave)];

		
		skipFive.scale = 2;
		playPause.scale = 2;
		backFive.scale = 2;
		//newCombo.scaleX = 0.6;
		
		CCMenu * menu = [CCMenu menuWithItems:skipFive, playPause, backFive, newCombo, deleter, back, save, nil];
		menu.position = ccp(32, 220);
		skipFive.position = ccp(0, -48);
		newCombo.position = ccp(0, -96);
		deleter.position = ccp(0, -128);
		back.position = ccp(0, -160);
		save.position = ccp(0, -192);

		
		backFive.position = ccp(0, 48);
		[self addChild:menu];
		
		
		timeLabel = [CCLabelBMFont labelWithString:@"00:00" fntFile:@"zerofourbee-32.fnt"];
		[self addChild:timeLabel];
		timeLabel.anchorPoint = ccp(0,1);
		timeLabel.position = ccp(0, 320);
		
		//HitObjects = std::set<HitObject*, bool(*)(const HitObject*,const HitObject*)>(CompareHitObjects);
		hitObjectDisplays = [[NSMutableArray alloc] init];
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
		
		// Artwork
		MPMediaItem * currentItem = musicPlayer.nowPlayingItem;
		MPMediaItemArtwork *artwork = [currentItem valueForProperty:MPMediaItemPropertyArtwork];
		UIImage * artworkImage;
		artworkImage = [artwork imageWithSize:CGSizeMake(320, 320)];
		if([artworkImage CGImage]) {
			
			CCSprite * albumArt = [CCSprite spriteWithCGImage:[artworkImage CGImage]];
			albumArt.position = ccp(480/2, 320/2);
			if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2){
				//iPhone 4
				[albumArt setScale:0.5];
			}
			[self addChild:albumArt z:0];
		}
		
		
		
	} @catch(NSException *e) {
		//cout << "no music playing dawg" << endl;
	}
#endif
	CCSprite * grid = [CCSprite spriteWithFile: @"grid.png"];
	[self addChild:grid z:1];
	//grid.opacity = 0.5;
	grid.position = ccp(480/2, 320/2);
	
	[self schedule:@selector(updateTime:) interval: 1];
	[self schedule:@selector(nextFrame:)];

}

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch * touch = [touches anyObject];	
	CGPoint location = [self convertTouchToNodeSpace: touch];
	
	if([touches count] > 1) {
		[self play];
	} else {
		touchBeganAtTime = [self time];
	}
	
	if(mode == NEWCOMBO && hitObjects.size() != 0 && [self paused]) {
		[self handleNewCombo: location];
	}
	else if(mode == DELETE && hitObjects.size() != 0) {
		[self handleDelete: location];
	}
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch * touch = [touches anyObject];	
	CGPoint location = [self convertTouchToNodeSpace: touch];

	HitObject * ho = 0;
	HODCircle * hod = nil;
	
	if( (![self paused] && (mode == NEWCOMBO) || mode == NORMAL)) {
		double touchEndedAtTime = [self time];
		
		if(touchEndedAtTime - touchBeganAtTime < 100) {
			if(location.x < 64)
				return; // don't intercept the ccmenu stuff!!
			
			location = [self normalizeLocation: location];

			
			ho = new HitObject(location.x, location.y, touchBeganAtTime, 1, 0);
			
			if(hoIndex == 0)
				ho->number = 1;
			else {
				ho->number = hitObjects[hoIndex-1]->number + 1;
			}
			
			if(mode == NEWCOMBO) {
				ho->number = 1;
				ho->objectType = 5;
				[self newComboMode]; //untoggle newCombo
			}
				
			hitObjects.insert( (hitObjects.begin() + hoIndex++), ho);
			
			hod = [[[HODCircle alloc] initWithHitObject:ho red:200 green:0 blue:0] retain];
			[self addChild:hod];
			[hod justDisplay];
			[hitObjectDisplays addObject:hod];
			[hod release];
			
			if(hoIndex != hitObjects.size()-1)
				[self informChange];
			
			id removeAction = [CCCallBlock actionWithBlock:^{
				[hitObjectDisplays removeObject:hod];
				[self removeChild:hod cleanup:true];
			}];
			
			[hod runAction: [CCSequence actions:[CCFadeOut actionWithDuration:disappearDurationMs/1000.], removeAction, nil]];
			if([self paused])
				[hod pauseTimersForHierarchy];
			// circle
		}
	}
	
}

- (void) informChange {
	
	if(hitObjects.size() == 0) return;
	
	hitObjects[0]->number = 1;
	hitObjects[0]->objectType = 5;
	for(int i = 1; i < hitObjects.size(); i++) {
		NSLog(@"doing it for this one: %d at index %d", hitObjects[i]->number, i);
		if(!(hitObjects[i]->objectType & 4)) {// if not a new combo
			
			hitObjects[i]->number = hitObjects[i-1]->number+1;
		}
		else
			hitObjects[i]->number = 1;
	}
	for(HitObjectDisplay * hod in hitObjectDisplays) {
		[hod regenTexture];
	}
}


- (void) nextFrame: (ccTime)dt {
	double time = [self time] + 100;
	while( (hoIndex < hitObjects.size() ) &&
		  ( time > hitObjects[hoIndex]->startTimeMs)//[[hitObjectDisplays objectAtIndex: hoIndex] hitObject]->startTimeMs)
	) {
		if(time <= hitObjects[hoIndex]->startTimeMs + disappearDurationMs) {
			
			for(HitObjectDisplay* hod in hitObjectDisplays) {
				if([hod hitObject] == hitObjects[hoIndex]) 
					return;
			}
			
			//if(( time <= hitObjects[hoIndex]->startTimeMs + disappearDuration)) {
			HODCircle * hod = [[HODCircle alloc] initWithHitObject:hitObjects[hoIndex] red:200 green:0 blue:0];
			[self addChild:hod];
			[hod justDisplay];
			//[hod appearWithDuration:appearDuration];
			[hitObjectDisplays addObject:hod];
			
			id removeAction = [CCCallBlock actionWithBlock:^{
				[hitObjectDisplays removeObject:hod];
				[self removeChild:hod cleanup:true];
			}];
			NSLog(@"running a nextgram action for some reason XFD");
			
			double percentDone = (time - hitObjects[hoIndex]->startTimeMs) / (disappearDurationMs);
			[hod setOpacity: 255 * (1-percentDone)];
			
			[hod runAction: [CCSequence actions: [CCFadeOut actionWithDuration:disappearDurationMs/1000.], removeAction, nil]];
			
			if([self paused]) {
				/*
				id pauseHodAction = [CCCallBlock actionWithBlock:^{
					[hod pauseTimersForHierarchy];
				}];
				[self runAction:[CCSequence actions: [CCDelayTime actionWithDuration:(hitObjects[hoIndex]->startTimeMs + disappearDurationMs - time)], pauseHodAction, nil]];
				 */
				[hod pauseTimersForHierarchy];
			}
		}
		hoIndex++;
	}
}

	
- (void) updateTime: (ccTime)dt {
	NSTimeInterval interval = [musicPlayer currentPlaybackTime];
	long min = (long)interval / 60;    // divide two longs, truncates
	long sec = (long)interval % 60;    // remainder of long divide
	NSString* str = [[NSString alloc] initWithFormat:@"%02d:%02d", min, sec];
	
	[timeLabel setString:str];
	
	NSLog(@"%d", hoIndex);
}


- (void)skip {
	touchBeganAtTime = INT_MAX;
	[musicPlayer setCurrentPlaybackTime:[musicPlayer currentPlaybackTime] + 5];
	[self updateTime: 0];
}
- (void)play {
	if([self paused]) {
		[musicPlayer play];
		[self resumeTimersForHierarchy];
	}
	else {
		[musicPlayer pause];
		[self pauseTimersForHierarchy];
		[self resumeSchedulerAndActions]; // tricky tricky LOL
	}
}
- (void)back {
	hoIndex = 0;
	touchBeganAtTime = INT_MAX;
	int backTime = [musicPlayer currentPlaybackTime] - 5;
	if(backTime < 0) backTime = 0;
	[musicPlayer setCurrentPlaybackTime: backTime];
	[self updateTime: 0];
}

- (void)newComboMode {
	if(mode != NEWCOMBO) {
		mode = NEWCOMBO;
		newCombo.color = (ccColor3B){200,0,0};
		deleter.color = (ccColor3B){255,255,255};
	}
	else {
		mode = NORMAL;
		newCombo.color = (ccColor3B){255,255,255};
	}
}

- (void) deleterMode {
	if(mode != DELETE) {
		mode = DELETE;
		deleter.color = (ccColor3B){200,0,0};
		newCombo.color = (ccColor3B){255,255,255};
	}
	else {
		mode = NORMAL;
		deleter.color = (ccColor3B){255,255,255};
	}
}

-(void) backToMain
{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[MenuScene scene]]];
	return;
}

																																						
- (void) handleNewCombo: (CGPoint)location {
	NSLog(@"Doing a HandleNewCombo, yep.");
	for(HitObjectDisplay * hod in hitObjectDisplays) {
		HitObject * hitObject = [hod hitObject];
		double dist = sqrt( pow(hitObject->x - location.x, 2) + pow(hitObject->y - location.y, 2));
		if(dist < 46) {
			[hod hitObject]->number = 1;
			hoIndex = 0;
			if(!([hod hitObject]->objectType & 4)) {
				NSLog(@"not a new combo");
				[hod hitObject]->objectType += 4;
				while(hitObjects[hoIndex] != [hod hitObject]) {
					hoIndex++;
				}
				[hod regenTexture];
				/*
				[hod draw];
				[hod visit];
				 */
				hoIndex++; // start with the first one that is not the newcombo'd one
			} else {
				NSLog(@"already a new combo");
				[hod hitObject]->objectType -= 4;
			}
			
			[self informChange];
			
			[self newComboMode];
			
			return;
		}
	}
}
	

- (void)handleDelete:(CGPoint)location {
	NSLog(@"Doing a Delete");
	for(HitObjectDisplay * hod in hitObjectDisplays) {
		HitObject * hitObject = [hod hitObject];
		double dist = sqrt( pow(hitObject->x - location.x, 2) + pow(hitObject->y - location.y, 2));
		if(dist < 46) {
			/*
			for(int i = 0; i < hitObjects.size(); i++) {
				if(hitObjects[i] == ho)
			}
			 */
			hitObjects.erase(find(hitObjects.begin(), hitObjects.end(), hitObject));
			NSLog(@"about to delete");
			[self removeHitObjectDisplay: hod];
			NSLog(@"deleted");
			hoIndex = 0;
			[self informChange];
			return;
		}
	}
}

/*
 [Metadata]
 Title:Talamak
 Artist:Toro y Moi
 */
- (void) handleSave {
	ostringstream os;
	NSString* title = [[[mediaItem items] objectAtIndex:0] valueForProperty:MPMediaItemPropertyTitle];
	NSString* artist = [[[mediaItem items] objectAtIndex:0] valueForProperty:MPMediaItemPropertyArtist];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM-dd-yyyy' T 'HH:mm";
	
	os << "beatnik file format 04/2011\n" << [[dateFormatter stringFromDate:[NSDate date]] UTF8String] << "\n";
	os << "[Metadata]\n" << "Title:" << [title UTF8String] <<"\nArtist:" << [artist UTF8String] <<"\n[TimingPoints]\n" << "5140.06340758736,606.428138265616,4,2,0,100,1,0\n"
	<< "[HitObjects]\n";
	for(int i = 0; i < hitObjects.size(); i++) {
		hitObjects[i]->x -= 64;
		hitObjects[i]->y -= 64;

		// Put them into iphone space
		hitObjects[i]->x /= (480.-128.)/480.;
		hitObjects[i]->y /= (320.-128.)/320.;
		
		hitObjects[i]->y = 320 - hitObjects[i]->y;
		
		//hitObjects[i]->startTimeMs += 400; //wtf???
		
		//cout << "STRAIGHT TO COUT: " << *(hitObjects[i]);
		os << *(hitObjects[i]);
	}
	
	cout << "PRINTING OUT:\n" << os.str() << " HERP DERP DERP.";
	
	//Beatmap * lol = new Beatmap([NSString stringWithUTF8String:os.str().c_str()]);
	//[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[GameScene sceneWithBeatmap: lol]]];
	NSString* beatmapStr = [NSString stringWithUTF8String:os.str().c_str()];
	[[[SqlHandler alloc] init] insertNewBeatmap:beatmapStr artist:artist title:title];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionMoveInL transitionWithDuration:0.5f scene:[MenuScene scene]]];
}

- (CGPoint) normalizeLocation: (CGPoint) location {

	if(location.x > 416)
		location.x = 416;
	if(location.y < 64)
		location.y = 64;
	if(location.y > 256)
		location.y = 256;
	int x, y;
	if((int)location.x % 32 < 16)
		x = location.x - ((int)location.x % 32);
	else
		x = location.x + (32 - ((int)location.x % 32));
	
	if((int)location.y % 32 < 16)
		y = location.y - ((int)location.y % 32);
	else
		y = location.y + (32 - ((int)location.y % 32));
	return CGPointMake(x, y);
}


// this is generally caleld by one of the HitObjectDisplays.
- (void) removeHitObjectDisplay: (HitObjectDisplay*)hod {
	[hitObjectDisplays removeObject:hod];
	[self removeChild:hod cleanup:true];
}

- (double) time {
	return [musicPlayer currentPlaybackTime] * 1000.0f;
}

- (BOOL) paused {
	return ([musicPlayer playbackState] ==   MPMusicPlaybackStatePaused);
}



@end





