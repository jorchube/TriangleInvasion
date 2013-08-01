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
@synthesize contactDelegate;

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
		
		contactDelegate = [[ContactDelegate alloc]init];
		[self.physicsWorld setContactDelegate:contactDelegate];
		
		if ([self.physicsWorld.contactDelegate respondsToSelector:@selector(didBeginContact:)]) NSLog(@"DEL");
		else NSLog(@"NODEL");
		
        self.backgroundColor = [SKColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
        
		[self addScoreLabel];
		[self addSlingshot];
        [self setTouchMoved:false];
		[self addDummy];
		
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

-(void) addDummy{
	SKShapeNode *cube = [[SKShapeNode alloc]init];
	cube.path = CGPathCreateWithRect(CGRectMake(100, 800, 500, 100), nil);
	SKPhysicsBody *pb2 = [SKPhysicsBody bodyWithPolygonFromPath:cube.path];
	
	[pb2 setAffectedByGravity:NO];
	[pb2 setCategoryBitMask:collisionMask];
	[pb2 setCollisionBitMask:collisionMask];
	[cube setPhysicsBody:pb2];
	
	[self addChild:cube];

}

-(void) addSlingshot {
	slingshot = [[Slingshot alloc] init];
	[slingshot setNode:[[SKShapeNode alloc] init] ];
	[slingshot node].path = CGPathCreateWithEllipseInRect(CGRectMake(0.0,
															  0.0,
															  slingshotHeight,
															  slingshotWidth),
												   nil);

	[slingshot node].position = CGPointMake(CGRectGetMidX(self.frame)-slingshotHeight/2,
									 CGRectGetMinY(self.frame)+slingshotYFromBottom);
	

	SKPhysicsBody *pb = [SKPhysicsBody bodyWithCircleOfRadius:slingshotHeight/2];
	
	[pb setCategoryBitMask:noCollideMask];
	[pb setCollisionBitMask:noCollideMask];
	[pb setMass:slingshotMass];
	[pb setAffectedByGravity:NO];
	[pb setUsesPreciseCollisionDetection:YES];
	
	[slingshot.node setPhysicsBody:pb];
	
	
	[self addChild:[slingshot node]];
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
	
	[[slingshot node].physicsBody setDynamic:YES];
	[[slingshot node].physicsBody setCategoryBitMask:collisionMask];
	[[slingshot node].physicsBody setCollisionBitMask:collisionMask];
	[[slingshot node].physicsBody applyImpulse:CGPointMake((touchInitPos.x-touchEndPos.x)*slingshotForceMult,
													(touchInitPos.y-touchEndPos.y)*slingshotForceMult)];
	
	
	
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
