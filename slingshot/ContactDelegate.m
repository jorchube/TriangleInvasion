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
	
	if ( ( bodyA.categoryBitMask | bodyB.categoryBitMask ) == cat_sling)
		[self collisionBetweenSlings:bodyA and:bodyB];
	
}

-(void) didEndContact:(SKPhysicsContact *)contact {
}

# pragma mark collisions

-(void) collisionBetweenSlings: (SKPhysicsBody*) slingA and: (SKPhysicsBody*) slingB {
	NSLog(@"two slings collide");
}

@end
