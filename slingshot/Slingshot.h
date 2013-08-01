//
//  Slingshot.h
//  slingshot
//
//  Created by Jordi Chulia on 8/1/13.
//  Copyright (c) 2013 Jordi Chulia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>


@interface Slingshot : NSObject

@property SKShapeNode *node;
@property int powerup;


-(id) init;

@end
