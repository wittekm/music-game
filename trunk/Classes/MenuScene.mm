//
//  untitled.mm
//  musicGame
//
//  Created by Max Kolasinski on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MenuScene.h"
#import <sqlite3.h>
#import <iostream>
#import "SqlHandler.h"
#import "GameScene.h"
#import "osu-import.h.mm"
#include "SMXMLDocument.h"

#import "SongSelectScreen.h"

@implementation MenuScene
+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MenuScene *layer = [MenuScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}


-(id) init
{
	if( (self=[super init])) {
		CCSprite * window = [CCSprite spriteWithFile:@"window.bmp"];
		window.position = ccp(480/2,120);
		window.scaleY = 2.2;
		window.scaleX = 2.5;
		[self addChild:window];
		CCLabelTTF * title = [CCLabelTTF labelWithString:@"Beatnik!" fontName:@"hellovetica" fontSize:42];
		title.position = ccp(480/2,240);
		[self addChild:title];
		[CCMenuItemFont setFontName:@"hellovetica"];
		[CCMenuItemFont setFontSize:12];
		
		CCMenuItemFont * play = [CCMenuItemFont itemFromString:@"Play!" target:self selector:@selector(menuCallbackStart:)];
		CCMenuItemFont * create = [CCMenuItemFont itemFromString:@"Create!" target:self selector:@selector(menuCreate:)];
		CCMenuItemFont * share = [CCMenuItemFont itemFromString:@"Share!" target:self selector:@selector(menuShare:)];
		CCMenuItemFont * options = [CCMenuItemFont itemFromString:@"Options" target:self selector:@selector(menuOptions:)];
		CCMenu *menu = [CCMenu menuWithItems:
						play, create, share, options, nil];
		menu.position = ccp(480/2, 120);
		[menu alignItemsVerticallyWithPadding:5.0f];
		[self addChild: menu];
		
	}
	return self;
}

-(void) menuCreate: (id) sender
{
	return;
}
-(void) menuShare: (id) sender
{
	return;
}
-(void) menuOptions: (id) sender
{
	return;
}
-(void) menuCallbackStart: (id) sender
{

	NSMutableDictionary * songList = [[NSMutableDictionary alloc] init];
	
	//NSURL * tumblr = [NSURL URLWithString:@"beatnikapp.tumblr.com/api/read"];
	NSURL * xmlFile = [NSURL URLWithString:@"http://www-personal.umich.edu/~mkolas/uploads/songs.xml"];
	NSURLRequest *request = [NSURLRequest requestWithURL:xmlFile];
	NSError *error;
	NSURLResponse *response;
	NSData * result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	
	/*
	//XmlParser * tumblrfeed = [[XmlParser alloc] init];
	//[tumblrfeed parseXMLFile];
	
	SMXMLDocument *document = [SMXMLDocument documentWithData:result error:&error];
	SMXMLElement *songs = [document.root childNamed:@"songs"];
	
	for(SMXMLElement * song in [songs childrenNamed:@"song"]){
		NSString * title = [song attributeNamed:@"title"];
		NSString * map = [song valueWithPath:@"map"];
		NSLog(@"title is %@", title);
		NSLog(@"map is %@", map);
		[songList setObject:map forKey:title];
	}
	 */
	
	
	SqlHandler * handler = [[SqlHandler alloc] init];
	/*
	// lists all the beatmaps
	for(SqlRow * row in [handler beatmaps]) {
		NSLog(@"%@ - %@", [row artist], [row title]);
	}
	Beatmap * beatmap = [[[handler beatmaps] objectAtIndex:1] getBeatmap];
	*/
	 
	//[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[GameScene sceneWithBeatmap:beatmap]]];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[SongSelectScreen sceneWithSongList:handler]]];

	//[(CCMultiplexLayer*)parent_ switchTo:2];
}

@end