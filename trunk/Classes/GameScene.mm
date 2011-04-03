//
//  HelloWorldLayer.m
//  Cocos2dLesson1
//
//  Created by Max Wittek on 3/4/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

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
		return [[[HODCircle alloc] initWithHitObject:hitObject red:r green:g blue:b initialScale: 0.7] retain];
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

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	GameScene *layer = [GameScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		// Initialize Timer
		
		
		// Initialize Beatmap (C++)
		//beatmap = new Beatmap("mflo.osu");
		//beatmap = new Beatmap("gee_norm.osu");
		//beatmap = new Beatmap("talamak.osu");
		
		// Print out all available beatmaps
		SqlHandler * handler = [[SqlHandler alloc] init];
		for(SqlRow * row in [handler beatmaps]) {
			NSLog(@"%@ - %@", [row artist], [row title]);
		}
		
		// choose toro y moi
		beatmap = [[[handler beatmaps] objectAtIndex:1] getBeatmap];
		
		if(!beatmap) exit(0); // TODO: make an errmsg
		
		[self schedule:@selector(nextFrame:)];
		
		self.isTouchEnabled = YES;
		
		paused = false;

		
// this shit don't work in the simulator
#if !(TARGET_IPHONE_SIMULATOR)

		@try {
			/* Music stuff */
			musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
			
			MPMediaQuery * mfloQuery = [[MPMediaQuery alloc] init];
			[mfloQuery addFilterPredicate: [MPMediaPropertyPredicate
										predicateWithValue: @"Talamak"
										forProperty: MPMediaItemPropertyTitle]];
			
			[musicPlayer setQueueWithQuery:mfloQuery];
			[musicPlayer play];
			
			
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
			[self addChild:albumArt];
			
			//[musicPlayer setCurrentPlaybackTime:100]; // skip intro, usually 18
			//[musicPlayer setCurrentPlaybackTime:60];
			
			
		} @catch(NSException *e) {
			cout << "no music playing dawg" << endl;
		}
#endif
		/* cgpoints go from bottom left to top right like a graph */
		
		// commented because i dont have scorehud
		
		// Initialize Scoreboard
		scoreBoard = [[Scoreboard alloc] init];
		[self addChild:scoreBoard];

/*		score = 0;
		scoreLabel = [CCLabelTTF labelWithString:@"0" fontName:@"PhonepadTwo" fontSize:24.0];
		//scoreLabel.anchorPoint = ccp([scoreLabel contentSize].width,[scoreLabel contentSize].height);
		scoreLabel.position = ccp(430,305);
		[self addChild: scoreLabel];
		scoreLabel.color = ccc3(0,0,0);
 */

#if TARGET_IPHONE_SIMULATOR
		
		while(beatmap->hitObjects.front()->startTimeMs != 61234)
			beatmap->hitObjects.pop_front();
		HitObject* o = beatmap->hitObjects.front();
		HitObjectDisplay * hod = HODFactory(o, 0, 120, 0);
		[self addChild:hod];
		[hod appearWithDuration:1.5];
		
#endif
	}
	return self;
}

BOOL otherDirection = NO; // wtf does this do
int comboIndex;

- (void) nextFrame:(ccTime)dt {
	
	double milliseconds = [musicPlayer currentPlaybackTime] * 1000.0f;
	milliseconds += 1000; // offset for gee norm
	
	double durationS = 0.8; // seconds
	durationMs = durationS * 1000.;
	timeAllowanceMs = 150;
	// Make stuff start to appear
	
	
	if(beatmap->hitObjects.empty()) {
		//exit(0);
		// wait 3 seconds and then go to another scene
	}
	 
	   
	while(!beatmap->hitObjects.empty()) {
		HitObject * o = beatmap->hitObjects.front(); 
		//cout << o->x << " " << o->y << endl;
		
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
		
		/*
		 // commented out because I'm in the process of moving this stuff to the HitObjectDisplay side.
		 
		HitObject * o = hods.front().hitObject;
		double dist = sqrt( pow(o->x - location.x, 2) + pow(o->y - location.y, 2));
		int distInt = dist;
		
		if(dist > 100){
			CCSprite *fail = [CCSprite spriteWithFile:@"fail-128.png"];
			fail.position = ccp (o->x, o->y);
			//fail.scale = 0.15;
			[fail runAction:[CCRotateBy actionWithDuration:0.4 angle: 0]];
			[hods.front() addChild:fail];
		}
			 
		
		else if(dist > 50 && dist < 100){
			CCSprite *burst = [CCSprite spriteWithFile:@"starburst-blue-128.png"];
			burst.position = ccp (o->x,o->y);
			//burst.scale = 0.25;
			[burst runAction:[CCRotateBy actionWithDuration:0.4 angle :0]];
			[hods.front() addChild:burst];
		}
		
		else if(dist < 50){
			//CCLabelTTF *points = [CCLabelTTF labelWithString:@"100!" fontName:@"Helvetica" fontSize:24.0];
			//points.position = ccp(o->x, o->y);
			CCSprite *burst = [CCSprite spriteWithFile:@"starburst-128.png"];	
			//CCSprite *onehundred = [CCSprite spriteWithFile:@"100.png"];
			burst.position = ccp(o->x,o->y);
			//onehundred.position = ccp(o->x, o->y);
			//burst.scale = 0.25;
			//onehundred.scale = 0.6;
			//[self addChild:burst];
			[burst runAction:[CCRotateBy actionWithDuration:0.4 angle:0]];
			//[onehundred runAction:[CCFadeOut actionWithDuration:0.4]];
			[hods.front() addChild:burst];
			//[hods.front() addChild:onehundred];
			 
		}
		 */
		
		double milliseconds = [musicPlayer currentPlaybackTime] * 1000.0f;
		milliseconds += 1000; // offset for gee norm

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
		burst = [CCSprite spriteWithFile:@"starburst-128.png"];
	} else if(type == 100) {
		burst = [CCSprite spriteWithFile:@"starburst-blue-128.png"];
	} else if (type == 0) {
		burst = [CCSprite spriteWithFile:@"fail-128.png"];
	}
	
	id removeAction = [CCCallBlock actionWithBlock:^{
		[self removeChild:burst cleanup:true];
	}];
	
	burst.position = pos;
	burst.scale = 0.75;
	[burst runAction: [CCFadeOut actionWithDuration:0.1]];
	[burst runAction: [CCSequence actions:[CCRotateBy actionWithDuration:0.1 angle:50], removeAction, nil] ];
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
