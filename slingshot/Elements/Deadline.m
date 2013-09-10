//
//  Deadline.m
//  slingshot
//
//  Created by Jordi Chulia on 9/8/13.
//  Copyright (c) 2013 Jordi Chulia. All rights reserved.
//

#import "Deadline.h"

@implementation Deadline

-(id) initWithSize:(CGSize) size {
    self = [super init];
    if (self) {
        self.strokeColor = [SKColor whiteColor];
        self.lineWidth = 0.1;
        self.alpha = 0.75;
        
        float circleDiameter = size.height;
		self.path = CGPathCreateWithEllipseInRect(CGRectMake(-circleDiameter/2,
                                                             -circleDiameter/2,
                                                             circleDiameter,
                                                             circleDiameter),
                                                  nil);

        self.position = CGPointMake(size.width/2, 60-(circleDiameter/2));

        SKPhysicsBody *pb = [SKPhysicsBody bodyWithCircleOfRadius:circleDiameter/2];
		
		[pb setCategoryBitMask:cat_deadline];
		[pb setAffectedByGravity:NO];
		[pb setUsesPreciseCollisionDetection:YES];
        [pb setDynamic:NO];
        
        [self setPhysicsBody:pb];
    }
    return self;
}

@end
