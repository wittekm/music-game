//
//  SongSelectScreen.mm
//  musicGame
//
//  Created by Max Kolasinski on 4/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SongSelectScreen.h"
#import "CCUIViewWrapper.h"
#import "GameScene.h"


@implementation SongSelectScreen
@synthesize songList;
@synthesize currentBeatmap;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

+(id) sceneWithSongList:(SqlHandler*) songList_;
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	SongSelectScreen *layer = [SongSelectScreen node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	layer.songList = songList_;
	
	//[layer listSongs];
	// return the scene
	return scene;
	
}

-(void)addUIViewItem
{
	// create item programatically
	CGRect cgRct = CGRectMake(0.0, 100, 360, 320);
	
	table = [[UITableView alloc] initWithFrame:cgRct style:UITableViewStyleGrouped];
	//[button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchDown];
	//[button setTitle:@"Touch Me" forState:UIControlStateNormal];
	//table.delegate = self;
	//button.frame = CGRectMake(0.0, 0.0, 120.0, 40.0);
	
	SongSelectViewController * controller = [[SongSelectViewController alloc] initWithParent:self];
	table.delegate = controller;
	table.dataSource = controller;
	controller.title = @"Select a song!";
	// put a wrappar around it
	wrapper = [CCUIViewWrapper wrapperForUIView:table];
	[self addChild:wrapper];
}

-(id) init {
	if ( (self = [super init])){
		//handler = [[SqlHandler alloc] init];
	/*	CCSprite * bg = [CCSprite spriteWithFile:@"dan.png"];
		bg.position = ccp(480/2, 320/2);
		if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2){
			//iPhone 4
			[bg setScale:0.5];
		}
		CCSprite * select = [CCSprite spriteWithFile:@"selectasong.png"];
		select.position = ccp(480/2, 200);
		[self addChild:bg];
		[self addChild:select];
	 */
		[self addUIViewItem];
		//wrapper.position = ccp(480/2,320/2);
		CCSprite * go1 = [CCSprite spriteWithFile:@"starburst-128.png"];
		CCSprite * go2 = [CCSprite spriteWithFile:@"starburst-blue-128.png"];
		go1.position = ccp(420, 60);
		go2.position = ccp(420,60);
		//[self addChild:go];
		CCMenuItemSprite * gobutton = [CCMenuItemSprite itemFromNormalSprite:go1 selectedSprite:go2 target: self selector:@selector(menuCallbackStart:)];
		CCMenu *menu = [CCMenu menuWithItems:
						gobutton, nil];
		menu.position = ccp(420,60);
		[self addChild:menu];
	}
	return self;
}

-(void) menuCallbackStart: (id) sender
{

	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[GameScene sceneWithBeatmap: currentBeatmap ]]];
}

@end

@implementation SongSelectViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	SqlHandler * handler = [[SqlHandler alloc] init];
	SqlRow * row = [[handler beatmaps] objectAtIndex:indexPath.row];
	//currentBeatmap = [row beatmap];
	parent.currentBeatmap = [row getBeatmap];
	
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}
	- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
		NSLog(@"do i get called");
		SqlHandler * handler = [[SqlHandler alloc] init];
		return [[handler beatmaps] count];
	}
	
	- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
		SqlHandler * handler = [[SqlHandler alloc] init];
		
		NSLog(@"oh come on dude...");
		
		static NSString *CellIdentifier = @"Cell";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
		}
		
		
		//GasData * data = [[Globals sharedInstance].purchases objectAtIndex:indexPath.row];
		//NSLog(@"%@", date); 
		SqlRow * row = [[handler beatmaps] objectAtIndex:indexPath.row];
		cell.textLabel.text = [row artist]; //[NSString stringWithFormat:@"%@", [row artist]];
		/*
		 for(SqlRow * row in [handler beatmaps]) {
		 NSLog(@"%@ - %@", [row artist], [row title]);
		 cell.textLabel.text = [NSString stringWithFormat:@"%@", [row title]];
		 cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [row artist];
		 }
		 */
		return cell;
	}
- (id) initWithParent:(SongSelectScreen*)parent_ {
	if( (self = [super init]) ) {
		parent = parent_;
	}
	return self;
}
@end	
