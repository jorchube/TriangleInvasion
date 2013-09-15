//
//  MyScene.h
//  slingshot
//

//  Copyright (c) 2013 Pau Sastre Miguel. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <StoreKit/StoreKit.h>
#import "SceneImplementation.h"

@interface MainMenu : SceneImplementation <SKPhysicsContactDelegate,SKProductsRequestDelegate,SKPaymentTransactionObserver, UIAccelerometerDelegate,UIAlertViewDelegate>


@end
