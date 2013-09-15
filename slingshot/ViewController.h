//
//  ViewController.h
//  slingshot
//

//  Copyright (c) 2013 Pau Sastre Miguel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <iAd/iAd.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet ADBannerView *adBanner;

+(ViewController*)getSingleton;
-(void)hideAd;
-(void)showAd;
-(void)pauseGame;
-(void)resumeGame;

@end
