//
//  MyScene.m
//  slingshot
//
//  Created by Jordi Chulia on 7/31/13.
//  Copyright (c) 2013 Jordi Chulia. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene

@synthesize slingshot;
@synthesize scoreLabel;
@synthesize touchInitPos;
@synthesize touchEndPos;
@synthesize touchMoved;


-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
        
		[self addScoreLabel];
		[self addSlingshot];
        [self setTouchMoved:false];
		
    }
    return self;
}

#pragma mark add initial elements

-(void) addScoreLabel {
	scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
	scoreLabel.text = @"Hello, Score!";
	scoreLabel.fontSize = 30;
	scoreLabel.position = CGPointMake(CGRectGetMinX(self.frame)+150,
								   CGRectGetMaxY(self.frame)-60);
	
	[self addChild:scoreLabel];
}

-(void) addSlingshot {
	slingshot.node = [[SKShapeNode alloc] init];
	slingshot.node.path = CGPathCreateWithEllipseInRect(
												  CGRectMake(0.0,
															 0.0,
															 slingshotHeight,
															 slingshotWidth),
												  nil);
	slingshot.node.position = CGPointMake(CGRectGetMidX(self.frame)-slingshotHeight/2,
									 CGRectGetMinY(self.frame)+slingshotYFromBottom);
	
	SKPhysicsBody *pb = [SKPhysicsBody bodyWithPolygonFromPath:CGPathCreateWithRect(
																					CGRectMake(0.0,
																							   0.0,
																							   slingshotHeight,
																							   slingshotWidth),
																					nil)];
	[pb setCollisionBitMask:noCollideMask];
	[pb setMass:slingshotMass];
	[pb setAffectedByGravity:NO];
	
	slingshot.node.physicsBody = pb;
	
	
	[self addChild:slingshot.node];
}

#pragma mark touch detection

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    for (UITouch *touch in touches) {
        touchInitPos = [touch locationInNode:self];
        NSLog(@"init touch x=%f y=%f", self.touchInitPos.x, self.touchInitPos.y);
    }
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	[self setTouchMoved:true];
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	for (UITouch *touch in touches) {
        touchEndPos = [touch locationInNode:self];
        NSLog(@"end touch x=%f y=%f", self.touchEndPos.x, self.touchEndPos.y);
    }
	if ([self touchMoved]) {
		NSLog(@"Moved!");
		[self shotSling];
	}
	[self setTouchMoved:false];
}

#pragma mark shot

-(void) shotSling {
	
	[slingshot.node.physicsBody setDynamic:YES];
	[slingshot.node.physicsBody setCollisionBitMask:collisionMask];
	[slingshot.node.physicsBody applyImpulse:CGPointMake((touchInitPos.x-touchEndPos.x)*slingshotForceMult,
													(touchInitPos.y-touchEndPos.y)*slingshotForceMult)];
	
	
	
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
