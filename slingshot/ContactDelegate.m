//
//  ContactDelegate.m
//  slingshot
//
//  Created by Jordi Chulia on 8/1/13.
//  Copyright (c) 2013 Jordi Chulia. All rights reserved.
//

#import "ContactDelegate.h"

@implementation ContactDelegate

-(id) init {
	self = [super init];
	return self;
}

-(void) didBeginContact:(SKPhysicsContact *)contact {
	NSLog(@"OUCH!");
}

-(void) didEndContact:(SKPhysicsContact *)contact {
	NSLog(@"endopuch");
}

@end
