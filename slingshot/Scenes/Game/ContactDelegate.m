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
}

-(void) didEndContact:(SKPhysicsContact *)contact {
}


-(void) killSimpleObject: (SKPhysicsBody*) body withTime:(double) time {
    [[body node] runAction:[SKAction fadeOutWithDuration:time]
                completion: ^{
                    [[body node] runAction:[SKAction removeFromParent]];
                }];
}

# pragma mark collisions

-(void) collisionBetweenSlings: (SKPhysicsBody*) slingA and: (SKPhysicsBody*) slingB At: (CGPoint) point {
	//NSLog(@"two slings collide");
}

-(void) sling: (SKPhysicsBody*) sling hitSimpleObject: (SKPhysicsBody*) body At: (CGPoint) point {
    
    [delegatorID runAction:[SKAction playSoundFileNamedCheckingMusicEnable:@"Collision.mp3" waitForCompletion:NO]];
    
    [self killSimpleObject:body withTime:timeForObjectToDisappearAfterHit];
    [(Triangle*)body.node setIsAlive:NO];
    
    SKEmitterNode *sparks = [NSKeyedUnarchiver unarchiveObjectWithFile:
                             [[NSBundle mainBundle] pathForResource:@"collisionSparks" ofType:@"sks"]];
    sparks.position = point;
    sparks.targetNode = delegatorID;
    sparks.particleColor = ((SKShapeNode*)body.node).strokeColor;
    
    [delegatorID addChild:sparks];
    [delegatorID increaseComboCounter];
    [delegatorID updateScore:score_slingHitsTriangle];
}

-(void) collisionBetweenSimpleObjects: (SKPhysicsBody*) bodyA and: (SKPhysicsBody*) bodyB At: (CGPoint) point {
    
    [delegatorID runAction:[SKAction playSoundFileNamedCheckingMusicEnable:@"CollisionTriangle.mp3" waitForCompletion:NO]];
    
    [self killSimpleObject:bodyA withTime:timeForObjectToDisappearAfterHit];
    [self killSimpleObject:bodyB withTime:timeForObjectToDisappearAfterHit];
    
    [(Triangle*)bodyA.node setIsAlive:NO];
    [(Triangle*)bodyB.node setIsAlive:NO];
    
    SKEmitterNode *sparksA = [NSKeyedUnarchiver unarchiveObjectWithFile:
                              [[NSBundle mainBundle] pathForResource:@"collisionSparks" ofType:@"sks"]];
    sparksA.position = point;
    sparksA.numParticlesToEmit = 5;
    sparksA.targetNode = delegatorID;
    sparksA.particleColor = ((SKShapeNode*)bodyA.node).strokeColor;
    
    SKEmitterNode *sparksB = [NSKeyedUnarchiver unarchiveObjectWithFile:
                              [[NSBundle mainBundle] pathForResource:@"collisionSparks" ofType:@"sks"]];
    sparksB.position = point;
    sparksB.numParticlesToEmit = 5;
    sparksB.targetNode = delegatorID;
    sparksB.particleColor = ((SKShapeNode*)bodyB.node).strokeColor;
    
    [delegatorID addChild:sparksA];
    [delegatorID addChild:sparksB];
    
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
        [delegatorID addChild:sparks];
  
    }
    else {
        [body setVelocity:CGVectorMake(0, 0)];
        [body setAngularVelocity:0];
        [body setCollisionBitMask: cat_notCollide];
        
        [self killSimpleObject:body withTime:timeForObjectToDisappearAfterLanding];
    }
}

@end
