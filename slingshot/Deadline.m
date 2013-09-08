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
        
        CGPoint init = CGPointMake(0.0, slingshotYFromBottom/4);
        CGPoint end = CGPointMake(frame.size.width, slingshotYFromBottom/4);
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, nil, init.x, init.y);
        CGPathAddLineToPoint(path, nil, end.x, end.y);
        
        self.path = path;
        
        SKPhysicsBody *pb = [SKPhysicsBody bodyWithEdgeFromPoint:init toPoint:end];
		
		[pb setCategoryBitMask:cat_deadline];
		[pb setAffectedByGravity:NO];
		[pb setUsesPreciseCollisionDetection:YES];
        
        [self setPhysicsBody:pb];
    }
    return self;
}

@end
