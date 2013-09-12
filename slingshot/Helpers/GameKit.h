//
//  GameKit.h
//  slingshot
//
//  Created by Pau Sastre Miguel on 12/09/13.
//  Copyright (c) 2013 Pau Sastre Miguel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameKit : NSObject {

}

+(GameKit*)singleton;
-(void)saveScore:(int)score;
-(void)authenticatePlayerInViewController:(UIViewController*)rootViewController;
-(void)defaultLeaderboard;
@end
