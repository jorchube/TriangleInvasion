//
//  Story.m
//  slingshot
//
//  Created by Pau Sastre Miguel on 10/09/13.
//  Copyright (c) 2013 Pau Sastre Miguel. All rights reserved.
//

#import "Story.h"

@interface Story() {
    SKSpriteNode *bg_1;
    SKSpriteNode *bg_2;
    SKSpriteNode *fg_1;
    SKSpriteNode *fg_2;
    SKSpriteNode *fg_3;
    SKLabelNode *textLabel;
    SKAction* scene1;
    SKAction* scene2;
    SKAction* scene3;
}

@end

@implementation Story


-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor blackColor];
        
        SKEmitterNode *sparks = [NSKeyedUnarchiver unarchiveObjectWithFile:
                                 [[NSBundle mainBundle] pathForResource:@"universe" ofType:@"sks"]];
        sparks.position = CGPointMake(CGRectGetMinX(self.frame)-100, CGRectGetMidY(self.frame)-50);
        sparks.targetNode = self;
        [sparks advanceSimulationTime:100];
        [self addChild:sparks];
        
        
        
        //SKShapeNode *planet = [SKShapeNode ]
        
        textLabel = [[SKLabelNode alloc] init];
        textLabel.alpha = 1;
        textLabel.fontSize = 12;
        textLabel.fontColor = [SKColor whiteColor];
        textLabel.position = CGPointMake(150,400);
        textLabel.zPosition = 30;
        
        bg_1 = [[SKSpriteNode alloc] initWithImageNamed:@"story-bg-1.png"];
        bg_2 = [[SKSpriteNode alloc] initWithImageNamed:@"story-bg-2.png"];
        fg_1 = [[SKSpriteNode alloc] initWithImageNamed:@"story-fg-1.png"];
        fg_2 = [[SKSpriteNode alloc] initWithImageNamed:@"story-fg-2.png"];
        fg_3 = [[SKSpriteNode alloc] initWithImageNamed:@"story-fg-3.png"];
        
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
        
        [self putOnPosition:bg_1];
        [self putOnPosition:bg_2];
        [self putOnPosition:fg_1];
        [self putOnPosition:fg_2];
        [self putOnPosition:fg_3];
        
        bg_1.alpha = 0;
        bg_2.alpha = 0;
        fg_1.alpha = 0;
        fg_2.alpha = 0;
        fg_3.alpha = 0;
        
        bg_1.zPosition = 10;
        bg_2.zPosition = 10;
        fg_1.zPosition = 20;
        fg_2.zPosition = 20;
        fg_3.zPosition = 20;
        
        [self addChild:textLabel];
        [self addChild:bg_1];
        [self addChild:bg_2];
        [self addChild:fg_1];
        [self addChild:fg_2];
        [self addChild:fg_3];
        
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
    
    SKAction *show = [SKAction fadeAlphaTo:1 duration:story_showFadeInDuration];
    SKAction *waitInCut = [SKAction waitForDuration:story_timeForEachCut];
    SKAction *hide = [SKAction fadeAlphaTo:0 duration:story_showFadeOutDuration];
    //SKAction *waitBetweenCuts = [SKAction waitForDuration:story_timeBetweenCuts];
    SKAction *moveRight = [SKAction moveByX:20 y:0 duration:story_showFadeInDuration+story_timeForEachCut+story_showFadeOutDuration];
    SKAction *moveLeft = [SKAction moveByX:-20 y:0 duration:story_showFadeInDuration+story_timeForEachCut+story_showFadeOutDuration];
    SKAction *moveUp = [SKAction moveByX:0 y:20 duration:story_showFadeInDuration+story_timeForEachCut+story_showFadeOutDuration];
    
    SKAction *setText1 = [SKAction runBlock:^{
        textLabel.text = NSLocalizedString(@"story1", nil);
    }];
    SKAction *setText2 = [SKAction runBlock:^{
        textLabel.text = NSLocalizedString(@"story2", nil);
    }];
    SKAction *setText3 = [SKAction runBlock:^{
        textLabel.text = NSLocalizedString(@"story3", nil);
    }];
    SKAction *setText4 = [SKAction runBlock:^{
        textLabel.text = NSLocalizedString(@"story4", nil);
    }];
    SKAction *setText5 = [SKAction runBlock:^{
        textLabel.text = NSLocalizedString(@"story5", nil);
    }];
    SKAction *setText6 = [SKAction runBlock:^{
        textLabel.text = NSLocalizedString(@"story6", nil);
    }];
    SKAction *setText7 = [SKAction runBlock:^{
        textLabel.text = NSLocalizedString(@"story7", nil);
    }];
    
    SKAction *showText = [SKAction runBlock:^{
        [textLabel runAction: show];
    }];
    SKAction *hideText = [SKAction runBlock:^{
        [textLabel runAction: hide];
    }];
    
    /* Setting scene events */
    
    SKAction *textCut = [SKAction sequence:@[
                                             showText,
                                             waitInCut,
                                             hideText
                                             ]];
    
    SKAction *scene1In = [SKAction runBlock:^{
        [bg_1 runAction:show];
        [fg_1 runAction:show];
        [fg_1 runAction:moveRight];
        [textLabel runAction:show];
    }];
    SKAction *scene1Out = [SKAction runBlock:^{
        [bg_1 runAction:hide];
        [fg_1 runAction:hide];
        [textLabel runAction:hide];
    }];
    SKAction *scene2In = [SKAction runBlock:^{
        [bg_2 runAction:show];
        [fg_2 runAction:show];
        [fg_2 runAction:moveLeft];
        [textLabel runAction:show];
    }];
    SKAction *scene2Out = [SKAction runBlock:^{
        [bg_2 runAction:hide];
        [fg_2 runAction:hide];
        [textLabel runAction:hide];
    }];
    SKAction *scene3In = [SKAction runBlock:^{
        [fg_3 runAction:show];
        [fg_3 runAction:moveUp];
        [textLabel runAction:show];
    }];
    SKAction *scene3Out = [SKAction runBlock:^{
        [fg_3 runAction:hide];
        [textLabel runAction:hide];
    }];
    
    /* Building sequence */
    
    SKAction *story = [SKAction sequence:@[
                                           setText1,
                                           textCut,
                                           setText2,
                                           scene1In,
                                           waitInCut,
                                           scene1Out,
                                           setText3,
                                           textCut,
                                           setText4,
                                           scene2In,
                                           waitInCut,
                                           scene2Out,
                                           setText5,
                                           textCut,
                                           setText6,
                                           scene3In,
                                           waitInCut,
                                           scene3Out,
                                           setText7,
                                           textCut
                                           ]];
    
    /* run */
    [self runAction:story completion:^{
        /* Change to game */
    }];
    
}












@end
