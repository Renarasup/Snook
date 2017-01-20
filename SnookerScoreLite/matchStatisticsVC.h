//
//  matchStatistics.h
//  SnookerScoreMaster
//
//  Created by andrew glew on 16/01/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "player.h"
#import "embededMatchStatisticsVC.h"
#import "matchesVC.h"
#import "match.h"

@class matchStatisticsVC;

@protocol MatchStatisticsDelegate <NSObject>
- (void)addItemViewController:(matchStatisticsVC *)controller keepDisplayState:(int)displayState;
@end

@interface matchStatisticsVC : UIViewController {}
@property (nonatomic, weak) id <MatchStatisticsDelegate> delegate;
@property (strong, nonatomic) player *p1;
@property (strong, nonatomic) player *p2;
@property (strong, nonatomic) match *m;
@property (strong, nonatomic) match *activeMatchPlayers;
@property (strong, nonatomic) NSMutableArray *activeMatchData;
@property (strong, nonatomic) NSMutableArray *activeFrameData;
@property (strong, nonatomic) NSMutableArray *activeShots;
@property (assign) bool activeMatchStatistcsShown;
@property (assign) int displayState;
@property (strong, nonatomic) NSString *skinPrefix;
@property (assign) int activeFramePointsRemaining;
@property (strong, nonatomic) dbHelper *db;
@property (assign) bool isHollow;
@property (assign) int theme;

@property (strong, nonatomic) UIColor *skinBackgroundColour;
@property (strong, nonatomic) UIColor *skinForegroundColour;
@property (strong, nonatomic) UIColor *skinPlayer1Colour;
@property (strong, nonatomic) UIColor *skinPlayer2Colour;

@end

