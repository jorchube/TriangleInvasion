//
//  MyScene.h
//  slingshot
//

//  Copyright (c) 2013 Jordi Chulia. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Constants.h"
#import "Slingshot.h"
#import "ContactDelegate.h"

@interface MyScene : SKScene <SKPhysicsContactDelegate>

@property Slingshot *slingshot;
@property SKLabelNode *scoreLabel;
@property CGPoint touchInitPos;
@property CGPoint touchEndPos;
@property Boolean touchMoved;
@property id<SKPhysicsContactDelegate> contactDelegate;

@end
