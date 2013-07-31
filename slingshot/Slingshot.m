//
//  Slingshot.m
//  slingshot
//
//  Created by Jordi Chulia on 7/31/13.
//  Copyright (c) 2013 Jordi Chulia. All rights reserved.
//

#import "Slingshot.h"

@implementation Slingshot

@synthesize node;
@synthesize powerup;

-(id) init
{
    self = [super init];
    if (self) {
        node = [[SKShapeNode alloc] init];
		powerup = pow_none;
    }
    return self;
}

@end
