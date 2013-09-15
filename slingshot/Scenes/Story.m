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

-(void)startMusic {
    
    if (![ViewController getSingleton].musicEnable) {
        return;
    }
    
    if (storyPlayer) {
        [storyPlayer play];
        return;
    }
    
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/Story.mp3", [[NSBundle mainBundle] resourcePath]]];
	
	NSError *error;
	storyPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
	storyPlayer.numberOfLoops = -1;
	
	if (storyPlayer == nil)
		NSLog(@"%@",error);
	else
		[storyPlayer play];
}

-(void)stopMusic {
    [storyPlayer stop];
}





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
        
        [self addChild:textLabel1];
        [self addChild:textLabel2];
        [self addChild:textLabel3];
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
    
    SKAction *scene1In = [SKAction runBlock:^{
        [bg_1 runAction:show];
        [fg_1 runAction:show];
        [fg_1 runAction:moveRight];
        [textLabel1 runAction:show];
        [textLabel2 runAction:show];
        [textLabel3 runAction:show];
    }];
    SKAction *scene1Out = [SKAction runBlock:^{
        [bg_1 runAction:hide];
        [fg_1 runAction:hide];
        [textLabel1 runAction:hide];
        [textLabel2 runAction:hide];
        [textLabel3 runAction:hide];
    }];
    SKAction *scene2In = [SKAction runBlock:^{
        [bg_2 runAction:show];
        [fg_2 runAction:show];
        [fg_2 runAction:moveLeft];
        [textLabel1 runAction:show];
        [textLabel2 runAction:show];
        [textLabel3 runAction:show];
    }];
    SKAction *scene2Out = [SKAction runBlock:^{
        [bg_2 runAction:hide];
        [fg_2 runAction:hide];
        [textLabel1 runAction:hide];
        [textLabel2 runAction:hide];
        [textLabel3 runAction:hide];
    }];
    SKAction *scene3In = [SKAction runBlock:^{
        [fg_3 runAction:show];
        [fg_3 runAction:moveUp];
        [textLabel1 runAction:show];
        [textLabel2 runAction:show];
        [textLabel3 runAction:show];
    }];
    SKAction *scene3Out = [SKAction runBlock:^{
        [fg_3 runAction:hide];
        [textLabel1 runAction:hide];
        [textLabel2 runAction:hide];
        [textLabel3 runAction:hide];
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
        
        SKScene *nextScene = [Game sceneWithSize:self.view.bounds.size];
        nextScene.scaleMode = SKSceneScaleModeAspectFill;
        
        [self runAction:[SKAction runBlock:^{
            
            SKTransition *trans = [SKTransition fadeWithDuration:1];
            [self.view presentScene:nextScene transition:trans];
            
        }]];
    }];
    
}












@end
