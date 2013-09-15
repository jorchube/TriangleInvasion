//
//  SceneImplementation.h
//  slingshot
//
//  Created by Pau Sastre Miguel on 15/09/13.
//  Copyright (c) 2013 Pau Sastre Miguel. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface SceneImplementation : SKScene {
}

-(void)setMusicURL:(NSString*)url;

-(void)startMusic;
-(void)stopMusic;

@end
