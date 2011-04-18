//
//  SongSelectScreen.mm
//  musicGame
//
//  Created by Max Kolasinski on 4/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShareUploadScene.h"
#import "CCUIViewWrapper.h"
#import "ShareScene.h"
#import "BeatnikAlert.h"


@implementation ShareUploadScene
@synthesize currentBeatmap;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

+(id) scene;
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	ShareUploadScene *layer = [ShareUploadScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
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
	
	ShareUploadSceneController * controller = [[ShareUploadSceneController alloc] initWithParent:self];
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
		
		
		CCLabelBMFont * selectasong = [CCLabelBMFont labelWithString:@"UPLOAD A SONG!" fntFile:@"zerofourbee-32.fnt"];
		selectasong.position = ccp(480/2,280);
		selectasong.color = (ccColor3B){0,0,0};
		CCSprite * start1 = [CCSprite spriteWithFile:@"startmenu.png"];
		CCSprite * start2 = [CCSprite spriteWithFile:@"startmenu.png"];
		CCSprite * back1 = [CCSprite spriteWithFile:@"back.png"];
		CCSprite * upload = [CCSprite spriteWithFile:@"upload.png"];
		//play.scale = .5;
		CCMenuItemSprite * back = [CCMenuItemSprite itemFromNormalSprite:back1 selectedSprite:nil target:self selector:@selector(backToMain:)];
		//CCMenuItemLabel * download= [CCMenuItemLabel itemWithLabel:[CCLabelBMFont labelWithString:@"UPLOAD" fntFile:@"zerofourbee-32.fnt"] target:self selector:@selector(upload)];
		CCMenuItemSprite * menuupload = [CCMenuItemSprite itemFromNormalSprite:upload selectedSprite:nil target:self selector:@selector(upload)];
		//play.position = ccp(65, 275);
		[self addChild:selectasong];
		CCMenu * menu = [CCMenu menuWithItems:menuupload,back,nil];
		menu.position = ccp(480/2,320/2);
		menuupload.position = ccp(160,0);
		menuupload.scale = .4;
		back.scale = .5;
		back.position = ccp(185,-120);
		[self addChild:menu];
		
		[self addUIViewItem];
		wrapper.visible = false;
		
		id makeVisible = [CCCallBlock actionWithBlock:^{
			wrapper.visible = true;
		}];
		
		[self runAction:[CCSequence actions: [CCDelayTime actionWithDuration:.5], makeVisible, nil ]];
		
	}
	return self;
	
}

-(void)upload {
	
	NSString * urlString = [NSString stringWithFormat:@"http://services.jnadeau.com/beatnik/beatnik-upload.php?artist=%@&title=%@&beatmap=%@", 
						[currentBeatmap artist], [currentBeatmap title], [currentBeatmap beatmap]];
	
	NSLog(urlString);

	
	NSURL * url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
	NSURLRequest *request = [NSURLRequest requestWithURL:url];
	NSError *error;
	NSURLResponse *response;
	NSData * result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
	 
	
	NSString *content = [[NSString alloc]  initWithBytes:[result bytes]
												  length:[result length] encoding: NSUTF8StringEncoding];
	NSLog(@"RESULT IS: %@", content);
	
	//NSString* content = [NSString stringWithFormat:@"1"];
	
	//if([content isEqualToString:[NSString stringWithFormat:@"1"]]) {
		BeatnikAlert * alert = [[BeatnikAlert alloc] initWithParent:self text:@"UPLOADED!"];
		alert.message.scaleX *= .9;
		alert.message.scaleY *= 1.5;
		alert.message.position.y -= 10;
	//}
}

-(void) menuCallbackStart: (id) sender
{
	[self removeChild:wrapper cleanup: true];
}
-(void) backToMain:(id)sender
{
	[self removeChild:wrapper cleanup: true];	
	[[CCDirector sharedDirector] replaceScene:[CCTransitionMoveInR transitionWithDuration:0.5f scene:[ShareScene scene]]];
}

@end






@implementation ShareUploadSceneController
@synthesize handler;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	handler = [[SqlHandler alloc] init];
	SqlRow * row = [[handler beatmaps] objectAtIndex:indexPath.row];
	//currentBeatmap = [row beatmap];
	NSLog(@"SETTING BEATMAP TO %@", [row beatmap]);
	
	
	parent.currentBeatmap = [[SqlRow alloc] init];
	parent.currentBeatmap.beatmap = row.beatmap;
	parent.currentBeatmap.title = row.title;
	parent.currentBeatmap.artist = row.artist;
	
	//parent.currentBeatmap = row;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	// If row is deleted, remove it from the list.
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		// delete your data item here
		// Animate the deletion from the table.
		[[handler beatmaps] removeObjectAtIndex:[indexPath row]];
		[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
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
	
	cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@",[row artist],[row title]];
	
	return cell;
}
- (id) initWithParent:(ShareUploadScene*)parent_ {
	if( (self = [super init]) ) {
		parent = parent_;
		//handler = [parent songList];
		handler = [[[SqlHandler alloc] init] retain];
	}
	return self;
}
@end	
