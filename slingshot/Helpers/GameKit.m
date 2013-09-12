//
//  GameKit.m
//  slingshot
//
//  Created by Pau Sastre Miguel on 12/09/13.
//  Copyright (c) 2013 Pau Sastre Miguel. All rights reserved.
//

#import "GameKit.h"
#import <GameKit/GameKit.h>
#import "AppDelegate.h"

@interface GameKit() {
    BOOL enabled;
    GKLocalPlayer *player;
}
@end

@implementation GameKit

static GameKit *GKsingleton;

+(GameKit*)singleton {
    if (!GKsingleton){
        GKsingleton = [GameKit new];
    }
    return GKsingleton;
}

-(id)init {
    
    player = [GKLocalPlayer localPlayer];
    
    return self;
}

-(void)authenticatePlayerInViewController:(UIViewController*)rootViewController {

        player.authenticateHandler = ^(UIViewController *viewController, NSError *error){
            if (viewController != nil)
            {
                //showAuthenticationDialogWhenReasonable: is an example method name. Create your own method that displays an authentication view when appropriate for your app.
                [rootViewController presentViewController:viewController animated:YES completion:nil];
            }
        };
    
}

-(void)defaultLeaderboard {
    [[GKLocalPlayer localPlayer] loadDefaultLeaderboardIdentifierWithCompletionHandler:
     ^(NSString *leaderboardIdentifier, NSError *error) {
         NSLog(@"%@",leaderboardIdentifier);
     }];
}

-(void)saveScore:(int)score {

    NSString *leaderboard = (score < 0)?@"worstscore":@"defendtheworld";
    
    GKScore *scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier:leaderboard];
    scoreReporter.value = score;
    scoreReporter.context = 0;
    
    [GKScore reportScores:@[scoreReporter] withCompletionHandler:^(NSError *error) {
        if (error)
            NSLog(@"error reporting the score");
    }];
    
}

-(void)saveMaxBonus:(int)bonus {
    
    GKScore *scoreReporter = [[GKScore alloc] initWithLeaderboardIdentifier:@"biggestcombo"];
    scoreReporter.value = bonus;
    scoreReporter.context = 0;
    
    [GKScore reportScores:@[scoreReporter] withCompletionHandler:^(NSError *error) {
        if (error)
            NSLog(@"error reporting the score");
    }];
    
}




@end
