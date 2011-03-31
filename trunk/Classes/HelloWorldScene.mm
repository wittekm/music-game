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
#import "HelloWorldScene.h"
#import "HODCircle.h"
#import "osu-import.h.mm"
#import "HODSlider.h"
#import "HitObjectDisplay.h.mm"
#import "SqlHandler.h"

#import "FRCurve.h"

#include "TargetConditionals.h"


#include <list>
#include <iostream>
using std::cout;
using std::endl;
using std::vector;

CCLabelTTF * scoreLabel;
int score;

Beatmap * beatmap;

MPMusicPlayerController * musicPlayer;

std::list<HODCircle*> circles;

int zOrder = INT_MAX;

CGPoint start_;
CGPoint end_;


HitObjectDisplay* HODFactory(HitObject* hitObject, int r, int g, int b) {
	if(hitObject->objectType & 1) { // bitmask for normal
		return [[[HODCircle alloc] initWithHitObject:hitObject red:r green:g blue:b initialScale: 0.7] retain];
	}
	
	else if(hitObject->objectType & 2) {
		return [[[HODSlider alloc] initWithHitObject:hitObject red:r green:g blue:b initialScale: 1] retain];
	}
	
	else {
		// this is just a "unknown type" circle, we haven't done spinner yet
		return [[[HODCircle alloc] initWithHitObject:hitObject red:150 green:0 blue:0] retain];
	}
	return 0;
}

// HelloWorld implementation

@implementation Layer2

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Layer2 *layer = [Layer2 node];
	
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
		
		if(!beatmap) exit(0);
		 
		
		[self schedule:@selector(nextFrame:)];
		
		self.isTouchEnabled = YES;
		
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
			UIImage * artworkImage = [artwork imageWithSize:CGSizeMake(320, 320)];
			
			CCSprite * albumArt = [CCSprite spriteWithCGImage:[artworkImage CGImage]];
			albumArt.position = ccp(480/2, 320/2);
			[self addChild:albumArt];
			
			//[musicPlayer setCurrentPlaybackTime:100]; // skip intro, usually 18
			
			
		} @catch(NSException *e) {
			cout << "no music playing dawg" << endl;
		}
#endif
		/* cgpoints go from bottom left to top right like a graph */
		
		// commented because i dont have scorehud
		/*
		CCSprite *scorebg = [CCSprite spriteWithFile:@"scorehud.png"];
		scorebg.scale = .15;
		scorebg.position = ccp(435,300);
		[self addChild:scorebg];
		 */

		score = 0;
		scoreLabel = [CCLabelTTF labelWithString:@"0" fontName:@"PhonepadTwo" fontSize:24.0];
		//scoreLabel.anchorPoint = ccp([scoreLabel contentSize].width,[scoreLabel contentSize].height);
		scoreLabel.position = ccp(430,305);
		[self addChild: scoreLabel];
		scoreLabel.color = ccc3(0,0,0);
		
		/*
		HitObject * o = beatmap->hitObjects.front();
		HitObjectDisplay * hod = HODFactory(o, 0, 120, 0);
		[self addChild:hod];
		[hod appearWithDuration:1.5];
		*/
		
	}
	return self;
}

BOOL otherDirection = NO;

- (void) nextFrame:(ccTime)dt {
	
	/***** Music Game Stuff ****/
	
	double milliseconds = [musicPlayer currentPlaybackTime] * 1000.0f;
	milliseconds += 1000; // offset for gee norm
	
	double durationS = 0.8; // seconds
	double timeAllowanceMs = 150;
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
			
			//HitObjectDisplay * hod = [[HODCircle alloc] initWithHitObject:o red:0 green:180 blue:0];
			 
			HitObjectDisplay * hod = HODFactory(o, 0, 120, 0);
			NSLog(@"successful HODfactory");
			[self addChild:hod z:zOrder--];
			[hod appearWithDuration: durationS];
			circles.push_back(hod);
			beatmap->hitObjects.pop_front();
		}
		else
			break;
	}
	
	
	if(circles.empty()) {
		zOrder = INT_MAX;
	} // why not?
	
	while(!circles.empty()) {
		HitObject * o = circles.front().hitObject;
		if(milliseconds > o->startTimeMs + timeAllowanceMs + (1000.0 * durationS)) {
			NSLog(@"doing the if in the second while");
			HitObjectDisplay * c = circles.front();
			circles.pop_front();
			[self removeChild:c cleanup:true];
			// [c release];
		}
		else {
			NSLog(@"ended second while");
			break;
		}
	}
	
}

BOOL paused = false;

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	NSArray * touchesArray = [touches allObjects];
	NSLog(@"%d", [touchesArray  count]);
	UITouch * touch = [touches anyObject];	
	CGPoint location = [self convertTouchToNodeSpace: touch];
	if(!circles.empty()) {
		HitObject * o = circles.front().hitObject;
		double dist = sqrt( pow(o->x - location.x, 2) + pow(o->y - location.y, 2));
		int distInt = dist;
		
		if(dist < 100){
			/*
			 // commented because i dont have starburst
			 
			//CCLabelTTF *points = [CCLabelTTF labelWithString:@"100!" fontName:@"Helvetica" fontSize:24.0];
			//points.position = ccp(o->x, o->y);
			CCSprite *burst = [CCSprite spriteWithFile:@"starburst.png"];	
			//CCSprite *onehundred = [CCSprite spriteWithFile:@"100.png"];
			burst.position = ccp(o->x,o->y);
			//onehundred.position = ccp(o->x, o->y);
			burst.scale = 0.25;
			//onehundred.scale = 0.6;
			//[self addChild:burst];
			[burst runAction:[CCRotateBy actionWithDuration:0.4 angle:90]];
			//[onehundred runAction:[CCFadeOut actionWithDuration:0.4]];
			[circles.front() addChild:burst];
			//[circles.front() addChild:onehundred];
			 */
		}
		
	if([touches count] > 1) {
		
	
		if(!paused) {
			[[CCDirector sharedDirector] stopAnimation];
			[musicPlayer pause];
			paused = true;
		} else {
			[[CCDirector sharedDirector] startAnimation];
			[musicPlayer play];
			paused = false;
		}
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


/*
- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
	CGPoint location = [self convertTouchToNodeSpace: touch];
	
	NSLog(@"%f %f", location.x, location.y);
	
	if(!circles.empty()) {
		HitObject * o = circles.front().hitObject;
		double dist = sqrt( pow(o->x - location.x, 2) + pow(o->y - location.y, 2));
		int distInt = dist;
	
		score += 1;
		[scoreLabel setString:[NSString stringWithFormat:@"%d %d", score, distInt]];
		NSLog(@"%d %d %f", o->x, o->y, location.x, location.y, dist);
	}
	else
		[scoreLabel setString:[NSString stringWithFormat:@"%d X", score]];

    return YES;
}
*/

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
