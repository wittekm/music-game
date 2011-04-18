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
	CGRect cgRct = CGRectMake(15, 85, 300, 200);
	CCSprite * blackbox = [CCSprite spriteWithFile:@"wehavetogoblack.png"];
	blackbox.position = ccp(155,145);
	[self addChild:blackbox];
	table = [[UITableView alloc] initWithFrame:cgRct style:UITableViewStylePlain];
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
	wrapper.visible = false;
	[self addChild:wrapper];
	//[wrapper setOpacity:0];
	//[wrapper runAction:[CCFadeIn actionWithDuration:1]];
}

-(id) init {
	if( (self=[super initWithColor:ccc4(238,232,170,255)])){
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
		//CCSprite * play = [CCSprite spriteWithFile:@"playmenu.png"];
		CCLabelBMFont * selectasong = [CCLabelBMFont labelWithString:@"SELECT A SONG!" fntFile:@"zerofourbee-32.fnt"];
		selectasong.position = ccp(480/2,280);
		selectasong.color = (ccColor3B){0,0,0};
		CCSprite * start1 = [CCSprite spriteWithFile:@"startmenu.png"];
		CCSprite * start2 = [CCSprite spriteWithFile:@"startmenu.png"];
		CCSprite * back1 = [CCSprite spriteWithFile:@"back.png"];
		CCSprite * back2 = [CCSprite spriteWithFile:@"back.png"];
		//play.scale = .5;
		CCMenuItemSprite * back = [CCMenuItemSprite itemFromNormalSprite:back1 selectedSprite:back2 target:self selector:@selector(backToMain:)];
		CCMenuItemSprite * start= [CCMenuItemSprite itemFromNormalSprite:start1 selectedSprite:start2 target:self selector:@selector(menuCallbackStart:)];
		//play.position = ccp(65, 275);
		[self addChild:selectasong];
		CCMenu * menu = [CCMenu menuWithItems:start,back,nil];
		menu.position = ccp(480/2,320/2);
		start.position = ccp(160,0);
		start.scale = .65;
		back.scale = .5;
		back.position = ccp(185,-120);
		[self addChild:menu];
		//wrapper.position = ccp(480/2,320/2);
		//CCMenuItemSprite * gobutton = [CCMenuItemSprite itemFromNormalSprite:go1 selectedSprite:go2 target: self selector:@selector(menuCallbackStart:)];
		//CCMenu *menu = [CCMenu menuWithItems:
		//				gobutton, nil];
		//menu.position = ccp(420,60);
		//[self addChild:menu];
		[self addUIViewItem];
		wrapper.visible = false;
		
		id makeVisible = [CCCallBlock actionWithBlock:^{
			wrapper.visible = true;
		}];
		
		[self runAction:[CCSequence actions: [CCDelayTime actionWithDuration:.4], makeVisible, nil ]];
		
	}
	return self;

}


-(void) menuCallbackStart: (id) sender
{
	[self removeChild:wrapper cleanup: true];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[GameScene sceneWithBeatmap: currentBeatmap ]]];
}
-(void) backToMain:(id)sender
{
	[self removeChild:wrapper cleanup: true];
	
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[MenuScene scene]]];
}

@end






@implementation SongSelectViewController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	SqlHandler * handler = [[SqlHandler alloc] init];
	SqlRow * row = [[handler beatmaps] objectAtIndex:indexPath.row];
	//currentBeatmap = [row beatmap];
	NSLog([row beatmap]);
	parent.currentBeatmap = [row getBeatmap];
	
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	// If row is deleted, remove it from the list.
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		SqlHandler * handler = [[SqlHandler alloc] init];
		// delete your data item here
		// Animate the deletion from the table.
		SqlRow * row = [[handler beatmaps] objectAtIndex:[indexPath row]];
		[handler deleteSongWithArtist:[row artist] title:[row title]];
		
		[[handler beatmaps] removeObjectAtIndex:[indexPath row]];
		[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
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
	
	
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	}
	

	//GasData * data = [[Globals sharedInstance].purchases objectAtIndex:indexPath.row];
	//NSLog(@"%@", date); 
	SqlRow * row = [[handler beatmaps] objectAtIndex:indexPath.row];
	NSLog(@"%d", [[handler beatmaps] count]);
	
	NSLog(@"now u see me");
	if([row title]) {
		NSLog(@"title");
		NSLog(@"um %@",[row title]);
	}
	if([row artist])
		NSLog(@"artist");
	cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@",[row title],[row artist]];
	//[NSString stringWithFormat:@"%@", [row artist]];
	
	NSLog(@"now u dont.");
	
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
		//handler = [parent songList];
		handler = [[[SqlHandler alloc] init] retain];
	}
	return self;
}
@end	
