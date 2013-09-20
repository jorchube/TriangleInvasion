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
#import "Powerup.h"

#define POWERUPS 3

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
    UIButton *powerup[3];
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

		[Sling addSlingAtScene:self withInfoSource:self];
		
        currentTimeGeneration = initialTimeIntervalForFallingTriangles;
        
        [self launchTimer];
		[self speedUpTimer];
        
    }
    return self;
}



-(void) launchTimer {
    SKAction *launch = [SKAction repeatActionForever:[SKAction sequence:@[[SKAction waitForDuration:currentTimeGeneration],
                                                                          [SKAction runBlock:^{[self decideObjectToLaunch];}],
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

-(void) adjustFallingSpeedToScore {
    if (score<0) speedVariation = (-score)*ratioScoreSpeed;
    else speedVariation = score*ratioScoreSpeed;
}

-(void) updateScore:(double)scr {
    int mult = (comboCounter<=0)? 1 : comboCounter;
    if(scr > 0)
        score += scr*mult;
    else
        score += scr;
    //if (score < 0) score = 0;
    self.scoreLabel.text = [NSString stringWithFormat:@"%.0f", score];
    [self adjustFallingSpeedToScore];
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
    scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;
	scoreLabel.position = CGPointMake(CGRectGetMaxX(self.frame)-15,
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
    //NSLog(@"children count: %d", [[self children] count]);
}


# pragma mark object launchers

-(void) decideObjectToLaunch {
    if ((rand()%powerupPeriod) == 0) [self launchPowerup];
    else [self launchTriangle];
}

-(void) launchPowerup {
    Powerup *pow = [[Powerup alloc]init];
    [self launchObject:pow];
}

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
    //NSLog(@"children count: %d", [[self children] count]);
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
    
    
    
    
    //add powerup buttons
    powerup[0] = [UIButton buttonWithType:UIButtonTypeCustom];
    powerup[0].frame = CGRectMake(-17, -17, 35, 35);
    [powerup[0] setImage:[UIImage imageNamed:@"clk.png"] forState:UIControlStateNormal];
    [powerup[0] setImage:[UIImage imageNamed:@"clk_w.png"] forState:UIControlStateDisabled];
    [powerup[0] addTarget:self action:@selector(powerup1) forControlEvents:UIControlEventTouchUpInside];
    powerup[0].center = CGPointMake(CGRectGetMaxX(self.frame)-25,CGRectGetMinY(self.frame)+70);
    powerup[0].enabled = NO;
    
    powerup[1] = [UIButton buttonWithType:UIButtonTypeCustom];
    powerup[1].frame = CGRectMake(-17, -17, 35, 35);
    [powerup[1] setImage:[UIImage imageNamed:@"exp.png"] forState:UIControlStateNormal];
    [powerup[1] setImage:[UIImage imageNamed:@"exp_w.png"] forState:UIControlStateDisabled];
    [powerup[1] addTarget:self action:@selector(powerup2) forControlEvents:UIControlEventTouchUpInside];
    powerup[1].center = CGPointMake(CGRectGetMaxX(self.frame)-25,CGRectGetMinY(self.frame)+110);
    powerup[1].enabled = NO;
    
    powerup[2] = [UIButton buttonWithType:UIButtonTypeCustom];
    powerup[2].frame = CGRectMake(-17, -17, 35, 35);
    [powerup[2] setImage:[UIImage imageNamed:@"wall.png"] forState:UIControlStateNormal];
    [powerup[2] setImage:[UIImage imageNamed:@"wall_w.png"] forState:UIControlStateDisabled];
    [powerup[2] addTarget:self action:@selector(powerup3) forControlEvents:UIControlEventTouchUpInside];
    powerup[2].center = CGPointMake(CGRectGetMaxX(self.frame)-25,CGRectGetMinY(self.frame)+150);
    powerup[2].enabled = NO;
    
    [self.view addSubview:powerup[0]];
    [self.view addSubview:powerup[1]];
    [self.view addSubview:powerup[2]];
    
}

-(void)removeButtons {
    
    [UIView animateWithDuration:1 animations:^{
        powerup[0].alpha = 0;
        powerup[1].alpha = 0;
        powerup[2].alpha = 0;
    } completion:^(BOOL finished) {
        [powerup[0] removeFromSuperview];
        [powerup[1] removeFromSuperview];
        [powerup[2] removeFromSuperview];
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
    
    [powerup[0] setUserInteractionEnabled:NO];
    [powerup[1] setUserInteractionEnabled:NO];
    [powerup[2] setUserInteractionEnabled:NO];

    
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
    
    [powerup[0] setUserInteractionEnabled:YES];
    [powerup[1] setUserInteractionEnabled:YES];
    [powerup[2] setUserInteractionEnabled:YES];
    
}

-(void)exitGame {
    
    [self stopMusic];
    [self removeButtons];
    
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
    
    [self removeButtons];
    
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
    
    
    [[ViewController getSingleton] hideVolumeButton];
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

-(BOOL)isStoped {
    return gameStoped;
}

-(void)cheatingDone {
    
    score += (score>0)?-CHEATINGPENALTY:CHEATINGPENALTY;
    
}

-(void) unleashKillerWave {
    SKShapeNode *line = [[SKShapeNode alloc]init];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, 0, 100);
    CGPathAddLineToPoint(path, nil, CGRectGetMaxX(self.frame), 100);
    CGPathAddLineToPoint(path, Nil, CGRectGetMaxX(self.frame), 95);
    CGPathAddLineToPoint(path, Nil, 0, 95);
    CGPathCloseSubpath(path);
    line.path = path;
    line.alpha = 0;
    
    SKPhysicsBody *pb = [SKPhysicsBody bodyWithPolygonFromPath:path];
    pb.categoryBitMask = cat_killerWave;
    pb.collisionBitMask = cat_simpleObject | cat_powerup;
    pb.contactTestBitMask = cat_simpleObject | cat_powerup;
    
    line.physicsBody = pb;
    
    //SKAction *tiraParribaDeMierda = [SKAction moveToY:CGRectGetMaxY(self.frame) duration:5];
    [self addChild:line];
    //[line runAction:tiraParribaDeMierda];
    line.physicsBody.affectedByGravity = NO;
    line.physicsBody.mass = INT64_MAX;
    line.physicsBody.velocity = CGVectorMake(0, 500);
    
    [line runAction:[SKAction sequence:@[[SKAction waitForDuration:5],[SKAction removeFromParent]]]];
    
}

-(void) slowTriangles {
    for (SKNode *node in [self children]) {
        if ([node class] == [Triangle class] || [node class] == [Powerup class]) {
            CGVector oldSpeed = node.physicsBody.velocity;
            [node runAction:[SKAction customActionWithDuration:speedDownAnimationTime
                                                   actionBlock:^(SKNode *node, CGFloat elapsedTime) {
                                                       CGVector newSpeed = CGVectorMake(oldSpeed.dx-oldSpeed.dx*(1-speedDown)*elapsedTime,
                                                                                        oldSpeed.dy-oldSpeed.dy*(1-speedDown)*elapsedTime);
                                                       node.physicsBody.velocity = newSpeed;
                                                   }]];
        }
    }
}


-(void) addWalls {
    
    SKShapeNode *leftWall = [[SKShapeNode alloc] init];
    leftWall.path = CGPathCreateWithRect(CGRectMake(CGRectGetMinX(self.frame),
                                                    CGRectGetMinY(self.frame),
                                                    5,
                                                    CGRectGetHeight(self.frame)), nil);
    leftWall.strokeColor = [SKColor greenColor];
    leftWall.fillColor = [SKColor greenColor];
    leftWall.glowWidth = 1;
    
    SKPhysicsBody *leftWallPB = [SKPhysicsBody bodyWithPolygonFromPath:leftWall.path];
    [leftWallPB setCategoryBitMask:cat_bonuswall];
    [leftWallPB setCollisionBitMask:cat_sling];
    [leftWallPB setContactTestBitMask:cat_bonuswall | cat_sling];
    
    [leftWallPB setRestitution:1];
    [leftWallPB setAffectedByGravity:NO];
    [leftWallPB setUsesPreciseCollisionDetection:YES];
    [leftWallPB setDynamic:NO];
    leftWall.physicsBody = leftWallPB;
    
    SKShapeNode *rightWall = [[SKShapeNode alloc] init];
    rightWall.path = CGPathCreateWithRect(CGRectMake(CGRectGetMaxX(self.frame)-5,
                                                    CGRectGetMinY(self.frame),
                                                    5,
                                                    CGRectGetHeight(self.frame)), nil);
    rightWall.strokeColor = [SKColor greenColor];
    rightWall.fillColor = [SKColor greenColor];
    rightWall.glowWidth = 1;
    
    SKPhysicsBody *rightWallPB = [SKPhysicsBody bodyWithPolygonFromPath:rightWall.path];
    
    [rightWallPB setCategoryBitMask:cat_bonuswall];
    [rightWallPB setCollisionBitMask:cat_sling];
    [rightWallPB setContactTestBitMask:cat_bonuswall | cat_sling];
    
    [rightWallPB setRestitution:1];
    [rightWallPB setAffectedByGravity:NO];
    [rightWallPB setUsesPreciseCollisionDetection:YES];
    [rightWallPB setDynamic:NO];
    rightWall.physicsBody = rightWallPB;
    
    [self addChild:leftWall];
    [self addChild:rightWall];
    
    SKAction *glowEffect = [SKAction sequence:@[
                                                [SKAction customActionWithDuration:0.5
                                                                       actionBlock:^(SKNode *node, CGFloat elapsedTime) {
                                                                           rightWall.glowWidth = 1 + elapsedTime * 8;
                                                                           leftWall.glowWidth = 1 + elapsedTime * 8;
                                                                       }],
                                                [SKAction customActionWithDuration:0.5
                                                                       actionBlock:^(SKNode *node, CGFloat elapsedTime) {
                                                                           rightWall.glowWidth = 5 - elapsedTime * 8;
                                                                           leftWall.glowWidth = 5 - elapsedTime * 8;
                                                                       }]
                                                ]];
    glowEffect.timingMode = SKActionTimingEaseInEaseOut;
    
    [self runAction:[SKAction sequence:@[
                                         [SKAction repeatAction:glowEffect
                                                          count:20],
                                         [SKAction runBlock:^{
                                            [leftWall removeFromParent];
                                            [rightWall removeFromParent];
                                            powerup[2].userInteractionEnabled = YES;
                                            }]
                                         ]]];
    
}

#pragma mark powerup functions

-(void)powerup1 {
    powerup[0].enabled = NO;
    [self slowTriangles];
}

-(void)powerup2 {
    powerup[1].enabled = NO;
    [self unleashKillerWave];
}

-(void)powerup3 {
    powerup[2].enabled = NO;
    powerup[2].userInteractionEnabled = NO;
    [self addWalls];
}

-(CGPoint)getPowerUpButtonPosition:(int)button {
    return powerup[button].center;
}

-(void)enablePowerUp:(int)button {
    powerup[button].enabled = YES;
}

@end
