//
//  Story.m
//  slingshot
//
//  Created by Pau Sastre Miguel on 10/09/13.
//  Copyright (c) 2013 Pau Sastre Miguel. All rights reserved.
//

#import "Story.h"

@implementation Story


-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        self.backgroundColor = [SKColor blackColor];
        
        SKEmitterNode *sparks = [NSKeyedUnarchiver unarchiveObjectWithFile:
                                 [[NSBundle mainBundle] pathForResource:@"universe" ofType:@"sks"]];
        sparks.position = CGPointMake(CGRectGetMinX(self.frame)-100, CGRectGetMidY(self.frame)-50);
        sparks.targetNode = self;
        [sparks advanceSimulationTime:100];
        [self addChild:sparks];
        
        
        
        //SKShapeNode *planet = [SKShapeNode ]
        
        
        
    }
    return self;
}



@end
