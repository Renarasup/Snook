//
//  graphView.h
//  SnookerScoreMaster
//
//  Created by andrew glew on 19/03/2015.
//  Copyright (c) 2015 andrew glew. All rights reserved.
//
@protocol graphViewDelegateX
-(void)reloadGrid;
-(void)displayMatchPoint :(int)pointsPlayer1 :(int)pointsPlayer2 :(int)playerIndex :(int)frameRef;
@end

// icons from http://commons.wikimedia.org/wiki/SMirC

#import <UIKit/UIKit.h>
#import "ball.h"
#import "scoreboardVC.h"
#import "ballShot.h"
#import "dbHelper.h"
#import "breakEntry.h"
#import "frameScore.h"


@interface statsV : UIView {
    NSMutableArray *selectedFrameData;
}
@property (assign) id <graphViewDelegateX> delegate;
@property (strong, nonatomic) dbHelper *db;
@property (strong, nonatomic) NSMutableArray *activeMatchData;
@property (strong, nonatomic) NSMutableArray *activeFrameData;
@property (strong, nonatomic) NSMutableArray *statFrameData;
@property (strong, nonatomic) NSMutableArray *selectedFrameData;
@property (assign) int scorePlayer1;
@property (assign) NSUInteger visitNumberOfBalls;
@property (assign) int scorePlayer2;
@property (assign) int currentBreakPlayer1;
@property (assign) int currentBreakPlayer2;
@property (assign) int visitId;
@property (weak, nonatomic) UIView *visitBreakDown;
@property (strong, nonatomic) UIImage *graphPNG;
@property (strong, nonatomic) NSMutableArray *visitShots;
@property (strong, nonatomic) NSMutableArray *matchFramePoints;
@property (assign) NSNumber *visitPlayerIndex;
@property (assign) NSNumber *visitShotType;
@property (assign) NSNumber *visitPoints;
@property (nonatomic) NSString *visitRef;
@property (nonatomic) NSString *timeStamp;
@property (assign) bool matchStatistics;
@property (assign) bool printGraph;
@property (assign) int numberOfFrames;
@property (assign) int matchMaxPoints;
@property (weak, nonatomic) UICollectionView *visitBallGrid;



-(void) drawRect:(CGRect)rect;
-(void) initFrameData;
-(void) resetFrameData;
-(void) loadVisitWindow:(int) visitIndex :(BOOL) fromGraph;
-(void) initMatchGraphData;
- (UIImage *) imageWithView:(statsV *)view;
- (UIImage *) imageWithCollectionView:(UICollectionView *)collectionBreakView;
-(void) setPrint :(BOOL) enabled;
-(void) initDB;
-(bool) initMatch;
-(void) deleteMatchData;
-(void) initFrame :(NSNumber*)currentFrameId;
-(int) getFramePoints:(NSMutableArray*) activeData :(NSNumber*)playerid :(NSNumber *)frameid;
-(int) getQtyOfBallsByColor:(NSMutableArray*) activeData  :(NSNumber*)playerid :(NSNumber*) reqBallPoint;
-(bool) isColourKilled:(NSMutableArray*) activeData :(NSNumber*)reqBallValue;
-(int) getAmtBreakFromBalls:(NSMutableArray*)balls :(NSNumber*)reqShotId;
-(void) removeLastBreak;
-(void) addBreakToData :(breakEntry*) lastBreak;
-(void) getFramesWon :(NSNumber*) frameIndex :(UILabel*) player1Won :(UILabel*) player2Won;
-(bool) setFrameActive :(NSNumber*) frameId :(NSNumber*) activeto :(NSNumber*) activefrom;
-(NSMutableArray*) getData :(NSMutableArray*) frameDataSet :(NSNumber*)frameId;
-(int) getScoreByShotId :(NSMutableArray*) frameDataSet :(NSNumber*)playerId :(NSNumber*)shotId;
-(int) getTotalVisits:(NSMutableArray*) frameDataSet  :(NSNumber*)playerId;
-(int) getTotalScoringVisits:(NSMutableArray*) frameDataSet  :(NSNumber*)playerId;
-(float) getAvgBreakAmt:(NSMutableArray*) frameDataSet :(NSNumber*)playerId;
-(int) getAmtOfBallsPotted:(NSMutableArray*) frameDataSet :(NSNumber*)playerId :(NSNumber*)frameId;
-(int) getHiBreak:(NSMutableArray*) frameDataSet :(NSNumber*)playerId :(NSNumber*)frameId;
-(NSMutableArray *) getHiBreakBalls:(NSMutableArray*) frameDataSet :(NSNumber*)playerId :(NSNumber*)frameId;
-(NSString *)getElapsedTime :(NSNumber *) frameId :(bool)fromArchive;
-(bool) checkElapsedTime :(NSNumber *) frameId;
-(NSString*) composeResultsFile :(NSMutableArray*) frameDataSet :(NSString*) playerName1 :(NSString*) playerName2;
-(NSString*) composeDataFile :(NSMutableArray*) frameDataSet :(NSString*) playerName1 :(NSString*) playerName2;
-(NSNumber*) loadArchiveMatch :(NSArray*)lines :(UITextField*)player1 :(UITextField*)player2 :(breakEntry*)breakText :(int)skins;

-(int)getPotsInPocket:(NSMutableArray*) frameDataSet :(NSNumber*)playerId :(NSNumber*)pocketId :(NSNumber*)shotId;
-(player *)setPlayerData :(player *) reqPlayer;
-(void) updatePlayerData :(player *) reqPlayer;
-(void) insertPlayerData :(player *) reqPlayer;
-(NSNumber*) addNewMatch :(NSNumber *) player1Number :(NSNumber *) player2Number;
-(void) updateMatchPlayers :(NSNumber *) player1Number :(NSNumber *) player2Number;
-(NSNumber*) updateActiveMatch :(player *) p1 :(player *) p2;
-(NSNumber*) getMatchId;



@property (weak, nonatomic) IBOutlet statsV *statistics;



#define kGraphHeight 275
#define kDefaultGraphWidth 275
#define kOffsetX 0
#define kStepX 50
#define kGraphBottom 275
#define kGraphTop 0
#define kStepY 50
#define kOffsetY 0
#define kCircleRadius 4.5
#define kSmallCircleRadius 2.0

@end
