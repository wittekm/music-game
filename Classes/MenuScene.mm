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
	if( (self=[super initWithColor:ccc4(238,232,170,255)])) {
		//CCLabelTTF * title = [CCLabelTTF labelWithString:@"Beatnik!" fontName:@"04b-19" fontSize:42];
		id toRed = [CCTintBy actionWithDuration: 0.2 red:255 green: 0 blue: 0];
		id fromRed = [CCTintBy actionWithDuration:0.2 red:-255 green:0 blue:0];
		id toBlue = [CCTintBy actionWithDuration: 0.4 red: 0 green: 0 blue: 255];
		id fromBlue = [CCTintBy actionWithDuration: 0.4 red: 0 green: 0 blue: -255];
		id toGreen = [CCTintBy actionWithDuration: 0.8 red: 0 green: 255 blue: 0];
		id fromGreen = [CCTintBy actionWithDuration:0.8 red:0 green: -255 blue:0];
		id redSequence = [CCSequence actions: toRed, fromBlue, nil];
		id blueSequence = [CCSequence actions: toBlue, fromGreen, nil];
		id greenSequence = [CCSequence actions: toGreen, fromRed, nil];
		id colorCraziness = [CCSpawn actions: [CCRepeat actionWithAction: redSequence times: 4], [CCRepeat actionWithAction: blueSequence times: 2], greenSequence, nil];
		CCSprite * title = [CCSprite spriteWithFile:@"beatniksolo.png"];
		title.position = ccp(480/2,320/2);
		//[self addChild:title];
		CCSprite * create1 = [CCSprite spriteWithFile:@"create.png"];
		CCSprite * create2 = [CCSprite spriteWithFile:@"create.png"];
		CCSprite * share1 = [CCSprite spriteWithFile:@"share.png"];
		CCSprite * share2 = [CCSprite spriteWithFile:@"share.png"];
		CCSprite * options1 = [CCSprite spriteWithFile:@"options.png"];
		CCSprite * options2 = [CCSprite spriteWithFile:@"options.png"];
		CCSprite * play1 = [CCSprite spriteWithFile:@"play.png"];
		CCSprite * play2 = [CCSprite spriteWithFile:@"play.png"];
		
		CCMenuItemSprite * play = [CCMenuItemSprite itemFromNormalSprite:play1 selectedSprite:play2 target:self selector:@selector(menuCallbackStart:)];
		[play runAction: [CCRepeatForever actionWithAction: colorCraziness]];
		CCMenuItemSprite * create = [CCMenuItemSprite itemFromNormalSprite:create1 selectedSprite:create2 target:self selector:@selector(menuCreate:)];
		CCMenuItemSprite * share = [CCMenuItemSprite itemFromNormalSprite:share1 selectedSprite:share2 target:self selector:@selector(menuShare:)];
		CCMenuItemSprite * options = [CCMenuItemSprite itemFromNormalSprite:options1 selectedSprite:options2 target:self selector:@selector(menuOptions:)];
		CCMenu *menu = [CCMenu menuWithItems:
						play, create, share, options, nil];
		menu.position = ccp(118,80);
		//[menu alignItemsVerticallyWithPadding:5.0f];
		//if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2){
			//iPhone 4
			[title setScale:.5];
			[menu setScale:.5];
		//}
		[self addChild:title];
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