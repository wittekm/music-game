//
//  HelloWorldLayer.m
//  Cocos2dLesson1
//
//  Created by Max Wittek on 3/4/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#define COCOS2D_DEBUG 1

// Import the interfaces
#import <MediaPlayer/MediaPlayer.h> 
#import "CCTouchDispatcher.h"
#import "GameScene.h"
#import "HODCircle.h"
#import "osu-import.h.mm"
#import "HODSlider.h"
#import "HitObjectDisplay.h.mm"
#import "SqlHandler.h"
#import "Scoreboard.h"
#import "FRCurve.h"

#import "ResultsScreen.h"

#include "TargetConditionals.h"


#include <list>
#include <iostream>
using std::cout;
using std::endl;
using std::vector;
using std::list;

CCLabelTTF * scoreLabel;
int score;

list<HitObjectDisplay*> hods;

int zOrder = INT_MAX;


HitObjectDisplay* HODFactory(HitObject* hitObject, int r, int g, int b) {
	if(hitObject->objectType & 1) { // bitmask for normal
		return [[[HODCircle alloc] initWithHitObject:hitObject red:r green:g blue:b initialScale: 1.0] retain];
	}
	
	else if(hitObject->objectType & 2) {
		return [[[HODSlider alloc] initWithHitObject:hitObject red:r green:g blue:b initialScale: 1.0] retain];
	}
	
	else {
		// this is just a "unknown type" circle, we haven't done spinner yet
		return [[[HODCircle alloc] initWithHitObject:hitObject red:150 green:0 blue:0] retain];
	}
	return 0;
}

// HelloWorld implementation

@implementation GameScene
@synthesize beatmap;
@synthesize timeAllowanceMs;
@synthesize durationMs;
@synthesize scoreBoard;

+(id) sceneWithBeatmap: (Beatmap*)beatmap_;
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameScene *layer = [GameScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// tell the layer we're using this beatmap, and start animation
	[layer startSceneWithBeatmap:beatmap_];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		
		self.isTouchEnabled = YES;
		
		paused = false;
		beatmap = 0;
#if !TARGET_IPHONE_SIMULATOR
		musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
#endif
		
		// Initialize Scoreboard
		scoreBoard = [[Scoreboard alloc] init];
		[self addChild:scoreBoard z:1];
		
		timeAllowanceMs = 100;
		durationMs = 750;
		comboIndex = 0;

	}
	return self;
}

- (void) startSceneWithBeatmap:(Beatmap*)beatmap_ {
	
	beatmap = beatmap_;
	 if(!beatmap) exit(0); // TODO: make an errmsg
	 
	 [self schedule:@selector(nextFrame:)];
	 
	 // this shit don't work in the simulator
#if !TARGET_IPHONE_SIMULATOR
	 
	 @try {
		 // Music Stuff
		 
		 MPMediaQuery * mfloQuery = [[MPMediaQuery alloc] init];
		 [mfloQuery addFilterPredicate: [MPMediaPropertyPredicate
		 predicateWithValue: @"Talamak"
		 forProperty: MPMediaItemPropertyTitle]];
		 
		 [musicPlayer setQueueWithQuery:mfloQuery];
		 [musicPlayer play];
		 
		 //Letterboxes
		 
		 CCSprite  * left_curtain = [CCSprite spriteWithFile:@"left_curtain.png"];
		 CCSprite  * right_curtain = [CCSprite spriteWithFile:@"right_curtain.png"];
		 left_curtain.position = ccp(40, 320/2);
		 right_curtain.position = ccp(440, 320/2);
		 if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2){
			 //iPhone 4
			 [left_curtain setScale:0.5];
			 [right_curtain setScale:0.5];
		 }
		 [self addChild:left_curtain];
		 [self addChild:right_curtain];
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
	 cout << "no music playing dawg" << endl;
	 }
#endif
	
	// test out slider stuff in the simulator
#if TARGET_IPHONE_SIMULATOR
	while(beatmap->hitObjects.front()->startTimeMs < 61234)
		beatmap->hitObjects.pop_front();
	HitObject* o = beatmap->hitObjects.front();
	HitObjectDisplay * hod = HODFactory(o, 0, 120, 0);
	[self addChild:hod];
	[hod appearWithDuration:1.5];
#endif
	 
}




-(void)fadeout {
	
	if(musicPlayer.volume > 0.05) {
		musicPlayer.volume = musicPlayer.volume - 0.05;
		[self performSelector: @selector(fadeout) withObject: nil afterDelay: 0.05 ];
	} else { [musicPlayer pause]; }
}

int numPopped = 0;

- (void) nextFrame:(ccTime)dt {
	
	double milliseconds = [musicPlayer currentPlaybackTime] * 1000.0f;
	milliseconds += 800; // offset for gee norm
	
	
	if(beatmap->hitObjects.empty()) {
		//exit(0);
		// wait 3 seconds and then go to another scene
	}
	 
	   
	while(!beatmap->hitObjects.empty()) {
		HitObject * o = beatmap->hitObjects.front(); 
		
		if(milliseconds > o->startTimeMs) {
			cout << o->x << " " << o->y << endl;
			cout << "making a HitObject at time " << o->startTimeMs << endl;
			
			// give a different color to each combo group
			if(o->number == 1) comboIndex++;
			ccColor3B col = beatmap->comboColors[comboIndex % 4];
			
			HitObjectDisplay * hod = HODFactory(o, col.r, col.g, col.b );
			[self addChild:hod z:zOrder--];
			[hod appearWithDuration: durationMs / 1000.];
			hods.push_back(hod);
			beatmap->hitObjects.pop_front();
			
			numPopped++;
		}
		else
			break;
	}
	
	
	if(hods.empty()) {
		zOrder = INT_MAX;
	} // reset z-order to topmost. cuz we can.
	
	while(!hods.empty()) {
		//HitObject * o = hods.front().hitObject;
		if(milliseconds > [hods.front() disappearTime]) {
			HitObjectDisplay * c = hods.front();
			[self spawnReaction:0 pos:ccp([c hitObject]->x, [c hitObject]->y)];
			 
			hods.pop_front();
			[self removeChild:c cleanup:true];
			// [c release];
		}
		else {
			break;
		}
	}
	
	
	if(hods.empty() && beatmap->hitObjects.empty()) {
	//if(numPopped == 10) {
		//[self fadeout];
		[self pauseSchedulerAndActions];
		[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.5f scene:[ResultsScreen sceneWithBeatmap:beatmap scoreboard:scoreBoard]]];
	}
 
}

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch * touch = [touches anyObject];	
	CGPoint location = [self convertTouchToNodeSpace: touch];
	
	if([touches count] > 1) {
		/*
		if(!pausedLabel)
			pausedLabel = [[CCLabelTTF labelWithString:@"PAUSED" fontName:@"Helvetica" fontSize:48] retain];
		*/
		
		if(!paused) {
			[musicPlayer pause];
			paused = true;
			
			[[CCDirector sharedDirector] stopAnimation];
		} else {
			[[CCDirector sharedDirector] startAnimation];
			[musicPlayer play];
			paused = false;
		}
	}
	
	
	if(!hods.empty()) {
		
		double milliseconds = [musicPlayer currentPlaybackTime] * 1000.0f;
		milliseconds += 800; // offset for gee norm

		// iterate through everying in "hods"
		list<HitObjectDisplay*>::iterator hodIter = hods.begin();
		list<HitObjectDisplay*>::iterator hodsEnd = hods.end();
		for(hodIter; hodIter != hodsEnd; ++hodIter) {
			HitObjectDisplay * hod = *hodIter;
			if([hod wasHit: location atTime: milliseconds]) {
				// wasHit should remove the object if it needed to be removed
				cout << "hit something!" << endl;;
				break;
			}
		}
		if(hodIter == hodsEnd) {
			// Tapped somewhere on the screen that doesn't correspond to a HitObject.
			// Reset the multiplier back to 1x.
		}
		
		
	}
}

- (void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch* touch = [touches anyObject];
	NSSet* allTouches = [touches setByAddingObjectsFromSet:[event touchesForView:[touch view]]];
	NSArray* allTheTouches = [allTouches allObjects];
	
	NSLog(@"%d", [allTheTouches count]);
	
	/*
	CGPoint location = [self convertTouchToNodeSpace: touch];
	[(HODSlider*)[self getChildByTag:0] slider].position = ccp(location.x, location.y);
	 */
}


// this is generally caleld by one of the HitObjectDisplays.
- (void) removeHitObjectDisplay: (HitObjectDisplay*)hod {
	hods.remove(hod);
	[self removeChild:hod cleanup:true];
}

// type is 300, 100, 0
- (void) spawnReaction: (int)type pos: (CGPoint)pos {
	
	NSLog(@"in spawn reaction, should change score....");
	[scoreBoard hitWith:type];
	
	CCSprite *burst;
	
	// change this to fail, blue, and red
	if(type == 300) {
		burst = [CCSprite spriteWithFile:@"starburst-128 pix.png"];
	} else if(type == 100) {
		burst = [CCSprite spriteWithFile:@"starburst-blue-128 pix.png"];
	} else if (type == 0) {
		burst = [CCSprite spriteWithFile:@"fail-128 pix.png"];
	}
	
	id removeAction = [CCCallBlock actionWithBlock:^{
		[self removeChild:burst cleanup:true];
	}];
	
	burst.position = pos;
	burst.scale = 0.75;
	[burst runAction: [CCFadeOut actionWithDuration:0.1]];
	[burst runAction: [CCSequence actions:[CCRotateBy actionWithDuration:0.1 angle:0], removeAction, nil] ];
	[self addChild:burst];
}

/*
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint location = [self convertTouchToNodeSpace: touch];
}
 */

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	NSLog(@"hey i was called ~neato");
}
/*
- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint location = [self convertTouchToNodeSpace: touch];
}
 */


// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
