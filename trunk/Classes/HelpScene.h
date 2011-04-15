//
//  HelpScene.h
//  musicGame
//
//  Created by Max Kolasinski on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "OptionsScene.h"


@interface HelpScene : CCLayerColor {

}
+(id) scene;
-(void) backToOptions:(id)sender;
@end
