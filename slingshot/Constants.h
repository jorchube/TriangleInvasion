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

#pragma mark Game

#define MAXSLINGSTOP 20
#define CHEATINGPENALTY 1000
#define initialTimeIntervalForFallingTriangles 1.2

#pragma mark difficulty settings:

#define intervalForIncreasingTriangleCreationRate 10
#define minIntervalCreationRate 0.3
#define ratioScoreSpeed 0.01
#define intervalDecrementForCreationRate 0.1
#define deadlineLifeDecreaseForAnImpact 0.4
#define powerupPeriod 15 

#pragma mark slingshot body and position

#define  slingshotWidth 10
#define  slingshotHeight 10
#define  slingshotYFromBottom 75

/* Some linker shit happens if I try to declare const double hintAlpha  0.5 */
#define hintAlpha 0.1

#pragma mark slingshot physic parameters

#define  cat_notCollide     0x0
#define  cat_sling          0x1 << 0
#define  cat_simpleObject   0x1 << 1
#define  cat_powerup        0x1 << 2

#define  cat_killerWave     0x1 << 30
#define  cat_deadline       0x1 << 31

#define  slingshotMass  1.0
#define  slingshotForceMult  2.5

#pragma mark objects

#define  minSpeed  60
#define  varSpeed  60

#define  triangleScale  0.5
#define  triangleMass  slingshotMass/2
#define  powerupMass triangleMass


#pragma mark powerup

#define  pow_none  0

#pragma mark actions

/* Actual sling lifespan is slingLifespan + slingFadingTime */
#define  slingLifespan  1.5
#define  slingFadingTime  0.5

#define  timeForObjectToDisappearAfterHit  1.5
#define  timeForObjectToDisappearAfterLanding 0.5

#pragma mark scoring

#define score_slingHitsTriangle 10.0
#define score_triangleHitsTriangle 5.0
#define score_triangleHitsDeadline -10.0
#define score_slingIsShot -5.0

#pragma mark colors

#define color_allColors     @[[SKColor cyanColor],  \
                            [SKColor magentaColor], \
                            [SKColor yellowColor],  \
                            [SKColor orangeColor],  \
                            [SKColor greenColor]]

#define comboLabelAlpha 0.9
#define comboLabelSpawnScale 1.5
#define comboTime 2.0

#pragma mark story
#define story_showFadeInDuration 0.5
#define story_showFadeOutDuration 0.5
#define story_timeBetweenCuts 3
#define story_timeForEachCut 5.5

/* next Scene definitions for Story scene call */
#define next_mainmenu 0
#define next_game 1

#endif
