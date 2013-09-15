//
//  Story.m
//  slingshot
//
//  Created by Pau Sastre Miguel on 10/09/13.
//  Copyright (c) 2013 Pau Sastre Miguel. All rights reserved.
//

#import "Story.h"
#import "Game.h"
#import <AVFoundation/AVFoundation.h>

@interface Story() {
    SKSpriteNode *bg_1;
    SKSpriteNode *bg_2;
    SKSpriteNode *fg_1;
    SKSpriteNode *fg_2;
    SKSpriteNode *fg_3;
    SKSpriteNode *fg_4;
    SKSpriteNode *fg_5;
    SKSpriteNode *fg_you;
    SKLabelNode *textLabel1;
    SKLabelNode *textLabel2;
    SKLabelNode *textLabel3;
    SKAction* scene1;
    SKAction* scene2;
    SKAction* scene3;
    
    AVAudioPlayer *storyPlayer;
}

@end

@implementation Story


-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        [self setMusicURL:@"Story.mp3"];
        
        self.backgroundColor = [SKColor blackColor];
        
        SKEmitterNode *sparks = [NSKeyedUnarchiver unarchiveObjectWithFile:
                                 [[NSBundle mainBundle] pathForResource:@"universe" ofType:@"sks"]];
        sparks.position = CGPointMake(CGRectGetMinX(self.frame)-100, CGRectGetMidY(self.frame)-50);
        sparks.targetNode = self;
        [sparks advanceSimulationTime:100];
        [self addChild:sparks];
        
        
        
        //SKShapeNode *planet = [SKShapeNode ]
        
        int fontsize = 16;
        
        textLabel1 = [[SKLabelNode alloc] init];
        textLabel1.alpha = 0;
        textLabel1.fontSize = fontsize;
        textLabel1.fontColor = [SKColor whiteColor];
        textLabel1.position = CGPointMake(160,400);
        textLabel1.zPosition = 30;
        
        textLabel2 = [[SKLabelNode alloc] init];
        textLabel2.alpha = 0;
        textLabel2.fontSize = fontsize;
        textLabel2.fontColor = [SKColor whiteColor];
        textLabel2.position = CGPointMake(160,380);
        textLabel2.zPosition = 30;
        
        textLabel3 = [[SKLabelNode alloc] init];
        textLabel3.alpha = 0;
        textLabel3.fontSize = fontsize;
        textLabel3.fontColor = [SKColor whiteColor];
        textLabel3.position = CGPointMake(160,360);
        textLabel3.zPosition = 30;
        
        /*
        bg_1 = [[SKSpriteNode alloc] initWithImageNamed:@"story-bg-1.png"];
        bg_2 = [[SKSpriteNode alloc] initWithImageNamed:@"story-bg-2.png"];
        fg_1 = [[SKSpriteNode alloc] initWithImageNamed:@"story-fg-1-2-noface.png"];
        fg_2 = [[SKSpriteNode alloc] initWithImageNamed:@"story-fg-1-2-noface.png"];
        fg_3 = [[SKSpriteNode alloc] initWithImageNamed:@"story-fg-3-noface.png"];
        */
        
        bg_1 = [[SKSpriteNode alloc] initWithImageNamed:@"story-bg-noballs.png"];
        bg_2 = [[SKSpriteNode alloc] initWithImageNamed:@"story-bg-2-noballs.png"];
        fg_1 = [[SKSpriteNode alloc] initWithImageNamed:@"story-fg-a.png"];
        fg_2 = [[SKSpriteNode alloc] initWithImageNamed:@"story-fg-b.png"];
        fg_3 = [[SKSpriteNode alloc] initWithImageNamed:@"story-fg-c.png"];
        fg_4 = [[SKSpriteNode alloc] initWithImageNamed:@"story-fg-d.png"];
        fg_5 = [[SKSpriteNode alloc] initWithImageNamed:@"story-fg-e.png"];
        fg_you = [[SKSpriteNode alloc] initWithImageNamed:@"story-fg-3-noface.png"];
        
        double sc = 0.18;
        
        [bg_1 setXScale:sc];
        [bg_1 setYScale:sc];
        [bg_2 setXScale:sc];
        [bg_2 setYScale:sc];
        [fg_1 setXScale:sc];
        [fg_1 setYScale:sc];
        [fg_2 setXScale:sc];
        [fg_2 setYScale:sc];
        [fg_3 setXScale:sc];
        [fg_3 setYScale:sc];
        [fg_4 setXScale:sc];
        [fg_4 setYScale:sc];
        [fg_5 setXScale:sc];
        [fg_5 setYScale:sc];
        [fg_you setXScale:sc];
        [fg_you setYScale:sc];
        
        [self putOnPosition:bg_1];
        [self putOnPosition:bg_2];
        [self putOnPosition:fg_1];
        [self putOnPosition:fg_2];
        [self putOnPosition:fg_3];
        [self putOnPosition:fg_4];
        [self putOnPosition:fg_5];
        [self putOnPosition:fg_you];
        
        bg_1.alpha = 0;
        bg_2.alpha = 0;
        fg_1.alpha = 0;
        fg_2.alpha = 0;
        fg_3.alpha = 0;
        fg_4.alpha = 0;
        fg_5.alpha = 0;
        fg_you.alpha = 0;
        
        bg_1.zPosition = 10;
        bg_2.zPosition = 10;
        fg_1.zPosition = 20;
        fg_2.zPosition = 20;
        fg_3.zPosition = 20;
        fg_4.zPosition = 20;
        fg_5.zPosition = 20;
        fg_you.zPosition = 20;
        
        [self addChild:textLabel1];
        [self addChild:textLabel2];
        [self addChild:textLabel3];
        [self addChild:bg_1];
        [self addChild:bg_2];
        [self addChild:fg_1];
        [self addChild:fg_2];
        [self addChild:fg_3];
        [self addChild:fg_4];
        [self addChild:fg_5];
        [self addChild:fg_you];
        
        [self startMusic];
        [self showSequence];
    }
    return self;
}

-(void) putOnPosition: (SKSpriteNode*) node {
    node.position = CGPointMake(node.position.x+150,
                                node.position.y+150);
}

-(void) showSequence {
    
    /* Preparing the actions that compose the scenes */
    
    #define firstSectionDuration 9.5
    #define secondSectionDuration 14.55
    #define thirdSectionDuration 21
    
    SKAction *scene1Time = [SKAction waitForDuration:(firstSectionDuration-2)/2];
    SKAction *scene2Time = [SKAction waitForDuration:(secondSectionDuration-2)/2];
    SKAction *scene3Time = [SKAction waitForDuration:(thirdSectionDuration-3)/3];
    
    SKAction *show = [SKAction fadeAlphaTo:1 duration:story_showFadeInDuration];
    SKAction *waitInCut = [SKAction waitForDuration:story_timeForEachCut];
    SKAction *hide = [SKAction fadeAlphaTo:0 duration:story_showFadeOutDuration];
    //SKAction *waitBetweenCuts = [SKAction waitForDuration:story_timeBetweenCuts];
    //SKAction *moveRight = [SKAction moveByX:20 y:0 duration:story_showFadeInDuration+story_timeForEachCut+story_showFadeOutDuration];
    //SKAction *moveLeft = [SKAction moveByX:-20 y:0 duration:story_showFadeInDuration+story_timeForEachCut+story_showFadeOutDuration];
    SKAction *moveUp = [SKAction moveByX:0 y:20 duration:story_showFadeInDuration+story_timeForEachCut+story_showFadeOutDuration];
    
    SKAction *jumpUp = [SKAction moveByX:0 y:40 duration:0.25];
    jumpUp.timingMode = SKActionTimingEaseOut;
    SKAction *jumpDown = [SKAction moveByX:0 y:-40 duration:0.25];
    jumpDown.timingMode = SKActionTimingEaseIn;
    
    
    #define jumpTime 0.5
    SKAction *jumpMoves = [SKAction sequence:@[
                                          [SKAction waitForDuration:jumpTime withRange:jumpTime],
                                          jumpUp,
                                          jumpDown
                                          ]];
    
    SKAction *jump = [SKAction repeatAction:jumpMoves count:story_timeForEachCut/jumpTime];
    
#define miniMoveTime 0.05
    SKAction *shake = [SKAction sequence:@[
                                           [SKAction moveByX:0 y:3 duration:miniMoveTime],
                                           [SKAction moveByX:2 y:-3 duration:miniMoveTime],
                                           [SKAction moveByX:-2 y:5 duration:miniMoveTime],
                                           [SKAction moveByX:1 y:-4 duration:miniMoveTime],
                                           [SKAction moveByX:-2 y:2 duration:miniMoveTime],
                                           [SKAction moveByX:1 y:-3 duration:miniMoveTime],
                                           ]];
    SKAction *fear = [SKAction repeatAction:shake count:story_timeForEachCut/miniMoveTime];
    SKAction *shakingOffset = [SKAction waitForDuration:0.2 withRange:0.4];
    
    SKAction *soScaryYouShake = [SKAction sequence:@[
                                                     shakingOffset,
                                                     fear
                                                     ]];
    
    //This is the one to use in the story
    SKAction *everybodyJumps = [SKAction runBlock:^{
        [fg_1 runAction:jump];
        [fg_2 runAction:jump];
        [fg_3 runAction:jump];
        [fg_4 runAction:jump];
        [fg_5 runAction:jump];
    }];
    
    SKAction *everybodyShakes = [SKAction runBlock:^{
        [fg_1 runAction:soScaryYouShake];
        [fg_2 runAction:soScaryYouShake];
        [fg_3 runAction:soScaryYouShake];
        [fg_4 runAction:soScaryYouShake];
        [fg_5 runAction:soScaryYouShake];
    }];
    
    
    SKAction *setText1 = [SKAction runBlock:^{
        textLabel1.text = NSLocalizedString(@"story11", nil);
        textLabel2.text = NSLocalizedString(@"story12", nil);
        textLabel3.text = NSLocalizedString(@"story13", nil);
    }];
    SKAction *setText2 = [SKAction runBlock:^{
        textLabel1.text = NSLocalizedString(@"story21", nil);
        textLabel2.text = NSLocalizedString(@"story22", nil);
        textLabel3.text = NSLocalizedString(@"story23", nil);
    }];
    SKAction *setText3 = [SKAction runBlock:^{
        textLabel1.text = NSLocalizedString(@"story31", nil);
        textLabel2.text = NSLocalizedString(@"story32", nil);
        textLabel3.text = NSLocalizedString(@"story33", nil);
    }];
    SKAction *setText4 = [SKAction runBlock:^{
        textLabel1.text = NSLocalizedString(@"story41", nil);
        textLabel2.text = NSLocalizedString(@"story42", nil);
        textLabel3.text = NSLocalizedString(@"story43", nil);
    }];
    SKAction *setText5 = [SKAction runBlock:^{
        textLabel1.text = NSLocalizedString(@"story51", nil);
        textLabel2.text = NSLocalizedString(@"story52", nil);
        textLabel3.text = NSLocalizedString(@"story53", nil);
    }];
    SKAction *setText6 = [SKAction runBlock:^{
        textLabel1.text = NSLocalizedString(@"story61", nil);
        textLabel2.text = NSLocalizedString(@"story62", nil);
        textLabel3.text = NSLocalizedString(@"story63", nil);
    }];
    SKAction *setText7 = [SKAction runBlock:^{
        textLabel1.text = NSLocalizedString(@"story71", nil);
        textLabel2.text = NSLocalizedString(@"story72", nil);
        textLabel3.text = NSLocalizedString(@"story73", nil);
    }];
    
    SKAction *showText = [SKAction runBlock:^{
        [textLabel1 runAction: show];
        [textLabel2 runAction: show];
        [textLabel3 runAction: show];
    }];
    SKAction *hideText = [SKAction runBlock:^{
        [textLabel1 runAction: hide];
        [textLabel2 runAction: hide];
        [textLabel3 runAction: hide];
    }];
    
    /* Setting scene events */
    
    SKAction *textCut = [SKAction sequence:@[
                                             showText,
                                             waitInCut,
                                             hideText
                                             ]];
    
    SKAction *textCutScene1 = [SKAction sequence:@[
                                             showText,
                                             scene1Time,
                                             hideText
                                             ]];
    
    SKAction *textCutScene2 = [SKAction sequence:@[
                                             showText,
                                             scene2Time,
                                             hideText
                                             ]];
    
    SKAction *textCutScene3 = [SKAction sequence:@[
                                             showText,
                                             scene3Time,
                                             hideText
                                             ]];
    
    SKAction *scene1In = [SKAction runBlock:^{
        [bg_1 runAction:show];
        [fg_1 runAction:show];
        [fg_2 runAction:show];
        [fg_3 runAction:show];
        [fg_4 runAction:show];
        [fg_5 runAction:show];
        //[fg_1 runAction:moveRight];
        [textLabel1 runAction:show];
        [textLabel2 runAction:show];
        [textLabel3 runAction:show];
    }];
    SKAction *scene1Out = [SKAction runBlock:^{
        [bg_1 runAction:hide];
        [fg_1 runAction:hide];
        [fg_2 runAction:hide];
        [fg_3 runAction:hide];
        [fg_4 runAction:hide];
        [fg_5 runAction:hide];
        [textLabel1 runAction:hide];
        [textLabel2 runAction:hide];
        [textLabel3 runAction:hide];
    }];
    SKAction *scene2In = [SKAction runBlock:^{
        [bg_2 runAction:show];
        [fg_1 runAction:show];
        [fg_2 runAction:show];
        [fg_3 runAction:show];
        [fg_4 runAction:show];
        [fg_5 runAction:show];
        //[fg_2 runAction:moveLeft];
        [textLabel1 runAction:show];
        [textLabel2 runAction:show];
        [textLabel3 runAction:show];
    }];
    SKAction *scene2Out = [SKAction runBlock:^{
        [bg_2 runAction:hide];
        [fg_1 runAction:hide];
        [fg_2 runAction:hide];
        [fg_3 runAction:hide];
        [fg_4 runAction:hide];
        [fg_5 runAction:hide];
        [textLabel1 runAction:hide];
        [textLabel2 runAction:hide];
        [textLabel3 runAction:hide];
    }];
    SKAction *scene3In = [SKAction runBlock:^{
        [fg_you runAction:show];
        [fg_you runAction:moveUp];
        [textLabel1 runAction:show];
        [textLabel2 runAction:show];
        [textLabel3 runAction:show];
    }];
    SKAction *scene3Out = [SKAction runBlock:^{
        [fg_you runAction:hide];
        [textLabel1 runAction:hide];
        [textLabel2 runAction:hide];
        [textLabel3 runAction:hide];
    }];
    
    /* Building sequence */
    
    SKAction *story = [SKAction sequence:@[
                                           setText1,
                                           textCutScene1,
                                           setText2,
                                           scene1In,
                                           everybodyJumps,
                                           scene1Time,
                                           scene1Out,
                                           setText3,
                                           textCutScene2,
                                           setText4,
                                           scene2In,
                                           everybodyShakes,
                                           scene2Time,
                                           scene2Out,
                                           setText5,
                                           textCutScene3,
                                           setText6,
                                           scene3In,
                                           scene3Time,
                                           scene3Out,
                                           setText7,
                                           textCutScene3
                                           ]];
    
    /* run */
    [self runAction:story completion:^{
        
        SKScene *nextScene = [Game sceneWithSize:self.view.bounds.size];
        nextScene.scaleMode = SKSceneScaleModeAspectFill;
        
        [self runAction:[SKAction runBlock:^{
            
            SKTransition *trans = [SKTransition fadeWithDuration:1];
            [self.view presentScene:nextScene transition:trans];
            
        }]];
    }];
    
}












@end
