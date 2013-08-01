//
//  Slingshot.m
//  slingshot
//
//  Created by Jordi Chulia on 8/1/13.
//  Copyright (c) 2013 Jordi Chulia. All rights reserved.
//

#import "Slingshot.h"
#import "Constants.h"

@implementation Slingshot

@synthesize node;
@synthesize powerup;

-(id) init {
	self = [super init];
	if (self)
	{
		powerup = pow_none;
	}
	return self;
}

@end
