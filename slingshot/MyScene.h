//
//  MyScene.h
//  slingshot
//

//  Copyright (c) 2013 Jordi Chulia. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Slingshot.h"
#import "Constants.h"

@interface MyScene : SKScene

@property Slingshot *slingshot;
@property SKLabelNode *scoreLabel;
@property CGPoint touchInitPos;
@property CGPoint touchEndPos;
@property Boolean touchMoved;

@end
