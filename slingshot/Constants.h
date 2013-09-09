//
//  Constants.h
//  slingshot
//
//  Created by Jordi Chulia on 7/31/13.
//  Copyright (c) 2013 Jordi Chulia. All rights reserved.
//

#ifndef slingshot_Constants_h
#define slingshot_Constants_h

#pragma mark scene

#define Xmargin 20

#pragma mark slingshot body and position

#define  slingshotWidth 2.5
#define  slingshotHeight 2.5
#define  slingshotYFromBottom 75

/* Some linker shit happens if I try to declare const double hintAlpha  0.5 */
#define hintAlpha 0.1

#pragma mark slingshot physic parameters

#define  cat_notCollide 0x0
#define  cat_sling  0x1 << 0
#define  cat_simpleObject  0x1 << 1

#define  cat_deadline  0x1 << 31

#define  slingshotMass  1.0
#define  slingshotForceMult  2.5

#pragma mark objects

#define  minSpeed  60
#define  varSpeed  60

#define  triangleScale  0.5
#define  triangleMass  slingshotMass/2


#pragma mark powerup

#define  pow_none  0

#pragma mark actions

/* Actual sling lifespan is slingLifespan + slingFadingTime */
#define  slingLifespan  1.5
#define  slingFadingTime  0.5

#define  timeForObjectToDisappearAfterHit  1.5

#endif
