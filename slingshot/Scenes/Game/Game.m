//
//  MyScene.m
//  slingshot
//
//  Created by Jordi Chulia on 7/31/13.
//  Copyright (c) 2013 Jordi Chulia. All rights reserved.
//

#import "Game.h"

@implementation Game

@synthesize idleSling;
@synthesize scoreLabel;
@synthesize touchInitPos;
@synthesize touchMiddlePos;
@synthesize touchEndPos;
@synthesize touchMoved;
@synthesize contactDelegate;
@synthesize hint;
@synthesize deadline;

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
		
		contactDelegate = [[ContactDelegate alloc]initWithPhysicsWorld:self.physicsWorld andDelegator:self];
		[self.physicsWorld setContactDelegate:contactDelegate];
        
        /* Line at the bottom that means the geometric apocalypse will start */
        deadline = [[Deadline alloc] initWithFrame:self.frame];
        [self addChild:deadline];
        
        
        hint = [[SKShapeNode alloc]init];
        hint.alpha = 0.0;
        [self addChild:hint];
        
        self.backgroundColor = [SKColor blackColor];
        
		[self addScoreLabel];
		[Sling addSlingAtScene:self];
        [self setTouchMoved:false];
        
        
		
		NSTimer *triangleTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(launchTriangle) userInfo:nil repeats:YES];
		[[NSRunLoop currentRunLoop] addTimer:triangleTimer forMode:NSDefaultRunLoopMode];
		
    }
    return self;
}

#pragma mark add initial elements

-(void) addScoreLabel {
	scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
	scoreLabel.text = @"Hello, Score!";
	scoreLabel.fontSize = 12;
	scoreLabel.position = CGPointMake(CGRectGetMinX(self.frame)+50,
                                      CGRectGetMaxY(self.frame)-30);
	
	[self addChild:scoreLabel];
}

-(void) addDummyAtX: (CGFloat)X atY:(CGFloat)Y{
	Triangle *tri = [[Triangle alloc] init];
	tri.position = CGPointMake(X, Y);
	
	[self addChild:tri];
    
}

-(void) addSlingAtPosition:(CGPoint)pos {
    idleSling = [[Sling alloc] init];
	idleSling.position = pos;
	[self addChild:idleSling];
}


# pragma mark object launchers

-(void) launchTriangle {
	Triangle *tri = [[Triangle alloc]init];
	[self launchObject:tri];
}

-(void) launchObject: (SKShapeNode *)object {
	CGFloat Ypos = CGRectGetMaxY(self.frame);
	CGFloat Xpos = ( rand() % (int)(CGRectGetMaxX(self.frame)-(Xmargin*2)) ) + Xmargin;
	
    [object.physicsBody setVelocity:CGVectorMake(0, -((rand()%varSpeed)+minSpeed))];
	
	object.position = CGPointMake(Xpos, Ypos);
	[self addChild:object];
}

#pragma mark touch detection

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    [[Sling getIdlesling] touchesBegan:touches withEvent:event];
    /*
    for (UITouch *touch in touches) {
        touchInitPos = [touch locationInNode:self];
        NSLog(@"init touch x=%f y=%f", self.touchInitPos.x, self.touchInitPos.y);
    }*/
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [[Sling getIdlesling] touchesMoved:touches withEvent:event];
	/*[self setTouchMoved:true];
    for (UITouch *touch in touches){
        touchMiddlePos = [touch locationInNode:self];
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path,
                          nil,
                          slingshotPosition.x + (slingshotWidth/2),
                          slingshotPosition.y + (slingshotHeight/2));
        
        // Shooting as if were dragging the ball
        if(touchInitPos.y - touchMiddlePos.y < 0) {
            CGPathAddLineToPoint(path,
                                 nil,
                                 (slingshotPosition.x + 10*(touchMiddlePos.x-touchInitPos.x)),
                                 (slingshotPosition.y + 10*(touchMiddlePos.y-touchInitPos.y)));
        }
        // Shooting as a slingshot
        else {
            CGPathAddLineToPoint(path,
                                 nil,
                                 (slingshotPosition.x + 10*(touchInitPos.x-touchMiddlePos.x)),
                                 (slingshotPosition.y + 10*(touchInitPos.y-touchMiddlePos.y)));
        }
        
        hint.path = path;
        hint.alpha = hintAlpha;
    }*/
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [[Sling getIdlesling] touchesEnded:touches withEvent:event];
	/*for (UITouch *touch in touches) {
        touchEndPos = [touch locationInNode:self];
        NSLog(@"end touch x=%f y=%f", self.touchEndPos.x, self.touchEndPos.y);
    }
	if ([self touchMoved]) {
		NSLog(@"Moved!");
		[self shotSling];
	}
	[self setTouchMoved:false];
    hint.alpha = 0.0;*/
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
