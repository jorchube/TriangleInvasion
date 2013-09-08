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

const int Xmargin = 20;

#pragma mark slingshot body and position

const double slingshotWidth = 2.5;
const double slingshotHeight = slingshotWidth;
const double slingshotYFromBottom = 75;

/* Some linker shit happens if I try to declare const double hintAlpha = 0.5 */
#define hintAlpha 0.1

#pragma mark slingshot physic parameters

const uint32_t cat_notCollide = 0x0;
const uint32_t cat_sling = 0x1 << 0;
const uint32_t cat_simpleObject = 0x1 << 1;

const uint32_t cat_deadline = 0x1 << 31;

const double slingshotMass = 1.0;
const double slingshotForceMult = 2.5;

#pragma mark objects

const int minSpeed = 60;
const int varSpeed = 60;

const double triangleScale = 0.5;
const double triangleMass = slingshotMass/2;


#pragma mark powerup

const int pow_none = 0;

#pragma mark actions

/* Actual sling lifespan is slingLifespan + slingFadingTime */
const double slingLifespan = 1.5;
const double slingFadingTime = 0.5;

const double timeForObjectToDisappearAfterHit = 1.5;

#endif
