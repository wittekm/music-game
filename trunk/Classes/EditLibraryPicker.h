//
//  EditLibraryPicker.h
//  musicGame
//
//  Created by Max Wittek on 4/13/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "CCUIViewWrapper.h"
#import <MediaPlayer/MediaPlayer.h>

@interface EditLibraryPicker : CCLayerColor  {
	CCUIViewWrapper * wrapper;
	MPMediaPickerController *mediaPicker;
	CCMenu *menu;
}

+(id) scene;
- (void) removeMediaPicker;
- (void) selectedItem: (MPMediaItemCollection *) m;

- (void) chooseCreate;
- (void) chooseEdit;
-(void) backToMain;

@end


@interface EditLibraryDelegate : NSObject <MPMediaPickerControllerDelegate> {
	EditLibraryPicker* pickerScene;
}

- (id) initWithPickerScene: (EditLibraryPicker*)elp ;

@end
