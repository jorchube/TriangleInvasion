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
#import "Deadline.h"

@interface Game : SKScene <SKPhysicsContactDelegate>

@property SKLabelNode *scoreLabel;

//-(void) shotSlingWithInitPos: (CGPoint) init andEndPos: (CGPoint) end;
//-(void) addSlingAtPosition: (CGPoint) pos;
-(void) updateScore: (double) scr;
-(void) increaseComboCounter;
-(int) getComboCounter;
-(void) resetComboCounter;

@end
