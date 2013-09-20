//
//  Powerup.m
//  slingshot
//
//  Created by Jordi Chulia on 9/19/13.
//  Copyright (c) 2013 Pau Sastre Miguel. All rights reserved.
//

#import "Powerup.h"


@implementation Powerup

@synthesize parallized;

-(id) init {
    self = [super init];
    if (self) {
        self.fillColor = self.strokeColor;
        
        self.physicsBody.categoryBitMask = cat_powerup;
        self.physicsBody.collisionBitMask = cat_simpleObject | cat_sling | cat_deadline | cat_powerup;
        self.physicsBody.contactTestBitMask = cat_simpleObject | cat_sling | cat_deadline | cat_powerup;
        
        self.physicsBody.mass = powerupMass;
        self.parallized = false;
        
    }
    return self;
}

@end
