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


@interface SongSelectScreen : CCLayer {
	SqlHandler * songList;
	UITableView * table;
	CCUIViewWrapper * wrapper;
	SqlHandler * handler;
	Beatmap * currentBeatmap;
}

+(id) sceneWithSongList: (SqlHandler*)songList;

@property (retain) SqlHandler * songList;
@property Beatmap * currentBeatmap;
@end

@interface SongSelectViewController : UITableViewController {
	SongSelectScreen * parent;
}
- (id) initWithParent:(SongSelectScreen *)parent_;
@end