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
#import "Story.h"
#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMotion/CoreMotion.h>

@interface MainMenu() {
    @private
    SKLabelNode *newGame, *credits;
    Sling *sling;
    SKSpriteNode *hand;
    BOOL transitioning;
    SKEmitterNode *sparks;
    UIButton *playButton;
}
@end

@implementation MainMenu

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        
        [[ViewController getSingleton] showVolumeButton];
        [[ViewController getSingleton] showAd];
        [[ViewController getSingleton] showRemoveAdButton];
    
    
        transitioning = false;
    
        [self setMusicURL:@"MainMenu.mp3"];
        [self startMusic];
    
        self.backgroundColor = [SKColor blackColor];
        
        self.anchorPoint = CGPointMake(0.5, -1);
        
        [self addLabels];
        [Sling addSlingAtScene:self];
        [self addChild:[[Deadline alloc] initWithFrame:self.frame]];
        
        
        sparks = [NSKeyedUnarchiver unarchiveObjectWithFile:
                                 [[NSBundle mainBundle] pathForResource:@"menu" ofType:@"sks"]];
        sparks.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame));
        sparks.targetNode = self;
        [sparks advanceSimulationTime:100];
        [self addChild:sparks];
        
        
        [self.physicsWorld setContactDelegate:self];
     
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        if (![defaults objectForKey:@"hand"]){
            [self showHand];
            [defaults setObject:[NSNumber numberWithBool:true] forKey:@"hand"];
            [defaults synchronize];
        }
        
    }
    return self;
}


-(void)showHand {
    hand = [SKSpriteNode spriteNodeWithImageNamed:@"hand.png"];
    hand.zPosition = 11;
    hand.size = CGSizeMake(100, 100);
    hand.zRotation = -0.8;
    hand.position = CGPointMake(CGRectGetMidX(self.frame)-70, CGRectGetMinY(self.frame)+20);
    [self addChild:hand];
    
    SKAction *handMove = [SKAction moveByX:20 y:20 duration:1];
    SKAction *loop = [SKAction repeatActionForever:[SKAction sequence:@[handMove,
                                                                        [handMove reversedAction]]]];

    [hand runAction:loop withKey:@"loop"];
}

-(void) addLabels {
    
    newGame = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue"];
    credits = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue"];
    
    newGame.fontSize = 18;
    credits.fontSize = 18;
    
    newGame.position = CGPointMake(CGRectGetMidX(self.frame)-70,
                                   self.size.height - 100);
    credits.position = CGPointMake(CGRectGetMidX(self.frame)+70,
                                   self.size.height - 100);
    
    newGame.text = NSLocalizedString(@"New Game", nil) ;
    credits.text = NSLocalizedString(@"Credits", nil) ;
    
    
    SKPhysicsBody *newGamePB = [SKPhysicsBody bodyWithRectangleOfSize:newGame.frame.size];
    SKPhysicsBody *creditsPB = [SKPhysicsBody bodyWithRectangleOfSize:credits.frame.size];
    

    [newGamePB setDynamic:NO];
    [newGamePB setAffectedByGravity:NO];
    
    [creditsPB setDynamic:NO];
    [creditsPB setAffectedByGravity:NO];
    
    [newGame setPhysicsBody:newGamePB];
    [credits setPhysicsBody:creditsPB];
    
    
    //initial animation
    newGame.alpha = 0;
    credits.alpha = 0;
    
#define LABELSCALE 0.4
    newGame.xScale = LABELSCALE; newGame.yScale = LABELSCALE;
    credits.xScale = LABELSCALE; credits.yScale = LABELSCALE;
    
    SKAction *act = [SKAction group:@[ [SKAction moveToY:CGRectGetMidY(self.frame)+50 duration:1],
                                       [SKAction fadeAlphaTo:1 duration:1],
                                       [SKAction scaleTo:1 duration:1]
                                       ]];
    [act setTimingMode:SKActionTimingEaseOut];
    [newGame runAction:act];
    [credits runAction:act];

    
    [self addChild:newGame];
    [self addChild:credits];

}



#pragma mark touch detection

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[Sling getIdlesling] touchesBegan:touches withEvent:event];
    if(hand){
        [hand removeActionForKey:@"loop"];
        [hand runAction:[SKAction moveByX:0 y:-200 duration:1] completion:^{
            [hand removeFromParent];
        }];

    }
}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [[Sling getIdlesling] touchesMoved:touches withEvent:event];
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [[Sling getIdlesling] touchesEnded:touches withEvent:event];
    
    for (UITouch *touch in touches) {
        if ([newGame containsPoint:[touch locationInNode:self.scene]]) {
            [self setNewGame];
            return;
        }else if ([credits containsPoint:[touch locationInNode:self.scene]]) {
            [self showCredits];
        }
    }
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
    
    if(!transitioning){
        transitioning = true;
    
        [playButton removeFromSuperview];
        [self stopMusic];
        
        [[ViewController getSingleton] hideVolumeButton];
        
        Credits *creditView =    [Credits sceneWithSize:self.view.bounds.size];
        creditView.scaleMode = SKSceneScaleModeAspectFill;
        
        SKAction *changeView = [SKAction runBlock:^{
            SKTransition *trans = [SKTransition fadeWithDuration:1];
            
            [self.view presentScene:creditView transition:trans];
        }];
        
        [self runAction:[SKAction sequence:@[[SKAction rotateByAngle:1 duration:3], changeView]]];
    }
}

-(void) setNewGame {
    
    if (!transitioning){
        
        transitioning = true;
        
        [playButton removeFromSuperview];
        [[ViewController getSingleton] removeAdButton];
        [[ViewController getSingleton] hideVolumeButton];
        [self stopMusic];

        
        SKScene *nextScene;
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        if (![defaults objectForKey:@"story"]){
            nextScene = [[Story alloc ] initWithSize:self.view.bounds.size nextScene:next_game];
            [defaults setObject:[NSNumber numberWithBool:true] forKey:@"story"];
            [defaults synchronize];
        }else{
            nextScene = [Game sceneWithSize:self.view.bounds.size];
        }
        nextScene.scaleMode = SKSceneScaleModeAspectFill;
        
        SKAction *changeView = [SKAction runBlock:^{
            
            SKTransition *trans = [SKTransition fadeWithDuration:1];
            [self.view presentScene:nextScene transition:trans];
            
        }];
        
        [[ViewController getSingleton] hideAd];

        [self runAction:[SKAction sequence:@[[SKAction rotateByAngle:-1 duration:3], changeView]]];
        
    }
}




-(void)didMoveToView:(SKView *)view {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults objectForKey:@"story"]){
    
        UIImage *image = [UIImage imageNamed:@"play.png"];
        
        playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        playButton.frame = CGRectMake(0, 0, 200, 50);
        playButton.center = CGPointMake(CGRectGetMidX(self.view.frame),CGRectGetMaxY(self.view.frame)-25);
        [playButton setImage:image forState:UIControlStateNormal];
        [playButton setTitle:NSLocalizedString(@"Watch story", nil) forState:UIControlStateNormal];
        [playButton setTitleColor:[SKColor whiteColor] forState:UIControlStateNormal];
        playButton.titleLabel.font = [UIFont systemFontOfSize:18];
        [playButton addTarget:self action:@selector(playStory) forControlEvents:UIControlEventTouchUpInside];

        [self.view addSubview:playButton];
        
    }
}

-(void)playStory {
    
    [[ViewController getSingleton] hideAd];
    [[ViewController getSingleton] removeAdButton];
    [[ViewController getSingleton] hideVolumeButton];
    [playButton removeFromSuperview];
    [self stopMusic];
    
    SKScene *nextScene = [[Story alloc ] initWithSize:self.view.bounds.size nextScene:next_mainmenu];
    nextScene.scaleMode = SKSceneScaleModeAspectFill;
    
    SKAction *changeView = [SKAction runBlock:^{
        
        SKTransition *trans = [SKTransition fadeWithDuration:4];
        [self.view presentScene:nextScene transition:trans];
        
    }];
    
    [self runAction:changeView];
    
    [playButton removeFromSuperview];
    
    
}


@end
