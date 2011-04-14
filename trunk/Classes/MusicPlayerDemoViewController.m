//
//  MusicPlayerDemoViewController.m
//  MusicPlayerDemo
//
//  Written by Ole Begemann, July 2009, http://oleb.net
//  Accompanying blog post: http://oleb.net/blog/2009/07/the-music-player-framework-in-the-iphone-sdk
//
//  License: do what you want with it. You are authorized to use this code in whatever way you want.
//  No need to credit me, though I'd love a backlink if you discuss this somewhere on the web.//
//

#import "MusicPlayerDemoViewController.h"

// private interface
@interface MusicPlayerDemoViewController ()
- (void)handleNowPlayingItemChanged:(id)notification;
- (void)handlePlaybackStateChanged:(id)notification;
- (void)handleExternalVolumeChanged:(id)notification;
@end



@implementation MusicPlayerDemoViewController

@synthesize musicPlayer;
@synthesize playPauseButton;
@synthesize songLabel;
@synthesize artistLabel;
@synthesize albumLabel;
@synthesize artworkImageView;
@synthesize volumeSlider;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    
    // Initial sync of display with music player state
    [self handleNowPlayingItemChanged:nil];
    [self handlePlaybackStateChanged:nil];
    [self handleExternalVolumeChanged:nil];
    
    // Register for music player notifications
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self 
                           selector:@selector(handleNowPlayingItemChanged:)
                               name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification 
                             object:self.musicPlayer];
    [notificationCenter addObserver:self 
                           selector:@selector(handlePlaybackStateChanged:)
                               name:MPMusicPlayerControllerPlaybackStateDidChangeNotification 
                             object:self.musicPlayer];
    [notificationCenter addObserver:self 
                           selector:@selector(handleExternalVolumeChanged:)
                               name:MPMusicPlayerControllerVolumeDidChangeNotification 
                             object:self.musicPlayer];
    [self.musicPlayer beginGeneratingPlaybackNotifications];
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    // Stop music player notifications
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:MPMusicPlayerControllerNowPlayingItemDidChangeNotification 
                                                  object:self.musicPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:MPMusicPlayerControllerPlaybackStateDidChangeNotification 
                                                  object:self.musicPlayer];
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:MPMusicPlayerControllerVolumeDidChangeNotification
                                                  object:self.musicPlayer];
    [self.musicPlayer endGeneratingPlaybackNotifications];
    
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
    self.musicPlayer = nil;
    self.playPauseButton = nil;
    self.songLabel = nil;
    self.artistLabel = nil;
    self.albumLabel = nil;
    self.artworkImageView = nil;
    self.volumeSlider = nil;
}



- (void)dealloc {
    [musicPlayer release];
    [playPauseButton release];
    [songLabel release];
    [artistLabel release];
    [albumLabel release];
    [artworkImageView release];
    [volumeSlider release];
    [super dealloc];
}



#pragma mark Media player notification handlers

// When the now playing item changes, update song info labels and artwork display.
- (void)handleNowPlayingItemChanged:(id)notification {
    // Ask the music player for the current song.
    MPMediaItem *currentItem = self.musicPlayer.nowPlayingItem;
    
    // Display the artist, album, and song name for the now-playing media item.
    // These are all UILabels.
    self.songLabel.text   = [currentItem valueForProperty:MPMediaItemPropertyTitle];
    self.artistLabel.text = [currentItem valueForProperty:MPMediaItemPropertyArtist];
    self.albumLabel.text  = [currentItem valueForProperty:MPMediaItemPropertyAlbumTitle];    
    
    // Display album artwork. self.artworkImageView is a UIImageView.
    CGSize artworkImageViewSize = self.artworkImageView.bounds.size;
    MPMediaItemArtwork *artwork = [currentItem valueForProperty:MPMediaItemPropertyArtwork];
    if (artwork != nil) {
        self.artworkImageView.image = [artwork imageWithSize:artworkImageViewSize];
    } else {
        self.artworkImageView.image = nil;
    }
}

// When the playback state changes, set the play/pause button appropriately.
- (void)handlePlaybackStateChanged:(id)notification {
    MPMusicPlaybackState playbackState = self.musicPlayer.playbackState;
    if (playbackState == MPMusicPlaybackStatePaused || playbackState == MPMusicPlaybackStateStopped) {
        [self.playPauseButton setTitle:@"Play" forState:UIControlStateNormal];
    } else if (playbackState == MPMusicPlaybackStatePlaying) {
        [self.playPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
    }
}

// When the volume changes, sync the volume slider
- (void)handleExternalVolumeChanged:(id)notification {
    // self.volumeSlider is a UISlider used to display music volume.
    // self.musicPlayer.volume ranges from 0.0 to 1.0.
    [self.volumeSlider setValue:self.musicPlayer.volume animated:YES];
}



#pragma mark Button actions

- (IBAction)playOrPauseMusic:(id)sender {
	MPMusicPlaybackState playbackState = self.musicPlayer.playbackState;
	if (playbackState == MPMusicPlaybackStateStopped || playbackState == MPMusicPlaybackStatePaused) {
		[self.musicPlayer play];
	} else if (playbackState == MPMusicPlaybackStatePlaying) {
		[self.musicPlayer pause];
	}
}


- (IBAction)playNextSong:(id)sender {
    [self.musicPlayer skipToNextItem];
}


- (IBAction)playPreviousSong:(id)sender {
    static NSTimeInterval skipToBeginningOfSongIfElapsedTimeLongerThan = 3.5;

    NSTimeInterval playbackTime = self.musicPlayer.currentPlaybackTime;
    if (playbackTime <= skipToBeginningOfSongIfElapsedTimeLongerThan) {
        [self.musicPlayer skipToPreviousItem];
    } else {
        [self.musicPlayer skipToBeginning];
    }
}


- (IBAction)openMediaPicker:(id)sender {
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
    mediaPicker.delegate = self;
    mediaPicker.allowsPickingMultipleItems = YES; // this is the default   
    [self presentModalViewController:mediaPicker animated:YES];
    [mediaPicker release];
}


- (IBAction)volumeSliderChanged:(id)sender {
    self.musicPlayer.volume = self.volumeSlider.value;
}



#pragma mark MPMediaPickerController delegate methods

- (void)mediaPicker: (MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
    // We need to dismiss the picker
    [self dismissModalViewControllerAnimated:YES];
    
    // Assign the selected item(s) to the music player and start playback.
    [self.musicPlayer stop];
    [self.musicPlayer setQueueWithItemCollection:mediaItemCollection];
    [self.musicPlayer play];
}

- (void)mediaPickerDidCancel:(MPMediaPickerController *)mediaPicker {
    // User did not select anything
    // We need to dismiss the picker
    [self dismissModalViewControllerAnimated:YES];
}


@end
