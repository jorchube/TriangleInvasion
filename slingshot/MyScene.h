//
//  MyScene.h
//  slingshot
//

//  Copyright (c) 2013 Jordi Chulia. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "Constants.h"
#import "Sling.h"
#import "ContactDelegate.h"
#import "Triangle.h"

@interface MyScene : SKScene <SKPhysicsContactDelegate>

@property Sling *idleSling;
@property SKLabelNode *scoreLabel;
@property CGPoint touchInitPos;
@property CGPoint touchEndPos;
@property Boolean touchMoved;
@property id<SKPhysicsContactDelegate> contactDelegate;

@end
