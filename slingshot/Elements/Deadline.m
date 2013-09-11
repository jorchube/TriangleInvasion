//
//  Deadline.m
//  slingshot
//
//  Created by Jordi Chulia on 9/8/13.
//  Copyright (c) 2013 Jordi Chulia. All rights reserved.
//

#import "Deadline.h"

@implementation Deadline

@synthesize life;

-(id) initWithFrame:(CGRect) frame {
    self = [super init];
    if (self) {
        self.strokeColor = [SKColor whiteColor];
        self.fillColor = [SKColor blackColor];
        self.lineWidth = 5;
        
        float circleDiameter = (frame.size.height*2)+140;
		self.path = CGPathCreateWithEllipseInRect(CGRectMake(-circleDiameter/2,
                                                             -circleDiameter/2,
                                                             circleDiameter,
                                                             circleDiameter),
                                                  nil);

        CGPoint rect = CGPointMake(CGRectGetMidX(frame), CGRectGetMinY(frame)-CGRectGetHeight(frame));
        self.position = rect;

        SKPhysicsBody *pb = [SKPhysicsBody bodyWithCircleOfRadius:circleDiameter/2];
		
		[pb setCategoryBitMask:cat_deadline];
        
		[pb setAffectedByGravity:NO];
		[pb setUsesPreciseCollisionDetection:YES];
        [pb setDynamic:NO];
        
        [self setPhysicsBody:pb];
        
        self.zPosition = 10;
        
    }
    return self;
}

@end
