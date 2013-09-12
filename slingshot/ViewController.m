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

@implementation ViewController

static ViewController *viewController;

+(ViewController*)getSingleton {
    return viewController;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    viewController = self;

    [[GameKit singleton] authenticatePlayerInViewController:self];
    
    [self checkAd];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    SKScene * scene = [MainMenu sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    

    
    // Present the scene.
    [skView presentScene:scene];
}


-(void)checkAd {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if ([defaults boolForKey:@"removeAd"]) {
        [_adBanner removeFromSuperview];
        _adBanner = nil;
    }
}

-(void)removeAd {
    [UIView animateWithDuration:1 animations:^{
        _adBanner.alpha = 0;
    } completion:^(BOOL finished) {
        [_adBanner removeFromSuperview];
        _adBanner = nil;
    }];
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
