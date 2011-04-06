//
//  CCSequenceHelper.m
//  Created by Jose Antonio Andújar Clavell on 09/02/11.
//  Alias "jandujar"
//
//  More snippets on http://www.jandujar.com
//
//  License http://creativecommons.org/licenses/by/3.0/
//
//  Based upon code by daemonk
//  http://www.cocos2d-iphone.org/forum/topic/2547
//

#import "CCSequenceHelper.h"

@implementation CCSequenceHelper

+(id) actionMutableArray: (NSMutableArray*) _actionList {
	CCFiniteTimeAction *now;
	CCFiniteTimeAction *prev = [_actionList objectAtIndex:0];
	
	for (int i = 1 ; i < [_actionList count] ; i++) {
		now = [_actionList objectAtIndex:i];
		prev = [CCSequence actionOne: prev two: now];
	}
	
	return prev;
}

@end