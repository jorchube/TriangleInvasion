//
//  SKAction+Sound.h
//  slingshot
//
//  Created by Pau Sastre Miguel on 15/09/13.
//  Copyright (c) 2013 Pau Sastre Miguel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface SKAction (SKAction_Sound)

+ (SKAction *)playSoundFileNamedCheckingMusicEnable:(NSString *)soundFile waitForCompletion:(BOOL)wait;

@end
