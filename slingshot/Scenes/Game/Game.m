//
//  MyScene.m
//  slingshot
//
//  Created by Jordi Chulia on 7/31/13.
//  Copyright (c) 2013 Jordi Chulia. All rights reserved.
//

#import "Game.h"


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
    UIButton *stopButton;
}

@end

@implementation Game

@synthesize scoreLabel;

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
		
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
        [self addComboLabel];
        
        hint = [[SKShapeNode alloc]init];
        hint.alpha = 0.0;
        [self addChild:hint];
        
        self.backgroundColor = [SKColor blackColor];

		[Sling addSlingAtScene:self];
		
		triangleTimer = [NSTimer timerWithTimeInterval:initialTimeIntervalForFallingTriangles
                                                         target:self
                                                       selector:@selector(launchTriangle)
                                                       userInfo:nil
                                                        repeats:YES];
        
		[[NSRunLoop currentRunLoop] addTimer:triangleTimer forMode:NSDefaultRunLoopMode];
        
        NSTimer *increaseTriangleFreqTimer = [NSTimer timerWithTimeInterval:intervalForIncreasingTriangleCreationRate
                                                                     target:self
                                                                   selector:@selector(speedupTriangleGeneration)
                                                                   userInfo:nil
                                                                    repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:increaseTriangleFreqTimer forMode:NSDefaultRunLoopMode];
		
        
    }
    return self;
}

-(void) speedupTriangleGeneration {
    double interval = triangleTimer.timeInterval -0.1;
    if(interval < minIntervalCreationRate) interval=minIntervalCreationRate;
    [triangleTimer invalidate];
    triangleTimer = [NSTimer timerWithTimeInterval:interval
                                            target:self
                                          selector:@selector(launchTriangle)
                                          userInfo:nil
                                           repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:triangleTimer forMode:NSDefaultRunLoopMode];
}

-(void) updateScore:(double)scr {
    int mult = (comboCounter<=0)? 1 : comboCounter;
    if(scr > 0)
        score += scr*mult;
    else
        score += scr;
    if (score < 0) score = 0;
    self.scoreLabel.text = [NSString stringWithFormat:@"%.0f", score];
    speedVariation = score*ratioScoreSpeed;
}

-(void) increaseComboCounter {
    ++comboCounter;
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
	scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
	scoreLabel.text = @"";
	scoreLabel.fontSize = 12;
	scoreLabel.position = CGPointMake(CGRectGetMaxX(self.frame)-30,
                                      CGRectGetMaxY(self.frame)-30);
	
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
    stopButton.frame = CGRectMake(5, 5, 100, 50);
    [stopButton setTitle:@"stop" forState:UIControlStateNormal];
    stopButton.titleLabel.textColor = [UIColor whiteColor];
    
    [stopButton addTarget:self action:@selector(stopGame) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:stopButton];
}

-(void)stopGame {
    self.view.paused = true;
    [stopButton addTarget:self action:@selector(resumeGame) forControlEvents:UIControlEventTouchUpInside];
}

-(void)resumeGame {
    self.view.paused = false;
    [stopButton addTarget:self action:@selector(stopGame) forControlEvents:UIControlEventTouchUpInside];
}

@end