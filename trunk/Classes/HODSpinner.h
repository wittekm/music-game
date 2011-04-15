//
//  HODSpinner.h
//  musicGame
//
//  Created by Max Kolasinski on 4/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HitObjectDisplay.h.mm"


@interface HODSpinner : HitObjectDisplay {
	CCSprite * spinner;
	CCSprite * ring;
}

@property (retain) CCSprite * spinner;
@property (retain) CCSprite * ring;
@end
