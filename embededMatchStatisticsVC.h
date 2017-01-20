//
//  matchStatisticsVC.h
//  SnookerScoreMaster
//
//  Created by andrew glew on 15/01/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "player.h"
#import "dbHelper.h"
#import "matchesTV.h"
#import "graphV.h"
#import "singlePlayerStatsV.h"
#import "common.h"
#import "frameStatisticCellTVC.h"
#import <Social/Social.h>

@class embededMatchStatisticsVC;

@protocol EmbededMatchStatisticsDelegate <NSObject>
-(void) addItemViewController:(embededMatchStatisticsVC *)controller keepDisplayState:(int)displayState;
@end

@interface embededMatchStatisticsVC : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id <EmbededMatchStatisticsDelegate> delegate;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintGeneralCellWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintGeneralCellHeight;

@property (weak, nonatomic) IBOutlet UIView *player1View;
@property (weak, nonatomic) IBOutlet UIView *player2View;
@property (weak, nonatomic) IBOutlet UILabel *player1Score;
@property (weak, nonatomic) IBOutlet UILabel *player2Score;
@property (weak, nonatomic) IBOutlet UIImageView *player1Photo;
@property (weak, nonatomic) IBOutlet UIImageView *player2Photo;
@property (weak, nonatomic) IBOutlet UILabel *player1Name;
@property (weak, nonatomic) IBOutlet UILabel *player2Name;
@property (weak, nonatomic) IBOutlet graphV *graphStatisticView;
@property (weak, nonatomic) IBOutlet graphV *graphStatisticsOverlayView;
@property (weak, nonatomic) IBOutlet UIView *overlayView;

@property (weak, nonatomic) IBOutlet UILabel *background;
@property (strong, nonatomic) IBOutlet UIView *footerView;


@property (weak, nonatomic) IBOutlet UIStepper *stepperFrame;
@property (weak, nonatomic) IBOutlet UILabel *graphSummaryLabel;
@property (assign) bool isHollow;
@property (strong, nonatomic) player *p1;
@property (strong, nonatomic) player *p2;
@property (strong, nonatomic) match *m;
@property (strong, nonatomic) match *activeMatchPlayers;
@property (strong, nonatomic) dbHelper *db;
@property (strong, nonatomic) NSMutableArray *activeMatchData;
@property (strong, nonatomic) NSMutableArray *activeFrameData;
@property (strong, nonatomic) NSMutableArray *breakShots;
@property (strong, nonatomic) NSMutableArray *activeShots;
@property (assign) NSUInteger breakShotsCount;
@property (assign) NSNumber *breakShotsPoints ;
@property (nonatomic) NSString *breakShotsReference;
@property (nonatomic) NSString *frameDuration;
@property (assign) NSNumber *breakShotsPlayerId;
@property (assign) NSNumber *breakShotsType;
@property (weak, nonatomic) IBOutlet UIStepper *graphStepper;
@property (weak, nonatomic) IBOutlet UILabel *graphReferenceLabel;

@property (weak, nonatomic) IBOutlet UIButton *MorePlayer1Button;
@property (weak, nonatomic) IBOutlet UIButton *MorePlayer2Button;
@property (weak, nonatomic) IBOutlet singlePlayerStatsV *player1StatView;
@property (weak, nonatomic) IBOutlet singlePlayerStatsV *player2StatView;
@property (weak, nonatomic) IBOutlet UILabel *p1BallAvgLabel;
@property (weak, nonatomic) IBOutlet UILabel *p1HiBreakLabel;
@property (weak, nonatomic) IBOutlet UILabel *p1AvgBreakLabel;
@property (weak, nonatomic) IBOutlet UILabel *p1SumPotsFouls;
@property (weak, nonatomic) IBOutlet UILabel *p1TopBreaks;
@property (weak, nonatomic) IBOutlet UILabel *p1ShotAvgTimeLabel;



@property (weak, nonatomic) IBOutlet UILabel *p1RedCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *p1YellowCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *p1GreenCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *p1BrownCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *p1BlueCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *p1PinkCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *p1BlackCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *p2BallAvgLabel;
@property (weak, nonatomic) IBOutlet UILabel *p2SumPotsFouls;
@property (weak, nonatomic) IBOutlet UILabel *p2TopBreaks;
@property (weak, nonatomic) IBOutlet UILabel *p2ShotAvgTimeLabel;


@property (weak, nonatomic) IBOutlet UILabel *p2HiBreakLabel;
@property (weak, nonatomic) IBOutlet UILabel *p2AvgBreakLabel;
@property (weak, nonatomic) IBOutlet UILabel *p2RedCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *p2YellowCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *p2GreenCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *p2BrownCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *p2BlueCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *p2PinkCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *p2BlackCountLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *p1HiBreakCollection;
@property (weak, nonatomic) IBOutlet UICollectionView *p2HiBreakCollection;
@property (weak, nonatomic) IBOutlet UICollectionView *breakCollection;
@property (weak, nonatomic) IBOutlet UIImageView *snookerTable;
@property (strong, nonatomic) NSString *skinPrefix;
@property (assign) int activeFramePointsRemaining;

@property (strong, nonatomic) NSMutableArray *p1BreakBalls;
@property (strong, nonatomic) NSMutableArray *p2BreakBalls;

@property (assign) bool updateP1Collection;
@property (assign) int displayState;
@property (assign) int breakShotsIndex;

@property (weak, nonatomic) IBOutlet UIView *breakStatistcsView;
@property (assign) bool activeMatchStatistcsShown;

@property (weak, nonatomic) IBOutlet UILabel *borderLabel;

@property (strong, nonatomic) IBOutlet UIButton *tweetButton;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *forwardButton;
@property (weak, nonatomic) IBOutlet UIImageView *p1BreakInfoBall;
@property (weak, nonatomic) IBOutlet UIImageView *p2BreakInfoBall;
@property (weak, nonatomic) IBOutlet UILabel *P2BreakInfo;
@property (weak, nonatomic) IBOutlet UILabel *P1BreakInfo;
@property (weak, nonatomic) IBOutlet UILabel *P2AmountBreak;
@property (weak, nonatomic) IBOutlet UILabel *P1AmountBreak;
@property (weak, nonatomic) IBOutlet UILabel *DurationVisitsLabel;
@property (nonatomic, strong) NSIndexPath *selectedBreakIndexPath;
@property (assign) int theme;
@property (strong, nonatomic) UIColor *redColour;
@property (strong, nonatomic) UIColor *yellowColour;
@property (strong, nonatomic) UIColor *greenColour;
@property (strong, nonatomic) UIColor *brownColour;
@property (strong, nonatomic) UIColor *blueColour;
@property (strong, nonatomic) UIColor *pinkColour;
@property (strong, nonatomic) UIColor *blackColour;
@property (weak, nonatomic) IBOutlet UIImageView *p1ImageBallRed;
@property (weak, nonatomic) IBOutlet UIImageView *p1ImageBallYellow;
@property (weak, nonatomic) IBOutlet UIImageView *p1ImageBallGreen;
@property (weak, nonatomic) IBOutlet UIImageView *p1ImageBallBrown;
@property (weak, nonatomic) IBOutlet UIImageView *p1ImageBallBlue;
@property (weak, nonatomic) IBOutlet UIImageView *p1ImageBallPink;
@property (weak, nonatomic) IBOutlet UIImageView *p1ImageBallBlack;
@property (weak, nonatomic) IBOutlet UIImageView *p2ImageBallRed;
@property (weak, nonatomic) IBOutlet UIImageView *p2ImageBallYellow;
@property (weak, nonatomic) IBOutlet UIImageView *p2ImageBallGreen;
@property (weak, nonatomic) IBOutlet UIImageView *p2ImageBallBrown;
@property (weak, nonatomic) IBOutlet UIImageView *p2ImageBallBlue;
@property (weak, nonatomic) IBOutlet UIImageView *p2ImageBallPink;
@property (weak, nonatomic) IBOutlet UIImageView *p2ImageBallBlack;
@property (strong, nonatomic) IBOutlet UIView *frameStatisticView;
@property (strong, nonatomic) IBOutlet UITableView *tableFrameStatistics;
@property (strong, nonatomic) IBOutlet UIButton *buttonDetailStats;
@property (strong, nonatomic) IBOutlet UIButton *buttonListStats;
@property (strong, nonatomic) IBOutlet UILabel *sliderBorderLabel;
@property (strong, nonatomic) IBOutlet UIView *player2BreakInfoView;
@property (strong, nonatomic) IBOutlet UIView *player1BreakInfoView;
@property (strong, nonatomic) IBOutlet UIView *backgroundView;






@property (strong, nonatomic) UIColor *skinBackgroundColour;
@property (strong, nonatomic) UIColor *skinForegroundColour;
@property (strong, nonatomic) UIColor *skinPlayer1Colour;
@property (strong, nonatomic) UIColor *skinPlayer2Colour;


@end



