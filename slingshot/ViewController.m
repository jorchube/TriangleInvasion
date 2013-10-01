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
#import <StoreKit/StoreKit.h>

@interface ViewController() {
    SKView *mainView;
    UIButton *removeAdButton;
    UIButton *restoreBuy;
    
    //variable for the payment process
    SKPayment *payment;
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

    //[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"removeAd"];
    //[[NSUserDefaults standardUserDefaults] synchronize];

    
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



#pragma mark add button stuff

-(void)removeAdButton {
    [UIView animateWithDuration:.5 animations:^{
        removeAdButton.alpha = 0;
        restoreBuy.alpha = 0;
    } completion:^(BOOL finished) {
        [removeAdButton setHidden:YES];
        [restoreBuy setHidden:YES];
    }];
}

-(void)showRemoveAdButton {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if (![defaults boolForKey:@"removeAd"]) {
        
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        
        if (!removeAdButton){
            
            removeAdButton = [UIButton buttonWithType:UIButtonTypeSystem];
            removeAdButton.frame = CGRectMake(0, 65, self.view.frame.size.width/2, 50);
            [removeAdButton setTitle:NSLocalizedString(@"Remove Ads", nil) forState:UIControlStateNormal];
            removeAdButton.titleLabel.font = [UIFont systemFontOfSize:18];
            removeAdButton.alpha = 0;
            [removeAdButton addTarget:self action:@selector(buyRemoveAd) forControlEvents:UIControlEventTouchUpInside];
            
            [self.view addSubview:removeAdButton];
            
        }
        if (!restoreBuy) {
            restoreBuy = [UIButton buttonWithType:UIButtonTypeSystem];
            restoreBuy.frame = CGRectMake(self.view.frame.size.width/2, 65, self.view.frame.size.width/2, 50);
            [restoreBuy setTitle:NSLocalizedString(@"Restore", nil) forState:UIControlStateNormal];
            restoreBuy.titleLabel.font = [UIFont systemFontOfSize:18];
            restoreBuy.alpha = 0;
            [restoreBuy addTarget:self action:@selector(restorePurchase) forControlEvents:UIControlEventTouchUpInside];
            
            [self.view addSubview:restoreBuy];
        }
        
        [removeAdButton setHidden:NO];
        [restoreBuy setHidden:NO];
        
        [UIView animateWithDuration:1 animations:^{
            removeAdButton.alpha = 1;
            restoreBuy.alpha = 1;
        }];
        
    }
}

#pragma mark restoring purchases

-(void)restorePurchase{
    [[SKPaymentQueue defaultQueue]   restoreCompletedTransactions];
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {

    NSLog(@"Restored Transactions are once again in Queue for purchasing");
    
    for (SKPaymentTransaction *transaction in queue.transactions) {
        NSString *productID = transaction.payment.productIdentifier;
        if ([productID isEqualToString:@"removeAd"]) {
            [self removeAdPurchased];
        }
        else {
            UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Nothing to restore"
                                                              message:@"You don't have any purchase to be restored"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles:nil];
            [message show];
        }
    }
}

#pragma mark buying purchases

-(void)buyRemoveAd {
    
    NSSet *productID = [NSSet setWithObjects:@"removeAd", nil];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:productID];
    request.delegate = self;
    [request start];
    
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    
    SKProduct *product = [response.products firstObject];
    payment = [SKPayment paymentWithProduct:product];
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:product.localizedTitle
                                                      message:product.localizedDescription
                                                     delegate:self
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    [message show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (payment != nil) {
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
}


- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions {
    
    for (SKPaymentTransaction * transaction in transactions) {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self removeAdPurchased];
                NSLog(@"Remove Ad bought");
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            default:
                break;
        }
    };
}

-(void)removeAdPurchased {
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"removeAd"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[ViewController getSingleton] hideAd];
    [self removeAdButton];
    
}

#pragma mark volume buttons
-(void)hideVolumeButton {
    _volumeButton.hidden = true;
}
-(void)showVolumeButton {
    _volumeButton.hidden = false;
}



@end
