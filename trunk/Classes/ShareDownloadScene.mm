//
//  SongSelectScreen.mm
//  musicGame
//
//  Created by Max Kolasinski on 4/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ShareDownloadScene.h"
#import "ShareScene.h"

#import "SMXMLDocument.h"

#import "BeatnikAlert.h"


@implementation ShareDownloadScene
@synthesize toDownload;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	ShareDownloadScene *layer = [ShareDownloadScene node];
	
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
	
	ShareController * controller = [[ShareController alloc] initWithParent:self];
	table.delegate = controller;
	table.dataSource = controller;
	controller.title = @"Select a song!";
	// put a wrappar around it
	wrapper = [CCUIViewWrapper wrapperForUIView:table];
	wrapper.visible = false;
	[self addChild:wrapper];
	
}

-(id) init {
	if( (self=[super initWithColor:ccc4(238,232,170,255)])){
		//CCSprite * play = [CCSprite spriteWithFile:@"playmenu.png"];
		CCLabelBMFont * selectasong = [CCLabelBMFont labelWithString:@"DOWNLOAD A SONG!" fntFile:@"zerofourbee-32.fnt"];
		selectasong.position = ccp(480/2,280);
		selectasong.color = (ccColor3B){0,0,0};
		CCSprite * back1 = [CCSprite spriteWithFile:@"back.png"];
		//play.scale = .5;
		CCMenuItemSprite * back = [CCMenuItemSprite itemFromNormalSprite:back1 selectedSprite:nil target:self selector:@selector(backToMain:)];
		CCMenuItemLabel * download= [CCMenuItemLabel itemWithLabel:[CCLabelBMFont labelWithString:@"DOWNLOAD" fntFile:@"zerofourbee-32.fnt"] target:self selector:@selector(insert)];

		[self addChild:selectasong];
		CCMenu * menu = [CCMenu menuWithItems:download,back,nil];
		menu.position = ccp(480/2,320/2);
		download.position = ccp(160,0);
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
		
		[self runAction:[CCSequence actions: [CCDelayTime actionWithDuration:.5], makeVisible, nil ]];
		
	}
	return self;
	
}


-(void) insert {
	NSLog(@"inserting");
	if(toDownload) {
		SqlHandler * handler = [[SqlHandler alloc] init];
		
		for(SqlRow * row in [handler beatmaps]) {
			if([[row title] isEqualToString:[toDownload title]]) {
				BeatnikAlert * alert = [[BeatnikAlert alloc] initWithParent:self text:@"You have\n this!"];
				alert.message.scaleX = 1.6;
				//alert.message.position.y += 150;
				alert.message.position.x -= 50;
				return;
			}
		}
		
		[handler insertNewBeatmap:[toDownload beatmap] artist:[toDownload artist] title:[toDownload title]];
		BeatnikAlert * alert = [[BeatnikAlert alloc] initWithParent:self text:@"Done!"];
	}
}

-(void) backToMain:(id)sender
{
	[self removeChild:wrapper cleanup: true];
	
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:0.5f scene:[ShareScene scene]]];
}

@end






@implementation ShareController

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	SqlRow * row = [rows objectAtIndex:indexPath.row];
	//NSLog([row beatmap]);
	parent.toDownload = row;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [rows count];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	SqlHandler * handler = [[SqlHandler alloc] init];
	
	
	static NSString *CellIdentifier = @"Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
	}
	
	SqlRow * row = [rows objectAtIndex:indexPath.row];
	
	cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@",[row artist],[row title]];
	
	return cell;
}
- (id) initWithParent:(ShareScene*)parent_ {
	if( (self = [super init]) ) {
		parent = parent_;
		
		rows = [[NSMutableArray alloc] init];
		
		NSURL * xmlFile = [NSURL URLWithString:@"http://services.jnadeau.com/beatnik/beatnik-download.php"];
		NSURLRequest *request = [NSURLRequest requestWithURL:xmlFile];
		NSError *error;
		NSURLResponse *response;
		NSData * result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
		SMXMLDocument *document = [SMXMLDocument documentWithData:result error:&error];
		
		NSLog(@" children: %d",	[[document.root children] count]);
		
		SMXMLElement *songs =  document.root;
		
		
		for(SMXMLElement * song in [songs childrenNamed:@"song"]){
			NSString* artist = [song attributeNamed:@"artist"];
			NSString* title = [song attributeNamed:@"title"];
			NSString* beatmap = [song valueForKey:@"value"];
			SqlRow * row = [[SqlRow alloc] init];
			row.artist = artist;
			row.title = title;
			row.beatmap = beatmap;
			[rows addObject:row];
		}
		
	}
	return self;
}
@end	
