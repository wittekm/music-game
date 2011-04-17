//
//  ShareScene.mm
//  musicGame
//
//  Created by Max Kolasinski on 4/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShareScene.h"
#import "ShareDownloadScene.h"
#import "ShareUploadScene.h"

@implementation ShareScene

+(id) scene
{
	CCScene * scene = [CCScene node];
	ShareScene * layer = [ShareScene node];
	[scene addChild: layer];
	return scene;
}

-(id) init
{
	if( (self=[super initWithColor:ccc4(238,232,170,255)])) {
		CCSprite * share = [CCSprite spriteWithFile:@"sharemenu.png"];
		CCSprite * back1 = [CCSprite spriteWithFile:@"back.png"];
		share.scale = .5;
		
		CCMenuItemSprite * back = [CCMenuItemSprite itemFromNormalSprite:back1 selectedSprite:nil target:self selector:@selector(backToMain:)];
		CCMenuItemLabel * download = [CCMenuItemLabel itemWithLabel:[CCLabelBMFont labelWithString:@"DOWNLOAD" fntFile:@"zerofourbee-32.fnt"] target:self selector:@selector(goToDownload)];
		CCMenuItemLabel * upload = [CCMenuItemLabel itemWithLabel:[CCLabelBMFont labelWithString:@"UPLOAD" fntFile:@"zerofourbee-32.fnt"] target:self selector:@selector(goToUpload)];
				
		share.position = ccp(65, 275);
		[self addChild:share];
		
		CCMenu * menu = [CCMenu menuWithItems:download, upload, back,nil];
		[menu alignItemsHorizontallyWithPadding:20];
		menu.position = ccp(480/2,320/2);
		back.scale = .5;
		back.position = ccp(185,-120);
		[self addChild:menu];
		
		
	}
	return self;
}

- (void) goToDownload {
	[[CCDirector sharedDirector] replaceScene:[CCTransitionMoveInR transitionWithDuration:0.5f scene:[ShareDownloadScene scene]]];
}

- (void) goToUpload {
	[[CCDirector sharedDirector] replaceScene:[CCTransitionMoveInR transitionWithDuration:0.5f scene:[ShareUploadScene scene]]];

}

-(void) backToMain:(id)sender
{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[MenuScene scene]]];
	return;
}
@end
