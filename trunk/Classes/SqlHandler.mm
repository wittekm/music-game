//
//  SqlHandler.m
//  musicGame
//
//  Created by Max Wittek on 3/31/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SqlHandler.h"

static sqlite3_stmt *sql_handler_init_stmt=nil;

@implementation SqlRow
@synthesize primaryKey, artist, title, beatmap;

- (id)initWithPrimaryKey:(NSInteger)pk database:(sqlite3 *)db {
	if ( (self = [super init]) ) {
		primaryKey = pk;
		database = db;
		
		if(sql_handler_init_stmt == nil) {
			const char *sql = "SELECT artist, title, beatmap FROM beatmaps WHERE pk=?";
			if(sqlite3_prepare_v2(database, sql, -1, &sql_handler_init_stmt, NULL) != SQLITE_OK) {
				NSLog(@"now u fucked up");
			}
		}
		
		sqlite3_bind_int(sql_handler_init_stmt, 1, primaryKey);
		
		int result = sqlite3_step(sql_handler_init_stmt);
		if(result == SQLITE_ROW) {
			artist = [NSString stringWithUTF8String:(char*) sqlite3_column_text(sql_handler_init_stmt, 0)];
			title = [NSString stringWithUTF8String:(char*) sqlite3_column_text(sql_handler_init_stmt, 1)];
			beatmap = [NSString stringWithUTF8String:(char*) sqlite3_column_text(sql_handler_init_stmt, 2)];
			NSLog(@"YES I GOT ALL OF THEM FOR FUCKS SAKE %@ %@", artist, title);
			//NSLog(@"%@ |||| %@ |||| %@", artist, title, beatmap);
		} else {
			NSLog(@"NOTHING. NADA.");
			artist = @"Nothing. Nada.";
		}
		
		sqlite3_reset(sql_handler_init_stmt);
		
	}
	return self;
}

- (Beatmap* ) getBeatmap {
	return new Beatmap(beatmap);
}

- (NSComparisonResult)compare:(id)otherObject {
	NSComparisonResult artistCompare = [ [artist lowercaseString] compare: [[(SqlRow*)otherObject artist] lowercaseString] ];
	if(!artistCompare) {
		return [ [title lowercaseString] compare: [[(SqlRow*)otherObject title] lowercaseString] ];
	} else {
		return artistCompare;
	}
}

@end


@implementation SqlHandler
@synthesize beatmaps;

- (id) init {
	
	
	if( (self = [super init]) ) {
		[self createEditableCopy];
		
		NSMutableArray * beatmapArray = [[NSMutableArray alloc] init];
		self.beatmaps = beatmapArray;
		[beatmapArray release];
		
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
		NSString *documentsDirectory = [paths objectAtIndex:0]; 
		NSString *path = [documentsDirectory stringByAppendingPathComponent:@"musicgame.sqlite"];
		
		/*
		 NSString *path = [[[NSBundle mainBundle] resourcePath] 
		 stringByAppendingPathComponent:@"musicgame.sqlite"];
		 */
		if(sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
			const char *sql = "SELECT pk FROM beatmaps";
			sqlite3_stmt *statement;
			
			if(sqlite3_prepare_v2(database, sql, -1, &statement, NULL) == SQLITE_OK) {
				while(sqlite3_step(statement) == SQLITE_ROW) {
					int primaryKey = sqlite3_column_int(statement, 0);
					SqlRow * row = [[SqlRow alloc] initWithPrimaryKey:primaryKey database:database];
					[beatmaps addObject:row];
					[row release];
				}
			}
			sqlite3_finalize(statement);
		} else {
			sqlite3_close(database);
			NSAssert1(0, @"Failed to open db w message %s", sqlite3_errmsg(database));
		}
		
		[beatmaps sortUsingSelector:@selector(compare:)];
	}
	return self;
}


- (BOOL) insertNewBeatmap: (NSString*)beatmapStr artist: (NSString*)artist title: (NSString*)title{
	/*
	 NSString *path = [[[NSBundle mainBundle] resourcePath] 
	 stringByAppendingPathComponent:@"musicgame.sqlite"];
	 */
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0]; 
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"musicgame.sqlite"];
	
	
	if(sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
		NSString * sqlNS = [NSString stringWithFormat:@"INSERT INTO beatmaps (artist, title, beatmap) VALUES (\"%@\", \"%@\", \"%@\")", artist, title, beatmapStr];
		const char * sql = [sqlNS UTF8String];
		//"SELECT pk FROM beatmaps";
		
		sqlite3_stmt *statement;
		
		if(sqlite3_prepare_v2(database, sql, -1, &statement, NULL) != SQLITE_OK) {
			NSLog(@"didn't prepare for some reason, wtf");
			NSAssert1(0, @"Failed to open db w message %s", sqlite3_errmsg(database));
		}
		
		int success = sqlite3_step(statement);
		sqlite3_reset(statement);
		
		if(success != SQLITE_ERROR) {
			sqlite3_finalize(statement);
			NSLog(@"returning 1 %d", success);
			return 1;
		}
		else {
			NSLog(@"returning 0");
			return 0;
		}
		
	} else {
		sqlite3_close(database);
		NSLog(@"failed to open db or some shit???");
		NSAssert1(0, @"Failed to open db w message %s", sqlite3_errmsg(database));
	}
	
	return 0;
}


- (void)deleteSongWithArtist: (NSString*)artist title: (NSString*)title
{ 
	/*
	 NSString *path = [[[NSBundle mainBundle] resourcePath] 
	 stringByAppendingPathComponent:@"musicgame.sqlite"];
	 */
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
	NSString *documentsDirectory = [paths objectAtIndex:0]; 
	NSString *path = [documentsDirectory stringByAppendingPathComponent:@"musicgame.sqlite"];
	
	
	if(sqlite3_open([path UTF8String], &database) == SQLITE_OK) {
		
		NSString * sqlNS = [NSString stringWithFormat:@"delete from beatmaps where (title = \"%@\" AND artist = \"%@\")", title, artist];
		const char * sql = [sqlNS UTF8String];
		//"SELECT pk FROM beatmaps";
		
		sqlite3_stmt *statement;
		
		if(sqlite3_prepare_v2(database, sql, -1, &statement, NULL) != SQLITE_OK) {
			NSLog(@"didn't prepare for some reason, wtf");
			NSAssert1(0, @"Failed to open db w message %s", sqlite3_errmsg(database));
		}
		
		int success = sqlite3_step(statement);
		sqlite3_reset(statement);
		
		if(success != SQLITE_ERROR) {
			sqlite3_finalize(statement);
			NSLog(@"returning 1 %d", success);
		}
		else {
			NSLog(@"returning 0");
		}
		
	} else {
		sqlite3_close(database);
		NSLog(@"failed to open db or some shit???");
		NSAssert1(0, @"Failed to open db w message %s", sqlite3_errmsg(database));
	}
}


- (void)createEditableCopy 
{ 
    // First, test for existence. 
    BOOL success; 
    NSFileManager *fileManager = [NSFileManager defaultManager]; 
    NSError *error; 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
    NSString *documentsDirectory = [paths objectAtIndex:0]; 
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"musicgame.sqlite"]; 
    success = [fileManager fileExistsAtPath:writableDBPath]; 
    // NSLog(@"path : %@", writableDBPath); 
    if (success) return; 
    // The writable database does not exist, so copy the default to the appropriate location. 
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"musicgame.sqlite"]; 
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error]; 
    if (!success)  
    { 
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]); 
    } 
}

@end