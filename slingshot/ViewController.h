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

@property (readonly) BOOL musicEnable;
@property (weak, nonatomic) IBOutlet ADBannerView *adBanner;
@property (weak, nonatomic) IBOutlet UIButton *volumeButton;

+(ViewController*)getSingleton;
-(void)hideAd;
-(void)showAd;
-(void)pauseGame;
-(void)resumeGame;

- (IBAction)volumeChange:(id)sender;

@end
