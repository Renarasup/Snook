//
//  AppDelegate.h
//  SnookerScoreMaster
//
//  Created by andrew glew on 21/11/2014.
//  Copyright (c) 2014 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RootViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) UIImageView *helpView;

@property (strong, nonatomic) UIColor *themeBackgroundColour;
@property (strong, nonatomic) UIColor *themeForegroundColour;
@property (strong, nonatomic) UIColor *themePlayer1Colour;
@property (strong, nonatomic) UIColor *themePlayer2Colour;
@property (strong, nonatomic) UIColor *themeSelectedScore;
@property (assign) int theme;
@property (assign) int breakThreshholdForCelebration;
@property (assign) bool isUndoShot;
@property (assign) bool isPaused;
@property (assign) bool isMatchStarted;
@property (assign) bool isHollow;
@property (assign) bool isMenuShot;
@property (assign) bool isShotStopWatch;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end

