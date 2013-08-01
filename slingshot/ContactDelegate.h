//
//  ContactDelegate.h
//  slingshot
//
//  Created by Jordi Chulia on 8/1/13.
//  Copyright (c) 2013 Jordi Chulia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

@interface ContactDelegate : NSObject <SKPhysicsContactDelegate>

-(id) init;
-(void) didBeginContact:(SKPhysicsContact *)contact;
-(void) didEndContact:(SKPhysicsContact *)contact;

@end
