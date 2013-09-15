//
//  MyScene.m
//  slingshot
//
//  Created by Jordi Chulia on 7/31/13.
//  Copyright (c) 2013 Jordi Chulia. All rights reserved.
//

#import "Game.h"
#import "MainMenu.h"
#import "GameKit.h"

@interface Game() {
    @private
    Sling *idleSling;
    ContactDelegate *contactDelegate;
    SKShapeNode *hint;
    SKLabelNode *comboLabel;
    Deadline *deadline;
    double score;
    int comboCounter;
    NSTimer *resetComboCounterTimer;
    double currentTimeGeneration;
    double speedVariation;
    UIButton *stopButton;
    UIButton *continueButton;
    UIButton *exitButton;
    UIButton *mainMenuButton;
    UILabel *gameOverLabel;
    UILabel *punctuationLabel;
    int maxCombo;
    BOOL gameEnded;
    BOOL gameStoped;
}

@end

@implementation Game

@synthesize scoreLabel;

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        [self setMusicURL:@"Game.mp3"];
        [self startMusic];
        
        [[ViewController getSingleton] showVolumeButton];
        
        gameEnded = false;
        gameStoped = false;
        
		contactDelegate = [[ContactDelegate alloc]initWithPhysicsWorld:self.physicsWorld andDelegator:self];
		[self.physicsWorld setContactDelegate:contactDelegate];
        
        /* Line at the bottom that means the geometric apocalypse will start */
        deadline = [[Deadline alloc] initWithFrame:self.frame];
        [self addChild:deadline];
        
        [self addScoreLabel];
        score = 0;
        [self updateScore:0];
        
        speedVariation = 0;
        
        comboCounter = 0;
        maxCombo = 0;
        [self addComboLabel];
        
        hint = [[SKShapeNode alloc]init];
        hint.alpha = 0.0;
        [self addChild:hint];
        
        self.backgroundColor = [SKColor blackColor];

		[Sling addSlingAtScene:self];
		
        currentTimeGeneration = initialTimeIntervalForFallingTriangles;
        
        [self launchTimer];
		[self speedUpTimer];
        
    }
    return self;
}



-(void) launchTimer {
    SKAction *launch = [SKAction repeatActionForever:[SKAction sequence:@[[SKAction waitForDuration:currentTimeGeneration],
                                                                          [SKAction runBlock:^{[self launchTriangle];}],
                                                                          ]]];
    [self runAction:launch withKey:@"launchTime"];
}
-(void) speedUpTimer {
    SKAction *launch = [SKAction repeatActionForever:[SKAction sequence:@[[SKAction waitForDuration:intervalForIncreasingTriangleCreationRate],
                                                                          [SKAction runBlock:^{

        currentTimeGeneration -= intervalDecrementForCreationRate;
        if (currentTimeGeneration < minIntervalCreationRate) {
            currentTimeGeneration = minIntervalCreationRate;
        }
        [self removeActionForKey:@"launchTime"];
        [self launchTimer];
        if (currentTimeGeneration == minIntervalCreationRate) {
            [self removeActionForKey:@"speedUpTimer"];
        }
        
        
                                                                            }]]]];
    [self runAction:launch withKey:@"speedUpTimer"];
}


-(void) updateScore:(double)scr {
    int mult = (comboCounter<=0)? 1 : comboCounter;
    if(scr > 0)
        score += scr*mult;
    else
        score += scr;
    //if (score < 0) score = 0;
    self.scoreLabel.text = [NSString stringWithFormat:@"%.0f", score];
    speedVariation = ((score<0)?-score:score)*ratioScoreSpeed;
}

-(void) increaseComboCounter {
    ++comboCounter;
    if (comboCounter > maxCombo) maxCombo = comboCounter;
    resetComboCounterTimer = [NSTimer timerWithTimeInterval:comboTime
                                                     target:self
                                                   selector:@selector(resetComboCounter)
                                                   userInfo:nil
                                                    repeats:NO];
    //[[NSRunLoop currentRunLoop] cancelPerformSelectorsWithTarget:self];
    /*[[NSRunLoop currentRunLoop] cancelPerformSelector:@selector(resetComboCounter)
                                               target:self
                                             argument:nil];*/
    [resetComboCounterTimer invalidate];
    [[NSRunLoop currentRunLoop] addTimer:resetComboCounterTimer
                                 forMode:NSDefaultRunLoopMode];
    if(comboCounter > 1){
        [self showCombo];
    }
}

-(int) getComboCounter {
    return comboCounter;
}

-(void) resetComboCounter {
    comboCounter = 0;
}

-(void) showCombo {
    comboLabel.fontColor = [self getColor];
    comboLabel.alpha = comboLabelAlpha;
    comboLabel.text = [NSString stringWithFormat:@"Combo x%i", comboCounter];
    //NSLog(@"Combo x%i", comboCounter);
    [comboLabel runAction:[SKAction sequence:@[
                                               [SKAction fadeAlphaTo:comboLabelAlpha
                                                            duration:0.1],
                                               [SKAction scaleTo:comboLabelSpawnScale
                                                        duration:0.1],
                                               [SKAction group:@[
                                                                 [SKAction fadeAlphaTo:0.0
                                                                              duration:comboTime],
                                                                 [SKAction scaleTo:1.0
                                                                          duration:comboTime]
                                                                 ]]
                                               ]]];
}

-(SKColor*) getColor {
    sranddev();
    NSArray *colors = color_allColors;
    return [colors objectAtIndex:rand()%[colors count]];
}

#pragma mark add initial elements

-(void) addComboLabel {
    comboLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    comboLabel.text = [NSString stringWithFormat:@"Combo x%i", comboCounter];
    comboLabel.fontSize = 16;
    comboLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                      CGRectGetMaxY(self.frame)-100);
    comboLabel.alpha = 0.0;
    
    [self addChild:comboLabel];
}

-(void) addScoreLabel {
	scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue"];
	scoreLabel.text = @"";
	scoreLabel.fontSize = 15;
	scoreLabel.position = CGPointMake(CGRectGetMaxX(self.frame)-20,
                                      CGRectGetMaxY(self.frame)-35);
	
	[self addChild:scoreLabel];
}

-(void) addDummyAtX: (CGFloat)X atY:(CGFloat)Y{
	Triangle *tri = [[Triangle alloc] init];
	tri.position = CGPointMake(X, Y);
	
	[self addChild:tri];
    
}

-(void) addSlingAtPosition:(CGPoint)pos {
    idleSling = [[Sling alloc] init];
	idleSling.position = pos;
	[self addChild:idleSling];
}


# pragma mark object launchers

-(void) launchTriangle {
	Triangle *tri = [[Triangle alloc]init];
	[self launchObject:tri];
}

-(void) launchObject: (SKShapeNode *)object {
	CGFloat Ypos = CGRectGetMaxY(self.frame);
	CGFloat Xpos = ( rand() % (int)(CGRectGetMaxX(self.frame)-(Xmargin*2)) ) + Xmargin;
	
    [object.physicsBody setVelocity:CGVectorMake(0, -((rand()%varSpeed)+minSpeed+speedVariation))];
	
	object.position = CGPointMake(Xpos, Ypos);
	[self addChild:object];
}

#pragma mark touch detection

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    [[Sling getIdlesling] touchesBegan:touches withEvent:event];

}

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [[Sling getIdlesling] touchesMoved:touches withEvent:event];
	
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [[Sling getIdlesling] touchesEnded:touches withEvent:event];

}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}


-(void)didMoveToView:(SKView *)view {
    stopButton = [UIButton buttonWithType:UIButtonTypeSystem];
    stopButton.frame = CGRectMake(5, 5, 80, 50);
    [stopButton setTitle:NSLocalizedString(@"Stop", nil) forState:UIControlStateNormal];
    [stopButton setTitleColor:[SKColor whiteColor] forState:UIControlStateNormal];
    stopButton.titleLabel.font = [UIFont systemFontOfSize:18];
    stopButton.alpha = 0;
    [stopButton addTarget:self action:@selector(stopGame) forControlEvents:UIControlEventTouchUpInside];
    
    
    continueButton = [UIButton buttonWithType:UIButtonTypeSystem];
    continueButton.frame = CGRectMake(CGRectGetMidX(self.frame)-100, CGRectGetMidY(self.frame)-90, 200, 50);
    [continueButton setTitle:NSLocalizedString(@"Continue", nil) forState:UIControlStateNormal];
    [continueButton setTitleColor:[SKColor whiteColor] forState:UIControlStateNormal];
    continueButton.titleLabel.font = [UIFont systemFontOfSize:28];
    [continueButton addTarget:self action:@selector(resumeGame) forControlEvents:UIControlEventTouchUpInside];
    continueButton.alpha = 0;
    continueButton.center = CGPointMake(-200,continueButton.center.y);
    
    
    exitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    exitButton.frame = CGRectMake(CGRectGetMidX(self.frame)-100, CGRectGetMidY(self.frame)-30, 200, 50);
    [exitButton setTitle:NSLocalizedString(@"Exit", nil) forState:UIControlStateNormal];
    [exitButton setTitleColor:[SKColor whiteColor] forState:UIControlStateNormal];
    exitButton.titleLabel.font = [UIFont systemFontOfSize:28];
    [exitButton addTarget:self action:@selector(exitGame) forControlEvents:UIControlEventTouchUpInside];
    exitButton.alpha = 0;
    exitButton.center = CGPointMake(CGRectGetMidX(self.frame)+200,exitButton.center.y);
    
    
    mainMenuButton = [UIButton buttonWithType:UIButtonTypeSystem];
    mainMenuButton.frame = CGRectMake(CGRectGetMidX(self.frame)-200, CGRectGetMidY(self.frame)-30, 400, 50);
    [mainMenuButton setTitle:NSLocalizedString(@"Main Menu", nil) forState:UIControlStateNormal];
    [mainMenuButton setTitleColor:[SKColor whiteColor] forState:UIControlStateNormal];
    mainMenuButton.titleLabel.font = [UIFont fontWithName:@"fipps" size:20];
    [mainMenuButton addTarget:self action:@selector(goMainMenuFromEnd) forControlEvents:UIControlEventTouchUpInside];
    mainMenuButton.alpha = 0;
    mainMenuButton.center = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMinX(self.frame)-100);
    
    
    
    [view addSubview:stopButton];
    [UIView animateWithDuration:1 animations:^{
        stopButton.alpha = 1;
    }];
    
}

-(void)stopGame {
    
    if (gameEnded || gameStoped) return;
    
    gameStoped = true;
    
    self.view.paused = true;
    
    [self.view addSubview:continueButton];
    [self.view addSubview:exitButton];
    
    [UIView animateWithDuration:1 animations:^{
        continueButton.alpha = 1;
        continueButton.center = CGPointMake(CGRectGetMidX(self.frame),continueButton.center.y);
        exitButton.alpha = 1;
        exitButton.center = CGPointMake(CGRectGetMidX(self.frame),exitButton.center.y);
        stopButton.alpha = 0;
    } completion:^(BOOL finished) {
        [stopButton removeFromSuperview];
    }];
    
}

-(void)resumeGame {
    
    if (gameEnded || !gameStoped) return;
    
    gameStoped = false;

    [self.view addSubview:stopButton];
    [UIView animateWithDuration:1 animations:^{
        exitButton.center = CGPointMake(-200,exitButton.center.y);
        continueButton.center = CGPointMake(CGRectGetMidX(self.frame)+200,continueButton.center.y);
        continueButton.alpha = 0;
        exitButton.alpha = 0;
        stopButton.alpha = 1;
    } completion:^(BOOL finished) {
        [continueButton removeFromSuperview];
        [exitButton removeFromSuperview];
        exitButton.center = CGPointMake(CGRectGetMidX(self.frame)+200,exitButton.center.y);
        continueButton.center = CGPointMake(-200,continueButton.center.y);
        self.view.paused = false;
    }];
}

-(void)exitGame {
    
    [self stopMusic];
    
    self.view.paused = false;
    SKTransition *trans = [SKTransition fadeWithDuration:1];
    MainMenu *scene =    [MainMenu sceneWithSize:self.view.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;

    [self.view presentScene:scene transition:trans];
    
    [UIView animateWithDuration:.5 animations:^{
        continueButton.alpha = 0;
        exitButton.alpha = 0;
    } completion:^(BOOL finished) {
        [continueButton removeFromSuperview];
        [exitButton removeFromSuperview];
    }];
    
    


    
}

-(void) decreaseDeadlineLife {
    if (deadline.alpha - deadlineLifeDecreaseForAnImpact <= 0){
        deadline.alpha = 0;
        [self runAction:[SKAction sequence:@[[SKAction waitForDuration:0.4],
                                             [SKAction runBlock:^{[self gameFuckingOver];}]]]];
        
        deadline.physicsBody.collisionBitMask = cat_notCollide;
    }
    else deadline.alpha -= deadlineLifeDecreaseForAnImpact;
}

-(void) gameFuckingOver {
    
    gameEnded = true;
    
    [[GameKit singleton] saveScore:score];
    [[GameKit singleton] saveMaxBonus:maxCombo];
    
    
    
    gameOverLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.frame)-150, -100, 300, 50)];
    gameOverLabel.font = [UIFont fontWithName:@"fipps" size:35];
    gameOverLabel.textAlignment = NSTextAlignmentCenter;
    gameOverLabel.textColor = [SKColor whiteColor];
    gameOverLabel.text = NSLocalizedString(@"Game Over", nil);
    gameOverLabel.alpha = 0;
    [self.view addSubview:gameOverLabel];
    
    punctuationLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMidX(self.frame)-150, -100, 300, 50)];
    punctuationLabel.font = [UIFont fontWithName:@"fipps" size:20];
    punctuationLabel.textAlignment = NSTextAlignmentCenter;
    punctuationLabel.textColor = [SKColor whiteColor];
    punctuationLabel.text = [NSString stringWithFormat:@"%.0f",score];
    punctuationLabel.alpha = 0;
    [self.view addSubview:punctuationLabel];
    
    
    self.view.paused = true;
    [self.view addSubview:mainMenuButton];
    
    [scoreLabel removeFromParent];
    deadline.fillColor = [SKColor redColor];
    deadline.alpha = 0.5;
    
    [UIView animateWithDuration:1 animations:^{
        mainMenuButton.alpha = 1;
        mainMenuButton.center = CGPointMake(mainMenuButton.center.x,CGRectGetMidY(self.frame)+100);
        gameOverLabel.alpha = 1;
        gameOverLabel.center = CGPointMake(gameOverLabel.center.x,100);
        punctuationLabel.alpha = 1;
        punctuationLabel.center = CGPointMake(punctuationLabel.center.x,200);
        stopButton.alpha = 0;
    } completion:^(BOOL finished) {
        [stopButton removeFromSuperview];
    }];
}

-(void) goMainMenuFromEnd {
    
    
    [self stopMusic];
    
    self.view.paused = false;
    
    SKTransition *trans = [SKTransition fadeWithDuration:1];
    MainMenu *scene =    [MainMenu sceneWithSize:self.view.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    [self.view presentScene:scene transition:trans];
    
    [UIView animateWithDuration:.5 animations:^{
        mainMenuButton.alpha = 0;
        gameOverLabel.alpha = 0;
        punctuationLabel.alpha = 0;
    } completion:^(BOOL finished) {
        [mainMenuButton removeFromSuperview];
        [gameOverLabel removeFromSuperview];
        [punctuationLabel removeFromSuperview];
    }];
}

@end
