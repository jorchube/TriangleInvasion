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
#import <StoreKit/StoreKit.h>

@interface MainMenu() {
    @private
    SKLabelNode *newGame, *credits;
    Sling *sling;
    SKSpriteNode *hand;
    BOOL transitioning;
    UIButton *removeAdButton;
}
@end

@implementation MainMenu

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        
        transitioning = false;
        
        self.backgroundColor = [SKColor blackColor];
        
        self.anchorPoint = CGPointMake(0.5, -1);
        
        [self addLabels];
        [Sling addSlingAtScene:self];
        [self addChild:[[Deadline alloc] initWithFrame:self.frame]];
        
        
        SKEmitterNode *sparks = [NSKeyedUnarchiver unarchiveObjectWithFile:
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
}



#pragma mark contact delegate

-(void) didBeginContact:(SKPhysicsContact *)contact {
	SKNode *bodyA = [contact bodyA].node;
	SKNode *bodyB = [contact bodyB].node;

    if (!transitioning && (bodyA == credits || bodyB == credits) ){
        [self showCredits];
        transitioning = true;
    }else if (!transitioning && (bodyA == newGame || bodyB == newGame) ){
        [self setNewGame];
        transitioning = true;
    }
}



#pragma mark menu functions

-(void) showCredits {
    
    [self removeAdButton];
    
    SKAction *changeView = [SKAction runBlock:^{
        SKTransition *trans = [SKTransition fadeWithDuration:1];
        Credits *creditView =    [Credits sceneWithSize:self.view.bounds.size];
        creditView.scaleMode = SKSceneScaleModeAspectFill;
        
        [self.view presentScene:creditView transition:trans];
    }];
    
    [self runAction:[SKAction sequence:@[[SKAction rotateByAngle:1 duration:3], changeView]]];
}

-(void) setNewGame {
    
    [self removeAdButton];
    
    SKScene *nextScene;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults objectForKey:@"story"]){
        
        nextScene = [Story sceneWithSize:self.view.bounds.size];
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

    [self runAction:[SKAction sequence:@[[SKAction rotateByAngle:-1 duration:3], changeView]]];
}




#pragma mark removing ad button

-(void)removeAdButton {
    [UIView animateWithDuration:.5 animations:^{
        removeAdButton.alpha = 0;
    } completion:^(BOOL finished) {
        [removeAdButton removeFromSuperview];
    }];
}

-(void)didMoveToView:(SKView *)view {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults boolForKey:@"removeAd"]) {

        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
        removeAdButton = [UIButton buttonWithType:UIButtonTypeSystem];
        removeAdButton.frame = CGRectMake(0, 5, self.frame.size.width, 50);
        [removeAdButton setTitle:NSLocalizedString(@"Remove Ads", nil) forState:UIControlStateNormal];
        removeAdButton.titleLabel.font = [UIFont systemFontOfSize:18];
        removeAdButton.alpha = 0;
        [removeAdButton addTarget:self action:@selector(buyRemoveAd) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:removeAdButton];
        
        [UIView animateWithDuration:1 animations:^{
            removeAdButton.alpha = 1;
        }];

    }
}

-(void)buyRemoveAd {
    
    NSSet *productID = [NSSet setWithObjects:@"removeAd", nil];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:productID];
    request.delegate = self;
    
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {

    SKProduct *product = [response.products firstObject];
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
}


- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    for (SKPaymentTransaction * transaction in transactions) {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [defaults setBool:YES forKey:@"removeAd"];
                [self removeAdButton];
                [[ViewController getSingleton] removeAd];
                [self removeAdButton];
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            default:
                break;
        }
    };
}



@end
