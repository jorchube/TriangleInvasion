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
        
        self.anchorPoint = CGPointMake(0.5, 0);
        
        [self addLabels];
        [Sling addSlingAtScene:self];
        
        /* Line at the bottom that means the geometric apocalypse will start */
        [self addChild:[[Deadline alloc] initWithSize:size]];
        
        
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
    

    [newGamePB setDynamic:NO];
    [newGamePB setAffectedByGravity:NO];
    
    [creditsPB setDynamic:NO];
    [creditsPB setAffectedByGravity:NO];
    
    [newGame setPhysicsBody:newGamePB];
    [credits setPhysicsBody:creditsPB];
    
    [self addChild:newGame];
    [self addChild:credits];

}



#pragma mark touch detection

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[Sling getIdlesling] touchesBegan:touches withEvent:event];
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [[Sling getIdlesling] touchesMoved:touches withEvent:event];
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [[Sling getIdlesling] touchesEnded:touches withEvent:event];
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

    [credits setFontColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:1]];
    
    SKAction *changeView = [SKAction runBlock:^{
        SKTransition *trans = [SKTransition fadeWithDuration:1];
        Credits *creditView =    [Credits sceneWithSize:self.view.bounds.size];
        creditView.scaleMode = SKSceneScaleModeAspectFill;
        
        [self.view presentScene:creditView transition:trans];
    }];
    
    [self runAction:[SKAction sequence:@[[SKAction rotateByAngle:1 duration:3], changeView]]];
}

-(void) setNewGame {

    [newGame setFontColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:1]];
    
    SKAction *changeView = [SKAction runBlock:^{
        SKTransition *trans = [SKTransition fadeWithDuration:1];
        Game *game =    [Game sceneWithSize:self.view.bounds.size];
        game.scaleMode = SKSceneScaleModeAspectFill;
        
        [self.view presentScene:game transition:trans];
    }];

    [self runAction:[SKAction sequence:@[[SKAction rotateByAngle:1 duration:3], changeView]]];
}





@end
