//
//  untitled.h
//  musicGame
//
//  Created by Max Kolasinski on 3/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface MenuScene : CCLayerColor {
	CCMenuItemSprite * play;
}
-(void) menuCallbackStart:(id) sender;
-(void) menuCreate: (id) sender;
-(void) menuShare: (id) sender;
-(void) menuOptions: (id) sender;

//- (void) colorStuff:(int)dt;

@end
