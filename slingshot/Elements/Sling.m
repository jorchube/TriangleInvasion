//
//  Slingshot.m
//  slingshot
//
//  Created by Jordi Chulia on 8/1/13.
//  Copyright (c) 2013 Jordi Chulia. All rights reserved.
//

#import "Sling.h"
#import "Game.h"

@interface Sling(){
@private
    CGPoint touchInitPos;
    CGPoint touchMiddlePos;
    CGPoint touchEndPos;
    Boolean touchMoved;
    CGPoint slingshotPosition;
    Game *game;
}
@end

@implementation Sling

@synthesize powerup;

static Sling *idleSling;
static SKShapeNode *hint;



-(id) initWithFrame: (CGRect) frame{
	self = [super init];
	if (self)
	{
        /* Where new slings born */
		slingshotPosition = CGPointMake(CGRectGetMidX(frame)-slingshotHeight/2,
                                        CGRectGetMinY(frame)+slingshotYFromBottom);
        
		self.strokeColor = [SKColor whiteColor];
		self.fillColor = [SKColor whiteColor];
		[self setPowerup:pow_none];
		
		self.path = CGPathCreateWithEllipseInRect(CGRectMake(0.0,
                                                             0.0,
                                                             slingshotHeight,
                                                             slingshotWidth),
                                                  nil);
        
		SKPhysicsBody *pb = [SKPhysicsBody bodyWithCircleOfRadius:slingshotHeight/2];
		
		[pb setCategoryBitMask:cat_notCollide];
		[pb setCollisionBitMask:cat_notCollide];
		[pb setMass:slingshotMass];
		[pb setFriction:0.0];
		[pb setLinearDamping:0.0];
		[pb setAffectedByGravity:NO];
		[pb setUsesPreciseCollisionDetection:YES];
		
		[self setPhysicsBody:pb];
        self.position = slingshotPosition;
	}
	return self;
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // Called when a touch begins
    
    for (UITouch *touch in touches) {
        touchInitPos = [touch locationInNode:self.scene];
        NSLog(@"init touch x=%f y=%f", touchInitPos.x, touchInitPos.y);
    }
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	touchMoved = true;
    for (UITouch *touch in touches){
        touchMiddlePos = [touch locationInNode:self.scene];
        
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
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	for (UITouch *touch in touches) {
        touchEndPos = [touch locationInNode:self.scene];
        NSLog(@"end touch x=%f y=%f", touchEndPos.x, touchEndPos.y);
    }
	if (touchMoved) {
		NSLog(@"Moved!");
		[self shotSling];
	}
	touchMoved = false;
    hint.alpha = 0.0;
}

#pragma mark shot

-(void) shotSling {
	
    Sling *sling = idleSling;
    
	[sling.physicsBody setContactTestBitMask:cat_sling | cat_simpleObject];
	[sling.physicsBody setDynamic:YES];
	[sling.physicsBody setCategoryBitMask:cat_sling];
	[sling.physicsBody setCollisionBitMask:cat_sling | cat_simpleObject];
    
    // Shooting as if were dragging the ball
    if(touchInitPos.y - touchEndPos.y < 0) {
        [sling.physicsBody applyImpulse:CGVectorMake((touchEndPos.x-touchInitPos.x)*slingshotForceMult,
                                                     (touchEndPos.y-touchInitPos.y)*slingshotForceMult)];
    }
    // Shooting as a slingshot
    else {
        [sling.physicsBody applyImpulse:CGVectorMake((touchInitPos.x-touchEndPos.x)*slingshotForceMult,
                                                     (touchInitPos.y-touchEndPos.y)*slingshotForceMult)];
    }
    
    
    [sling runAction:[SKAction waitForDuration:slingLifespan]
          completion: ^{
              [sling runAction:[SKAction fadeOutWithDuration:slingFadingTime]];
              [sling runAction:[SKAction waitForDuration:slingFadingTime]
                    completion:^{
                        [sling runAction:[SKAction removeFromParent]];
                    }];
          }];
    
    [Sling addSlingAtScene: self.scene];
    [(Game*)self.parent updateScore:score_slingIsShot];
}

+(void) addSlingAtScene:(SKScene *)scene {
    idleSling = [[Sling alloc] initWithFrame: scene.frame];
    [scene addChild:idleSling];
    
    
    if (!hint) {
        hint = [[SKShapeNode alloc]init];
        hint.alpha = 0.0;
        [scene addChild:hint];
    }else if(hint.scene != scene){
        [hint removeFromParent];
        [scene addChild:hint];
    }
    
}

+(Sling*) getIdlesling {
    return idleSling;
}

@end
