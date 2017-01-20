//
//  matchListingTVC.h
//  SnookerScoreMaster
//
//  Created by andrew glew on 14/01/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "player.h"
#import "playerDetailVC.h"
#import "dbHelper.h"
#import "match.h"

@class matchListingTVC;

@protocol MatchListingDelegate <NSObject>
@end

@interface matchListingTVC : UITableViewController {}

@property (nonatomic, weak) id <MatchListingDelegate> delegate;
@property (nonatomic) NSNumber *activePlayerNumber;
@property (strong, nonatomic) dbHelper *db;
@property (strong, nonatomic) player *activePlayer;
@property (strong, nonatomic) NSMutableArray  *matches;
@property (strong ,nonatomic) NSMutableDictionary *cachedImages;


@property (strong ,nonatomic) NSMutableDictionary *cachedAvatarP1;
@property (strong ,nonatomic) NSMutableDictionary *cachedAvatarP2;
@property (assign) int staticPlayer1Number;
@property (assign) int staticPlayer2Number;
@property (assign) int staticPlayer1CurrentBreak;
@property (assign) int staticPlayer2CurrentBreak;
@property (strong,nonatomic) NSNumber* activeMatchId;
@property (strong, nonatomic) match *activeMatchPlayers;
@property (assign) int displayState;
@property (assign) int activeFramePointsRemaining;
@property (strong, nonatomic) NSString *skinPrefix;



@end
