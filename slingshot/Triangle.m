//
//  Triangle.m
//  slingshot
//
//  Created by Jordi Chulia on 8/4/13.
//  Copyright (c) 2013 Jordi Chulia. All rights reserved.
//

#import "Triangle.h"

@implementation Triangle

-(id) init {
	self = [super init];
	if (self)
	{
		self.strokeColor = [SKColor magentaColor];
		//self.fillColor = [SKColor magentaColor];
		
		CGMutablePathRef path = CGPathCreateMutable();
		CGPathMoveToPoint(path, nil, 0, 0);
		CGPathAddLineToPoint(path, nil, 50*triangleScale, 0);
		CGPathAddLineToPoint(path, nil, 25*triangleScale, 43*triangleScale);
		CGPathCloseSubpath(path);
        
		self.path = path;
		SKPhysicsBody *pb = [SKPhysicsBody bodyWithPolygonFromPath:path];
		
		[pb setCategoryBitMask:cat_simpleObject];
		[pb setCollisionBitMask:cat_simpleObject | cat_sling];
        [pb setContactTestBitMask:cat_simpleObject | cat_sling];
		[pb setMass:triangleMass];
		[pb setFriction:0.0];
		[pb setLinearDamping:0.0];
		[pb setAffectedByGravity:NO];
		
		[self setPhysicsBody:pb];
	}
	return self;
}

@end
