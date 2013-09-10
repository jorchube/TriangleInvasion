//
//  MyScene.m
//  slingshot
//
//  Created by Pau Sastre Miguel on 06/09/13.
//  Copyright (c) 2013 Pau Sastre Miguel. All rights reserved.
//

#import "MainMenu.h"
#import "Sling.h"
#import "Game.h"
#import "Credits.h"
#import "Deadline.h"

@interface MainMenu() {
    @private
    SKLabelNode *newGame, *credits;
    Sling *sling;
}
@end

@implementation MainMenu

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        
        [self addLabels];
        [self addSling];
        
        /* Line at the bottom that means the geometric apocalypse will start */
        [self addChild:[[Deadline alloc] initWithFrame:self.frame]];
        
        
        [self.physicsWorld setContactDelegate:self];
        
    }
    return self;
}


-(void) addLabels {
    
    newGame = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    credits = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
    newGame.fontSize = 12;
    credits.fontSize = 12;
    
    newGame.position = CGPointMake(CGRectGetMidX(self.frame)-50,
                                   self.size.height - 100);
    credits.position = CGPointMake(CGRectGetMidX(self.frame)+50,
                                   self.size.height - 100);
    
    newGame.text = @"Juego Nuevo";
    credits.text = @"Creditos";
    
    SKAction *act = [SKAction moveToY:CGRectGetMidY(self.frame)+50 duration:1];
    [act setTimingMode:SKActionTimingEaseOut];
    [newGame runAction:act];
    [credits runAction:act];
    
    SKPhysicsBody *newGamePB = [SKPhysicsBody bodyWithRectangleOfSize:newGame.frame.size];
    SKPhysicsBody *creditsPB = [SKPhysicsBody bodyWithRectangleOfSize:credits.frame.size];
    
    [newGamePB setContactTestBitMask:cat_sling | cat_simpleObject];
    [newGamePB setDynamic:NO];
    [newGamePB setCategoryBitMask:cat_sling];
    [newGamePB setCollisionBitMask:cat_sling | cat_simpleObject];
    [newGamePB setAffectedByGravity:NO];
    
    [creditsPB setContactTestBitMask:cat_sling | cat_simpleObject];
    [creditsPB setDynamic:NO];
    [creditsPB setCategoryBitMask:cat_sling];
    [creditsPB setCollisionBitMask:cat_sling | cat_simpleObject];
    [creditsPB setAffectedByGravity:NO];
    
    [newGame setPhysicsBody:newGamePB];
    [credits setPhysicsBody:creditsPB];
    
    [self addChild:newGame];
    [self addChild:credits];

}


#pragma mark sling

-(void) addSling {
    sling = [Sling new];
    sling.position = CGPointMake(CGRectGetMidX(self.frame)-slingshotHeight/2,
                                 CGRectGetMinY(self.frame)+slingshotYFromBottom);
	[self addChild:sling];
}

-(void)shotSling {
    
    float time = 1;
    float initialGlow = sling.glowWidth;
    [sling runAction:[SKAction customActionWithDuration:time actionBlock:^(SKNode *node, CGFloat elapsedTime) {
        
        float inc = 1-(elapsedTime / time);
        [sling setGlowWidth:initialGlow*inc];
        UIColor *color = [UIColor colorWithRed:1 green:1-inc blue:1-inc alpha:1];
        [sling setFillColor:color];
        [sling setStrokeColor:color];

    }]];
    
    [sling.physicsBody setContactTestBitMask:cat_sling | cat_simpleObject];
	[sling.physicsBody setDynamic:YES];
	[sling.physicsBody setCategoryBitMask:cat_sling];
	[sling.physicsBody setCollisionBitMask:cat_sling | cat_simpleObject];
//	[sling.physicsBody applyImpulse:CGVectorMake((touchInitPos.x-touchEndPos.x)*slingshotForceMult,
//                                                 (touchInitPos.y-touchEndPos.y)*slingshotForceMult)];
	
	[self addSling];
}


#pragma mark touch detection

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [sling touchesBegan:touches withEvent:event];
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [sling touchesMoved:touches withEvent:event];
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [sling touchesEnded:touches withEvent:event];
}



#pragma mark contact delegate

-(void) didBeginContact:(SKPhysicsContact *)contact {
	SKNode *bodyA = [contact bodyA].node;
	SKNode *bodyB = [contact bodyB].node;

    if (bodyA == credits || bodyB == credits){
        [self showCredits];
    }else if (bodyA == newGame || bodyB == newGame){
        [self setNewGame];
    }
}



#pragma mark menu functions

-(void) showCredits {
    [self showEmitter:CGPointMake(CGRectGetMidX(credits.frame), CGRectGetMidY(credits.frame))];
    [credits setFontColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:1]];
    
    SKAction *changeView = [SKAction runBlock:^{
        SKTransition *trans = [SKTransition fadeWithDuration:1];
        Credits *creditView =    [Credits sceneWithSize:self.view.bounds.size];
        creditView.scaleMode = SKSceneScaleModeAspectFill;
        
        [self.view presentScene:creditView transition:trans];
    }];
    
    [self runAction:[SKAction sequence:@[[SKAction waitForDuration:3], changeView]]];
}

-(void) setNewGame {
    [self showEmitter:CGPointMake(CGRectGetMidX(newGame.frame), CGRectGetMidY(newGame.frame))];
    [newGame setFontColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:1]];
    
    SKAction *changeView = [SKAction runBlock:^{
        SKTransition *trans = [SKTransition fadeWithDuration:1];
        Game *game =    [Game sceneWithSize:self.view.bounds.size];
        game.scaleMode = SKSceneScaleModeAspectFill;
        
        [self.view presentScene:game transition:trans];
    }];

    [self runAction:[SKAction sequence:@[[SKAction waitForDuration:3], changeView]]];
}

-(void) showEmitter:(CGPoint)origin {
    SKEmitterNode *emitter = [NSKeyedUnarchiver unarchiveObjectWithFile:[[NSBundle mainBundle] pathForResource:@"menuParticles" ofType:@"sks"]];
    
    emitter.position = origin;
    emitter.targetNode = self.scene;
    
    [self addChild:emitter];
    
}



@end
