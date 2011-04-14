//
//  OptionsScene.h
//  musicGame
//
//  Created by Max Kolasinski on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"



@interface OptionsScene : CCLayerColor {

}
+(id) scene;
-(void) viewHelp: (id) sender;
-(void) toggleFailure: (id) sender;
-(void) backToMain: (id) sender;

@end
