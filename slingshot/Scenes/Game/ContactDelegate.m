//
//  ContactDelegate.m
//  slingshot
//
//  Created by Jordi Chulia on 8/1/13.
//  Copyright (c) 2013 Jordi Chulia. All rights reserved.
//

#import "ContactDelegate.h"
#import "Constants.h"
#import "Game.h"
#import "SKAction+Sound.h"
#import <AudioToolbox/AudioServices.h>

@interface ContactDelegate() {
    SKAction * collisionSound;
    SKAction * collisionTrianglesSound;
}

@end

@implementation ContactDelegate

@synthesize physicsWorld;
@synthesize delegatorID;

-(id) init {
	self = [super init];
	if (self) {
		physicsWorld = nil;
	}
	return self;
}

-(id) initWithPhysicsWorld:(SKPhysicsWorld *) pWorld andDelegator:(id)delID {
	self = [super init];
	if (self) {
		self.physicsWorld = pWorld;
        self.delegatorID = delID;
        collisionSound = [SKAction playSoundFileNamed:@"Collision.mp3" waitForCompletion:NO];
        collisionTrianglesSound = [SKAction playSoundFileNamed:@"CollisionTriangle.mp3" waitForCompletion:NO];
	}
	return self;
}

#pragma mark delegate protocol calls

-(void) didBeginContact:(SKPhysicsContact *)contact {
	SKPhysicsBody *bodyA = [contact bodyA];
	SKPhysicsBody *bodyB = [contact bodyB];
	CGPoint collisionPoint = [contact contactPoint];
    
    uint32_t AMask = bodyA.categoryBitMask;
    uint32_t BMask = bodyB.categoryBitMask;
    
    
	if ( (AMask | BMask) == cat_sling)
		[self collisionBetweenSlings:bodyA and:bodyB At:collisionPoint];
    
    else if( (AMask | BMask) == (cat_sling | cat_simpleObject) ) {
        if(AMask == cat_sling)
            [self sling:bodyA hitSimpleObject:bodyB At:collisionPoint];
        else [self sling:bodyB hitSimpleObject:bodyA At:collisionPoint];
    }
    
    else if( (AMask | BMask) == cat_simpleObject)
        [self collisionBetweenSimpleObjects:bodyA and:bodyB At:collisionPoint];
    
    else if( (AMask | BMask) == (cat_simpleObject | cat_deadline) ){
        if(AMask == cat_simpleObject)
            [self reachedDeadlineObject:bodyA At:collisionPoint];
        else [self reachedDeadlineObject:bodyB At:collisionPoint];
    }
    
    else if( (AMask | BMask) == (cat_sling | cat_powerup)){
        if(AMask == cat_powerup) [self collisionBetweenSling:bodyB andPowerup:bodyA at:collisionPoint];
        else [self collisionBetweenSling:bodyA andPowerup:bodyB at:collisionPoint];
    }
    
    else if( (AMask | BMask) == (cat_simpleObject | cat_powerup ) ){
        if (AMask == cat_powerup) [self collisionBetweenSimpleObject:bodyB andPowerup:bodyA at:collisionPoint];
        else [self collisionBetweenSimpleObject:bodyA andPowerup:bodyB at:collisionPoint];
    }
    
    else if ( (AMask | BMask) == cat_powerup)
        [self collisionBetweenPowerups:bodyA and:bodyB At:collisionPoint];
    else if ( (AMask | BMask) == (cat_powerup | cat_deadline) ){
        if (AMask == cat_powerup) [self reachedDeadlineObject:bodyA At:collisionPoint];
        else [self reachedDeadlineObject:bodyB At:collisionPoint];
    }
    
    else if ( (AMask | BMask) == (cat_killerWave | cat_simpleObject )) {
        if (AMask == cat_simpleObject) [self killerWaveHitObject:bodyA atPoint:collisionPoint];
        else [self killerWaveHitObject:bodyB atPoint:collisionPoint];
    }
    
    else if ( (AMask | BMask) == (cat_killerWave | cat_powerup )) {
        if (AMask == cat_powerup) [self killerWaveHitObject:bodyA atPoint:collisionPoint];
        else [self killerWaveHitObject:bodyB atPoint:collisionPoint];
    }
    
    else if ( (AMask | BMask) == (cat_sling | cat_bonuswall )) {
        if (AMask == cat_sling) [self sling:bodyA bouncedInWall:bodyB atPoint:collisionPoint];
        else [self sling:bodyB bouncedInWall:bodyA atPoint:collisionPoint];
    }
}

-(void) didEndContact:(SKPhysicsContact *)contact {
}


-(void) killSimpleObject: (SKPhysicsBody*) body withTime:(double) time {
    [[body node] runAction:[SKAction fadeOutWithDuration:time]
                completion: ^{
                    [[body node] runAction:[SKAction removeFromParent]];
                }];
}

-(void) emitExplosionFromBody: (SKPhysicsBody*) body atPoint: (CGPoint) point {
    [self emitExplosionFromBody:body atPoint:point withAccel:CGVectorMake(0, 0)];
}

-(void) emitExplosionFromBody: (SKPhysicsBody*) body atPoint: (CGPoint) point withAccel: (CGVector) accel{
    SKEmitterNode *sparks = [NSKeyedUnarchiver unarchiveObjectWithFile:
                             [[NSBundle mainBundle] pathForResource:@"collisionSparks" ofType:@"sks"]];
    sparks.position = point;
    sparks.targetNode = delegatorID;
    sparks.particleColor = ((SKShapeNode*)body.node).strokeColor;
    sparks.xAcceleration = accel.dx;
    sparks.yAcceleration = accel.dy;
    
    if(accel.dx != 0 && accel.dy != 0) {
        sparks.particleSpeed /= 10;
        sparks.particleSpeedRange /= 10;
    }
    
    [sparks runAction:[SKAction sequence:@[[SKAction waitForDuration:1],[SKAction removeFromParent]]]];
    
    [delegatorID addChild:sparks];
}

-(void) emitParticlesForSling: (SKPhysicsBody*) sling atPoint: (CGPoint) point{
    [self emitParticlesForSling:sling atPoint:point withScale:0];
}

-(void) emitParticlesForSling: (SKPhysicsBody*) sling atPoint:(CGPoint)point withScale: (float) scale {
    [sling.node runAction:[SKAction removeFromParent]];
    
    SKEmitterNode *sparks = [NSKeyedUnarchiver unarchiveObjectWithFile:
                             [[NSBundle mainBundle] pathForResource:@"slingBreaks" ofType:@"sks"]];
    sparks.position = point;
    sparks.targetNode = delegatorID;
    
    if(scale != 0) sparks.particleScale = scale;
    
    [sparks runAction:[SKAction sequence:@[[SKAction waitForDuration:1],[SKAction removeFromParent]]]];
    
    [delegatorID addChild:sparks];
}

# pragma mark collisions

-(void) sling: (SKPhysicsBody*) sling bouncedInWall: (SKPhysicsBody*) wall atPoint: (CGPoint) point {
    [self emitParticlesForSling:sling atPoint:point withScale:0.02];
}

-(void) killerWaveHitObject: (SKPhysicsBody*) object atPoint: (CGPoint) point{
    [self killSimpleObject:object withTime:0];
    [self emitExplosionFromBody:object atPoint:point];
    
    [delegatorID updateScore:score_slingHitsTriangle];
}

-(int) getPowerupType: (SKPhysicsBody*) pow{
    return [(Powerup*)pow.node type];
}

-(void) collisionBetweenSling: (SKPhysicsBody*) sling andPowerup:(SKPhysicsBody*)pow at:(CGPoint)point {
    
    int type =  [self getPowerupType:pow];
    
    [delegatorID runAction:[SKAction sequence:@[
                                                [SKAction waitForDuration:pow_enableButtonTime],
                                                [SKAction runBlock:^{[delegatorID enablePowerUp:type];}]
                                                ]]];
    
    CGPoint target = [delegatorID getPowerUpButtonPosition:type];
                      
    CGVector particlesDirection = CGVectorMake((target.x-point.x)*10,
                                               ([delegatorID frame].size.height-target.y-point.y)*10);
    
    [self emitExplosionFromBody:pow atPoint:point withAccel:particlesDirection];
    
    [self killSimpleObject:pow withTime:timeForObjectToDisappearAfterHit];
    
    [self emitParticlesForSling:sling atPoint:point];
    
    [delegatorID updateScore:score_slingHitsTriangle];
    
}

-(void) collisionBetweenPowerups:(SKPhysicsBody*) bodyA and:(SKPhysicsBody*) bodyB At:(CGPoint) point {
    [self collisionBetweenSimpleObjects:bodyA and:bodyB At:point];
}

-(void) collisionBetweenSimpleObject: (SKPhysicsBody*) object andPowerup: (SKPhysicsBody*) pow at: (CGPoint) point{
    [self collisionBetweenSimpleObjects:object and:pow At:point];
}

-(void) collisionBetweenSlings: (SKPhysicsBody*) slingA and: (SKPhysicsBody*) slingB At: (CGPoint) point {
	//NSLog(@"two slings collide");
}

-(void) sling: (SKPhysicsBody*) sling hitSimpleObject: (SKPhysicsBody*) body At: (CGPoint) point {
    
    [delegatorID runAction:[collisionSound runActionChekingAudio]];
    
    [self killSimpleObject:body withTime:timeForObjectToDisappearAfterHit];
    [(Triangle*)body.node setIsAlive:NO];
    
    [self emitExplosionFromBody:body atPoint:point];
    [delegatorID increaseComboCounter];
    [delegatorID updateScore:score_slingHitsTriangle];
}

-(void) collisionBetweenSimpleObjects: (SKPhysicsBody*) bodyA and: (SKPhysicsBody*) bodyB At: (CGPoint) point {
    
    [delegatorID runAction:[collisionTrianglesSound runActionChekingAudio]];
    
    [self killSimpleObject:bodyA withTime:timeForObjectToDisappearAfterHit];
    [self killSimpleObject:bodyB withTime:timeForObjectToDisappearAfterHit];
    
    [(Triangle*)bodyA.node setIsAlive:NO];
    [(Triangle*)bodyB.node setIsAlive:NO];
    
    [self emitExplosionFromBody:bodyA atPoint:point];
    [self emitExplosionFromBody:bodyB atPoint:point];
    
    if([delegatorID getComboCounter] > 1) [delegatorID increaseComboCounter];
    [delegatorID updateScore:score_triangleHitsTriangle];
}

-(void) reachedDeadlineObject: (SKPhysicsBody*) body At: (CGPoint) point {
    /* Game over, substracting one life... whatever */
    
    if([(Triangle*)body.node isAlive]){
        [(Triangle*)body.node setIsAlive:NO];
        [body setVelocity:CGVectorMake(0, 0)];
        [body setAngularVelocity:0];
        [body setCollisionBitMask: cat_notCollide];
        
        [self killSimpleObject:body withTime:timeForObjectToDisappearAfterLanding];
        [delegatorID updateScore:score_triangleHitsDeadline];
        [delegatorID decreaseDeadlineLife];
        
        SKEmitterNode *sparks = [NSKeyedUnarchiver unarchiveObjectWithFile:
                                [[NSBundle mainBundle] pathForResource:@"deadlineSparks" ofType:@"sks"]];
        
        sparks.position = point;
        sparks.targetNode = delegatorID;
        sparks.particleColor = ((SKShapeNode*)body.node).strokeColor;
        [sparks runAction:[SKAction sequence:@[[SKAction waitForDuration:1],[SKAction removeFromParent]]]];
        
        [delegatorID addChild:sparks];
        
        [delegatorID runAction:[collisionTrianglesSound runActionChekingAudio]];
        
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);

        
    }
    else {
        [body setVelocity:CGVectorMake(0, 0)];
        [body setAngularVelocity:0];
        [body setCollisionBitMask: cat_notCollide];
        
        [self killSimpleObject:body withTime:timeForObjectToDisappearAfterLanding];
    }
}

@end
