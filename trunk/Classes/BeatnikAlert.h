//
//  BeatnikAlert.h
//  musicGame
//
//  Created by Max Wittek on 4/17/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface BeatnikAlert : CCLayer {
	CCNode* parent;
	CCLabelBMFont * message;
}
- (id) initWithParent: (CCNode*)parent_ text: (NSString*)text;

@property (retain) 	CCLabelBMFont * message;

@end
