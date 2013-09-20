//
//  Triangle.m
//  slingshot
//
//  Created by Jordi Chulia on 8/4/13.
//  Copyright (c) 2013 Jordi Chulia. All rights reserved.
//

#import "Triangle.h"

@implementation Triangle

@synthesize isAlive;

-(id) init {
	self = [super init];
	if (self)
	{
		self.strokeColor = [self getColor];
        self.antialiased = NO;
        
        CGMutablePathRef path = CGPathCreateMutable();
		CGPathMoveToPoint(path, nil, 0, 0);
		CGPathAddLineToPoint(path, nil, 50*triangleScale, 0);
		CGPathAddLineToPoint(path, nil, 25*triangleScale, 43*triangleScale);
		CGPathCloseSubpath(path);
        
        isAlive = YES;
        
		self.path = path;
        self.lineWidth = 2
        ;
        self.blendMode = SKBlendModeAlpha;
		SKPhysicsBody *pb = [SKPhysicsBody bodyWithPolygonFromPath:path];
		
		[pb setCategoryBitMask:cat_simpleObject];
		[pb setCollisionBitMask:cat_simpleObject | cat_sling | cat_deadline | cat_powerup | cat_bonuswall];
        [pb setContactTestBitMask:cat_simpleObject | cat_sling | cat_deadline | cat_powerup];
		[pb setMass:triangleMass];
		[pb setFriction:0.0];
		[pb setLinearDamping:0.0];
		[pb setAffectedByGravity:NO];
		
		[self setPhysicsBody:pb];
	}
	return self;
}

-(SKColor*) getColor {
    sranddev();
    NSArray *colors = color_allColors;
    return [colors objectAtIndex:rand()%[colors count]];
}

@end
