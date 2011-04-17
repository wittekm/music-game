//
//  SongSelectScreen.h
//  musicGame
//
//  Created by Max Kolasinski on 4/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Scoreboard.h"
#import "CCUIViewWrapper.h"
#import "SqlHandler.h"


@interface ShareUploadScene : CCLayerColor {
	UITableView * table;
	CCUIViewWrapper * wrapper;
	SqlRow * currentBeatmap;
}

+(id) scene;

@property (retain) SqlRow * currentBeatmap;
@end


@interface ShareUploadSceneController : UITableViewController {
	ShareUploadScene * parent;
	SqlHandler * handler;
}
- (id) initWithParent:(ShareUploadScene *)parent_;
@property (retain) SqlHandler * handler;
@end