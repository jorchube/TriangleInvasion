//
//  Slingshot.m
//  slingshot
//
//  Created by Jordi Chulia on 8/1/13.
//  Copyright (c) 2013 Jordi Chulia. All rights reserved.
//

#import "Sling.h"

@implementation Sling

@synthesize powerup;

-(id) init {
	self = [super init];
	if (self)
	{
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
	}
	return self;
}

@end
