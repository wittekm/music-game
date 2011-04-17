//
//  SongSelectScreen.h
//  musicGame
//
//  Created by Max Kolasinski on 4/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCUIViewWrapper.h"
#import "SqlHandler.h"
#import "MenuScene.h"


@interface ShareDownloadScene : CCLayerColor {
	UITableView * table;
	CCUIViewWrapper * wrapper;
	SqlRow* toDownload;
}

+(id) scene;

@property (retain) SqlRow* toDownload;

@end


@interface ShareController : UITableViewController {
	ShareDownloadScene * parent;
	NSMutableArray * rows;
}
- (id) initWithParent:(ShareDownloadScene *)parent_;
@end