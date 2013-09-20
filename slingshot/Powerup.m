//
//  Powerup.m
//  slingshot
//
//  Created by Jordi Chulia on 9/19/13.
//  Copyright (c) 2013 Pau Sastre Miguel. All rights reserved.
//

#import "Powerup.h"


@implementation Powerup

@synthesize type;

-(id) init {
    self = [super init];
    if (self) {
        [self setType];
        
        self.physicsBody.categoryBitMask = cat_powerup;
        self.physicsBody.collisionBitMask = cat_simpleObject | cat_sling | cat_deadline | cat_powerup;
        self.physicsBody.contactTestBitMask = cat_simpleObject | cat_sling | cat_deadline | cat_powerup;
        
        self.physicsBody.mass = powerupMass;
    }
    return self;
}

-(void) setType {
    self.type = rand()%3;
    switch (self.type) {
        case pow_time:
            self.fillColor = [UIColor cyanColor];
            self.strokeColor = [UIColor cyanColor];
            break;
        case pow_wall:
            self.fillColor = [UIColor greenColor];
            self.strokeColor = [UIColor greenColor];
            break;
        case pow_wave:
            self.fillColor = [UIColor orangeColor];
            self.strokeColor = [UIColor orangeColor];
            break;
    }
}

@end
