//
//  EditLibraryPicker.m
//  musicGame
//
//  Created by Max Wittek on 4/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "EditLibraryPicker.h"
#import "MusicPlayerDemoViewController.h"

@implementation EditLibraryPicker

-(id) init {
	if( (self = [super init]) ) {
				
		CGRect cgRct = CGRectMake(0.0, 100, 360, 320);

		UIView * view = [[UIView alloc] initWithFrame:cgRct];
		
		MusicPlayerDemoViewController * cont = [[MusicPlayerDemoViewController alloc] init];
		
		[view addSubview:cont.view];
		/*
		mediaPicker.delegate = self;
		mediaPicker.allowsPickingMultipleItems = YES; // this is the default   
		[self presentModalViewController:mediaPicker animated:YES];
		[mediaPicker release];
		*/
		
		wrapper = [CCUIViewWrapper wrapperForUIView:view];
		
		[self addChild:wrapper];
	}
	return self;
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

@end
