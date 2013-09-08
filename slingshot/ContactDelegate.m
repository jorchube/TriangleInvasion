//
//  ContactDelegate.m
//  slingshot
//
//  Created by Jordi Chulia on 8/1/13.
//  Copyright (c) 2013 Jordi Chulia. All rights reserved.
//

#import "ContactDelegate.h"
#import "Constants.h"

@implementation ContactDelegate

@synthesize physicsWorld;

-(id) init {
	self = [super init];
	if (self) {
		physicsWorld = nil;
	}
	return self;
}

-(id) initWithPhysicsWorld:(SKPhysicsWorld *) pWorld {
	self = [super init];
	if (self) {
		self.physicsWorld = pWorld;
	}
	return self;
}

#pragma mark delegate protocol calls

-(void) didBeginContact:(SKPhysicsContact *)contact {
	SKPhysicsBody *bodyA = [contact bodyA];
	SKPhysicsBody *bodyB = [contact bodyB];
	
    uint32_t AMask = bodyA.categoryBitMask;
    uint32_t BMask = bodyB.categoryBitMask;
    
    
	if ( (AMask | BMask) == cat_sling)
		[self collisionBetweenSlings:bodyA and:bodyB];
    else if( (AMask | BMask) == (cat_sling | cat_simpleObject) ) {
        if(AMask == cat_sling)
            [self sling:bodyA hitSimpleObject:bodyB];
        else [self sling:bodyB hitSimpleObject:bodyA];
    }
    else if( (AMask | BMask) == cat_simpleObject)
        [self collisionBetweenSimpleObjects:bodyA and:bodyB];
    else if( (AMask | BMask) == (cat_simpleObject | cat_deadline) ){
        if(AMask == cat_simpleObject)
            [self reachedDeadlineObject:bodyA];
        else [self reachedDeadlineObject:bodyB];
    }
}

-(void) didEndContact:(SKPhysicsContact *)contact {
}

# pragma mark collisions

-(void) collisionBetweenSlings: (SKPhysicsBody*) slingA and: (SKPhysicsBody*) slingB {
	NSLog(@"two slings collide");
}

-(void) killSimpleObject: (SKPhysicsBody*) body {
    [[body node] runAction:[SKAction fadeOutWithDuration:timeForObjectToDisappearAfterHit]
                completion: ^{
                    [[body node] runAction:[SKAction removeFromParent]];
                }];
}

-(void) sling: (SKPhysicsBody*) sling hitSimpleObject: (SKPhysicsBody*) body {
    [self killSimpleObject:body];
}

-(void) collisionBetweenSimpleObjects: (SKPhysicsBody*) bodyA and: (SKPhysicsBody*) bodyB {
    [self killSimpleObject:bodyA];
    [self killSimpleObject:bodyB];
}

-(void) reachedDeadlineObject: (SKPhysicsBody*) body {
    /* Game over, substracting one life... whatever */
    [self killSimpleObject:body];
}

@end
