//
//  SKAction+Sound.m
//  slingshot
//
//  Created by Pau Sastre Miguel on 15/09/13.
//  Copyright (c) 2013 Pau Sastre Miguel. All rights reserved.
//

#import "SKAction+Sound.h"


@implementation SKAction (SKAction_Sound)

- (SKAction*)runActionChekingAudio{
    
    if (![ViewController getSingleton].musicEnable) {
        return nil;
    }

    return self;
    
}


@end
