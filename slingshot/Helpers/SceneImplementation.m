//
//  GameKit.m
//  slingshot
//
//  Created by Pau Sastre Miguel on 12/09/13.
//  Copyright (c) 2013 Pau Sastre Miguel. All rights reserved.
//

#import "SceneImplementation.h"
#import <AVFoundation/AVFoundation.h>


@interface SceneImplementation() {

    NSString *musicURL;
}
@end

@implementation SceneImplementation

static AVAudioPlayer *audioPlayer;

-(void)setMusicURL:(NSString*)url {
    musicURL = url;
}

-(void)startMusic {
    
    if (![ViewController getSingleton].musicEnable || musicURL == nil) {
        return;
    }
    
    if (audioPlayer) {
        [audioPlayer stop];
    }
    
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath],musicURL]];
	
	NSError *error;
	audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	audioPlayer.numberOfLoops = -1;
	
	if (audioPlayer == nil)
		NSLog(@"%@",error);
	else
		[audioPlayer play];
}

-(void)stopMusic {
    [audioPlayer stop];
}


@end
