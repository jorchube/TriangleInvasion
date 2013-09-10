//
//  Deadline.m
//  slingshot
//
//  Created by Jordi Chulia on 9/8/13.
//  Copyright (c) 2013 Jordi Chulia. All rights reserved.
//

#import "Deadline.h"

@implementation Deadline

-(id) initWithFrame:(CGRect) frame {
    self = [super init];
    if (self) {
        self.strokeColor = [SKColor whiteColor];
        self.lineWidth = 0.1;
        self.alpha = 0.75;
        
        float circleDiameter = frame.size.height;
		self.path = CGPathCreateWithEllipseInRect(CGRectMake((frame.size.width/2) - (circleDiameter/2),
                                                             50 - frame.size.height ,
                                                             circleDiameter,
                                                             circleDiameter),
                                                  nil);

    
        
        SKPhysicsBody *pb = [SKPhysicsBody bodyWithCircleOfRadius:slingshotHeight/2];
		
		[pb setCategoryBitMask:cat_deadline];
		[pb setAffectedByGravity:NO];
		[pb setUsesPreciseCollisionDetection:YES];
        
        [self setPhysicsBody:pb];
    }
    return self;
}

@end
