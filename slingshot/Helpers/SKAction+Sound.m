//
//  SKAction+Sound.m
//  slingshot
//
//  Created by Pau Sastre Miguel on 15/09/13.
//  Copyright (c) 2013 Pau Sastre Miguel. All rights reserved.
//

#import "SKAction+Sound.h"


@implementation SKAction (SKAction_Sound)

+ (SKAction *)playSoundFileNamedCheckingMusicEnable:(NSString *)soundFile waitForCompletion:(BOOL)wait{
    
    if (![ViewController getSingleton].musicEnable) {
        return nil;
    }

    return [SKAction playSoundFileNamed:soundFile waitForCompletion:wait];
    
}


@end
