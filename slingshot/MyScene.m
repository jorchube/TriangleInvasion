//
//  MyScene.m
//  slingshot
//
//  Created by Jordi Chulia on 7/31/13.
//  Copyright (c) 2013 Jordi Chulia. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene

@synthesize idleSling;
@synthesize scoreLabel;
@synthesize touchInitPos;
@synthesize touchEndPos;
@synthesize touchMoved;
@synthesize contactDelegate;

#define slingshotPosition CGPointMake(CGRectGetMidX(self.frame)-slingshotHeight/2,		\
									  CGRectGetMinY(self.frame)+slingshotYFromBottom);

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
		
		contactDelegate = [[ContactDelegate alloc]initWithPhysicsWorld:self.physicsWorld];
		[self.physicsWorld setContactDelegate:contactDelegate];

		
        self.backgroundColor = [SKColor blackColor];
        
		[self addScoreLabel];
		[self addSling];
        [self setTouchMoved:false];
		
		NSTimer *triangleTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(launchTriangle) userInfo:nil repeats:YES];
		[[NSRunLoop currentRunLoop] addTimer:triangleTimer forMode:NSDefaultRunLoopMode];
		
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

-(void) addDummyAtX: (CGFloat)X atY:(CGFloat)Y{
	Triangle *tri = [[Triangle alloc] init];
	tri.position = CGPointMake(X, Y);
	
	[self addChild:tri];

}

-(void) addSling {
	idleSling = [[Sling alloc] init];
	idleSling.position = slingshotPosition;
	[self addChild:idleSling];
}

# pragma mark object launchers

-(void) launchTriangle {
	Triangle *tri = [[Triangle alloc]init];
	[self launchObject:tri];
}

-(void) launchObject: (SKShapeNode *)object {
	CGFloat Ypos = CGRectGetMaxY(self.frame);
	/* this -100 +50 stuff is to have a 50 units margin in each side. */
	CGFloat Xpos = ( rand() % (int)(CGRectGetMaxX(self.frame)-100) ) + 50;
	
	[object.physicsBody setVelocity:CGVectorMake(0, -100)];
	
	object.position = CGPointMake(Xpos, Ypos);
	[self addChild:object];
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
	
    Sling *sling = idleSling;
    
	[sling.physicsBody setContactTestBitMask:cat_sling | cat_simpleObject];
	[sling.physicsBody setDynamic:YES];
	[sling.physicsBody setCategoryBitMask:cat_sling];
	[sling.physicsBody setCollisionBitMask:cat_sling | cat_simpleObject];
	[sling.physicsBody applyImpulse:CGVectorMake((touchInitPos.x-touchEndPos.x)*slingshotForceMult,
													(touchInitPos.y-touchEndPos.y)*slingshotForceMult)];
    
    
    [sling runAction:[SKAction waitForDuration:slingLifespan]
          completion: ^{
              [sling runAction:[SKAction fadeOutWithDuration:slingFadingTime]];
              [sling runAction:[SKAction waitForDuration:slingFadingTime]
                    completion:^{
                        [sling runAction:[SKAction removeFromParent]];
                    }];
          }];
    
    [self addSling];
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
