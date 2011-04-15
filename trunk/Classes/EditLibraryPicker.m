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
#import "EditorScene.h"

@implementation EditLibraryPicker
-(id) init {
	if( (self = [super init]) ) {
		
		mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
		mediaPicker.delegate = [[EditLibraryDelegate alloc] initWithPickerScene: self];
		
		[[(BeatnikDelegate*)[[UIApplication sharedApplication] delegate] window] addSubview:mediaPicker.view];
		
	}
	return self;
}

- (void) selectedItem: (MPMediaItemCollection *) item {
	[self removeMediaPicker];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[EditorScene sceneWithMediaItem:item]]];

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
	[mediaPicker release]; // needed?
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

