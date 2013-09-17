//
//  Story.h
//  slingshot
//
//  Created by Pau Sastre Miguel on 10/09/13.
//  Copyright (c) 2013 Pau Sastre Miguel. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SceneImplementation.h"

@interface Story : SceneImplementation

-(id)initWithSize:(CGSize)size nextScene:(int) nextScene;

@end
