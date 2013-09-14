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
}
@end

@implementation Sling

@synthesize powerup;

static Sling *idleSling;
static Sling *rightBonusSling;
static Sling *leftBonusSling;
static SKShapeNode *hint;
static Sling *bonusSlings[8];


-(id) initWithFrame: (CGRect) frame{
	self = [super init];
	if (self)
	{
        /* Where new slings born */
		slingshotPosition = CGPointMake(CGRectGetMidX(frame)-slingshotHeight/2,
                                        CGRectGetMinY(frame)+slingshotYFromBottom);
        
        self.antialiased = NO;
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
        //NSLog(@"init touch x=%f y=%f", touchInitPos.x, touchInitPos.y);
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
        //NSLog(@"end touch x=%f y=%f", touchEndPos.x, touchEndPos.y);
    }
	if (touchMoved) {
		//NSLog(@"Moved!");
		[self shotSling];
	}
	touchMoved = false;
    hint.alpha = 0.0;
}

#pragma mark shot

-(void) shotSling {
    
    [self runAction:[SKAction playSoundFileNamed:@"shoot.mp3" waitForCompletion:NO]];
	
    Sling *sling = idleSling;
    
	[sling.physicsBody setContactTestBitMask:cat_sling | cat_simpleObject];
	[sling.physicsBody setDynamic:YES];
	[sling.physicsBody setCategoryBitMask:cat_sling];
	[sling.physicsBody setCollisionBitMask:cat_sling | cat_simpleObject];
    
    CGVector impulse;
    // Shooting as if were dragging the ball
    if(touchInitPos.y - touchEndPos.y < 0) {
        impulse = CGVectorMake((touchEndPos.x-touchInitPos.x)*slingshotForceMult,
                               (touchEndPos.y-touchInitPos.y)*slingshotForceMult);
    }
    // Shooting as a slingshot
    else {
        impulse = CGVectorMake((touchInitPos.x-touchEndPos.x)*slingshotForceMult,
                               (touchInitPos.y-touchEndPos.y)*slingshotForceMult);
    }
    [sling.physicsBody applyImpulse:impulse];
    
    SKAction *scaleAction = [SKAction scaleBy:0.1 duration:slingLifespan];
    [scaleAction setTimingMode:SKActionTimingEaseIn];
    
    [sling runAction:[SKAction sequence:@[
                                          scaleAction,
                                          [SKAction removeFromParent]
                                          ]]];
    
    [Sling addSlingAtScene: self.scene];
    
    if(bonusSlings[0]){
        [self shootBonusSlingsWithImpulse: impulse];
    }
    
    if(self.parent.class == [Game class]){
        [Sling addBonusSlings:[(Game*)self.parent getComboCounter] AtScene:self.scene];
    }
    
    if (self.parent.class == [Game class]) {
        [(Game*)self.parent updateScore:score_slingIsShot];
        [(Game*)self.parent resetComboCounter];
    }
    
}

-(void) shootBonusSlingsWithImpulse: (CGVector) impulse{
    int i = 0;
    
    while (bonusSlings[i]) {
        Sling *sling = bonusSlings[i];
        
        [sling.physicsBody setContactTestBitMask:cat_sling | cat_simpleObject];
        [sling.physicsBody setDynamic:YES];
        [sling.physicsBody setCategoryBitMask:cat_sling];
        [sling.physicsBody setCollisionBitMask:cat_sling | cat_simpleObject];
        
        
        [sling.physicsBody applyImpulse:impulse];

        
        SKAction *scaleAction = [SKAction scaleBy:0.1 duration:slingLifespan];
        [scaleAction setTimingMode:SKActionTimingEaseIn];
        
        [sling runAction:[SKAction sequence:@[
                                               scaleAction,
                                               [SKAction removeFromParent]
                                               ]]];
        
        bonusSlings[i++] = NULL;
        
    }
    

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

+(void) addBonusSlings:(int)slings AtScene: (SKScene *) scene {
    
    int i;
    unsigned char numberOfSlings = (slings >> 1) & 0x06;
    
    for (i = 0; i < numberOfSlings; i++) {
        bonusSlings[i] = [[Sling alloc] initWithFrame:scene.frame];
        
        [bonusSlings[i] runAction:[SKAction moveTo:CGPointMake(bonusSlings[i].position.x+((i%2)?33*((i/2)+1):-33*((i/2)+1)),
                                                              bonusSlings[i].position.y- ((i/2)+1)*2 )
                                         duration:0.2]];
        
        [scene addChild:bonusSlings[i]];
        
    }

}

+(Sling*) getIdlesling {
    return idleSling;
}

@end
