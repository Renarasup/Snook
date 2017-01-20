//
//  matchesVC.h
//  SnookerScoreMaster
//
//  Created by andrew glew on 17/07/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "player.h"
#import "playerDetailVC.h"
#import "dbHelper.h"
#import "match.h"

@class matchesVC;

@protocol MatchesDelegate <NSObject>
@end

@interface matchesVC : UIViewController {}


@property (nonatomic, weak) id <MatchesDelegate> delegate;
@property (nonatomic) NSNumber *activePlayerNumber;
@property (strong, nonatomic) dbHelper *db;
@property (strong, nonatomic) player *activePlayer;
@property (strong, nonatomic) NSMutableArray  *matches;
@property (strong, nonatomic) NSMutableArray  *exportMatchData;
@property (strong ,nonatomic) NSMutableDictionary *cachedImages;
@property(nonatomic, strong) IBOutlet UITableView *tableView;

@property (strong ,nonatomic) NSMutableDictionary *cachedAvatarP1;
@property (strong ,nonatomic) NSMutableDictionary *cachedAvatarP2;
@property (assign) int staticPlayer1Number;
@property (assign) int staticPlayer2Number;
@property (assign) int staticPlayer1CurrentBreak;
@property (assign) int staticPlayer2CurrentBreak;
@property (strong,nonatomic) NSNumber* activeMatchId;
@property (strong, nonatomic) match *activeMatchPlayers;
@property (assign) int displayState;
@property (assign) int selectionStyleHighlight;
@property (assign) int activeFramePointsRemaining;
@property (strong, nonatomic) NSString *skinPrefix;
@property (weak, nonatomic) IBOutlet UIButton *cancelExportButton;
@property (weak, nonatomic) IBOutlet UIButton *exportButton;

@property (strong, nonatomic) UIColor *skinBackgroundColour;
@property (strong, nonatomic) UIColor *skinForegroundColour;
@property (strong, nonatomic) UIColor *skinPlayer1Colour;
@property (strong, nonatomic) UIColor *skinPlayer2Colour;

@end
