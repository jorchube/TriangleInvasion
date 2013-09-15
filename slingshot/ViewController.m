//
//  ViewController.m
//  slingshot
//
//  Created by Pau Sastre Miguel on 06/09/13.
//  Copyright (c) 2013 Pau Sastre Miguel. All rights reserved.
//

#import "ViewController.h"
#import "MainMenu.h"
#import "GameKit.h"
#import "Game.h"
#import "SceneImplementation.h"

@interface ViewController() {
    SKView *mainView;
}

@end

@implementation ViewController

static ViewController *viewController;

+(ViewController*)getSingleton {
    return viewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _musicEnable = true;
    
    viewController = self;

    [[GameKit singleton] authenticatePlayerInViewController:self];
    
    [self checkAd];
    
    // Configure the view.
    mainView = (SKView *)self.view;
    //mainView.showsFPS = YES;
    //mainView.showsNodeCount = YES;
    
    // Create and configure the scene.
    SKScene * scene = [MainMenu sceneWithSize:mainView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    

    
    // Present the scene.
    [mainView presentScene:scene];
    
    [UIApplication sharedApplication].statusBarHidden = YES;

}

-(void)pauseGame {
    if ([mainView.scene class] == [Game class]){
        [(Game*)mainView.scene stopGame];
    }
}
-(void)resumeGame {
    if ([mainView.scene class] == [Game class]){
        [(Game*)mainView.scene resumeGame];
    }
}

- (IBAction)volumeChange:(id)sender {
    
    _volumeButton.selected = !_volumeButton.selected;
    _musicEnable = !_volumeButton.selected;
    
    if (_volumeButton.selected)
        [(SceneImplementation*)mainView.scene stopMusic];
    else
        [(SceneImplementation*)mainView.scene startMusic];
    
}


-(void)checkAd {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if ([defaults boolForKey:@"removeAd"]) {
        [_adBanner removeFromSuperview];
        _adBanner = nil;
    }
}

-(void)hideAd {
    [UIView animateWithDuration:1 animations:^{
        _adBanner.alpha = 0;
    } completion:^(BOOL finished) {
        [self checkAd];
    }];
}

-(void)showAd {
    [UIView animateWithDuration:1 animations:^{
        _adBanner.alpha = 1;
    }];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}



@end
