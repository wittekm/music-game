//
//  HelloWorldLayer.h
//  Cocos2dLesson1
//
//  Created by Max Wittek on 3/4/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
@interface Layer1: CCLayer
{
}
-(void) menuCallbackStart:(id) sender;

@end


// HelloWorld Layer
@interface Layer2 : CCLayer
{
}

// returns a Scene that contains the HelloWorld as the only child
+(id) scene;

@end
