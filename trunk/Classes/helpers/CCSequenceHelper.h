//
//  CCSequenceHelper.h
//
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

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface CCSequenceHelper : CCSequence {
	
}

+(id) actionMutableArray: (NSMutableArray*) _actionList;
@end