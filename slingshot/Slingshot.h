//
//  Slingshot.h
//  slingshot
//
//  Created by Jordi Chulia on 7/31/13.
//  Copyright (c) 2013 Jordi Chulia. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Constants.h"

@interface Slingshot : NSObject

@property SKShapeNode *node;
@property int powerup;

-(id) init;

@end
