//
//  playerDetailVC.h
//  SnookerScoreMaster
//
//  Created by andrew glew on 07/01/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "playerListingVC.h"
#import "headToHeadListingVC.h"
#import "matchesVC.h"
#import "player.h"
#import "breakBallCell.h"
#import "ballShot.h"
#import "match.h"
#import "dbHelper.h"
#import "AvatarV.h"
#import "common.h"
#import "NSDate+TimeAgo.h"

@class playerDetailVC;
@protocol PlayerDelegate <NSObject>
- (void)addItemViewController:(playerDetailVC *)controller didUpdatePlayer :(NSNumber*) newPlayerNumber :(int)playerId :(NSString*) playerName :(NSString*) playerEmail :(NSString*) playerImageName :(bool)photoUpdated;
- (void)addItemViewController:(playerDetailVC *)controller didInsertPlayer :(int)nextPlayerNumber :(NSString*) playerName :(NSString*) playerEmail :(NSString*) playerImageName :(bool)photoUpdated :(NSString*) playerkey;
@end
@interface playerDetailVC : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, weak) id <PlayerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *imageSelectedPlayer;
@property (weak, nonatomic) IBOutlet UITextField *playerNickName;
@property (weak, nonatomic) IBOutlet UITextField *playerEmail;
@property (assign) int playerIndex;
@property (assign) bool viewDismissed;
@property (assign) bool isHollow;
@property (assign) int nextPlayerNumber;
@property (assign) int currentPlayerNumber;
//@property (assign) int currentPlayerHiBreak;
@property (assign) int staticPlayer1Number;
@property (assign) int staticPlayer2Number;
@property (assign) int staticPlayer1CurrentBreak;
@property (assign) int staticPlayer2CurrentBreak;
@property (strong,nonatomic) NSNumber* currentPlayerHiBreak;
@property (strong,nonatomic) NSNumber* activeMatchId;
@property (strong, nonatomic) NSMutableArray     *currentPlayerHighestBreakHistory;
@property (strong, nonatomic) NSMutableArray     *activeBreakShots;
@property (assign) bool photoUpdated;
@property (strong, nonatomic) NSString *nickName;
@property (strong, nonatomic) NSString *nextPlayerKey;
@property (strong, nonatomic) NSString *currentPlayerKey;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *imagePathPhoto;
@property (strong, nonatomic) NSMutableArray *historyBreakShots;
@property (strong, nonatomic) match *activeMatchPlayers;
@property (strong, nonatomic) NSString *skinPrefix;
@property (assign) int theme;
@property (weak, nonatomic) IBOutlet UILabel *breakShownLabel;
@property (weak, nonatomic) IBOutlet UIView *avatarPlayer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintAvatarWidth;
@property (assign) int activeFramePointsRemaining;
@property (strong, nonatomic) dbHelper *db;
@property (strong, nonatomic) player *p1; // represents this player
@property (strong, nonatomic) player *p2; // represents the other player

@property (strong, nonatomic) UIColor *skinBackgroundColour;
@property (strong, nonatomic) UIColor *skinForegroundColour;
@property (strong, nonatomic) UIColor *skinPlayer1Colour;
@property (strong, nonatomic) UIColor *skinPlayer2Colour;
@end
