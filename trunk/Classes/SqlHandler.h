//
//  SqlHandler.h
//  musicGame
//
//  Created by Max Wittek on 3/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "osu-import.h.mm"

@interface SqlRow : NSObject {
	sqlite3 *database;
	NSInteger primaryKey;
	NSString *artist;
	NSString *title;
	NSString *beatmap;
}

@property (assign, nonatomic, readonly) NSInteger primaryKey;
@property (nonatomic, retain) NSString *artist;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *beatmap;

-(id)initWithPrimaryKey: (NSInteger)pk database: (sqlite3 *)db;

-(Beatmap*) getBeatmap;

@end




@interface SqlHandler : NSObject {
	sqlite3 * database;
	NSMutableArray * beatmaps;
}

- (id) initDatabase;
- (BOOL) insertNewBeatmap: (NSString*)beatmapStr artist:(NSString*)artist title:(NSString*)title;

@property (nonatomic, retain) NSMutableArray * beatmaps;

@end
