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

@interface EditLibraryPicker : CCLayer  {
	CCUIViewWrapper * wrapper;
	MPMediaPickerController *mediaPicker;
}

+(id) scene;
- (void) removeMediaPicker;
- (void) selectedItem: (MPMediaItemCollection *) m;


@end


@interface EditLibraryDelegate : NSObject <MPMediaPickerControllerDelegate> {
	EditLibraryPicker* pickerScene;
}

- (id) initWithPickerScene: (EditLibraryPicker*)elp ;

@end
