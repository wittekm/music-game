//
//  EditLibraryPicker.m
//  musicGame
//
//  Created by Max Wittek on 4/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "BeatnikDelegate.h"
#import "EditLibraryPicker.h"
#import "MusicPlayerDemoViewController.h"
#import "EditorScene.hh"
#include "MenuScene.h"

@implementation EditLibraryPicker
-(id) init {
	if( (self=[super initWithColor:ccc4(238,232,170,255)])) {
		
		mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
		mediaPicker.delegate = [[EditLibraryDelegate alloc] initWithPickerScene: self];
		/*
		
		CCMenuItemFont * create = [CCMenuItemFont itemFromString:@"DERP DERP."];
		//CCMenuItemLabel * create = [CCMenuItemLabel itemWithLabel:[CCLabelBMFont labelWithString:@"CREATE" fntFile:@"zerofourbee-48.fnt"] target: self selector:@selector(chooseCreate)] ;
		CCLabelBMFont * eLabel = [CCLabelBMFont labelWithString:@"EDIT" fntFile:@"zerofourbee-48.fnt"];
		CCMenuItemLabel * edit = [CCMenuItemLabel itemWithLabel:eLabel target: self selector:@selector(chooseEdit)];		
		//[create setScale:1.5];
		//[edit setScale:1.5];
		
		menu = [CCMenu menuWithItems:create, edit, nil];
		
		//[menu alignItemsHorizontallyWithPadding:20];
		
		menu.position = ccp(480/2, 320/2);
		[self addChild:menu];
		 */
		
		//CCMenuItemLabel * create = [CCMenuItemLabel itemWithLabel:[CCLabelBMFont labelWithString:@"CREATE" fntFile:@"zerofourbee-32.fnt"] target: self selector:@selector(chooseCreate)] ;
		//CCMenuItemLabel * edit = [CCMenuItemLabel itemWithLabel:[CCLabelBMFont labelWithString:@"EDIT" fntFile:@"zerofourbee-32.fnt"] target: self selector:@selector(chooseCreate)];		
		//CCMenuItemLabel *back = [CCMenuItemLabel itemWithLabel:[CCLabelBMFont labelWithString:@"BACK" fntFile:@"zerofourbee-32.fnt"] target: self selector:@selector(backToMain)];
		CCSprite * create = [CCSprite spriteWithFile:@"createmenu.png"];
		CCSprite * edit = [CCSprite spriteWithFile:@"edit.png"];
		CCSprite * back = [CCSprite spriteWithFile:@"back.png"];
		CCMenuItemSprite * menucreate = [CCMenuItemSprite itemFromNormalSprite:create selectedSprite:nil target:self selector:@selector(chooseCreate)];
		CCMenuItemSprite * menuedit = [CCMenuItemSprite itemFromNormalSprite:edit selectedSprite:nil target:self selector:@selector(chooseCreate)];
		CCMenuItemSprite * menuback = [CCMenuItemSprite itemFromNormalSprite:back selectedSprite:nil target:self selector:@selector(backToMain)];
		menu = [CCMenu menuWithItems: menucreate, menuedit, menuback, nil];
		menu.position = ccp(480/2, 320/2);
		menuback.position = ccp(185,-120);
		menuback.scale = .5;
		menucreate.position = ccp(-100,0);
		menucreate.scale = .5;
		menuedit.position = ccp(0,0);
		menuedit.scale = .5;
		//[menu alignItemsHorizontallyWithPadding:20];
		
		
		
		[self addChild:menu];
		
	}
	return self;
}

- (void) selectedItem: (MPMediaItemCollection *) item {
	[self removeMediaPicker];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[EditorScene sceneWithMediaItem:item]]];

}

- (void) chooseCreate {
	[[(BeatnikDelegate*)[[UIApplication sharedApplication] delegate] window] addSubview:mediaPicker.view];
}
- (void) chooseEdit {
	
}
-(void) backToMain
{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[MenuScene scene]]];
	return;
}


+ (id) scene {
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	EditLibraryPicker *layer = [EditLibraryPicker node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (void) removeMediaPicker {
	[mediaPicker.view removeFromSuperview];
	//[mediaPicker release]; // needed?
}

@end


@implementation EditLibraryDelegate

- (id) initWithPickerScene: (EditLibraryPicker*)elp {
	if ( (self = [super init]) ) {
		pickerScene = elp;
	}
	return self;
}

- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker {
	[pickerScene removeMediaPicker];
	//[[(BeatnikDelegate*)[[UIApplication sharedApplication] delegate] window] ];
	//[self dismissModalViewControllerAnimated: YES];
}


- (void) mediaPicker: (MPMediaPickerController *) mediaPicker
   didPickMediaItems: (MPMediaItemCollection *) collection {
	
	//MPMediaItem * item = [[collection items] objectAtIndex:0];
	
	[pickerScene selectedItem:collection];
	
    //[self dismissModalViewControllerAnimated: YES];
    //[self updatePlayerQueueWithMediaCollection: collection];
}

@end

