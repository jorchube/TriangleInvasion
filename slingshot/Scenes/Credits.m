//
//  Credits.m
//  slingshot
//
//  Created by Pau Sastre Miguel on 08/09/13.
//  Copyright (c) 2013 Pau Sastre Miguel. All rights reserved.
//

#import "Credits.h"
#import "Sling.h"
#import "Deadline.h"
#import "MainMenu.h"

@interface Credits() {
    SKLabelNode *backLabel;
}
@end


@implementation Credits

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        self.backgroundColor = [SKColor blackColor];
        
        
        [self addLabels];
        [Sling addSlingAtScene:self];
        [self addChild:[[Deadline alloc] initWithFrame:self.frame]];
        
        
        SKEmitterNode *sparks = [NSKeyedUnarchiver unarchiveObjectWithFile:
                                 [[NSBundle mainBundle] pathForResource:@"credits" ofType:@"sks"]];
        sparks.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMinY(self.frame));
        sparks.targetNode = self;
        [sparks advanceSimulationTime:100];
        [self addChild:sparks];
        
        
        [self.physicsWorld setContactDelegate:self];
        
    }
    return self;
}


-(void) addLabels {

    backLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue"];
    SKLabelNode *pau = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue"];
    SKLabelNode *jordi = [SKLabelNode labelNodeWithFontNamed:@"Helvetica Neue"];

    backLabel.fontSize = 18;
    pau.fontSize = 18;
    jordi.fontSize = 18;
    
    
    backLabel.position = CGPointMake(CGRectGetMidX(self.frame)-70,
                               CGRectGetMidY(self.frame));
    pau.position = CGPointMake(CGRectGetMidX(self.frame)+70,
                                   CGRectGetMidY(self.frame)-30);
    jordi.position = CGPointMake(CGRectGetMidX(self.frame)+70,
                                   CGRectGetMidY(self.frame)+40);
    
    backLabel.text = NSLocalizedString(@"Back", nil);
    pau.text = @"Pau Sastre";
    jordi.text = @"Jordi Chulia";
    
    SKPhysicsBody *backLabelPB = [SKPhysicsBody bodyWithRectangleOfSize:pau.frame.size];
    SKPhysicsBody *newGamePB = [SKPhysicsBody bodyWithRectangleOfSize:pau.frame.size];
    SKPhysicsBody *creditsPB = [SKPhysicsBody bodyWithRectangleOfSize:jordi.frame.size];
    

    [backLabelPB setDynamic:NO];
    [backLabelPB setAffectedByGravity:NO];
    
    [newGamePB setDynamic:NO];
    [newGamePB setAffectedByGravity:NO];
    
    [creditsPB setDynamic:NO];
    [creditsPB setAffectedByGravity:NO];

    [backLabel setPhysicsBody:backLabelPB];
    [pau setPhysicsBody:newGamePB];
    [jordi setPhysicsBody:creditsPB];
    
    [self addChild:backLabel];
    [self addChild:pau];
    [self addChild:jordi];
    
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
    
    if (bodyA == backLabel || bodyB == backLabel){
        [self goBack];
    }
}

-(void)goBack {
    
    SKAction *changeView = [SKAction runBlock:^{
        SKTransition *trans = [SKTransition fadeWithDuration:1];
        MainMenu *scene =    [MainMenu sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        [self.view presentScene:scene transition:trans];
    }];
    
    [self runAction:changeView];
}







@end
