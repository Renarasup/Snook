//
//  ViewController.m
//  SnookerScorer
//
//  Created by andrew glew on 05/11/2014.
//  Copyright (c) 2014 andrew glew. All rights reserved.

#import "scoreboardVC.h"
#import "ball.h"
#import "frame.h"
#import "snookerbreak.h"
#import "breakEntry.h"
#import "breakBallCell.h"
#import "indicator.h"
#import "DraggableView.h"


@interface scoreboardVC () <PlayerDelegate, MatchStatisticsDelegate>


@property (weak, nonatomic) IBOutlet UIImageView *medalImgPlayer1;
@property (weak, nonatomic) IBOutlet UIImageView *medalImgPlayer2;
@property (weak, nonatomic) IBOutlet UIButton *closeButtonCongratulations;



@property (weak, nonatomic) IBOutlet UIButton *buttonSwapPlayer;
@property (weak, nonatomic) IBOutlet UILabel *labelStopwatch;
@property (weak, nonatomic) IBOutlet UILabel *labelFrameStopwatch;



@property (weak, nonatomic) IBOutlet UILabel *labelVisitCounter;

@property (weak, nonatomic) IBOutlet UILabel *labelCongratsMessage;
@property (strong, nonatomic) IBOutlet UILabel *labelCongratsPlayerMessage;


@property (weak, nonatomic) IBOutlet breakEntry *activeBreak;
@property (weak, nonatomic) IBOutlet UILabel *scoreBoardBackLabel;
@property (weak, nonatomic) IBOutlet UILabel *ballsBackLabel;
@property (strong, nonatomic) IBOutlet ball *buttonRed;
@property (strong, nonatomic) IBOutlet ball *buttonYellow;
@property (strong, nonatomic) IBOutlet ball *buttonGreen;
@property (strong, nonatomic) IBOutlet ball *buttonBrown;
@property (strong, nonatomic) IBOutlet ball *buttonBlue;
@property (strong, nonatomic) IBOutlet ball *buttonPink;
@property (strong, nonatomic) IBOutlet ball *buttonBlack;
@property (strong, nonatomic) IBOutlet player *textScorePlayer1;
@property (strong, nonatomic) IBOutlet player *textScorePlayer2;
@property (strong, nonatomic) IBOutlet frameScore *labelScoreMatchPlayer1;
@property (strong, nonatomic) IBOutlet frameScore *labelScoreMatchPlayer2;
@property (strong, nonatomic) player    *currentPlayer;
@property (strong, nonatomic) player    *opposingPlayer;
@property (strong, nonatomic) IBOutlet indicator *redIndicator;
@property (strong, nonatomic) IBOutlet indicator *yellowIndicator;
@property (strong, nonatomic) IBOutlet indicator *greenIndicator;
@property (strong, nonatomic) IBOutlet indicator *brownIndicator;
@property (strong, nonatomic) IBOutlet indicator *blueIndicator;
@property (strong, nonatomic) IBOutlet indicator *pinkIndicator;
@property (strong, nonatomic) IBOutlet indicator *blackIndicator;
@property (strong, nonatomic) IBOutlet UITextField *textPlayerOneName;
@property (strong, nonatomic) IBOutlet UITextField *textPlayerTwoName;
@property (strong, nonatomic) IBOutlet UIView *viewScorePlayer1;
@property (strong, nonatomic) IBOutlet UIView *viewScorePlayer2;

@property (strong, nonatomic) IBOutlet UIView *viewBreak;
@property (strong, nonatomic) IBOutlet UIView *ballCollectionView;
@property (strong, nonatomic) IBOutlet UIView *disabledView;
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) IBOutlet UIImageView *imagePottedBall;
@property (strong, nonatomic) IBOutlet UIButton *buttonHelp;
@property (strong, nonatomic) IBOutlet UIButton *buttonNew;
@property (strong, nonatomic) IBOutlet UIButton *buttonEnd;
@property (strong, nonatomic) IBOutlet UIButton *buttonClear;
@property (strong, nonatomic) IBOutlet UIButton *buttonAdjust;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *breakViewLeadingConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *breakViewTrailingConstraint;
@property (strong, nonatomic) IBOutlet UIView *ballRowDisabledView;
@property (strong, nonatomic) IBOutlet UIImageView *snookerBackgroundPhotoImage;
@property (strong, nonatomic) IBOutlet UILabel *sliderBorderLabel;
@property (weak, nonatomic) IBOutlet UIButton *openPlayer1DetailButton;
@property (weak, nonatomic) IBOutlet UIButton *openPlayer2DetailButton;
@property (strong, nonatomic) NSMutableArray *frameData;
@property (nonatomic) NSString *savedNamePlayer1;
@property (nonatomic) NSString *savedNamePlayer2;
@property (nonatomic) NSString *emailPlayer1;
@property (nonatomic) NSString *emailPlayer2;
@property (nonatomic) NSString *imagePlayer1;
@property (nonatomic) NSString *imagePlayer2;
@property (nonatomic) NSString *shotBallColour;
@property (assign) int statPlayer1item;
@property (assign) int statPlayer2item;
@property (assign) int visitBallCount;
@property (assign) int medalCurrentPlayerBreak;
@property (assign) int medalOpposingPlayerBreak;
@property (assign) int medalCurrentPlayerBreakInThisFrame;
@property (assign) int medalOpposingPlayerBreakInThisFrame;
//@property (assign) int noOfGraphsInEmail;
@property (assign) int theme;
@property (assign) int breakThreshholdForCelebration;
@property (assign) bool isUndoShot;
@property (assign) bool isPaused;
@property (assign) bool isMatchStarted;
@property (assign) bool isHollow;
@property (assign) bool isMenuShot;
@property (assign) bool isShotStopWatch;
//@property (assign) bool embedImagesInHTML;
@property(nonatomic) CGPoint aaaShotViewPos;
@property (strong, nonatomic) UIAlertView *alertEndScores;
@property (strong, nonatomic) UIAlertView *alertOkNotification;
@property (strong, nonatomic) UIAlertView *alertUndoEntry;
@property (strong, nonatomic) UIColor *skinMainFontColor;
@property (nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) ball *buttonNoColor;
@property (strong, nonatomic) indicator *buttonIndicator;
@property (strong, nonatomic) IBOutlet UIVisualEffectView *blurView;


@property (weak, nonatomic) NSTimer *myTimer;
@property int frameTimeInSeconds;
@property int entryTimeInSeconds;
@property int frameVisitCounter;
@end

@implementation scoreboardVC {
    UISwipeGestureRecognizer *swipeLeft;
}
@synthesize joinedFrameResult;
@synthesize importedFile;
@synthesize currentFrameId;
@synthesize pocketId;
@synthesize matchData;
@synthesize activeColour;
@synthesize colourStateAtStartOfBreak;
@synthesize colourQuantityAtStartOfBreak;
@synthesize ballReplaced;
@synthesize matchTxId;
@synthesize shotTypeId;
@synthesize shotFoulId;
@synthesize shotTabId;
@synthesize shotGroup1SegmentId;
@synthesize shotGroup2SegmentId;
@synthesize managedObjectContext;
@synthesize activeMatchId;
@synthesize db;
@synthesize skinPrefix;


@synthesize skinPlayer1Colour;
@synthesize skinPlayer2Colour;
@synthesize skinBackgroundColour;
@synthesize skinForegroundColour;
@synthesize skinSelectedScore;


enum scoreStatus { LiveFrameScore, PreviousFrameScore };
enum scoreStatus scoreState;
enum IndicatorStyle {highlight, hide};
enum themes {greenbaize, orangejuice};

#define MY_APPDELEGATE ((AppDelegate*)[UIApplication sharedApplication].delegate)

#pragma mark - Standard




/* created 20150909 */
-(void)initDB {
    /* most times the database is already existing */
    self.db = [[dbHelper alloc] init];
    [self.db deleteDB:@"snookmast.db"];
    [self.db dbCreate :@"snookerm2_0.db"];
    
}


/* 
last modified 20160210
issue with startup now controlled by onload block condition
*/

-(bool)initMatch :(bool) onLoad {
    
    NSNumber *matchId = [self.db getActiveMatchId];
    
    /* vital code */
    if (onLoad) {
        if ([self.db isMatchActive :matchId] == false) {
            return false;
        }
    }
  
    [self.activeMatchData removeAllObjects];
    self.activeMatchData = [self.db entriesRetreive:matchId :nil :nil :nil :nil :[NSNumber numberWithInt:0] :nil :false];
    if (self.activeMatchData.count>0) {
        return true;
    } else {
        if ([self.db entriesRetreive:matchId :nil :nil :nil :nil :nil :nil :false].count>0) {
            return true;
        } else {
            return false;
        }
    }
}





/* created 20150928 */
-(bool)checkElapsedTime :(NSNumber *) frameId {
    NSMutableArray *startDates = [self.db entriesRetreive :[self getMatchId] :nil :frameId :nil :nil :[NSNumber numberWithInt:2] :nil :false];
    if (startDates.count>0) {
        return true;
    }
    return false;
}


/* created 20150927 */
-(NSString *)getElapsedTime :(NSNumber *) frameId :(bool) fromArchive {
    
    NSMutableArray *startDates;
    
    breakEntry *lastDate = [[breakEntry alloc] init];
    
    if (fromArchive) {
        for (breakEntry *singleBreak in self.activeMatchData) {
            if (singleBreak.lastshotid ==[NSNumber numberWithInt:0] && singleBreak.playerid==[NSNumber numberWithInt:0] && singleBreak.points==[NSNumber numberWithInt:0]) {
                if (!startDates) {
                    startDates = [[NSMutableArray alloc] init];
                }
                [startDates addObject:singleBreak];
            }
        }
        lastDate = [self.activeMatchData lastObject];
      
    } else {
        startDates = [self.db entriesRetreive :[self getMatchId] :nil :nil :nil :nil :[NSNumber numberWithInt:2] :nil :false];
    }
    
    breakEntry *tempEntry;
    NSString *firstEntry;
    NSString *lastEntry;
    
    if (startDates.count==0) {
        return @"00:00";
    }
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    if (frameId==[NSNumber numberWithInt:0]) {
        tempEntry = [startDates objectAtIndex:0];
        firstEntry = [NSString stringWithFormat:@"%@",tempEntry.endbreaktimestamp];
        lastEntry = [dateFormatter stringFromDate:[NSDate date]];
    } else {
        
        /* issue here 20160116 */
        tempEntry = [startDates objectAtIndex:[frameId intValue]-1];
        
        firstEntry = [NSString stringWithFormat:@"%@", tempEntry.endbreaktimestamp];
        if ([frameId intValue] == startDates.count) {
            
            if (fromArchive) {
                lastEntry = [NSString stringWithFormat:@"%@", lastDate.endbreaktimestamp];
            } else {
                lastEntry = [dateFormatter stringFromDate:[NSDate date]];
            }
            
            
        } else {
            tempEntry = [startDates objectAtIndex:[frameId intValue]];
            lastEntry = [NSString stringWithFormat:@"%@", tempEntry.endbreaktimestamp];
        }
    }
    
    NSDate *dateFirstEntry = [[NSDate alloc] init];
    NSDate *dateLastEntry = [[NSDate alloc] init];
    // voila!
    dateFirstEntry = [dateFormatter dateFromString:firstEntry];
    dateLastEntry = [dateFormatter dateFromString:lastEntry];
    NSTimeInterval interval = [dateLastEntry timeIntervalSinceDate:dateFirstEntry];
    return [common stringFromTimeInterval :interval];
}


/* created 20150922 */
/* last modified 20160506 */
-(void)addBreakToData :(breakEntry*) lastBreak {
    
    /* TODO needs to add the _entrytime from breakEntry */
    
    if (lastBreak.shots.count > 0 || lastBreak.active >= [NSNumber numberWithInt:activeFlag_FrameStart]) {
        
        if (lastBreak.active==[NSNumber numberWithInt:activeFlag_PlayerSwapped]) {
            lastBreak.active=[NSNumber numberWithInt:1];
        }
        
        /* first thing is to add to database */
        NSNumber *newRow = [self.db entriesInsert:lastBreak.matchid :lastBreak.playerid :lastBreak.frameid :lastBreak.lastshotid :lastBreak.points :lastBreak.active :lastBreak.duration];
        
        if (newRow == [NSNumber numberWithInt:-1]) {
            // nothing to do
        } else {
            [self.db shotsInsert:newRow :lastBreak.shots];
        }
        
        /* lastly add to the active array */
        if ([lastBreak.active intValue] != activeFlag_FrameStart) {
            [self.activeFrameData addObject:[lastBreak copy]];
        }
    }
}



/* refactored 20150910 */
-(void)deleteMatchData {
    [self.activeMatchData removeAllObjects];
    [self.activeFrameData removeAllObjects];
    [self.db deleteWholeMatchData:[self.db getActiveMatchId]];
    
    self.textScorePlayer1 = [self setPlayerData:self.textScorePlayer1];
    self.textScorePlayer2 = [self setPlayerData:self.textScorePlayer2];
    
    
}

/* created 20160712 */
-(void)rerackFrameData {
    [self.activeFrameData removeAllObjects];
    [self.db deleteWholeFrameData:[self.db getCurrentFrameId:self.activeMatchId] :self.activeMatchId];
    [self addFrameStartDate];
}



/* modified 20170118 */
-(player *)setPlayerData :(player *) p {
    
    /* must optimize!!!*/

    player *temp_p;
    
    temp_p = [self.db playerRetreive :p];
    
    if (temp_p.playerNumber!=p.playerNumber) {
        
        [self refreshScoreboard:temp_p];
        p=temp_p;
    
    }

    if (p.hbEver.breakBalls == nil ) {
        p.hbEver = [[hibreak alloc] init];
        p.hbFrame = [[hibreak alloc] init];
        p.hbMatch = [[hibreak alloc] init];
    }
    
    p.hbEver = [self.db findPastHB :p.playerNumber];

    /*frameData
        matchdata
        everdata*/
    
    
    if (self.activeFrameData.count == 0) {
        // no data contained in current frame - most likely start of new frame
        p.hbFrame.breakTotal = [NSNumber numberWithInt:0];
    } else
    {
        p.hbFrame.breakBalls = [common getHBBalls:self.activeFrameData :[NSNumber numberWithInt:p.playerIndex] :0];
        p.hbFrame.breakTotal = [common getHBTotal:self.activeFrameData :[NSNumber numberWithInt:p.playerIndex] :0];
    }

    if (self.activeMatchData.count == 0) {
        // no data contained in current match - most likely the 1st frame
        
        if (p.hbFrame.breakTotal>0) {
            p.hbMatch.breakBalls = p.hbFrame.breakBalls;
            p.hbMatch.breakTotal = p.hbFrame.breakTotal;
        } else {
            p.hbMatch.breakTotal = [NSNumber numberWithInt:0];
        }
    } else {
        p.hbMatch.breakBalls = [common getHBBalls:self.activeMatchData :[NSNumber numberWithInt:p.playerIndex] :0];
        p.hbMatch.breakTotal = [common getHBTotal:self.activeMatchData:[NSNumber numberWithInt:p.playerIndex] :0];
        if (p.hbFrame.breakTotal>p.hbMatch.breakTotal) {
            p.hbMatch.breakBalls = p.hbFrame.breakBalls;
            p.hbMatch.breakTotal = p.hbFrame.breakTotal;
        }
    }
        
    if (p.hbEver.breakTotal == [NSNumber numberWithInt:0] || p.hbEver.breakTotal==nil) {
        if (p.hbMatch.breakTotal>0) {
            p.hbEver.breakBalls = p.hbMatch.breakBalls;
            p.hbEver.breakTotal = p.hbMatch.breakTotal;
        }
    } else {
        if (p.hbMatch.breakTotal>p.hbEver.breakTotal) {
            p.hbEver.breakBalls = p.hbMatch.breakBalls;
            p.hbEver.breakTotal = p.hbMatch.breakTotal;
        }
    }
    
    return p;
}



/* new 20160111 */
-(NSNumber*) getMatchId {
    return [self.db getActiveMatchId];
}

/* modified 20151005 */
-(void) initFrameData {
    
    if (!self.activeFrameData) {
        self.activeFrameData = [[NSMutableArray alloc] init];
        self.activeMatchData = [[NSMutableArray alloc] init];
    }
    _frameVisitCounter=0;
}

/* created 20150911 */
/* modified 20150930 */
-(bool)isColourKilled: (NSMutableArray*) activeData :(NSNumber*) reqBallValue {
    
    for (breakEntry *data in activeData) {
        for (ballShot *shot in data.shots) {
            if ([shot.killed isEqualToNumber:[NSNumber numberWithInt:1]] && [shot.value isEqualToNumber:reqBallValue]) {
                return true;
            }
        }
    }
    return false;
}

/* created 20150910 */
-(void)initFrame :(NSNumber*)currentFrameId {
    [self.activeFrameData removeAllObjects];
    self.activeFrameData = [self.db entriesRetreive:[self getMatchId] :nil :self.currentFrameId :nil :nil :[NSNumber numberWithInt:1] :nil :false];

}



/* created 20150924 */
-(int)getFramePoints:(NSMutableArray*) activeData :(NSNumber*)playerid :(NSNumber *)frameid {
    int retValue=0;
    for (breakEntry *singleBreak in activeData) {
        if (playerid == singleBreak.playerid && (frameid == singleBreak.frameid || frameid == 0)) {
            retValue+=[singleBreak.points intValue];
        }
    }
    return retValue;
}

/* created 20150927 */
/* last modified 20151013 */
-(NSMutableArray*) getData :(NSMutableArray*) frameDataSet :(NSNumber*)frameId {
    
    NSMutableArray *frame = [[NSMutableArray alloc] init];
    
    for (breakEntry *singleBreak in frameDataSet) {
        if (singleBreak.frameid == frameId) {
            
            ballShot *shot = [singleBreak.shots firstObject];
            
            if (![shot.colour isEqualToString:@"FS"]) {
                [frame addObject:singleBreak];
            }
            
        } else if (singleBreak.frameid > frameId) {
            break;
        }
    }
    return frame;
}


/* create 20150925 */
-(void) getFramesWon :(NSNumber*) frameIndex :(frameScore*) player1 :(frameScore*) player2 {
    
    int winCountPlayer1 = 0;
    int winCountPlayer2 = 0;
    
    for (int i = 1; i < [frameIndex intValue]; i++) {
        int score1 = 0;
        int score2 = 0;
        
        score1 = [self getFramePoints:self.activeMatchData :[NSNumber numberWithInt:1] :[NSNumber numberWithInt:i]];
        score2 = [self getFramePoints:self.activeMatchData :[NSNumber numberWithInt:2] :[NSNumber numberWithInt:i]];
        
        if (score1 > score2) {
            winCountPlayer1 ++;
        } else {
            winCountPlayer2 ++;
        }
    }
    player1.framesWon = [NSNumber numberWithInt:winCountPlayer1];
    player2.framesWon = [NSNumber numberWithInt:winCountPlayer2];
    player1.text = [NSString stringWithFormat:@"%@",player1.framesWon];
    player2.text = [NSString stringWithFormat:@"%@",player2.framesWon];
}

/* created 20150920 */
/* last modified 20151005 */
-(void)removeLastBreak {
    
    // we already know there is more than 0 elements in array
    breakEntry *lastBreak = [[breakEntry alloc] init];
    lastBreak = [self.activeFrameData objectAtIndex:self.activeFrameData.count - 1];
    
    NSNumber *entryId = lastBreak.entryid;
    
    // validate if array has entryId or not...
    if (entryId==nil) {
        entryId = [self.db getIdOfLastEntry];
    }
    
    [self.activeFrameData removeObjectAtIndex:self.activeFrameData.count - 1];
    [self.db shotDelete:entryId];
    [self.db entryDelete:entryId];
    
    _frameVisitCounter = (int)self.activeFrameData.count;
    self.labelVisitCounter.text = [NSString stringWithFormat:@"Visits %d",
                                   _frameVisitCounter];
    
}


/* last modified 20161211 */
-(void)viewDidLoad {
    

    [super viewDidLoad];

    [self loadConfigDefaults];
    [self initDB];
    [self.db alterTableNewColumn];
    
    self.activeMatchId = [self getMatchId];
    self.currentFrameId = [self.db getCurrentFrameId:self.activeMatchId];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    bool doCheckPausedState=false;
  
    if ([self initMatch :true] == true) {
        [self setupUnfinsihedGame];
        doCheckPausedState = true;
    } else {
        /* we are starting over */
            
        self.imagePottedBall.layer.backgroundColor = [UIColor whiteColor].CGColor;
        self.imagePottedBall.layer.borderColor = [UIColor whiteColor].CGColor;
            
        self.imagePottedBall.image = [UIImage imageNamed:@"one-finger-tap"];
            
        self.viewBreak.hidden = false;
            
            
        self.currentFrameId = [NSNumber numberWithInt:1];
        self.isMatchStarted = false;
        self.ballCollectionView.hidden = true;
        self.matchData = [[NSMutableArray alloc] init];
        [self.textScorePlayer1 createFrame:([self.currentFrameId intValue])];
        self.textScorePlayer1.playerNumber = [NSNumber numberWithInt:1];
        [self.textScorePlayer2 createFrame:([self.currentFrameId intValue])];
        self.textScorePlayer2.playerNumber = [NSNumber numberWithInt:2];
        self.textScorePlayer1.text = @"0";
        self.textScorePlayer2.text = @"0";
        [self.labelScoreMatchPlayer1 resetFramesWon];
        [self.labelScoreMatchPlayer2 resetFramesWon];
    }
    [self loadDefaults];
   
    self.textScorePlayer1 = [self setPlayerData :self.textScorePlayer1 ];
    self.textScorePlayer2 = [self setPlayerData :self.textScorePlayer2 ];
    self.textPlayerOneName.text = self.textScorePlayer1.nickName;
    self.textPlayerTwoName.text = self.textScorePlayer2.nickName;
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    
    if ([self.textScorePlayer1.photoLocation isEqualToString:@""]) {
        [self.openPlayer1DetailButton setImage:[UIImage imageNamed:@"avatar0"] forState:UIControlStateNormal];
    } else {
        NSData *pngData = [NSData dataWithContentsOfFile:[[paths objectAtIndex:0] stringByAppendingPathComponent:self.textScorePlayer1.photoLocation]];
        [self.openPlayer1DetailButton setImage:[UIImage imageWithData:pngData] forState:UIControlStateNormal];
    }
    
    if ([self.textScorePlayer2.photoLocation isEqualToString:@""]) {
        [self.openPlayer2DetailButton setImage:[UIImage imageNamed:@"avatar0"] forState:UIControlStateNormal];
    } else {
        NSData *pngData = [NSData dataWithContentsOfFile:[[paths objectAtIndex:0] stringByAppendingPathComponent:self.textScorePlayer2.photoLocation]];
        [self.openPlayer2DetailButton setImage:[UIImage imageWithData:pngData] forState:UIControlStateNormal];
    }

    [self addGestures];
    
    self.currentPlayer = self.textScorePlayer1;
    self.opposingPlayer = self.textScorePlayer2;

    /* used for the 50/60 splits */
    self.joinedFrameResult = [[NSMutableArray alloc] init];
    [self initFrameData];
    
    self.statPlayer1item=0;
    self.statPlayer2item=0;
    self.visitBallCount=0;
    
    self.isUndoShot = false;
    [self.activeBreak setPlayerid:[NSNumber numberWithInt:0]];
    [self.activeBreak setPoints:[NSNumber numberWithInt:0]];
    
    self.displayState = 0;
 
    _myTimer = [self createTimer];
    
    
    // TODO we need to set the frametimeinseconds to now minus framestart
    // minus any paused seconds.
    _frameTimeInSeconds = [common getRealFrameDuration :self.activeFrameData] ;

    _entryTimeInSeconds = 0;
    self.labelStopwatch.text = [self formattedShortTime:_entryTimeInSeconds];

    _frameVisitCounter = (int)self.activeFrameData.count;
    self.labelVisitCounter.text = [NSString stringWithFormat:@"Visits %d",
                                   _frameVisitCounter];
    
   
    if (doCheckPausedState) {
        
        if (self.activeFrameData.count!=0) {
            breakEntry *lastEntry = [self.db lastEntryRetreive];
            if (lastEntry.active == [NSNumber numberWithInt:activeFlag_PausedState]) {
                self.isPaused=true;
                [self enableControls:false];
                self.labelStopwatch.text=@"paused";
                _frameTimeInSeconds = [lastEntry.duration intValue];
                self.labelFrameStopwatch.text = [self formattedTime:_frameTimeInSeconds];
                
                self.buttonSwapPlayer.backgroundColor = [UIColor redColor];
                self.buttonSwapPlayer.layer.borderColor = [UIColor redColor].CGColor;
               // [self.buttonSwapPlayer setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                self.labelStopwatch.textColor = [UIColor redColor];
                
            }
        }
        
    } else {
        self.isPaused=false;
        
    }
   
    self.bannerView.adUnitID = @"ca-app-pub-4981400960359325/9236228291";
// TEST ADMOB BANNER
//    self.bannerView.adUnitID = @"ca-app-pub-3940256099942544/2934735716";

    self.bannerView.rootViewController = self;
    
    
}

/* created 20151011 */
- (void)didBecomeActive:(NSNotification *)notification {
    // [self doCheckOnImportFile];
}




/* created 20151011 */
-(void) setupUnfinsihedGame {

    /* we are restarting an existing match */
    if (self.activeMatchData.count==0) {
        self.currentFrameId = [NSNumber numberWithInt:1];
    } else {

        self.currentFrameId = [self.db getCurrentFrameId:self.activeMatchId];
        if (self.currentFrameId==[NSNumber numberWithInt:0]) {
            int tempFrameId = [[self.db getCurrentFrameId:self.activeMatchId] intValue] + 1;
            self.currentFrameId = [NSNumber numberWithInt:tempFrameId];
        }
    }
    [self initFrame :self.currentFrameId];
    [self.textScorePlayer1 createCurrentFrame:(self.currentFrameId)];
    [self.textScorePlayer2 createCurrentFrame:(self.currentFrameId)];
    [self.textScorePlayer1 updateFrameScore:[self getFramePoints:self.activeFrameData :[NSNumber numberWithInt:1] :self.currentFrameId]];
    [self.textScorePlayer2 updateFrameScore:[self getFramePoints:self.activeFrameData :[NSNumber numberWithInt:2] :self.currentFrameId]];
    [self getFramesWon:self.currentFrameId :self.labelScoreMatchPlayer1 :self.labelScoreMatchPlayer2];
    self.activeBreak.hidden = true;
    //self.imagePottedBall.hidden = true;
    self.isMatchStarted = true;
    self.ballCollectionView.hidden = false;
    self.activeColour = 1;
}

/* last modified 20170117 */
-(void) loadConfigDefaults {
    
    self.textScorePlayer1.text = self.textScorePlayer1.nickName;
    self.textScorePlayer2.text = self.textScorePlayer2.nickName;

    self.savedNamePlayer1 = self.textPlayerOneName.text;
    self.savedNamePlayer2 = self.textPlayerTwoName.text;

    self.textScorePlayer1.playerIndex = 1;
    self.textScorePlayer2.playerIndex = 2;
}

/* created 20170117 */
-(void) loadTheme {
    self.theme = MY_APPDELEGATE.theme;
    self.isHollow =  MY_APPDELEGATE.isHollow;
    self.isShotStopWatch = MY_APPDELEGATE.isShotStopWatch;
    self.breakThreshholdForCelebration = MY_APPDELEGATE.breakThreshholdForCelebration;
    self.isMenuShot = MY_APPDELEGATE.isMenuShot;
    
    self.skinSelectedScore = [UIColor whiteColor];
    
    
    if (self.theme==greenbaize) {
        self.blurView.hidden = true;
        self.snookerBackgroundPhotoImage.hidden = false;
        self.skinForegroundColour = [UIColor colorWithRed:192.0f/255.0f green:139.0f/255.0f blue:98.0f/255.0f alpha:1.0];
        self.skinBackgroundColour  = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0];
        
        self.skinPlayer1Colour = [UIColor colorWithRed:255.0f/255.0f green:59.0f/255.0f blue:48.0f/255.0f alpha:1.0];
        self.skinPlayer2Colour = [UIColor colorWithRed:90.0f/255.0f green:200.0f/255.0f blue:250.0f/255.0f alpha:1.0];
 
    } else if (self.theme==orangejuice) {
        self.blurView.hidden = true;
        self.snookerBackgroundPhotoImage.hidden = true;
        self.skinForegroundColour  = [UIColor colorWithRed:161.0f/255.0f green:8.0f/255.0f blue:3.0f/255.0f alpha:1.0];
        self.skinBackgroundColour = [UIColor colorWithRed:249.0f/255.0f green:80.0f/255.0f blue:0.0f/255.0f alpha:1.0];
        self.skinPlayer1Colour = [UIColor colorWithRed:104.0f/255.0f green:142.0f/255.0f blue:38.0f/255.0f alpha:1.0];
        self.skinPlayer2Colour = [UIColor colorWithRed:85.0f/255.0f green:5.0f/255.0f blue:39.0f/255.0f alpha:1.0];
        
    }
    
    
    self.mainView.backgroundColor = self.skinBackgroundColour;
    
    self.sliderBorderLabel.backgroundColor = self.skinForegroundColour;
    
    [self.labelFrameStopwatch setTextColor:self.skinForegroundColour];
    
    
    if (!self.isShotStopWatch) {
        self.labelStopwatch.hidden = true;
    }
    
    self.labelStopwatch.textColor = self.skinForegroundColour;
    self.labelVisitCounter.textColor = self.skinForegroundColour;
    //self.labelScoreMatchPlayer1.textColor = self.skinForegroundColour;
    self.labelScoreMatchPlayer2.textColor = self.skinForegroundColour;
    
    self.viewScorePlayer1.layer.borderColor = self.skinSelectedScore.CGColor;
    self.viewScorePlayer2.layer.borderColor = self.skinSelectedScore.CGColor;

    self.scoreBoardBackLabel.layer.cornerRadius = 5;
    self.scoreBoardBackLabel.layer.borderWidth = 1.0f;
    self.scoreBoardBackLabel.layer.borderColor = self.skinForegroundColour.CGColor;
    self.scoreBoardBackLabel.layer.masksToBounds = YES;
    
    self.visitBallGrid.backgroundColor = [UIColor colorWithRed:35.0f/255.0f green:35.0f/255.0f blue:35.0f/255.0f alpha:1.0f];
    self.visitBallGrid.layer.cornerRadius = 5;
    self.visitBallGrid.layer.masksToBounds = YES;
    
    if (self.currentPlayer.playerIndex==1) {
        self.textScorePlayer1.textColor = self.skinForegroundColour;
        self.textScorePlayer2.textColor = self.skinSelectedScore;
        self.viewScorePlayer1.layer.borderWidth = 1.0f;
        self.viewScorePlayer2.layer.borderWidth = 0.0f;
        self.textPlayerOneName.textColor =  self.skinSelectedScore;
        self.textPlayerTwoName.textColor =  self.skinForegroundColour;
        
    } else {
        self.textScorePlayer1.textColor = self.skinSelectedScore;
        self.textScorePlayer2.textColor = self.skinForegroundColour;
        self.viewScorePlayer1.layer.borderWidth = 0.0f;
        self.viewScorePlayer2.layer.borderWidth = 1.0f;
        self.textPlayerOneName.textColor =  self.skinForegroundColour;
        self.textPlayerTwoName.textColor =  self.skinSelectedScore;
    }    
}


/* created 20151011 */
-(void) loadDefaults {
    
    /* set the balls */
    [self setBallCounters];
    self.buttonNoColor = [ball buttonWithType:UIButtonTypeRoundedRect];
    self.buttonNoColor.colour = @"MISS";
    self.buttonNoColor.foulPoints = 0;
    self.buttonNoColor.pottedPoints = 0;
    self.buttonNoColor.quantity = 0;
    self.buttonNoColor.imageNameLarge = @"";
    self.buttonNoColor.imageNameSmall = @"";
    self.buttonEnd.hidden = false;
    [self.buttonNew setTitle:@"New" forState:UIControlStateNormal];
    scoreState = LiveFrameScore;
}

/* created 20151011 */
/* modified 20161210 */
-(void)addGestures {
    /* enable all gestures (long press/press/swipe) */
    UITapGestureRecognizer *selectPlayerOneTap = [[UITapGestureRecognizer alloc]
                                                  initWithTarget:self action:@selector(selectPlayerOneTap:)];
    selectPlayerOneTap.numberOfTapsRequired = 1;
    [self.viewScorePlayer1 addGestureRecognizer:selectPlayerOneTap];
    
    UITapGestureRecognizer *selectPlayerTwoTap = [[UITapGestureRecognizer alloc]
                                                  initWithTarget:self action:@selector(selectPlayerTwoTap:)];
    selectPlayerTwoTap.numberOfTapsRequired = 1;
    [self.viewScorePlayer2 addGestureRecognizer:selectPlayerTwoTap];
    
    UITapGestureRecognizer *endBreakTap = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self action:@selector(endBreakTap:)];
    endBreakTap.numberOfTapsRequired = 1;
    [self.viewBreak addGestureRecognizer:endBreakTap];

    UILongPressGestureRecognizer* pauseLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gesturePauseLongPress:)];
    [pauseLongPress setMinimumPressDuration:1.5];
    [self.buttonSwapPlayer addGestureRecognizer:pauseLongPress];

    swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftShowPlayersStats:)];
    swipeLeft.numberOfTouchesRequired = 1;//give required num of touches here ..
    swipeLeft.delegate = (id)self;
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeLeft];
    
    /* long press gestures on balls in rack */
    
    UILongPressGestureRecognizer* redLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gestureBallLongPress:)];
    [redLongPress setMinimumPressDuration:0.3];
    [self.buttonRed addGestureRecognizer:redLongPress];
    
    UILongPressGestureRecognizer* yellowLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gestureBallLongPress:)];
    [yellowLongPress setMinimumPressDuration:0.3];
    [self.buttonYellow addGestureRecognizer:yellowLongPress];
    
    UILongPressGestureRecognizer* greenLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gestureBallLongPress:)];
    [greenLongPress setMinimumPressDuration:0.3];
    [self.buttonGreen addGestureRecognizer:greenLongPress];
    
    UILongPressGestureRecognizer* brownLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gestureBallLongPress:)];
    [brownLongPress setMinimumPressDuration:0.3];
    [self.buttonBrown addGestureRecognizer:brownLongPress];
    
    UILongPressGestureRecognizer* blueLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gestureBallLongPress:)];
    [yellowLongPress setMinimumPressDuration:0.3];
    [self.buttonBlue addGestureRecognizer:blueLongPress];
    
    UILongPressGestureRecognizer* pinkLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gestureBallLongPress:)];
    [pinkLongPress setMinimumPressDuration:0.3];
    [self.buttonPink addGestureRecognizer:pinkLongPress];
    
    UILongPressGestureRecognizer* blackLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gestureBallLongPress:)];
    [blackLongPress setMinimumPressDuration:0.3];
    [self.buttonBlack addGestureRecognizer:blackLongPress];
    
    
    
    
}


/* last modified 20160714 */
- (void)viewDidLayoutSubviews {

    
    [common makeRoundButtonOwnColour:self.openPlayer1DetailButton :self.openPlayer1DetailButton.frame.origin.x :self.openPlayer1DetailButton.frame.origin.y :75.0f :self.skinPlayer1Colour];
    [common makeRoundButtonOwnColour:self.openPlayer2DetailButton :self.openPlayer2DetailButton.frame.origin.x :self.openPlayer2DetailButton.frame.origin.y :75.0f : self.skinPlayer2Colour];
    [common makeRoundButtonOwnColour:self.buttonSwapPlayer :self.buttonSwapPlayer.frame.origin.x :self.buttonSwapPlayer.frame.origin.y :self.buttonSwapPlayer.frame.size.width :self.skinForegroundColour];
    [common makeBallImage:self.imagePottedBall :self.imagePottedBall.frame.origin.x :self.imagePottedBall.frame.origin.y :self.imagePottedBall.frame.size.width :5.0f];

    [self setBallButtonImage :self.buttonRed];
    [self setBallButtonImage :self.buttonYellow];
    [self setBallButtonImage :self.buttonGreen];
    [self setBallButtonImage :self.buttonBrown];
    [self setBallButtonImage :self.buttonBlue];
    [self setBallButtonImage :self.buttonPink];
    [self setBallButtonImage :self.buttonBlack];
}



/* last modified 20160714 */
 
-(void)makeRoundShotButton :(UIButton*) shotButton :(float) x :(float) y :(float) heightWidth :(bool) useSkinColour {
    //width and height should be same value
    shotButton.frame = CGRectMake(x, y, heightWidth, heightWidth);
    //Clip/Clear the other pieces whichever outside the rounded corner
    shotButton.clipsToBounds = YES;
    //half of the width
    shotButton.layer.cornerRadius = heightWidth/2.0f;
    if (useSkinColour) {
        shotButton.layer.borderColor=self.skinForegroundColour.CGColor;
    } else {
        shotButton.layer.borderColor=[UIColor orangeColor].CGColor;
    }
    shotButton.layer.borderWidth=1.5f;
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    

}


-(void)viewWillAppear :(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadTheme];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [self.navigationController setToolbarHidden:YES animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = self.skinForegroundColour;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    [self.bannerView loadRequest:[GADRequest request]];
    
}



-(BOOL)prefersStatusBarHidden{
    return YES;
}


-(void)displayMatchPoint :(int)pointsPlayer1 :(int)pointsPlayer2 :(int)playerIndex :(int)frameRef {

    NSArray  *framedetail = [NSArray arrayWithObjects:@"first",@"second",@"third",@"fourth",@"fifth",@"sixth",@"7th",@"8th",@"9th",@"10th",@"11th",@"12th",@"13th",@"14",@"15th",@"16th",@"17th",@"18th",@"19th",@"20th",@"21st",@"22nd",@"23rd",@"24th",@"25th",@"26th",@"27th",@"28th",@"29th",@"30th",@"31st",@"32nd",@"33rd",@"34th",@"final",nil];
    
    NSString *frameReference;
    if (frameRef>35) {
        frameReference = [NSString stringWithFormat:@"In frame %d",frameRef];
    } else {
        frameReference = [NSString stringWithFormat:@"In the %@ frame",[framedetail objectAtIndex:frameRef-1]];
    }
    
    
    bool pastTense = true;
    if ([NSNumber numberWithInt:frameRef] == self.currentFrameId) {
        pastTense = false;
    }
    
    if (playerIndex==1) {
        NSString *resultText;
        
        if (pointsPlayer1>pointsPlayer2) {
            if (pastTense) {
                resultText = @"and won the frame.";
            } else {
               resultText = @"and is winning the frame.";
            }
        } else if (pointsPlayer2>pointsPlayer1) {
            if (pastTense) {
                resultText = @"and lost the frame.";
            } else {
                resultText = @"and is losing the frame.";
            }
        } else {
            resultText = @"and is drawing the frame.";
        }
        
    } else {
        NSString *resultText;
        
        if (pointsPlayer2>pointsPlayer1) {
            if (pastTense) {
                resultText = @"and won the frame.";
            } else {
                resultText = @"and is winning the frame.";
            }
        } else if (pointsPlayer1>pointsPlayer2) {
            if (pastTense) {
                resultText = @"and lost the frame.";
            } else {
                resultText = @"and is losing the frame.";
            }
        } else {
            resultText = @"and is drawing the frame.";
        }

        
    }
}



-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Medal
/* last modified 20160720 */
-(void)displayMedal {
    int points = [self.activeBreak.points intValue];
    
    if ([NSNumber numberWithInt:points] > self.currentPlayer.hbMatch.breakTotal &&  [NSNumber numberWithInt:points] > self.opposingPlayer.hbMatch.breakTotal  && [NSNumber numberWithInt:points] > self.currentPlayer.hbFrame.breakTotal && [NSNumber numberWithInt:points] > self.opposingPlayer.hbFrame.breakTotal) {
        
        
        if (self.currentPlayer.playerIndex==1) {
            self.medalImgPlayer1.alpha=1.0f;
            self.medalImgPlayer1.image = [UIImage imageNamed:@"cup_gold.png"];
            self.medalImgPlayer2.alpha=0.0f;
        } else {
            self.medalImgPlayer1.alpha=0.0f;
            self.medalImgPlayer2.alpha=1.0f;
            self.medalImgPlayer2.image = [UIImage imageNamed:@"cup_gold.png"];
        }
    } else if ([NSNumber numberWithInt:points]  > self.currentPlayer.hbMatch.breakTotal  && [NSNumber numberWithInt:points]  > self.currentPlayer.hbFrame.breakTotal) {
        //show silver medal
        
        if (self.currentPlayer.playerIndex==1) {
            self.medalImgPlayer1.alpha=1.0f;
            self.medalImgPlayer1.image = [UIImage imageNamed:@"cup_silver.png"];
            self.medalImgPlayer2.alpha=0.0f;
        } else {
            self.medalImgPlayer1.alpha=0.0f;
            self.medalImgPlayer2.alpha=1.0f;
            self.medalImgPlayer2.image = [UIImage imageNamed:@"cup_silver.png"];
        }
        
    } else {
        if ([NSNumber numberWithInt:points] > self.currentPlayer.hbFrame.breakTotal) {
            //show bronze medal
            
            if (self.currentPlayer.playerIndex==1) {
                self.medalImgPlayer1.alpha=1.0f;
                self.medalImgPlayer1.image = [UIImage imageNamed:@"cup_bronze.png"];
                self.medalImgPlayer2.alpha=0.0f;
            } else {
                self.medalImgPlayer1.alpha=0.0f;
                self.medalImgPlayer2.alpha=1.0f;
                self.medalImgPlayer2.image = [UIImage imageNamed:@"cup_bronze.png"];
            }
        } else {
            // make sure it's hidden
            self.medalImgPlayer1.alpha=0.0f;
            self.medalImgPlayer2.alpha=0.0f;
        }
    }
}




#pragma mark - Break
/* last modified 20161203 */
-(void)closeBreak {
    /* set counter variables and clear break */
    if ([self.activeBreak.points intValue] > 0) {
        if (self.activeBreak.playerid!=[NSNumber numberWithInt:0]) {
            [self.currentPlayer setFrameScore:[self.activeBreak.points intValue]];
        }
        [self.buttonClear setTitle:@"Undo" forState:UIControlStateNormal];
        self.isUndoShot = false;
        self.buttonAdjust.enabled = true;
        [self.currentPlayer setNbrOfBreaks:self.currentPlayer.nbrOfBreaks + 1];
        [self processCurrentUsersHighestBreak];

        
        /* animate by droping the ball through the bottom of the main view... */
        CATransition *transition = nil;
        transition = [CATransition animation];
        transition.duration = 0.2;//kAnimationDuration
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionPush;
        transition.subtype =kCATransitionFromBottom ;
        [self.viewBreak.layer addAnimation:transition forKey:nil];
        
        [self.activeBreak clearBreak:self.viewBreak];
        
        [self clearIndicators :hide];
        self.ballReplaced=false;
        self.medalImgPlayer1.alpha=0.0f;
        self.medalImgPlayer2.alpha=0.0f;
        _entryTimeInSeconds = 0;
    }
}



-(void)processCurrentUsersHighestBreak {
    // if break that has just completed is higher than players highest break in match, save it.
    if ( [self.currentPlayer highestBreak] < [[self.activeBreak points] intValue] ) {
        [self.currentPlayer setHighestBreak:[[self.activeBreak points] intValue] :[self.currentFrameId intValue] :self.activeBreak.shots];
    }
    // if break is the highest for current player in frame save it to the frame object.
    if (self.currentPlayer.currentFrame.frameHighestBreak < [[self.activeBreak points] intValue]) {
        [self.currentPlayer.currentFrame setFrameHighestBreak:[[self.activeBreak points] intValue] :[self.currentFrameId intValue] :self.activeBreak.shots];
    }
}



#pragma mark - Frame handling


/* created 20150929 */
-(bool) isFrameTied :(bool) updateFramesWon {
   
    if (self.textScorePlayer1.frameScore > self.textScorePlayer2.frameScore) {
        if (updateFramesWon) {
            [self.labelScoreMatchPlayer1 incrementFramesWon];
        }
    } else if (self.textScorePlayer1.frameScore < self.textScorePlayer2.frameScore) {
        if (updateFramesWon) {
            [self.labelScoreMatchPlayer2 incrementFramesWon];
        }
    } else {
        /* do nothing. game tied so no winner yet! */
        return true;
    }
    return false;
}


/* modified 20151020 */
/* last modified 20160207 */
-(void)endOfFrame :(bool) showprompt {

        bool ignoreEndOfFrame = [self isFrameTied :false];
        NSString *optionText;
    
        if (ignoreEndOfFrame) {
            optionText = @"Cannot end, frame still tied";
        } else {
            optionText = @"New Frame";
        }
    
   
    
        if (showprompt==true) {
    
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"End Of Frame %@ Request", self.currentFrameId] message:[NSString stringWithFormat:@"Frame Completed in %@", [self getElapsedTime :self.currentFrameId :self.importedFile]] preferredStyle:UIAlertControllerStyleActionSheet]; // 1
            UIAlertAction *NewFrameAction = [UIAlertAction actionWithTitle:optionText
                                                                 style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                  
                                                                     [self isFrameTied :true];
                
                                                                     if (ignoreEndOfFrame == false) {
                    
                                                                         [self closeBreak];
                                                               
                                                                         /* get player point values */
                                                                         int playerPoints1 = [self getFramePoints:self.activeFrameData :[NSNumber numberWithInt:1] :self.currentFrameId];
                                                               
                                                                         int playerPoints2 = [self getFramePoints:self.activeFrameData :[NSNumber numberWithInt:2] :self.currentFrameId];
                                                               
                                                                         // long winded increment here!
                                                                         int value = [self.currentFrameId intValue];
                                                               
                                                                   
                                                                         [self.db setFrameActiveState:self.currentFrameId  :[NSNumber numberWithInt:activeFlag_Active] :[NSNumber numberWithInt:activeFlag_Inactive]];
                                                                         
                                                               
                                                                         self.currentFrameId = [NSNumber numberWithInt:value + 1];
                                                               
                                                                         /* bring all previous frames into match data */
                                                                         [self initMatch :false];
                                                                         /* and reset current frame data */
                                                                         [self initFrame:self.currentFrameId];
                                                                         /* reset new frame scores for each player */
                                                                         if ([self.joinedFrameResult count] == 0) {
                                                                             self.joinedFrameResult = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%03d/%03d",playerPoints1, playerPoints2], nil];
                                                                         } else {
                                                                             [self.joinedFrameResult addObject:[NSString stringWithFormat:@"%03d/%03d  ",playerPoints1,playerPoints2]];
                                                                         }
                                                               
                                                                         [self.textScorePlayer1 resetFrameScore:0];
                                                                         [self.textScorePlayer2 resetFrameScore:0];
                    
                                                                         self.activeBreak.playerid = [NSNumber numberWithInt:0];
                                                                         [self selectPlayerOne];
                                                                         scoreState = LiveFrameScore;
                                                                         [self.textScorePlayer1 createCurrentFrame:(self.currentFrameId)];
                                                                         [self.textScorePlayer2 createCurrentFrame:(self.currentFrameId)];
                                                                         [self resetBalls];
                                                                         [self addFrameStartDate];

                                                                         
                                                                         player *p1 = self.textScorePlayer1;
                                                                         player *p2 = self.textScorePlayer2;
                                                                         
                                                                         p1.hbMatch.breakBalls = [common getHBBalls:self.activeMatchData :[NSNumber numberWithInt:p1.playerIndex] :0];
                                                                         p1.hbMatch.breakTotal = [common getHBTotal:self.activeMatchData:[NSNumber numberWithInt:p1.playerIndex] :0];
                                                                         p2.hbMatch.breakBalls = [common getHBBalls:self.activeMatchData :[NSNumber numberWithInt:p2.playerIndex] :0];
                                                                         p2.hbMatch.breakTotal = [common getHBTotal:self.activeMatchData:[NSNumber numberWithInt:p2.playerIndex] :0];
                                                                   
                                                                         _frameVisitCounter=0;
                                                                         self.labelVisitCounter.text = [NSString stringWithFormat:@"Visits %d",_frameVisitCounter];

                                                                         //[self.statsView resetFrameData];
                                                                     }
                                                    
                                                                     NSLog(@"You pressed Go and end Match");
                                                                 }];
            
            UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                                                               NSLog(@"You pressed cancel");
                                                           }];
    
            [alert addAction:NewFrameAction];
            [alert addAction:CancelAction];
    
            [self presentViewController:alert animated:YES completion:nil];
        
        } else {
        
            //SAME AS ABOVE??  MOVE INTO OWN FUNCTION
            if (ignoreEndOfFrame == false) {
            
                /* get player point values */
                int playerPoints1 = [self getFramePoints:self.activeFrameData :[NSNumber numberWithInt:1] :self.currentFrameId];
            
                int playerPoints2 = [self getFramePoints:self.activeFrameData :[NSNumber numberWithInt:2] :self.currentFrameId];
            
                // long winded increment here!
                int value = [self.currentFrameId intValue];

            
                [self.db setFrameActiveState:self.currentFrameId  :[NSNumber numberWithInt:1] :[NSNumber numberWithInt:0]];
                
                self.currentFrameId = [NSNumber numberWithInt:value + 1];
            
                /* bring all previous frames into match data */
                [self initMatch :false];
                /* and reset current frame data */
                [self initFrame:self.currentFrameId];
            
                /* reset new frame scores for each player */
                if ([self.joinedFrameResult count] == 0) {
                    self.joinedFrameResult = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%03d/%03d",playerPoints1, playerPoints2], nil];
                } else {
                    [self.joinedFrameResult addObject:[NSString stringWithFormat:@"%03d/%03d  ",playerPoints1,playerPoints2]];
                }
            
                [self.textScorePlayer1 resetFrameScore:0];
                [self.textScorePlayer2 resetFrameScore:0];
                self.activeBreak.playerid = [NSNumber numberWithInt:0];
                [self selectPlayerOne];
                [self.textScorePlayer1 createCurrentFrame:(self.currentFrameId)];
                [self.textScorePlayer2 createCurrentFrame:(self.currentFrameId)];
                [self resetBalls];
                [self addFrameStartDate];
            }
        }
}






-(void)addFrameStartDate {
    // check if currentframe has already a start entry?
    if ([self checkElapsedTime:self.currentFrameId]==false) {
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *rightNow = [dateFormatter stringFromDate:[NSDate date]];
        
        [self.activeBreak setMatchid:self.activeMatchId];
        [self.activeBreak setFrameid:currentFrameId];
        [self.activeBreak setPlayerid:[NSNumber numberWithInt:0]];
        [self.activeBreak setLastshotid:[NSNumber numberWithInt:0]];
        [self.activeBreak setPoints:[NSNumber numberWithInt:0]];
        [self.activeBreak setActive:[NSNumber numberWithInt:activeFlag_FrameStart]];
        [self.activeBreak setEndbreaktimestamp:rightNow];
        [self.activeBreak setDuration:0];
        [self addBreakToData :self.activeBreak];
    }
    
    if (_myTimer) {
        [_myTimer invalidate];
    }
    
    _myTimer = [self createTimer];
    
    _frameTimeInSeconds = 0;
    _entryTimeInSeconds = 0;
    
    if (self.isShotStopWatch) {
        self.labelStopwatch.text = [self formattedShortTime:_entryTimeInSeconds];
    }
    
    self.labelFrameStopwatch.text = [self formattedTime:_frameTimeInSeconds];

    
    
}

#pragma mark - 7 Balls button group

-(void)clearIndicators :(enum IndicatorStyle) indicator {
    
    if (indicator == hide) {
        [self resetIndicator:self.buttonRed :self.redIndicator];
        [self resetIndicator:self.buttonYellow :self.yellowIndicator];
        [self resetIndicator:self.buttonGreen :self.greenIndicator];
        [self resetIndicator:self.buttonBrown :self.brownIndicator];
        [self resetIndicator:self.buttonBlue :self.blueIndicator];
        [self resetIndicator:self.buttonPink :self.pinkIndicator];
        [self resetIndicator:self.buttonBlack :self.blackIndicator];
    } else if (indicator == highlight) {
        [self resetIndicatorStyle:self.redIndicator];
        [self resetIndicatorStyle:self.yellowIndicator];
        [self resetIndicatorStyle:self.greenIndicator];
        [self resetIndicatorStyle:self.brownIndicator];
        [self resetIndicatorStyle:self.blueIndicator];
        [self resetIndicatorStyle:self.pinkIndicator];
        [self resetIndicatorStyle:self.blackIndicator];
    }
}


-(void)resetIndicator :(ball*)pottedBall :(UILabel*) indicatorBall {
    pottedBall.potsInBreakCounter = 0;
    indicatorBall.hidden=true;
}


-(void)resetIndicatorStyle :(UILabel*) indicatorBall {
    //[indicatorBall setFont:[UIFont systemFontOfSize:24]];
    
    UIFont *font = [UIFont fontWithName:@"Avenir-Book" size:24];
    [indicatorBall setFont:font];
    
    //[indicatorBall setFont:[UIFont systemFontOfSize:24.0f weight:UIFontWeightRegular]];
    
    //indicatorBall.font = [UIFont fontWithName:@"Verdana" size:24.0f];
    indicatorBall.textColor = self.skinForegroundColour;
}


-(void)resetBalls {
    self.buttonRed.enabled = true;
    self.buttonRed.quantity = 15;
    self.buttonYellow.enabled = true;
    self.buttonYellow.quantity = 1;
    self.buttonGreen.enabled = true;
    self.buttonGreen.quantity = 1;
    self.buttonBrown.enabled = true;
    self.buttonBrown.quantity = 1;
    self.buttonBlue.enabled = true;
    self.buttonBlue.quantity = 1;
    self.buttonPink.enabled = true;
    self.buttonPink.quantity = 1;
    self.buttonBlack.enabled = true;
    self.buttonBlack.quantity = 1;
    self.activeColour=1;
    self.ballReplaced = false;
}


/* last modified 20161211 */
-(void)endBreakTap:(UITapGestureRecognizer *)gesture {
    int breakThreshold=0;
    NSString *congratsMsg;
    
    if (self.isMatchStarted) {
        /* default when user just clicks on object break ball is missed average difficuty medium length */
        self.shotTypeId = Missed;

        [self.activeBreak setPlayerid :[NSNumber numberWithInt:[self.currentPlayer playerIndex]]];
        [self.activeBreak setDuration:[NSNumber numberWithInt:_entryTimeInSeconds]];
        [self addBreakToData:self.activeBreak];
        
        if (self.activeBreak.points > self.currentPlayer.hbFrame.breakTotal) {
            self.currentPlayer.hbFrame.breakTotal = self.activeBreak.points;
            [self.currentPlayer.hbFrame.breakBalls removeAllObjects];
            [self.currentPlayer.hbFrame.breakBalls addObjectsFromArray:self.activeBreak.shots];
        }
        if (self.currentPlayer.hbFrame.breakTotal > self.currentPlayer.hbMatch.breakTotal) {
            self.currentPlayer.hbMatch.breakTotal =  self.currentPlayer.hbFrame.breakTotal;
             [self.currentPlayer.hbMatch.breakBalls removeAllObjects];
            [self.currentPlayer.hbMatch.breakBalls addObjectsFromArray:self.activeBreak.shots];

        }
        if (self.currentPlayer.hbMatch.breakTotal > self.currentPlayer.hbEver.breakTotal) {
            self.currentPlayer.hbEver.breakTotal =  self.currentPlayer.hbMatch.breakTotal;
             [self.currentPlayer.hbEver.breakBalls removeAllObjects];
            [self.currentPlayer.hbEver.breakBalls addObjectsFromArray:self.activeBreak.shots];
            
            
            if (self.breakThreshholdForCelebration == 0) {
                breakThreshold = [self.currentPlayer.hbEver.breakTotal intValue];
                congratsMsg = [NSString stringWithFormat:@"Congratulations %@, you have beaten your highest break record!", self.currentPlayer.nickName];
            }
        }

        // self.breakThreshholdForCelebration
        

        
        if (self.breakThreshholdForCelebration != 0) {
           // breakThreshold = self.activeBreak.points;
            congratsMsg = [NSString stringWithFormat:@"Congratulations %@, you have made a big break!", self.currentPlayer.nickName];
        }
        
        if ((self.activeBreak.points >= [NSNumber numberWithInt:self.breakThreshholdForCelebration] && self.breakThreshholdForCelebration!=0) || (breakThreshold != 0 && self.breakThreshholdForCelebration==0)) {
            
            if (self.currentPlayer.playerIndex==1) {
                self.closeButtonCongratulations.tintColor = self.skinPlayer1Colour;
                [self.labelCongratsMessage setTextColor:self.skinPlayer1Colour];
                [self.labelCongratsPlayerMessage setTextColor:self.skinPlayer1Colour];
            } else {
                self.closeButtonCongratulations.tintColor = self.skinPlayer2Colour;
                [self.labelCongratsMessage setTextColor:self.skinPlayer2Colour];
                [self.labelCongratsPlayerMessage setTextColor:self.skinPlayer2Colour];
            }

            self.skView.showsFPS = YES;
            self.skView.showsNodeCount = YES;

            celebrationSceneSKV * scene = [celebrationSceneSKV sceneWithSize:self.skView.bounds.size];
            scene.scaleMode = SKSceneScaleModeResizeFill;

            scene.backgroundColor = [UIColor clearColor];
            self.labelCongratsMessage.text = [NSString stringWithFormat:@"%@", self.activeBreak.text];
            self.labelCongratsPlayerMessage.text = congratsMsg;
            
            
            
            // Present the scene.
            [self.skView presentScene:scene];
            
            self.blurView.hidden = false;
            self.skView.hidden = false;
        
        }
                
                
        /* add break score to users frame total and hide the cueball */
        [self closeBreak];
        [self.activeBreak setPlayerid:[NSNumber numberWithInt:0]];
        self.activeBreak.hidden = true;
        [self updateFrameVisitCounter];
        /* next player up */
        [self swapPlayers];
        
    } else {
        
        self.activeMatchId = [self.db insertMatch :self.textScorePlayer1.playerNumber :self.textScorePlayer2.playerNumber];
        if (self.activeMatchId==[NSNumber numberWithInt:1]) {
            /* very first new match */
            self.textScorePlayer1.playerNumber = [NSNumber numberWithInt:1];
            self.textScorePlayer2.playerNumber = [NSNumber numberWithInt:2];
        }
        
        self.buttonSwapPlayer.hidden = false;
        
        if (self.isShotStopWatch) {
            self.labelStopwatch.hidden = false;
        }
  //      self.viewBreak.hidden = false;
        //self.activeBreak.hidden = true;
        [self.activeBreak clearBreak:self.viewBreak];
        
        self.imagePottedBall.image = nil;
        self.imagePottedBall.hidden = false;
        self.isMatchStarted = true;
        self.ballCollectionView.hidden = false;
        [self addFrameStartDate];
    }
}


/* last modified 20161130 */
-(void)ballPotted:(ball*)pottedBall :(indicator*) indicatorBall {
    
    bool freeBall=false;
    ball* pottedFreeBall;

    if (self.activeBreak.playerid == [NSNumber numberWithInt:0]) {

        self.buttonAdjust.enabled = false;
        self.isUndoShot = true;

        self.activeBreak.hidden = false;
        
        [self.activeBreak setMatchid:self.activeMatchId];
        [self.activeBreak setFrameid:currentFrameId];
        [self.activeBreak setPlayerid:[NSNumber numberWithInt:self.currentPlayer.playerIndex]];
        [self.activeBreak setLastshotid:[NSNumber numberWithInt:self.shotTypeId]];
        [self.activeBreak setActive:[NSNumber numberWithInt:activeFlag_Active]];
    }
    
    if (self.shotTypeId == Foul) {

        [self.activeBreak setPlayerid :[NSNumber numberWithInt:[self.currentPlayer playerIndex]]];
        [self.activeBreak setLastshotid:[NSNumber numberWithInt:self.shotTypeId]];
        
       
        if ((self.shotFoulId==foulPotAndInOff && [pottedBall.colour isEqualToString:@"RED"]) || self.shotFoulId==foulWrongRedPot) {
            [self.activeBreak addShotToBreak :self.buttonRed  :self.imagePottedBall :self.viewBreak :[NSNumber numberWithInt:Potted] :[NSNumber numberWithInt:self.shotFoulId] :[NSNumber numberWithInt:0] :self.pocketId :nil :self.isHollow];
        } else {
            [self.activeBreak addShotToBreak :pottedBall  :self.imagePottedBall :self.viewBreak :[NSNumber numberWithInt:Foul] :[NSNumber numberWithInt:self.shotFoulId] :[NSNumber numberWithInt:0] :self.pocketId :nil :self.isHollow];
        }
        
        
        [self.activeBreak setDuration:[NSNumber numberWithInt:_entryTimeInSeconds]];
        [self addBreakToData :self.activeBreak];

        [self closeBreak];

        if ((self.shotFoulId==foulPotAndInOff && [pottedBall.colour isEqualToString:@"RED"]) || self.shotFoulId==foulWrongRedPot) {
            //if (self.activeColour==pottedBall.pottedPoints) {
                [self.buttonRed decreaseQty];
                if (self.buttonRed.quantity == 0) {
                    activeColour ++;
                }
            //}
        }
        
       
        [self.activeBreak.shots removeAllObjects];
        [self.activeBreak setPoints:[NSNumber numberWithInt:pottedBall.foulPoints]];
        [self.activeBreak setLastshotid:[NSNumber numberWithInt:Bonus]];
        [self.activeBreak setPlayerid:[NSNumber numberWithInt:self.opposingPlayer.playerIndex]];
        [self.activeBreak addShotToBreak :pottedBall  :self.imagePottedBall :self.viewBreak :[NSNumber numberWithInt:Bonus] :[NSNumber numberWithInt:self.shotFoulId] :[NSNumber numberWithInt:0] :self.pocketId :nil :self.isHollow];
        [self.activeBreak setDuration:[NSNumber numberWithInt:0]];
        [self addBreakToData :self.activeBreak];
        
        
        [self.activeBreak setPlayerid:[NSNumber numberWithInt:0]];
        
        // add the foul points to opposing player
        [self.opposingPlayer setFoulScore:pottedBall.foulPoints];

        [self.activeBreak clearBreak:self.viewBreak];
        
        self.buttonAdjust.enabled = true;
        self.isUndoShot = false;
        
        [self updateFrameVisitCounter];
        
        [self swapPlayers];
        
        if (scoreState==LiveFrameScore) {
            int liveTotal = self.currentPlayer.currentFrame.frameScore + [self.activeBreak.points intValue];
            self.currentPlayer.text = [NSString stringWithFormat:@"%d",liveTotal];
        }
        
 
        
        

    } else if (self.shotTypeId == Standard || self.shotTypeId == Potted) {
        
        if (self.shotTypeId == Standard) {
            self.shotGroup1SegmentId = Medium;
            self.shotGroup2SegmentId = Average;
            self.shotTypeId = Potted;
            self.pocketId = pocketNone;
            
        }
        
        //int test = [self.activeBreak.points intValue];
        //20160315 testing black tiebreak mechanism.
        
        [self.activeBreak setLastshotid:[NSNumber numberWithInt:self.shotTypeId]];
            if (self.activeColour < pottedBall.pottedPoints && (self.activeBreak.points == [NSNumber numberWithInt:0] || self.activeBreak.points == nil )) {
                // handle freeball scenario - free balls start the moment. Conditions - 1st pot of break.  ball potted greater than current 'live' ball
                
                pottedBall.potsInBreakCounter ++;
                indicatorBall.text = [NSString stringWithFormat:@"%d",pottedBall.potsInBreakCounter];
                
                pottedFreeBall = [pottedBall copy];

                if (self.activeColour==1) {
                    pottedBall = self.buttonRed;
                } else if (self.activeColour==2) {
                    pottedBall = self.buttonYellow;
                } else if (self.activeColour==3) {
                    pottedBall = self.buttonGreen;
                } else if (self.activeColour==4) {
                    pottedBall = self.buttonBrown;
                } else if (self.activeColour==5) {
                    pottedBall = self.buttonBlue;
                } else if (self.activeColour==6) {
                    pottedBall = self.buttonPink;
                }
                
                freeBall=true;
            } else if ([self.activeBreak.points intValue]==0) {
                // save current ball state at beginning of break just in case user cancels break.
                colourStateAtStartOfBreak = activeColour;
                colourQuantityAtStartOfBreak = pottedBall.quantity;
            }
            
            // it is a pot, so credit the current user
            if ([self.activeBreak validateShot] == true) {
 
                [self.currentPlayer incrementNbrBalls:1];
                [self.currentPlayer.currentFrame incrementFrameBallsPotted];
                
                if (pottedBall.quantity >= 1 && pottedBall.pottedPoints == 1 && freeBall == false) {
                    [pottedBall decreaseQty];
                    
                    if (pottedBall.quantity == 0) {
                        activeColour ++;
                        self.ballReplaced=true;
                    }
                } else if (pottedBall.pottedPoints == self.activeColour) {
                    
                    if (self.ballReplaced && pottedBall.pottedPoints == 2) {
                        //Allow Yellow to be potted twice after final red.
                        self.ballReplaced=false;
                        
                    } else if (pottedBall.pottedPoints == 7 && (self.currentPlayer.currentFrame.frameScore + [self.activeBreak.points intValue] +7) == self.opposingPlayer.currentFrame.frameScore) {
                        /* small modification on 20160315 */
                        
                    } else if (freeBall == false) {
                        [pottedBall decreaseQty];
                        self.activeColour ++;
                    }
                } else if (pottedBall.pottedPoints != self.activeColour && self.activeColour == 2 && self.ballReplaced) {
                    self.ballReplaced=false;
                }
                if (freeBall==false) {
                    pottedBall.potsInBreakCounter ++;
                    indicatorBall.text = [NSString stringWithFormat:@"%d",pottedBall.potsInBreakCounter];
                }
                
                
                /* previous potted ball slides out right side of view and new ball slides in transition animation */
                
                self.ballRowDisabledView.hidden = false;
                //[self enableControls :false];
                
                
                CGFloat originalLeadingConstraint = self.breakViewLeadingConstraint.constant;
                CGFloat originalTrailingConstraint = self.breakViewTrailingConstraint.constant;

                self.breakViewLeadingConstraint.constant += self.viewBreak.frame.size.width;
                self.breakViewTrailingConstraint.constant -= self.viewBreak.frame.size.width;
                
                /* TODO - consider if all parms need to be passed still */
                [self.activeBreak addShotToBreak :pottedBall  :self.imagePottedBall :self.viewBreak :[NSNumber numberWithInt:self.shotTypeId] :[NSNumber numberWithInt:notany] :[NSNumber numberWithInt:self.shotGroup2SegmentId] :self.pocketId :pottedFreeBall :self.isHollow];
                
                
                [UIView animateWithDuration:0.2
                                 animations:^{

                                     [self.view layoutIfNeeded];
                                 
                                 }
                                 completion:^(BOOL finished)
                 {
                     
                     //[self enableControls :true];
                     self.ballRowDisabledView.hidden = true;
                     self.viewBreak.hidden=false;
                     NSLog(@"first level animation");

                     /* was inside breakEntry, needed to be moved into here or split. */
                     NSString *labelScore = [NSString stringWithFormat:@"%@",[self.activeBreak points]];
                     self.activeBreak.text = labelScore;
                     
                     UIColor *pottedBallColour;
                     if (pottedFreeBall==nil) {
                         pottedBallColour = pottedBall.ballColour;
                     } else {
                         pottedBallColour = pottedFreeBall.ballColour;
                     }
                     
                     if (self.isHollow) {
                        self.activeBreak.textColor = pottedBallColour;
                     } else {
                        self.imagePottedBall.layer.backgroundColor = pottedBallColour.CGColor;
                     }
                     self.imagePottedBall.layer.borderColor = pottedBallColour.CGColor;

                     
                     self.breakViewLeadingConstraint.constant = originalLeadingConstraint - self.viewBreak.frame.size.width;
                     self.breakViewTrailingConstraint.constant = originalTrailingConstraint + self.viewBreak.frame.size.width;
                     [self.view layoutIfNeeded];
                     self.breakViewLeadingConstraint.constant = originalLeadingConstraint;
                     self.breakViewTrailingConstraint.constant = originalTrailingConstraint;

                     CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
                     animation.fromValue = [NSNumber numberWithFloat:0.0f];
                     animation.toValue = [NSNumber numberWithFloat: 2*M_PI];
                     animation.duration = 0.17f;
                     animation.repeatCount = 2;
                     [self.activeBreak.layer addAnimation:animation forKey:@"SpinAnimation"];

                     [UIView animateWithDuration:0.34
                                      animations:^{
                                          [self.view layoutIfNeeded];
                                      }
                                      completion:^(BOOL finished)
                      {
                        NSLog(@"second level animation");  
                          
                        if (scoreState==LiveFrameScore) {
                            int liveTotal = self.currentPlayer.currentFrame.frameScore + [self.activeBreak.points intValue];
                            self.currentPlayer.text = [NSString stringWithFormat:@"%d",liveTotal];
                        }
                          
                          
                      }];
                 }];
                

                [self clearIndicators :highlight];
                
                UIFont *font = [UIFont fontWithName:@"Avenir-Black" size:24];;
                [indicatorBall setFont:font];
                
                
                indicatorBall.textColor = [UIColor blackColor];
    
                indicatorBall.hidden = false;
            }
        
        [self displayMedal];
        [self.currentPlayer.currentFrame increaseFrameScore:self.currentPlayer.frameScore];
        
        
    } else if (self.shotTypeId == Missed) {

        [self.activeBreak addShotToBreak:pottedBall  :self.imagePottedBall :self.viewBreak :[NSNumber numberWithInt:Missed]  :[NSNumber numberWithInt:notany] :[NSNumber numberWithInt:self.shotGroup2SegmentId] :self.pocketId :nil :self.isHollow];
        [self.activeBreak setDuration:[NSNumber numberWithInt:_entryTimeInSeconds]];
        
        if ([self.activeBreak.points intValue] > 0 ) {
            [self.activeBreak setPlayerid :[NSNumber numberWithInt:[self.currentPlayer playerIndex]]];
            [self.activeBreak setLastshotid:[NSNumber numberWithInt:self.shotTypeId]];
            [self addBreakToData :self.activeBreak];
            [self closeBreak];
            [self.activeBreak setPlayerid:[NSNumber numberWithInt:0]];
            [self.activeBreak clearBreak:self.viewBreak];
            self.buttonAdjust.enabled = true;
            self.isUndoShot = false;
            [self updateFrameVisitCounter];
            [self swapPlayers];
        } else {
            
            [self addBreakToData :self.activeBreak];
            [self.activeBreak setPlayerid:[NSNumber numberWithInt:0]];
            [self.activeBreak setLastshotid:[NSNumber numberWithInt:self.shotTypeId]];
            [self.activeBreak clearBreak:self.viewBreak];
            [self updateFrameVisitCounter];
            [self swapPlayers];
            
            [self.buttonClear setTitle:@"Undo" forState:UIControlStateNormal];
            self.isUndoShot = false;
            
        }
        if (scoreState==LiveFrameScore) {
            int liveTotal = self.currentPlayer.currentFrame.frameScore + [self.activeBreak.points intValue];
            self.currentPlayer.text = [NSString stringWithFormat:@"%d",liveTotal];
        }
        
        
        
    } else if (self.shotTypeId == Safety) {
        
        self.pocketId = pocketNone;
        
        [self.activeBreak addShotToBreak :pottedBall  :self.imagePottedBall :self.viewBreak :[NSNumber numberWithInt:self.shotTypeId] :[NSNumber numberWithInt:notany] :[NSNumber numberWithInt:self.shotGroup2SegmentId] :self.pocketId :nil :self.isHollow];
        
        [self updateFrameVisitCounter];
        
        [self.activeBreak setDuration:[NSNumber numberWithInt:_entryTimeInSeconds]];
        if ([self.activeBreak.points intValue]>0 ) {
            [self.activeBreak setPlayerid :[NSNumber numberWithInt:[self.currentPlayer playerIndex]]];
            
            [self addBreakToData :self.activeBreak];
            [self closeBreak];
            [self.activeBreak setActive:[NSNumber numberWithInt:activeFlag_Active]];
            [self.activeBreak setPlayerid:[NSNumber numberWithInt:0]];
            [self.activeBreak setLastshotid:[NSNumber numberWithInt:self.shotTypeId]];
            [self.activeBreak clearBreak:self.viewBreak];
            self.buttonAdjust.enabled = true;
            self.isUndoShot = false;
            [self swapPlayers];
        } else {

            [self addBreakToData :self.activeBreak];
            [self.activeBreak setPlayerid:[NSNumber numberWithInt:0]];
            [self.activeBreak setLastshotid:[NSNumber numberWithInt:self.shotTypeId]];
            [self.activeBreak clearBreak:self.viewBreak];
            [self swapPlayers];
            self.isUndoShot = false;
        }
        if (scoreState==LiveFrameScore) {
            int liveTotal = self.currentPlayer.currentFrame.frameScore + [self.activeBreak.points intValue];
            self.currentPlayer.text = [NSString stringWithFormat:@"%d",liveTotal];
        }
        
    }
    self.shotTypeId = Standard;
}

/* last modified 20170116 */
- (IBAction)redClicked:(id)sender {
    if (self.isMenuShot==true) {
        [self displayShotMenu :self.buttonRed :self.redIndicator :1];
    } else {
        self.shotTypeId = Standard;
        [self ballPotted:self.buttonRed :self.redIndicator];
    }
}

/* last modified 20170116 */
- (IBAction)yellowClicked:(id)sender {
    
    if (self.isMenuShot==true) {
        [self displayShotMenu :self.buttonYellow :self.yellowIndicator :2];
    } else {
        self.shotTypeId = Standard;
        [self ballPotted:self.buttonYellow :self.yellowIndicator];
    }
}

/* last modified 20170116 */
- (IBAction)greenClicked:(id)sender {
    if (self.isMenuShot==true) {
        [self displayShotMenu :self.buttonGreen :self.greenIndicator :3];
    } else {
        self.shotTypeId = Standard;
        [self ballPotted:self.buttonGreen :self.greenIndicator];
    }
}

/* last modified 20170116 */
- (IBAction)brownClicked:(id)sender {
    if (self.isMenuShot==true) {
        [self displayShotMenu :self.buttonBrown :self.brownIndicator :4];
    } else {
        self.shotTypeId = Standard;
        [self ballPotted:self.buttonBrown :self.brownIndicator];
    }
}

/* last modified 20170116 */
- (IBAction)blueClicked:(id)sender {
    if (self.isMenuShot==true) {
        [self displayShotMenu :self.buttonBlue :self.blueIndicator :5];
    } else {
        self.shotTypeId = Standard;
        [self ballPotted:self.buttonBlue :self.blueIndicator];
    }
}

/* last modified 20170116 */
- (IBAction)pinkClicked:(id)sender {
    if (self.isMenuShot==true) {
        [self displayShotMenu :self.buttonPink :self.pinkIndicator :6];
    } else {
        self.shotTypeId = Standard;
        [self ballPotted:self.buttonPink :self.pinkIndicator];
    }
}

/* last modified 20170116 */
- (IBAction)blackClicked:(id)sender {
    
    if (self.isMenuShot==true) {
        [self displayShotMenu :self.buttonBlack :self.blackIndicator :7];
    } else {
        self.shotTypeId = Standard;
        [self ballPotted:self.buttonBlack :self.blackIndicator];
    }
}

-(ball*)findBall:(int)selectedBall {
    if (selectedBall == 1) {
        return self.buttonRed;
    } else if (selectedBall == 2) {
        return self.buttonYellow;
    } else if (selectedBall == 3) {
        return self.buttonGreen;
    } else if (selectedBall == 4) {
        return self.buttonBrown;
    }else if (selectedBall == 5) {
        return self.buttonBlue;
    }else if (selectedBall == 6) {
        return self.buttonPink;
    }else {
        return self.buttonBlack;
    }
}

#pragma mark - Player (keyboard/swapping etc)

-(void)swapPlayers {
    /* switch the player in focus to the other */
    
    if (self.currentPlayer == self.textScorePlayer1) {
        self.currentPlayer = self.textScorePlayer2;
        self.opposingPlayer = self.textScorePlayer1;
        [self.textPlayerTwoName setTextColor:self.skinSelectedScore];
        [self.textPlayerOneName setTextColor:self.skinForegroundColour];
        [self.labelScoreMatchPlayer2 setTextColor:self.skinSelectedScore];
        [self.labelScoreMatchPlayer1 setTextColor:self.skinForegroundColour ];
        
        self.viewScorePlayer2.layer.borderColor = self.skinSelectedScore.CGColor;
        self.viewScorePlayer2.layer.borderWidth = 1.0f;
        self.viewScorePlayer1.layer.borderColor = self.skinBackgroundColour.CGColor;
        self.viewScorePlayer1.layer.borderWidth = 0.0f;
    } else {
        self.currentPlayer = self.textScorePlayer1;
        self.opposingPlayer = self.textScorePlayer2;
        [self.textPlayerTwoName setTextColor:self.skinForegroundColour];
        [self.textPlayerOneName setTextColor:self.skinSelectedScore];
        [self.labelScoreMatchPlayer2 setTextColor:self.skinForegroundColour];
        [self.labelScoreMatchPlayer1 setTextColor:self.skinSelectedScore];
        
        self.viewScorePlayer1.layer.borderColor = self.skinSelectedScore.CGColor;
        self.viewScorePlayer1.layer.borderWidth = 1.0f;
        self.viewScorePlayer2.layer.borderColor = self.skinBackgroundColour.CGColor;
        self.viewScorePlayer2.layer.borderWidth = 0.0f;
    }
    [self.currentPlayer setTextColor:self.skinSelectedScore];
    [self.opposingPlayer setTextColor:self.skinForegroundColour];
    scoreState = LiveFrameScore;
}

/* last modified 20151014 */
-(void)selectPlayerOneTap:(UITapGestureRecognizer *)gesture {

    NSString *labelScore;
    
    if (self.textScorePlayer1 == self.opposingPlayer) {
        [self selectPlayerOne];
        int liveTotal = self.opposingPlayer.currentFrame.frameScore;
        labelScore = [NSString stringWithFormat:@"%d",liveTotal];
        self.textScorePlayer2.text = labelScore;
    }
    if (scoreState==PreviousFrameScore) {
        // show 'live score'
        int liveTotal = self.currentPlayer.currentFrame.frameScore + [self.activeBreak.points intValue];
        labelScore = [NSString stringWithFormat:@"%d",liveTotal];
        self.currentPlayer.text = labelScore;
        [self.currentPlayer setTextColor:self.skinSelectedScore];
        scoreState = LiveFrameScore;
    } else {
        labelScore = [NSString stringWithFormat:@"%d",self.currentPlayer.currentFrame.frameScore];
        self.currentPlayer.text = labelScore;
        [self.currentPlayer setTextColor:self.skinForegroundColour];
        scoreState = PreviousFrameScore;
    }

}

/* last modified 20151014 */
-(void)celebrationTap:(UITapGestureRecognizer *)gesture {
    [UIView transitionWithView:self.skView
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.blurView.hidden = true;
                        self.skView.hidden=true;
                    }
                    completion:NULL];
    
    
}


/* last modified 20151014 */
-(void)selectPlayerOne {
    self.currentPlayer = self.textScorePlayer1;
    self.opposingPlayer = self.textScorePlayer2;
    [self.currentPlayer setTextColor:self.skinSelectedScore];
    [self.opposingPlayer setTextColor:self.skinForegroundColour ];
    [self.textPlayerOneName setTextColor:self.skinSelectedScore];
    [self.textPlayerTwoName setTextColor:self.skinForegroundColour];
    [self.labelScoreMatchPlayer2 setTextColor:self.skinForegroundColour];
    [self.labelScoreMatchPlayer1 setTextColor:self.skinSelectedScore];
    /* here abcdefg*/
    self.viewScorePlayer1.layer.borderColor = self.skinSelectedScore.CGColor;
    self.viewScorePlayer1.layer.borderWidth = 1.0f;
    self.viewScorePlayer2.layer.borderColor = self.skinBackgroundColour.CGColor;
    self.viewScorePlayer2.layer.borderWidth = 0.0f;

    scoreState = PreviousFrameScore;
    [self displayMedal];
}

/* last modified 20151014 */
-(void)selectPlayerTwoTap:(UITapGestureRecognizer *)gesture {

    NSString *labelScore;
    
    if (self.textScorePlayer2 == self.opposingPlayer) {
        [self selectPlayerTwo];
        int liveTotal = self.opposingPlayer.currentFrame.frameScore;
        labelScore = [NSString stringWithFormat:@"%d",liveTotal];
        self.textScorePlayer1.text = labelScore;
    }
    if (scoreState==PreviousFrameScore) {
            // show 'live score'
            int liveTotal = self.currentPlayer.currentFrame.frameScore + [self.activeBreak.points intValue];
            labelScore = [NSString stringWithFormat:@"%d",liveTotal];
            self.currentPlayer.text = labelScore;
            [self.currentPlayer setTextColor:self.skinSelectedScore];
            scoreState = LiveFrameScore;
    } else {
            labelScore = [NSString stringWithFormat:@"%d",self.currentPlayer.currentFrame.frameScore];
            self.currentPlayer.text = labelScore;
            [self.currentPlayer setTextColor:self.skinForegroundColour];
            scoreState = PreviousFrameScore;
    }
}

/* last modified 20151014 */
-(void)selectPlayerTwo {
    self.currentPlayer = self.textScorePlayer2;
    self.opposingPlayer = self.textScorePlayer1;
    [self.currentPlayer setTextColor:self.skinSelectedScore];
    [self.opposingPlayer setTextColor:self.skinForegroundColour ];
    [self.textPlayerTwoName setTextColor:self.skinSelectedScore];
    [self.textPlayerOneName setTextColor:self.skinForegroundColour ];
    [self.labelScoreMatchPlayer2 setTextColor:self.skinSelectedScore];
    [self.labelScoreMatchPlayer1 setTextColor:self.skinForegroundColour];
    self.viewScorePlayer2.layer.borderColor = self.skinSelectedScore.CGColor;
    self.viewScorePlayer2.layer.borderWidth = 1.0f;
    self.viewScorePlayer1.layer.borderColor = self.skinBackgroundColour.CGColor;
    self.viewScorePlayer1.layer.borderWidth = 0.0f;

    scoreState = PreviousFrameScore;
    [self displayMedal];
}


-(IBAction)dismissPlayerOneKB:(id)sender {
    [self.textPlayerOneName becomeFirstResponder];
    [self.textPlayerOneName resignFirstResponder];
}
-(IBAction)dismissPlayerTwoKB:(id)sender {
    [self.textPlayerTwoName becomeFirstResponder];
    [self.textPlayerTwoName resignFirstResponder];
}
-(IBAction)newFrameClicked:(id)sender {
    [self endOfFrame :true];
}

#pragma mark - Statistics





/* last modified 20151021 */
-(void)swipeLeftShowPlayersStats:(UISwipeGestureRecognizer *)gesture {
    
   [self performSegueWithIdentifier:@"activeMatchStatistics" sender:self];

}


#pragma mark - Match


/* created 20150928 */
/* last modified 20151029 */
-(NSString*) composeResultsFile :(NSMutableArray*) frameDataSet :(NSString*) playerName1 :(NSString*) playerName2 {
    
    NSString *fileData = @"EntryID,BreakEndDT,Frame,Player,shotType,shotDetail1,shotDetail2,BallColor,Points,PotDT,pocketID,duration";
    
    int tempFrameid=1;
    NSNumber *frameIdx = [NSNumber numberWithInt:0];
    int tempEntryid=0;
    
    for (breakEntry *data in frameDataSet) {
        
        if (frameIdx != data.frameid) {
            tempFrameid ++;
            frameIdx = data.frameid;
            NSMutableArray *startDate = [self.db entriesRetreive:[self getMatchId] :nil :frameIdx :nil :nil :[NSNumber numberWithInt:2] :nil :false];
            breakEntry *tempEntry = [[breakEntry alloc] init];
            tempEntry = [startDate objectAtIndex:0];
            fileData = [NSString stringWithFormat:@"%@\n%@,%@,%@,%@,%s,%@,%@,%@,%d,%@,%@,%@",fileData, tempEntry.entryid,tempEntry.endbreaktimestamp,tempEntry.frameid,@"n/a","FrameStart",@"n/a",@"n/a",@"n/a",0,@"n/a",@"n/a",@"n/a"];
        }
        
        NSString *potTimeStamp;
        NSString *playerName;
        NSString *opponentPlayerName;
        if([data.playerid intValue] == 1) {
            playerName = playerName1;
            opponentPlayerName = playerName2;
        } else {
            playerName = playerName2;
            opponentPlayerName = playerName1;
        }
        
        int potIndex = 0;
        
        for (ballShot *ball in data.shots) {
            
            potTimeStamp = ball.shottimestamp;
            int ballPoint;
            ballPoint = [ball.value intValue];
            NSString *shotName;
            NSString *shotDetail1;
            NSString *shotDetail2;
            NSNumber *pocketid;
            
            pocketid = ball.pocketid;
            
            if (ball.shotid == [NSNumber numberWithInt:Potted]) {
                shotName = @"Potted";
                shotDetail1 = [ball getDistanceText:ball.distanceid];
                shotDetail2 = [ball getEffortText:ball.effortid];
            } else if (ball.shotid == [NSNumber numberWithInt:Foul]) {
                shotName = @"Foul";
                shotDetail1 = [ball getFoulTypeText:ball.foulid];
                shotDetail2 = @"n/a";
            } else if (ball.shotid == [NSNumber numberWithInt:Missed]) {
                shotName = @"Missed";
                shotDetail1 = [ball getDistanceText:ball.distanceid];
                shotDetail2 = [ball getEffortText:ball.effortid];
            } else if (ball.shotid == [NSNumber numberWithInt:Safety]) {
                shotName = @"Safety";
                shotDetail1 = [ball getSafetyTypeText:ball.safetyid];
                shotDetail2 = @"n/a";
            } else if (ball.shotid == [NSNumber numberWithInt:Bonus]) {
                shotName = @"Bonus";
                shotDetail1 = [ball getFoulTypeText:ball.foulid];
                shotDetail2 = @"n/a";
            }  else if (ball.shotid == [NSNumber numberWithInt:Adjustment]) {
                shotName = @"Adjustment";
                shotDetail1 = [ball getFoulTypeText:ball.foulid];
                shotDetail2 = @"n/a";
            }
            fileData = [NSString stringWithFormat:@"%@\n%@,%@,%@,%@,%@,%@,%@,%@,%d,%@,%@,%@",fileData, data.entryid,data.endbreaktimestamp,data.frameid,playerName,shotName,shotDetail1,shotDetail2,ball.colour,ballPoint,potTimeStamp,pocketid,data.duration];
            
            potIndex ++;
            
        }
        tempEntryid = [data.entryid intValue];
    }
    
    frameIdx = [NSNumber numberWithInt:tempFrameid];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    fileData = [NSString stringWithFormat:@"%@\n%d,%@,%@,%@,%s,%@,%@,%@,%d,%@",fileData, tempEntryid+1 ,[dateFormatter stringFromDate:[NSDate date]],frameIdx,@"n/a","MatchEnd",@"n/a",@"n/a",@"n/a",0,@"n/a"];
    
    
    return fileData;
}




-(void)processMatchEnd {
    /* so first we present the winner with a congratulations message */
    NSString *alertMessage;
    NSString *titleMessage;

    if (self.labelScoreMatchPlayer1.framesWon > self.labelScoreMatchPlayer2.framesWon) {
        titleMessage = [NSString stringWithFormat:@"Congratulations %@",self.textPlayerOneName.text];
        alertMessage = [NSString stringWithFormat:@"You won the match!\n %@ to %@\n\nIf you are sure the match is finished chose an option below.",self.labelScoreMatchPlayer1.text,self.labelScoreMatchPlayer2.text];
    } else if (self.labelScoreMatchPlayer1.framesWon < self.labelScoreMatchPlayer2.framesWon) {
        titleMessage = [NSString stringWithFormat:@"Congratulations %@",self.textPlayerTwoName.text];
        alertMessage = [NSString stringWithFormat:@"You won the match!\n %@ to %@\n\nIf you are sure the match is finished chose an option below.",self.labelScoreMatchPlayer1.text,self.labelScoreMatchPlayer2.text];
        
    } else {
        titleMessage = @"Match tied";
        alertMessage =[NSString stringWithFormat:@"Score was %@ to %@\n\nIf you are sure the match is finished chose an option below.",self.labelScoreMatchPlayer1.text,self.labelScoreMatchPlayer2.text];
    }
    
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:titleMessage
                                                                   message:alertMessage
                                                            preferredStyle:UIAlertControllerStyleActionSheet]; // 1
    
    
    
    UIAlertAction *GoEndMatchAction = [UIAlertAction actionWithTitle:@"Email & Archive Match"
                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                              self.viewBreak.hidden=false;
                                                              [self endMatch:@"goWithReportandStatistics"];
                                                              NSLog(@"You pressed Go and end Match");
                                                          }];
    
    UIAlertAction *GoEndMatchWithoutReportAction = [UIAlertAction actionWithTitle:@"Archive Match"
                                                       style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                           [self endMatch:@"goWithoutReport"];
                                                           self.viewBreak.hidden=false;
                                                           NSLog(@"You pressed Go and end Match");
                                                       }];
    
    UIAlertAction *GoScratchMatchAction = [UIAlertAction actionWithTitle:@"Scratch/Reset"
                                                                          style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                              [self endMatch :@"goWithScrap"];
                                                 _frameTimeInSeconds = 0;
                                                                              self.viewBreak.hidden=false;
                                                                              NSLog(@"You pressed Scratch Match");
                                                                          }];
    
    
    

    UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                                                               NSLog(@"You pressed cancel");
                                                           }];
    [alert addAction:GoEndMatchWithoutReportAction];
    [alert addAction:GoEndMatchAction];
    [alert addAction:GoScratchMatchAction];
    
    if (self.activeFrameData.count >0) {
        
        if ([self isFrameTied :false]==false) {
        
            UIAlertAction *GoWithCloseAction = [UIAlertAction actionWithTitle:@"Finish Frame & Archive"
                                                                    style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                      
                                                                        
                                                                        [self endOfFrame :false];
                                                                        [self endMatch :@"goWithCloseFrame"];
                                                                        NSLog(@"Close Frame and End Match");
                                                                    }];
            [alert addAction:GoWithCloseAction];
        }
    }
    [alert addAction:CancelAction];
    
    
    
    [self presentViewController:alert animated:YES completion:nil];
}


/* last modified 20161211 */
-(void)endMatch :(NSString*) option {
    
    /* option                       email Y/N       saveStats Y/N       end current frame Y/N
     goWithReportandStatistics      Y               Y                   N
     goWithoutReport                N               Y                   N
     goWithScrap                    N               N                   Y
     goWithCloseFrame               N               Y                   Y
     */
    
    
    if ([option isEqualToString:@"goWithoutReport"] || [option isEqualToString:@"goWithScrap"] || [option isEqualToString:@"goWithCloseFrame"]) {
        /* do nothing with emailing */
    } else {
        
    
        /* next part attempts to compose an email and offer the user to load recipients & send an email */
        BOOL ok = [MFMailComposeViewController canSendMail];
        if (!ok) return;
    
        NSFileManager *fileManager = [NSFileManager defaultManager];
    
        NSString *filePathCSV = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"MatchResults.csv"];
        [fileManager removeItemAtPath:filePathCSV error:nil];

        NSError *error;
        NSString *csvToWrite = [self composeResultsFile :self.activeMatchData :self.textPlayerOneName.text :self.textPlayerTwoName.text];
    

    
        [csvToWrite writeToFile:filePathCSV atomically:YES encoding:NSUTF8StringEncoding error:&error];
    
    
        NSString *body = [self composeMessage];
    
        NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
        [DateFormatter setDateFormat:@"dd-MMM-yyyy"];
    
        MFMailComposeViewController* snookerScorerMailComposer = [MFMailComposeViewController new];
        snookerScorerMailComposer.mailComposeDelegate = self;
        [snookerScorerMailComposer setSubject:[NSString stringWithFormat:@"Snooker Score Master - Matchday :%@", [DateFormatter stringFromDate:[NSDate date]]]];
    
        [snookerScorerMailComposer setToRecipients:[NSArray arrayWithObjects:self.emailPlayer1, self.emailPlayer2, nil]];
    
        [snookerScorerMailComposer setMessageBody:body isHTML:YES];

        NSData *csvFile = [NSData dataWithContentsOfFile:filePathCSV];
        [snookerScorerMailComposer addAttachmentData:csvFile
                                        mimeType:@"text/plain"
                                        fileName:@"SSMResults.csv"];
    
    
        [self presentViewController:snookerScorerMailComposer animated:YES completion:nil];
    
    }
    
    if ([option isEqualToString:@"goWithScrap"]) {
        [self deleteMatchData];
        [self refreshScoreboard :self.textScorePlayer1];
        [self refreshScoreboard :self.textScorePlayer2];
    }
    else if ([option isEqualToString:@"goWithReportandStatistics"] || [option isEqualToString:@"goWithoutReport"] || [option isEqualToString:@"goWithCloseFrame"]) {
        
        self.textScorePlayer1.wonframes = self.labelScoreMatchPlayer1.framesWon;
        self.textScorePlayer2.wonframes = self.labelScoreMatchPlayer2.framesWon;
        
        
        [self getFramesWon:self.currentFrameId :self.labelScoreMatchPlayer1 :self.labelScoreMatchPlayer2];

        self.textScorePlayer1.highestBreak = [common getHiBreak:self.activeMatchData :[NSNumber numberWithInt:self.textScorePlayer1.playerIndex] :[NSNumber numberWithInt:0]];
        
        self.textScorePlayer2.highestBreak = [common getHiBreak:self.activeMatchData :[NSNumber numberWithInt:self.textScorePlayer2.playerIndex] :[NSNumber numberWithInt:0]];
        
        [self.db updateActiveMatchData :self.textScorePlayer1 :self.textScorePlayer2];

    }
    
    /* this long winded part resets the application */
    [self.textScorePlayer1 resetFrameScore:0];
    [self.textScorePlayer2 resetFrameScore:0];
    
    [self.textScorePlayer1.frames removeAllObjects];
    [self.labelScoreMatchPlayer1 resetFramesWon];
    self.labelScoreMatchPlayer1.text = @"0";
    self.textScorePlayer1.highestBreak = 0;
    [self.textScorePlayer1.highestBreakHistory removeAllObjects];
    self.textScorePlayer1.nbrBallsPotted = 0;
    self.textScorePlayer1.currentFrameIndex=1;
    self.textScorePlayer1.nbrOfBreaks=0;
    self.textScorePlayer1.sumOfBreaks=0;
    self.textScorePlayer1.currentFrame.matchScore=0;
    [self.textScorePlayer1.playersBreaks removeAllObjects];
    
    
    [self.textScorePlayer2.frames removeAllObjects];
    [self.labelScoreMatchPlayer2 resetFramesWon];
    self.labelScoreMatchPlayer2.text = @"0";
    self.textScorePlayer2.highestBreak = 0;
    [self.textScorePlayer2.highestBreakHistory removeAllObjects];
    self.textScorePlayer2.nbrBallsPotted = 0;
    self.textScorePlayer2.currentFrameIndex=1;
    self.textScorePlayer2.nbrOfBreaks=0;
    self.textScorePlayer2.sumOfBreaks=0;
    self.textScorePlayer2.currentFrame.matchScore=0;
    [self.textScorePlayer2.playersBreaks removeAllObjects];
    [self.joinedFrameResult removeAllObjects];
    
    self.textScorePlayer1.frameScore=0;
    self.textScorePlayer1.text=@"0";
    
    self.textScorePlayer2.frameScore=0;
    self.textScorePlayer2.text=@"0";
    
    self.buttonAdjust.enabled = true;
    self.isUndoShot = false;

    self.currentFrameId=[NSNumber numberWithInt:1];

    [self resetBalls];
    self.imagePottedBall.image = [UIImage imageNamed:@"one-finger-tap"];
    self.activeBreak.text = @"";
    
    self.imagePottedBall.layer.backgroundColor = [UIColor whiteColor].CGColor;
    self.imagePottedBall.layer.borderColor = [UIColor whiteColor].CGColor;
    
    
    self.activeBreak.hidden = false;
    self.labelStopwatch.hidden = true;
    self.isMatchStarted = false;
    self.ballCollectionView.hidden = true;
    
    _frameVisitCounter=0;
    self.labelVisitCounter.text = [NSString stringWithFormat:@"Visits %d",_frameVisitCounter];

    // Reload the player break details
    //self.textScorePlayer1.hiBreakHistory = [self.db playerHiBreakInPreviousMatches:self.textScorePlayer1.playerNumber];
    //self.textScorePlayer2.hiBreakHistory = [self.db playerHiBreakInPreviousMatches:self.textScorePlayer2.playerNumber];
    
    // new
    self.textScorePlayer1 = [self setPlayerData:self.textScorePlayer1];
    self.textScorePlayer2 = [self setPlayerData:self.textScorePlayer2];
    
    
    // This is where we need to show the advert once again!
    [self performSegueWithIdentifier:@"showAdvert" sender:self];
    //showAdvert
    
}

#pragma mark - Email message construction

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:nil];
}

/* created 20150928 */
/* modified 20160208 */
-(NSString*) getSmallImage :(NSString*)ballcolour {
    
    if ([ballcolour isEqualToString:@"RED"]) {
        return [NSString stringWithFormat:@"%@red_01_small.png",self.skinPrefix];
    } else if ([ballcolour isEqualToString:@"YELLOW"]) {
        return [NSString stringWithFormat:@"%@yellow_02_small.png",self.skinPrefix];
    } else if ([ballcolour isEqualToString:@"GREEN"]) {
        return [NSString stringWithFormat:@"%@green_03_small.png",self.skinPrefix];
    } else if ([ballcolour isEqualToString:@"BROWN"]) {
        return [NSString stringWithFormat:@"%@brown_04_small.png",self.skinPrefix];
    } else if ([ballcolour isEqualToString:@"BLUE"]) {
        return [NSString stringWithFormat:@"%@blue_05_small.png",self.skinPrefix];;
    } else if ([ballcolour isEqualToString:@"PINK"]) {
        return [NSString stringWithFormat:@"%@pink_06_small.png",self.skinPrefix];;
    } else if ([ballcolour isEqualToString:@"BLACK"]) {
        return [NSString stringWithFormat:@"%@black_07_small.png",self.skinPrefix];;
    }
    return @"";
}



/* modified 20151013 */
-(NSString*)composePlayerStatsForFrame :(NSNumber*) playerId :(NSNumber*)frameId  {

    NSMutableArray *frame = [self getData:self.activeMatchData :frameId];
    
    NSString *hiBreakPlayer = [NSString stringWithFormat:@"</br>Highest Break: %d</br></br>",[common getHiBreak:frame :playerId :frameId]];
    
    NSString *bonusPoints = [NSString stringWithFormat:@"</br>Bonus Points: %d",[common getScoreByShotId:frame :playerId :[NSNumber numberWithInt:Bonus]]];
    
    NSString *PottedPoints = [NSString stringWithFormat:@"</br>Potted Points: %d ",[common getScoreByShotId:frame :playerId :[NSNumber numberWithInt:Potted]]];
    
    
    NSString *hiBreakBallsPlayer;
    NSString *hiBreakBallsStringFormat;
    
        hiBreakBallsPlayer = @"</br>";
        hiBreakBallsStringFormat = @"%@%@%@%@</br>%@";

 
    for (ballShot *ballObj in [common getHiBreakBalls:self.activeMatchData :playerId :frameId]) {
        /* added check to make sure only pots are shown */
        if (ballObj.shotid == [NSNumber numberWithInt:Potted]) {
            UIImage *emailImage = [UIImage imageNamed:[self getSmallImage:ballObj.colour]];

            NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(emailImage)];
            NSString *base64String = [imageData base64EncodedStringWithOptions:0 ];
            NSString *ballImageData = [NSString stringWithFormat:@"<img src='data:image/png;base64,%@'>",base64String];

                hiBreakBallsPlayer = [NSString stringWithFormat:@"%@%@&nbsp",hiBreakBallsPlayer, ballImageData];

        }
    }
    NSString *ballsPotted = [NSString stringWithFormat:@"Total Pots: %d</br>", [common getAmtOfBallsPotted:self.activeMatchData :playerId :frameId]];
    
    NSString *dataPlayer;

        dataPlayer = [NSString stringWithFormat:hiBreakBallsStringFormat,ballsPotted, PottedPoints, bonusPoints, hiBreakPlayer, hiBreakBallsPlayer];

    return dataPlayer;
}





/* created 20150927 */
-(NSString*)getStatisticsText :(NSNumber*)playerId :(NSMutableArray*) frameData :(NSString*) lineBreak :(int)item {

    NSString *nameOfPlayer;
    if (playerId==[NSNumber numberWithInt:1]) {
        nameOfPlayer = self.textPlayerOneName.text;
    } else {
        nameOfPlayer = self.textPlayerTwoName.text;
    }
    
    if (item==0) {
        return [NSString stringWithFormat:@"Tap to view %@'s statistics!", nameOfPlayer];
    }
    
    NSString *dataAvgPlayer = [NSString stringWithFormat:@"Average Break = %0.2f", [common getAvgBreakAmt:frameData :playerId]];
    
    if (item==1) {
        return dataAvgPlayer;
    }

    
    NSString *dataNbrOfPots = [NSString stringWithFormat:@"Pots / ScoringVisits / Visits = %d/%d/%d", [common getAmtOfBallsPotted:frameData :playerId :[NSNumber numberWithInt:0]], [common getTotalScoringVisits:frameData :playerId],[common getTotalVisits:frameData :playerId]];
    
    if (item==2) {
        return dataNbrOfPots;
    }
    
    
    /* count the number of colours that have been potted */
    NSString *ballStats=@"";
    int ballCount;
    
    NSArray  *colours = [NSArray arrayWithObjects:@"reds",@"yellows",@"greens",@"browns",@"blues",@"pinks",@"blacks",nil];

    for (int i = 7; i > 0; i--) {
        ballCount = [common getQtyOfBallsByColor:frameData :playerId :[NSNumber numberWithInt:i]];
        if (ballCount>0) {
            ballStats = [NSString stringWithFormat:@"%@%@=%d  ", ballStats,  [colours objectAtIndex:i-1] , ballCount];
        }
    }
    if ([ballStats length]>2) {
        ballStats = [ballStats substringToIndex:[ballStats length] - 2];
    } else {
        ballStats = @"no colours potted";
    }
    if (item==3) {
        return ballStats;
    }
    
    
    // highest break data
    NSString *dataHighestBreak = [NSString stringWithFormat:@"Highest Break = %d",[common getHiBreak:frameData :playerId :[NSNumber numberWithInt:0]]];
    
    if (item==4) {
        return dataHighestBreak;
    }
    
    
    
    NSMutableDictionary *breakdown  = [[NSMutableDictionary alloc] init];;
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"points"
                                                 ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray;
    sortedArray = [frameData sortedArrayUsingDescriptors:sortDescriptors];
    // obtain totals
    for (breakEntry *data in sortedArray) {
        if (playerId == data.playerid && data.lastshotid != [NSNumber numberWithInt:Bonus]) {
            NSString *paddedBreak = [NSString stringWithFormat:@"%03d",[data.points intValue]];
            paddedBreak = [NSString stringWithFormat:@"%@%@",[paddedBreak substringToIndex:[paddedBreak length] - 1],@"0"];
            if ([data.points intValue] < 10) {
                break;
            } else {
                NSNumber *occuances = [breakdown valueForKey:paddedBreak];
                
                int value = [occuances intValue];
                occuances = [NSNumber numberWithInt:value + 1];
                
                [breakdown setValue:occuances forKey:paddedBreak];
            }
        }
    }
    // write 3 totals
    NSString *breakstats = @"";
    
    for(id key in breakdown) {
        id value = [breakdown objectForKey:key];
        breakstats = [NSString stringWithFormat:@"%@ > %@ = %@%@",breakstats, key, value, @" /"];
    }
    
    if ([breakstats length] > 0) {
        breakstats = [breakstats substringToIndex:[breakstats length] - 1];
    }
    
    if([breakstats isEqualToString:@""]) {
        breakstats = @"Player has not yet had any breaks of note!";
    }
    
    if (item==5) {
        return breakstats;
    }

    NSString *result = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",dataHighestBreak,lineBreak,dataAvgPlayer,lineBreak,dataNbrOfPots,lineBreak,ballStats,lineBreak];
    
    return [NSString stringWithFormat:@"%@BREAKS:%@%@",result,breakstats,lineBreak];
    
}


-(NSString*)composeMessage {
    
    NSString *matchheader = @"<h1>Match Statistics</h1>";
    NSString *matchJoinedResults =@"";
    
    for (NSMutableArray *obj in self.joinedFrameResult) {
        matchJoinedResults = [NSString stringWithFormat:@"%@  %@", matchJoinedResults, obj];
    }
    
    matchheader = [NSString stringWithFormat:@"%@</br>Scores:%@</br></br>",matchheader,matchJoinedResults];
    
    NSString *tableHeader = [NSString stringWithFormat: @"<table style='table-layout:fixed' width=100%% bgcolor='#EAEAEA' border=0 cellpadding='10'><tr><td width=50%% valign='top' bgcolor='#0000CD'><h2><font color='#FFFFFF'>%@: %@</font></h2><font color='#FFFFFF'>%@</font></td><td width=50%% valign='top' bgcolor='#D32525'><h2><font color='#FFFFFF'>%@: %@</font></h2><font color='#FFFFFF'>%@</font></td></tr>",self.textPlayerOneName.text, self.labelScoreMatchPlayer1.framesWon,[self getStatisticsText:[NSNumber numberWithInt:1] :self.activeMatchData :@"</br>" :-1], self.textPlayerTwoName.text, self.labelScoreMatchPlayer2.framesWon, [self getStatisticsText :[NSNumber numberWithInt:2] :self.activeMatchData :@"</br>" :-1]];

    NSString *dataFrameHeader =@"";
    NSString *tableDetail = @"";
    NSString *dataPlayer1;
    NSString *dataPlayer2;
    NSString *scorePlayer1;
    NSString *scorePlayer2;

    for (int frameIndex = 0; frameIndex < [self.currentFrameId intValue] - 1; frameIndex++) {
        dataFrameHeader = [NSString stringWithFormat:@"<tr bgcolor='#951A1A'><td><h3><font color='#FFFFFF'>Frame %d </br>(%@)</font></h3></td><td></td></tr>",frameIndex+1, [self getElapsedTime:[NSNumber numberWithInt:frameIndex+1] :self.importedFile]];
        
        scorePlayer1 = [NSString stringWithFormat:@"<h4>Score: %d</h4>",[self getFramePoints:self.activeMatchData :[NSNumber numberWithInt:1] :[NSNumber numberWithInt:frameIndex+1]]];
        scorePlayer2 = [NSString stringWithFormat:@"<h4>Score: %d</h4>",[self getFramePoints:self.activeMatchData :[NSNumber numberWithInt:2] :[NSNumber numberWithInt:frameIndex+1]]];

        dataPlayer1 = [self composePlayerStatsForFrame:[NSNumber numberWithInt:1] :[NSNumber numberWithInt:frameIndex+1]];
        dataPlayer2 = [self composePlayerStatsForFrame:[NSNumber numberWithInt:2] :[NSNumber numberWithInt:frameIndex+1]];
        
        
        tableDetail = [NSString stringWithFormat:@"%@%@<tr><td><font color='#000000'>%@</font></td><td><font color='#000000'>%@</font></td></tr><tr><td valign='top'><font color='#000000'>%@</font></td><td valign='top'><font color='#000000'>%@</font></td></tr>", tableDetail,dataFrameHeader,scorePlayer1,scorePlayer2,dataPlayer1,dataPlayer2];
    }
    NSString *tableFooter = @"</table>";
    NSString *data = [NSString stringWithFormat:@"%@%@%@%@",matchheader, tableHeader, tableDetail, tableFooter];
    return data;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
    /* frame specific detail that is shared in the statistics part */
    int pointsRemaining=0;
    int p1ActiveBreak=0, p2ActiveBreak=0;
    
    // How many points remaining?
    for (int i = 7; i >= 1; i--)
    {
        if (i==1) {
            pointsRemaining += (self.buttonRed.quantity * 8);
        } else if (self.activeColour <= i) {
            pointsRemaining += i;
        } else {
            i=1;
        }
    }
    // get difference between players scores..
    
    if (self.currentPlayer == self.textScorePlayer1) {
        p1ActiveBreak = [self.activeBreak.points intValue];
        p2ActiveBreak = 0;
        
    } else {
        p1ActiveBreak = 0;
        p2ActiveBreak = [self.activeBreak.points intValue];
    }
        
 

    if([segue.identifier isEqualToString:@"showAdjustNumberPicker"]){
        adjustVC *controller = (adjustVC *)segue.destinationViewController;
        controller.delegate = self;
        controller.sumOfPlayerFouls = self.currentPlayer.currentFrame.foulScore;
        controller.ballIndex = self.buttonRed.quantity+self.buttonYellow.quantity+self.buttonGreen.quantity+self.buttonBrown.quantity+self.buttonBlue.quantity+self.buttonPink.quantity+self.buttonBlack.quantity;
        controller.skins = self.theme;
        controller.skinPrefix = self.skinPrefix;
        
        if (self.currentPlayer == self.textScorePlayer1) {
            controller.playerName = self.textPlayerOneName.text;
        } else {
            controller.playerName = self.textPlayerTwoName.text;
        }
        controller.skinForegroundColour = self.skinForegroundColour;
        controller.skinBackgroundColour = self.skinBackgroundColour;
        controller.skinPlayer1Colour = self.skinPlayer1Colour;
        controller.skinPlayer2Colour = self.skinPlayer2Colour;
        
        
    } else if([segue.identifier isEqualToString:@"player1DetailShow"]){
        /* current match data */
        match *m = [[match alloc]init];
        
        m.Player1FrameWins = self.labelScoreMatchPlayer1.framesWon;
        m.Player2FrameWins = self.labelScoreMatchPlayer2.framesWon;
        m.Player1HiBreak = self.textScorePlayer1.hiBreak;
        m.Player2HiBreak = self.textScorePlayer2.hiBreak;
        m.Player1Number = self.textScorePlayer1.playerNumber;
        m.Player2Number = self.textScorePlayer2.playerNumber;
        m.matchid = self.activeMatchId;
        
        playerDetailVC *controller = (playerDetailVC *)segue.destinationViewController;
        controller.delegate = self;
        controller.playerIndex = 1;
        controller.nickName = self.textPlayerOneName.text;
        controller.imagePathPhoto = self.textScorePlayer1.photoLocation;
        controller.email = self.textScorePlayer1.emailAddress;
        controller.currentPlayerNumber = [self.textScorePlayer1.playerNumber intValue];
        controller.photoUpdated = false;
        controller.staticPlayer1Number = [self.textScorePlayer1.playerNumber intValue];
        controller.staticPlayer2Number = [self.textScorePlayer2.playerNumber intValue];
        
        controller.currentPlayerHiBreak = [NSNumber  numberWithInt:self.textScorePlayer1.highestBreak];
        controller.currentPlayerHighestBreakHistory = self.textScorePlayer1.highestBreakHistory;

        controller.staticPlayer1CurrentBreak = p1ActiveBreak;
        controller.staticPlayer2CurrentBreak = p2ActiveBreak;
        controller.activeMatchId = self.activeMatchId;
        controller.activeMatchPlayers = m;
        controller.activeBreakShots = self.activeBreak.shots;
        controller.skinPrefix = self.skinPrefix;
        controller.skinForegroundColour = self.skinForegroundColour;
        controller.skinBackgroundColour = self.skinBackgroundColour;
        controller.skinPlayer1Colour = self.skinPlayer1Colour;
        controller.skinPlayer2Colour = self.skinPlayer2Colour;
        
        controller.activeFramePointsRemaining = [common getPointsRemainingInFrame:self.buttonRed :self.activeBreak :self.activeColour];
        
        controller.theme = self.theme;
        controller.isHollow = self.isHollow;
        controller.db = self.db;
        controller.p1 = self.textScorePlayer1;
        controller.p2 = self.textScorePlayer2;

        
    
    } else if([segue.identifier isEqualToString:@"player2DetailShow"]){
        /* current match data */
        match *m = [[match alloc]init];
        
        m.Player1FrameWins = self.labelScoreMatchPlayer1.framesWon;
        m.Player2FrameWins = self.labelScoreMatchPlayer2.framesWon;
        m.Player1HiBreak = self.textScorePlayer1.hiBreak;
        m.Player2HiBreak = self.textScorePlayer2.hiBreak;
        m.Player1Number = self.textScorePlayer1.playerNumber;
        m.Player2Number = self.textScorePlayer2.playerNumber;
        m.matchid = self.activeMatchId;

        playerDetailVC *controller = (playerDetailVC *)segue.destinationViewController;
        controller.delegate = self;
        controller.playerIndex = 2;
        controller.nickName = self.textPlayerTwoName.text;
        controller.imagePathPhoto = self.textScorePlayer2.photoLocation;
        controller.email = self.textScorePlayer2.emailAddress;
        controller.currentPlayerNumber = [self.textScorePlayer2.playerNumber intValue];
        controller.photoUpdated = false;
        controller.staticPlayer1Number = [self.textScorePlayer1.playerNumber intValue];
        controller.staticPlayer2Number = [self.textScorePlayer2.playerNumber intValue];
        controller.currentPlayerHiBreak = [NSNumber  numberWithInt:self.textScorePlayer2.highestBreak];
        controller.currentPlayerHighestBreakHistory = self.textScorePlayer2.highestBreakHistory;
        controller.staticPlayer1CurrentBreak = p1ActiveBreak;
        controller.staticPlayer2CurrentBreak = p2ActiveBreak;
        controller.activeMatchId = self.activeMatchId;
        controller.activeMatchPlayers = m;
        controller.activeBreakShots = self.activeBreak.shots;
        controller.isHollow = self.isHollow;
        controller.theme = self.theme;
        controller.skinForegroundColour = self.skinForegroundColour;
        controller.skinBackgroundColour = self.skinBackgroundColour;
        controller.skinPlayer1Colour = self.skinPlayer1Colour;
        controller.skinPlayer2Colour = self.skinPlayer2Colour;
        
        controller.p1 = self.textScorePlayer1;
        controller.p2 = self.textScorePlayer2;
        
        controller.activeFramePointsRemaining = [common getPointsRemainingInFrame:self.buttonRed :self.activeBreak :self.activeColour];
        controller.db = self.db;
        
    } else if([segue.identifier isEqualToString:@"activeMatchStatistics"]){
        
        matchStatisticsVC  *controller = (matchStatisticsVC *)segue.destinationViewController;
        controller.delegate = self;
        
        match *m = [[match alloc]init];

        m.Player1FrameWins = self.labelScoreMatchPlayer1.framesWon;
        m.Player2FrameWins = self.labelScoreMatchPlayer2.framesWon;
        m.Player1HiBreak = self.textScorePlayer1.hiBreak;
        m.Player2HiBreak = self.textScorePlayer2.hiBreak;
        m.Player1Number = self.textScorePlayer1.playerNumber;
        m.Player2Number = self.textScorePlayer2.playerNumber;
        m.matchid = self.activeMatchId;

        controller.p1 = self.textScorePlayer1;
        controller.p2 = self.textScorePlayer2;
        controller.p1.activeBreak = [NSNumber numberWithInt:p1ActiveBreak];
        controller.p2.activeBreak = [NSNumber numberWithInt:p2ActiveBreak];
        controller.db = self.db;
        controller.activeMatchPlayers = m;
        controller.activeFramePointsRemaining = [common getPointsRemainingInFrame:self.buttonRed :self.activeBreak :self.activeColour];
        controller.m = m;
        //controller.skinPrefix = self.skinPrefix;
        controller.displayState = self.displayState;
        controller.activeMatchStatistcsShown = true;
        controller.isHollow = self.isHollow;
        controller.theme = self.theme;
        
        controller.activeShots = self.activeBreak.shots;
        
        controller.skinForegroundColour = self.skinForegroundColour;
        controller.skinBackgroundColour = self.skinBackgroundColour;
        controller.skinPlayer1Colour = self.skinPlayer1Colour;
        controller.skinPlayer2Colour = self.skinPlayer2Colour;
        
    }
    
     else if([segue.identifier isEqualToString:@"presentHelp"]){
         
         
         
     }
    
    
}


#pragma mark - Delegate functions


- (void)addItemViewController:(playerDetailVC *)controller didInsertPlayer :(int)playerId :(NSString*) playerName :(NSString*) playerEmail :(NSString*) playerImageName :(bool)photoUpdated :(NSString*) playerkey {
}

/* created 20170118 */
-(void)refreshScoreboard :(player*) p {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    bool updatedAvatarImage = false;
    
    if (p.playerIndex==1) {
        

        self.textScorePlayer1.playerNumber = p.playerNumber;
        self.textScorePlayer1.emailAddress = p.emailAddress;
        self.textScorePlayer1.photoLocation = p.photoLocation;
        self.textScorePlayer1.nickName = p.nickName;
        
        
        self.textPlayerOneName.text = p.nickName;
        
        self.emailPlayer1 = p.emailAddress;
        
        
        
        if (self.imagePlayer1 != p.photoLocation) {
            updatedAvatarImage = true;
            self.imagePlayer1 = p.photoLocation;
        }
    } else {
        
        self.textScorePlayer2.playerNumber = p.playerNumber;
        self.textScorePlayer2.emailAddress = p.emailAddress;
        self.textScorePlayer2.photoLocation = p.photoLocation;
        self.textScorePlayer2.nickName = p.nickName;
        
        
        self.textPlayerTwoName.text = p.nickName;
        self.emailPlayer2 = p.emailAddress;
        
        if (self.imagePlayer2 != p.photoLocation) {
            updatedAvatarImage = true;
            self.imagePlayer2 = p.photoLocation;
        }
    }
    
    
    if (updatedAvatarImage) {
        
        if ([p.photoLocation isEqualToString:@""]) {
            [self.openPlayer2DetailButton setImage:[UIImage imageNamed:@"avatar0"] forState:UIControlStateNormal];
        } else {
            
            NSData *pngData = [NSData dataWithContentsOfFile:[[paths objectAtIndex:0] stringByAppendingPathComponent:p.photoLocation]];
            if (p.playerIndex==1) {
                [self.openPlayer1DetailButton setImage:[UIImage imageWithData:pngData] forState:UIControlStateNormal];
            } else {
                [self.openPlayer2DetailButton setImage:[UIImage imageWithData:pngData] forState:UIControlStateNormal];
            }
            
        }
    }

}


// created 07/01/2016
- (void)addItemViewController:(playerDetailVC *)controller didUpdatePlayer :(NSNumber*) newPlayerNumber :(int)playerId :(NSString*) playerName :(NSString*) playerEmail :(NSString*) playerImageName :(bool)photoUpdated {

    
    //[self refreshScoreboard];
    NSNumber *playerNumber;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    bool updatedAvatarImage = false;
    
    if (playerId==1) {
        
        playerNumber = newPlayerNumber;
        self.textScorePlayer1.playerNumber = playerNumber;
        self.textScorePlayer1.emailAddress = playerEmail;
        self.textScorePlayer1.photoLocation = playerImageName;
        self.textScorePlayer1.nickName = playerName;
        
        
        self.textPlayerOneName.text = playerName;
        
        self.emailPlayer1 = playerEmail;
        
        
        
        if (self.imagePlayer1 != playerImageName) {
            updatedAvatarImage = true;
            self.imagePlayer1 = playerImageName;
        }
    } else {
        
        playerNumber = newPlayerNumber;
        self.textScorePlayer2.playerNumber = playerNumber;
        self.textScorePlayer2.emailAddress = playerEmail;
        self.textScorePlayer2.photoLocation = playerImageName;
        self.textScorePlayer2.nickName = playerName;
        
        
        self.textPlayerTwoName.text = playerName;
        self.emailPlayer2 = playerEmail;
        
        if (self.imagePlayer2 != playerImageName) {
            updatedAvatarImage = true;
            self.imagePlayer2 = playerImageName;
        }
    }
    
    
    if (updatedAvatarImage) {
        
        if ([playerImageName isEqualToString:@""]) {
            [self.openPlayer2DetailButton setImage:[UIImage imageNamed:@"avatar0"] forState:UIControlStateNormal];
        } else {
            
            NSData *pngData = [NSData dataWithContentsOfFile:[[paths objectAtIndex:0] stringByAppendingPathComponent:playerImageName]];
            if (playerId==1) {
                [self.openPlayer1DetailButton setImage:[UIImage imageWithData:pngData] forState:UIControlStateNormal];
            } else {
                [self.openPlayer2DetailButton setImage:[UIImage imageWithData:pngData] forState:UIControlStateNormal];
            }
            
        }
    }

    
    [self.db updateMatchPlayers :self.textScorePlayer1.playerNumber :self.textScorePlayer2.playerNumber];
    
    if (playerId==1) {
        [self.db updatePlayer :self.textScorePlayer1];
    } else {
        [self.db updatePlayer :self.textScorePlayer2];
    }
    
    [self setPlayerData:self.textScorePlayer1];
    [self setPlayerData:self.textScorePlayer2];
    
    
}

-(void)addItemViewController:(adjustVC *)controller didPickDeduction:(int)selectedPoints {
    
    ball* currentBall = [[ball alloc] init];
    
    [self.activeBreak setMatchid:self.activeMatchId];
    [self.activeBreak setFrameid:currentFrameId];
    [self.activeBreak setPlayerid:[NSNumber numberWithInt:self.currentPlayer.playerIndex]];
    [self.activeBreak setLastshotid:[NSNumber numberWithInt:Bonus]];
    [self.activeBreak setActive:[NSNumber numberWithInt:activeFlag_Active]];
    [self.activeBreak setEndbreaktimestamp:@""];

    [self.activeBreak setPoints:[NSNumber numberWithInt:selectedPoints]];
    [self.activeBreak setPlayerid:[NSNumber numberWithInt:self.currentPlayer.playerIndex]];
    
    currentBall.foulPoints = selectedPoints;
    
    [self.activeBreak addShotToBreak :currentBall  :self.imagePottedBall :self.viewBreak :[NSNumber numberWithInt:Bonus] :[NSNumber numberWithInt:adjusted] :[NSNumber numberWithInt:0] :self.pocketId :nil :self.isHollow];

    [self.activeBreak setDuration:[NSNumber numberWithInt:_entryTimeInSeconds]];
    
    [self addBreakToData:self.activeBreak];
    [self closeBreak];
    [self.activeBreak setPlayerid:[NSNumber numberWithInt:0]];
}

    
    
/* modified 20151006 */
- (void)addItemViewController:(adjustVC *)controller didPickBallAdjust:(int)startBallIndex :(int)ballIndex {
    
    ball* currentBall = [[ball alloc] init];
    
    [self.activeBreak setMatchid:self.activeMatchId];
    [self.activeBreak setFrameid:currentFrameId];
    [self.activeBreak setPlayerid:[NSNumber numberWithInt:0]];
    [self.activeBreak setLastshotid:[NSNumber numberWithInt:Adjustment]];
    [self.activeBreak setActive:[NSNumber numberWithInt:activeFlag_Active]];
    [self.activeBreak setEndbreaktimestamp:@""];
    
    int runningPoints=0;
    
    for(int i=startBallIndex;i>ballIndex;i--) {
        
        if (i>6) {
            // reds
            currentBall = self.buttonRed;
            runningPoints++;
            // cover the switch between the last red and the yellow
            if (i==7) {
                activeColour = 2;
            }
            [currentBall decreaseQty];
        
            [self.activeBreak addShotToBreak :currentBall  :self.imagePottedBall :self.viewBreak :[NSNumber numberWithInt:Adjustment] :[NSNumber numberWithInt:adjusted] :[NSNumber numberWithInt:0] :self.pocketId :nil :self.isHollow];
            colourQuantityAtStartOfBreak = ballIndex - 6;
    
        } else {
            // colours
            if (i==6) {
                currentBall = self.buttonYellow;
            } else if (i==5) {
                currentBall = self.buttonGreen;
            } else if (i==4) {
                currentBall = self.buttonBrown;
            } else if (i==3) {
                currentBall = self.buttonBlue;
            } else if (i==2) {
                currentBall = self.buttonPink;
            } else if (i==1) {
                currentBall = self.buttonBlack;
            }
            
            [currentBall decreaseQty];
            self.activeColour = 8 - i + 1;
            runningPoints+=currentBall.pottedPoints;
            
             [self.activeBreak addShotToBreak :currentBall  :self.imagePottedBall :self.viewBreak :[NSNumber numberWithInt:Adjustment] :[NSNumber numberWithInt:adjusted] :[NSNumber numberWithInt:0] :self.pocketId :nil :self.isHollow];
            colourQuantityAtStartOfBreak = 1;
        }
    }
    
    [self.activeBreak setDuration:[NSNumber numberWithInt:_entryTimeInSeconds]];
    [self.activeBreak setPoints:[NSNumber numberWithInt:runningPoints]];
    [self addBreakToData:self.activeBreak];
    [self closeBreak];
}


/* created 20161127 */
-(void)setBreakBallColour :(ballShot*)ball :(UIImageView*)breakBall {
    
    if ([ball.colour isEqual:@"RED"]) {
        breakBall.layer.backgroundColor = self.buttonRed.backgroundColor.CGColor;
        breakBall.layer.borderColor = self.buttonRed.backgroundColor.CGColor;
    } else  if ([ball.colour isEqual:@"YELLOW"]) {
        breakBall.layer.backgroundColor = self.buttonYellow.backgroundColor.CGColor;
        breakBall.layer.borderColor = self.buttonYellow.backgroundColor.CGColor;
    } else  if ([ball.colour isEqual:@"GREEN"]) {
        breakBall.layer.backgroundColor = self.buttonGreen.backgroundColor.CGColor;
        breakBall.layer.borderColor = self.buttonGreen.backgroundColor.CGColor;
    } else  if ([ball.colour isEqual:@"BROWN"]) {
        breakBall.layer.backgroundColor = self.buttonBrown.backgroundColor.CGColor;
        breakBall.layer.borderColor = self.buttonBrown.backgroundColor.CGColor;
    } else  if ([ball.colour isEqual:@"BLUE"]) {
        breakBall.layer.backgroundColor = self.buttonBlue.backgroundColor.CGColor;
        breakBall.layer.borderColor = self.buttonBlue.backgroundColor.CGColor;
    } else  if ([ball.colour isEqual:@"PINK"]) {
        breakBall.layer.backgroundColor = self.buttonPink.backgroundColor.CGColor;
        breakBall.layer.borderColor = self.buttonPink.backgroundColor.CGColor;
    } else  if ([ball.colour isEqual:@"BLACK"]) {
        breakBall.layer.backgroundColor = self.buttonBlack.backgroundColor.CGColor;
        breakBall.layer.borderColor = self.buttonBlack.backgroundColor.CGColor;
    }
    
}




/* last modified 20161127 */
-(IBAction)clearClicked:(id)sender {
    
    if (self.isUndoShot) {
        /* undo last shot entry */
        
        NSString *alertMessage;
        NSString *titleMessage;

        __block ballShot* deletedBall = [[ballShot alloc] init];
        
        deletedBall = [self.activeBreak.shots objectAtIndex:self.activeBreak.shots.count - 1];
        titleMessage = @"Undo Shots in Current Break!";
        alertMessage = @"Either undo the last shot or clear the current break";
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:titleMessage
                                                                       message:alertMessage
                                                                preferredStyle:UIAlertControllerStyleActionSheet];
        
        UIAlertAction *LastShotAction = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"Last Shot - %@",[[deletedBall.colour lowercaseString] capitalizedString]]
                                                               style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                   NSLog(@"You pressed undo last shot ");
                                                                   
                                                                   if (self.activeBreak.shots.count > 1) {
                                                                       
                                                                       ballShot* previousBall = [[ballShot alloc] init];
                                                                       
                                                                       [self.currentPlayer setNbrBallsPotted:(self.currentPlayer.nbrBallsPotted - 1)];
                                                                   
                                                                       self.currentPlayer.currentFrame.frameBallsPotted -= 1;
                                                                   
                                                                       previousBall = [self.activeBreak.shots objectAtIndex:self.activeBreak.shots.count - 2];

                                                                       CGFloat originalLeadingConstraint = self.breakViewLeadingConstraint.constant;
                                                                       CGFloat originalTrailingConstraint = self.breakViewTrailingConstraint.constant;
                                                                       
                                                                       self.breakViewLeadingConstraint.constant -= self.viewBreak.frame.size.width;
                                                                       self.breakViewTrailingConstraint.constant += self.viewBreak.frame.size.width;
                                                                       
                                                                       [UIView animateWithDuration:0.2
                                                                                        animations:^{
                                                                                            
                                                                                            [self.view layoutIfNeeded];
                                                                                            
                                                                                        }
                                                                                        completion:^(BOOL finished)
                                                                        {
                                                                            NSLog(@"first level animation");
                                                                            
                                                                            [self setBreakBallColour :previousBall :self.imagePottedBall];

                                                                            int points = [self.activeBreak.points intValue] - [deletedBall.value intValue];
                                                                            
                                                                            self.activeBreak.points = [NSNumber numberWithInt:points];
                                                                            
                                                                            self.activeBreak.text = [NSString stringWithFormat:@"%@",self.activeBreak.points];
                                                                            
                                                                            
                                                                            
                                                                            self.breakViewLeadingConstraint.constant = originalLeadingConstraint + self.viewBreak.frame.size.width;
                                                                            self.breakViewTrailingConstraint.constant = originalTrailingConstraint - self.viewBreak.frame.size.width;
                                                                            [self.view layoutIfNeeded];
                                                                            
                                                                            self.breakViewLeadingConstraint.constant = originalLeadingConstraint;
                                                                            self.breakViewTrailingConstraint.constant = originalTrailingConstraint;
                                                                            
                                                                            CABasicAnimation* animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
                                                                            animation.fromValue = [NSNumber numberWithFloat:0.0f];
                                                                            animation.toValue = [NSNumber numberWithFloat: -2*M_PI];
                                                                           // rotationAnimation.toValue = @(-2.0*M_PI);
                                                                            
                                                                            animation.duration = 0.25f;
                                                                            animation.repeatCount = 2;
                                                                            [self.activeBreak.layer addAnimation:animation forKey:@"SpinAnimation"];

                                                                            
                                                                            [UIView animateWithDuration:0.5
                                                                                             animations:^{
                                                                                                 [self.view layoutIfNeeded];
                                                                                             }
                                                                                             completion:^(BOOL finished)
                                                                             {
                                                                                 NSLog(@"second level animation");  
                                                                                 
                                                                                 
                                                                                 /* is medal taken away again? */
                                                                                 [self displayMedal];
                                                                                 
                                                                                 /* we need to remove the indictor just applied */
                                                                                 [self clearIndicators :highlight];
                                                                                 
                                                                                 if ([deletedBall.colour isEqualToString:@"RED"]) {
                                                                                     [self undoBallinShot :deletedBall :self.buttonRed :self.redIndicator];
                                                                                 } else if ([deletedBall.colour isEqualToString:@"YELLOW"]) {
                                                                                     [self undoBallinShot :deletedBall :self.buttonYellow :self.yellowIndicator];
                                                                                 } else if ([deletedBall.colour isEqualToString:@"GREEN"]) {
                                                                                     [self undoBallinShot :deletedBall :self.buttonGreen :self.greenIndicator];
                                                                                 } else if ([deletedBall.colour isEqualToString:@"BROWN"]) {
                                                                                     [self undoBallinShot :deletedBall :self.buttonBrown :self.brownIndicator];
                                                                                 } else if ([deletedBall.colour isEqualToString:@"BLUE"]) {
                                                                                     [self undoBallinShot :deletedBall :self.buttonBlue :self.blueIndicator];
                                                                                 } else if ([deletedBall.colour isEqualToString:@"PINK"]) {
                                                                                     [self undoBallinShot :deletedBall :self.buttonPink :self.pinkIndicator];
                                                                                 } else if ([deletedBall.colour isEqualToString:@"BLACK"]) {
                                                                                     [self undoBallinShot :deletedBall :self.buttonBlack :self.blackIndicator];
                                                                                 }
                                                                                 self.isUndoShot = true;
                                                                                 
                                                                                 self.ballRowDisabledView.hidden = true;
                                                                                 
                                                                                 [self.activeBreak.shots removeLastObject];
                                                                                 
                                                                                 if (scoreState==LiveFrameScore) {
                                                                                     int liveTotal = self.currentPlayer.currentFrame.frameScore + [self.activeBreak.points intValue];
                                                                                     self.currentPlayer.text = [NSString stringWithFormat:@"%d",liveTotal];;
                                                                                 }
                                                                                 
                                                                                 
                                                                             }];
                                                                        }];

                                                                       
                                                                      // self.imagePottedBall.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@.png",self.skinPrefix,previousBall.imageNameLarge]];
                                                                       
                                                                    
                                                                       
                                                                       
                                                                   } else {
                                                                       /* final ball in break, we do something similar to clearing the whole break.*/
                                                                       
                                                                       /* need to test this part! */
                                                                       
                                                                       self.isUndoShot = false;
                                                                       
                                                                       [self.activeBreak clearBreak:self.viewBreak];
                                                                       [self clearIndicators :hide];
                                                                       
                                                                       [self.activeBreak setPlayerid:[NSNumber numberWithInt:0]];
                                                                       
                                                                       self.buttonAdjust.enabled=true;
                                                                       
                                                                       ball* currentBall;
                                                                    
                                                                       for (int i = colourStateAtStartOfBreak; i <= activeColour; i++)
                                                                       {
                                                                           currentBall = [self findBall:i];

                                                                           if (i==1) {
                                                                               currentBall.quantity=colourQuantityAtStartOfBreak;
                                                                               currentBall.enabled = true;
                                                                           } else {
                                                                               currentBall.quantity=1;
                                                                               currentBall.enabled = true;
                                                                               
                                                                           }
                                                                       }
                                                                       activeColour = colourStateAtStartOfBreak;
                                                                       
                                                                       [self setBallCounters];
                                                                       
                                                                       self.medalImgPlayer1.alpha=0.0f;
                                                                       self.medalImgPlayer2.alpha=0.0f;
                                                                       
                                                                       [self.activeBreak.shots removeLastObject];
                                                                       
                                                                       if (scoreState==LiveFrameScore) {
                                                                           int liveTotal = self.currentPlayer.currentFrame.frameScore + [self.activeBreak.points intValue];
                                                                           self.currentPlayer.text = [NSString stringWithFormat:@"%d",liveTotal];;
                                                                       }
                                                                       
                                                                       
                                                                   }
                                                                  
                                                                   


                                                               }];

        UIAlertAction *CurrentBreakAction = [UIAlertAction actionWithTitle:[NSString stringWithFormat:@"Current Break of %@",self.activeBreak.points]
                                                                 style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                     NSLog(@"You pressed undo whole break");
                                                                     ball* currentBall;
                                                                     /* below is clear whole active break, to do if user wants to clear break or wants to remove only shot in break */
                                                                     if ([self.activeBreak.points intValue] > 0) {
                                                                         self.buttonAdjust.enabled = true;
                                                                         
                                                                         self.isUndoShot = false;
                                                                         
                                                                         [self.currentPlayer setNbrBallsPotted:(self.currentPlayer.nbrBallsPotted - (int)self.activeBreak.shots.count)];
                                                                         
                                                                         self.currentPlayer.currentFrame.frameBallsPotted -= (int)self.activeBreak.shots.count;
                                                                         
                                                                         [self.activeBreak clearBreak:self.viewBreak];
                                                                         [self clearIndicators :hide];
                                                                         
                                                                         // reset counters impacted!
                                                                         for (int i = colourStateAtStartOfBreak; i <= activeColour; i++)
                                                                         {
                                                                             currentBall = [self findBall:i];
                                                                             
                                                                             if (i==1) {
                                                                                 currentBall.quantity=colourQuantityAtStartOfBreak;
                                                                                 currentBall.enabled = true;
                                                                             } else {
                                                                                 currentBall.quantity=1;
                                                                                 currentBall.enabled = true;
                                                                                 
                                                                             }
                                                                             
                                                                         }
                                                                         activeColour = colourStateAtStartOfBreak;
                                                                         [self.activeBreak setPlayerid:[NSNumber numberWithInt:0]];
                                                                     }
                                                                     
                                                                     self.medalImgPlayer1.alpha=0.0f;
                                                                     self.medalImgPlayer2.alpha=0.0f;
                                                                     
                                                                     if (scoreState==LiveFrameScore) {
                                                                         int liveTotal = self.currentPlayer.currentFrame.frameScore + [self.activeBreak.points intValue];
                                                                         self.currentPlayer.text = [NSString stringWithFormat:@"%d",liveTotal];;
                                                                     }
                                                                     
                                                                 }];
        
        
        UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                                                               NSLog(@"You pressed cancel");
                                                           }];
        
        [alert addAction:LastShotAction];
        [alert addAction:CurrentBreakAction];
        [alert addAction:CancelAction];

        [self presentViewController:alert animated:YES completion:nil];
   

        
    } else {
        /* undo last break entry */
        
        if (self.activeFrameData.count == 0 ) {
            // nothing to do!

            NSString *alertMessage;
            NSString *titleMessage;
            
            titleMessage = @"Nothing to do!";
            alertMessage = @"No entries to undo in current frame";

            UIAlertController *alert = [UIAlertController alertControllerWithTitle:titleMessage
                                                                           message:alertMessage
                                                                    preferredStyle:UIAlertControllerStyleActionSheet];
            
            UIAlertAction *OkAction = [UIAlertAction actionWithTitle:@"Ok"
                                                                   style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                       NSLog(@"You pressed cancel");
                                                                   }];

            [alert addAction:OkAction];
            [self presentViewController:alert animated:YES completion:nil];
            
            
        } else {
            /* must be tested more!  */
            breakEntry *lastBreak = [[breakEntry alloc] init];
            lastBreak = [self.activeFrameData objectAtIndex:self.activeFrameData.count - 1];
            
            NSString *visitor;
            NSNumber *visitorIndex = lastBreak.playerid;
            NSNumber *visitorBreakAmount = lastBreak.points;
            NSMutableArray *visitorShots = lastBreak.shots;
            
            __block ballShot *firstShot = [visitorShots firstObject];
            NSNumber *visitorShotId = [firstShot valueForKey:@"shotid"];
            
            if ([visitorIndex intValue]==1) {
                visitor = self.textPlayerOneName.text;
            } else if ([visitorIndex intValue]==2) {
                visitor = self.textPlayerTwoName.text;
            } else {
                visitor = @"adjustor";
            }
            
            NSString *alertMessage;
            NSString *titleMessage;

            if ([visitorShotId intValue] == Potted) {
                titleMessage = @"Undo Whole Break";
                alertMessage = [NSString stringWithFormat:@"You can either undo %@'s Last Entry or Rerack the whole frame.",visitor];
            }
            else if ([visitorShotId intValue] == Safety || [visitorShotId intValue] == Missed) {
                NSString *shotName;
                if ([visitorShotId intValue] == Safety ) {
                    titleMessage = @"Undo Safety";
                    shotName = @"safety";
                } else {
                    titleMessage = @"Undo Missed";
                    shotName = @"missed shot";
                }
                alertMessage = [NSString stringWithFormat:@"You can either undo %@'s %@ or rerack the whole frame.", visitor, shotName];
 
            } else {
                NSString *shotName;
                if ([visitorShotId intValue] == Foul ) {
                    shotName = @"foul";
                    titleMessage = @"Undo Foul";
                } else {
                    shotName = @"bonus";
                    titleMessage = @"Undo Bonus";
                }
                alertMessage = [NSString stringWithFormat:@"You can either undo the %@ points %@ received or Rerack the whole frame.", shotName, visitor];
                
            }
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:titleMessage
                                                                           message:alertMessage
                                                                    preferredStyle:UIAlertControllerStyleActionSheet];
            
            NSString *lastEntryText;
            if (visitorBreakAmount == [NSNumber numberWithInt:0])  {
                lastEntryText = @"Last Entry";
            } else {
                lastEntryText = [NSString stringWithFormat:@"Last Entry of %@ points", visitorBreakAmount];
            }
            
            UIAlertAction *LastEntryAction = [UIAlertAction actionWithTitle:lastEntryText
                                                               style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                   /* obtain break that is about to be deleted first potted ball. this will give us the best
                                                                    chance to get correct colour state when action is made. if shotid is not Potted we do nothing 
                                                                    a free ball also works here due to it being transformed into active ball */
                                                                   if (firstShot.shotid==[NSNumber numberWithInt:Potted]) {
                                                                       activeColour = [firstShot.value intValue];
                                                                   }
                                                                   
                                                                   [self removeLastBreak];
                                                                   
                                                                   [self.textScorePlayer1 updateFrameScore:[self getFramePoints:self.activeFrameData :[NSNumber numberWithInt:1]  :self.currentFrameId]];
                                                                   [self.textScorePlayer2 updateFrameScore:[self getFramePoints:self.activeFrameData :[NSNumber numberWithInt:2] :self.currentFrameId]];
                                                                   
                                                                   
                                                                   self.textScorePlayer1 = [self setPlayerData:self.textScorePlayer1];
                                                                   self.textScorePlayer2 = [self setPlayerData:self.textScorePlayer2];
                                                                   
                                                                   
                                                                   [self setBallCounters];
                                                                   
                                                                   [self selectPlayerOne];
                                                                   scoreState=LiveFrameScore;
                                                                   
                                                                    NSLog(@"You pressed undo last entry");
                                                                   
                                                               }];
            
            UIAlertAction *RerackAction = [UIAlertAction actionWithTitle:@"Rerack"
                                                                style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                        [self.activeFrameData removeAllObjects];
                                                                        // now we need to tidy up!!
                                                                        [self.textScorePlayer1 updateFrameScore:0];
                                                                        [self.textScorePlayer2 updateFrameScore:0];
                                                                        [self resetBalls];
                                                                        [self selectPlayerOne];
                                                                        [self rerackFrameData];
                                                                        // ERROR here, need to test the frame entries from db too.
                                                                    self.frameVisitCounter=0;
                                                                    self.labelVisitCounter.text = @"Reracked!";
                                                                    NSLog(@"%@", [NSString stringWithFormat:@"frmae number:%@",self.currentFrameId]);
                                                                        NSLog(@"You pressed Rerack");
                                                                    
                                                                    
                                                                    self.textScorePlayer1 = [self setPlayerData:self.textScorePlayer1];
                                                                    self.textScorePlayer2 = [self setPlayerData:self.textScorePlayer2];
                                                                    
                                                                    
                                                                    }];

            
            UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                                   style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                                                                       NSLog(@"You pressed cancel");
                                                                   }];
            
            [alert addAction:LastEntryAction];
            [alert addAction:RerackAction];
            [alert addAction:CancelAction];
            
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        
    }
}


/* created 20151003 */
/* last modified 20151006 */
-(void) undoBallinShot :(ballShot*) selectedBall :(ball*) ballButton :(indicator*) ballIndicator {
    ballButton.potsInBreakCounter--;
    if (selectedBall.killed==[NSNumber numberWithInt:1]) {
        ballButton.enabled=true;
        ballButton.quantity ++;
        
        if (ballButton.pottedPoints==2) {
            self.ballReplaced=false;
        }
        
        self.activeColour=[selectedBall.value intValue];
    } else {
        if (self.activeColour==2) {
            self.ballReplaced=true;
        }
    }
    ballIndicator.text = [NSString stringWithFormat:@"%d",ballButton.potsInBreakCounter];
    if ([ballIndicator.text isEqualToString:@"0"]) {
        ballIndicator.hidden=true;
    }
}



#pragma mark - other



-(ball *)getShotBall :(NSString*) ballColour {
    ball *shotBall;
    
    if  ([self.shotBallColour isEqualToString:@"red"]) {
        return self.buttonRed;
    } else if  ([self.shotBallColour isEqualToString:@"yellow"]) {
        return self.buttonYellow;
    } else if  ([self.shotBallColour isEqualToString:@"green"]) {
        return self.buttonGreen;
    }else if  ([self.shotBallColour isEqualToString:@"brown"]) {
        return self.buttonBrown;
    }else if  ([self.shotBallColour isEqualToString:@"blue"]) {
        return self.buttonBlue;
    }else if  ([self.shotBallColour isEqualToString:@"pink"]) {
        return self.buttonPink;
    }else if  ([self.shotBallColour isEqualToString:@"black"]) {
        return self.buttonBlack;
    }
    return shotBall;
}



/* last modified 20170116 */
-(void)gestureBallLongPress:(UILongPressGestureRecognizer *)gesture
{
    UIGestureRecognizer *recognizer = (UIGestureRecognizer*) gesture;
    
    if(UIGestureRecognizerStateBegan == gesture.state)
    {
        long tag = recognizer.view.tag;
        // get ball object depending on what user pressed
        ball *ballPressed;
        indicator *indicatorOfBallPressed;
        if (tag==1) {
            ballPressed = self.buttonRed;
            indicatorOfBallPressed = self.redIndicator;
        } else if (tag==2) {
            ballPressed = self.buttonYellow;
            indicatorOfBallPressed = self.yellowIndicator;
        } else if (tag==3) {
            ballPressed = self.buttonGreen;
            indicatorOfBallPressed = self.greenIndicator;
        } else if (tag==4) {
            ballPressed = self.buttonBrown;
            indicatorOfBallPressed = self.brownIndicator;
        } else if (tag==5) {
            ballPressed = self.buttonBlue;
            indicatorOfBallPressed = self.blueIndicator;
        } else if (tag==6) {
            ballPressed = self.buttonPink;
            indicatorOfBallPressed = self.pinkIndicator;
        } else if (tag==7) {
            ballPressed = self.buttonBlack;
            indicatorOfBallPressed = self.blackIndicator;
        }
        
        [self displayShotMenu :ballPressed :indicatorOfBallPressed :tag];
    }
}

 /*
  created 20170116
  last modified 20170116 
  */
-(void)displayShotMenu: (ball*) selectedBall :(indicator*) indicatorOfBall :(long) ballTag
{
        
        NSString *titleMessage;
        
        
        int currentPlayerIndex = self.currentPlayer.playerIndex;
        if (currentPlayerIndex==1) {
            titleMessage = [NSString stringWithFormat:@"Nominate shot played by %@",self.textPlayerOneName.text];
           
        } else {
            titleMessage = [NSString stringWithFormat:@"Nominate shot played by %@",self.textPlayerTwoName.text];
        }

        NSString *alertMessage = @"The selected ball might be either the\ntarget or the foul ball itself.";

        UIAlertController *alert = [UIAlertController alertControllerWithTitle:titleMessage
                                                                       message:alertMessage
                                                                preferredStyle:UIAlertControllerStyleActionSheet];

        CGRect viewFrame = CGRectMake( 5, 20, 40, 40 );
        UIImageView *ballPressedView = [[UIImageView alloc]initWithFrame:viewFrame];
        [common makeBallImage:ballPressedView :ballPressedView.frame.origin.x :ballPressedView.frame.origin.y :ballPressedView.frame.size.width :5.0f];
        ballPressedView.backgroundColor = selectedBall.ballColour;
        ballPressedView.layer.borderColor = selectedBall.ballColour.CGColor;
        
        [alert.view addSubview:ballPressedView];
        
  
        NSString *pottedText = [NSString stringWithFormat:@"POTTED %@",[selectedBall.colour uppercaseString]];
        
        NSString *freeballText = [NSString stringWithFormat:@"Potted free-ball (%d points)",self.activeColour];
        
        NSString *foulPotAndInoffText = [NSString stringWithFormat:@"Potted %@ & in-off ",[selectedBall.colour lowercaseString]];
        
        NSString *inoffText = [NSString stringWithFormat:@"In-off playing %@",[selectedBall.colour lowercaseString]];
        
        NSString *missedBallText = [NSString stringWithFormat:@"Missed ball while playing %@",[selectedBall.colour lowercaseString]];
        
        NSString *wrongBallText = [NSString stringWithFormat:@"Wrong ball potted/hit"];
        
        NSString *wrongRedPotText = [NSString stringWithFormat:@"Red ball potted playing %@" , [selectedBall.colour lowercaseString]];
        
        
        
        UIAlertAction *pottedAction = [UIAlertAction actionWithTitle:pottedText
                                                                  style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                    
                                                                      self.shotTypeId = Standard;
                                                                      [self ballPotted:selectedBall :indicatorOfBall];
                                                                      
                                                                      
                                                                      NSLog(@"you made a pot");
                                                                      
                                                                  }];
        [pottedAction setValue:selectedBall.ballColour forKey:@"titleTextColor"];
        
        
        UIAlertAction *freeBallAction = [UIAlertAction actionWithTitle:freeballText
                                                               style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                   
                                                                   self.shotTypeId = Standard;
                                                                   [self ballPotted:selectedBall :indicatorOfBall];
                                                                   
                                                                   NSLog(@"well done you potted a free-ball");
                                                                   
                                                               }];
        [freeBallAction setValue:selectedBall.ballColour forKey:@"titleTextColor"];
        
       
        
        
        
        UIAlertAction *foulPotAndInoffAction = [UIAlertAction actionWithTitle:foulPotAndInoffText
                                                                 style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                     
                                                                     self.shotTypeId=Foul;
                                                                     self.shotFoulId=foulPotAndInOff;
                                                                     
                                                                     [self ballPotted:selectedBall :indicatorOfBall];
                                                                    
                                                                     NSLog(@"you potted the white in-off while potting the object ball");
                                                                 
                                                                 }];
    
        
       
        
        [foulPotAndInoffAction setValue: [UIColor colorWithRed:139.0f/255.0f green:12.0f/255.0f blue:0.0f/255.0f alpha:1.0f] forKey:@"titleTextColor"];
        
        UIAlertAction *inoffAction = [UIAlertAction actionWithTitle:inoffText
                                                                 style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                     
                                                                     self.shotTypeId=Foul;
                                                                     self.shotFoulId=foulInOff;
                                                        
                                                                    [self ballPotted:selectedBall :indicatorOfBall];
                                                                     
                                                                     
                                                                     NSLog(@"whoops you potted the white in-off");
                                                                     
                                                                 }];
        [inoffAction setValue:[UIColor colorWithRed:139.0f/255.0f green:12.0f/255.0f blue:0.0f/255.0f alpha:1.0f]  forKey:@"titleTextColor"];
        
        
        UIAlertAction *wrongBallAction = [UIAlertAction actionWithTitle:wrongBallText
                                                                 style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                     
                                                                     self.shotTypeId=Foul;
                                                                     self.shotFoulId=foulWrongPotOrHit;
                                                                     
                                                                    [self ballPotted:selectedBall :indicatorOfBall];
                                                                     
                                                                     NSLog(@"You potted ot hit the wrong ball");
                                                                     
                                                                 }];
        [wrongBallAction setValue:[UIColor colorWithRed:139.0f/255.0f green:12.0f/255.0f blue:0.0f/255.0f alpha:1.0f]  forKey:@"titleTextColor"];
        
        UIAlertAction *missedBallAction = [UIAlertAction actionWithTitle:missedBallText
                                                                  style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                      
                                                                      self.shotTypeId=Foul;
                                                                      self.shotFoulId=foulMissedBall;
                                                                      
                                                                      [self ballPotted:selectedBall :indicatorOfBall];
                                                                      
                                                                      NSLog(@"You missed the ball altogether");
                                                                      
                                                                  }];
        [missedBallAction setValue:[UIColor colorWithRed:139.0f/255.0f green:12.0f/255.0f blue:0.0f/255.0f alpha:1.0f]  forKey:@"titleTextColor"];
        
        
        UIAlertAction *wrongPotRedAction = [UIAlertAction actionWithTitle:wrongRedPotText
                                                                  style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                      
                                                                      self.shotTypeId=Foul;
                                                                      self.shotFoulId=foulWrongRedPot;
                                                                      
                                                                      [self ballPotted:selectedBall :indicatorOfBall];
                                                                      
                                                                      [self clearIndicators :hide];
                                                                      
                                                                      NSLog(@"You potted the red when you shouldn't have");
                                                                      
                                                                  }];
        [wrongPotRedAction setValue:[UIColor colorWithRed:139.0f/255.0f green:12.0f/255.0f blue:0.0f/255.0f alpha:1.0f]  forKey:@"titleTextColor"];
        
        
        
        
        UIAlertAction *CancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                                                               NSLog(@"You pressed cancel");
                                                           }];
    
   
    if (ballTag!=self.activeColour && (self.activeBreak.points==[NSNumber numberWithInt:0] || self.activeBreak.points==nil)) {
        [alert addAction:freeBallAction];
    } else {
         [alert addAction:pottedAction];
    }
    
    if (ballTag==self.activeColour) {
        [alert addAction:foulPotAndInoffAction];
    }
    [alert addAction:inoffAction];
    
    [alert addAction:wrongBallAction];
    [alert addAction:missedBallAction];
        
    if (ballTag!=1 && self.activeColour==1) {
        [alert addAction:wrongPotRedAction];
    }
    [alert addAction:CancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}




-(void)gesturePauseLongPress:(UILongPressGestureRecognizer *)gesture
{
    if(UIGestureRecognizerStateBegan == gesture.state)
    {
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *rightNow = [dateFormatter stringFromDate:[NSDate date]];
        if (self.isPaused) {
            self.isPaused=false;
            [self.db deletePausedEntry];
            [self enableControls:true];
            [common makeRoundButtonOwnColour:self.buttonSwapPlayer :self.buttonSwapPlayer.frame.origin.x :self.buttonSwapPlayer.frame.origin.y :self.buttonSwapPlayer.frame.size.width :self.skinForegroundColour];
            //need to stop all activity except the
            self.buttonSwapPlayer.backgroundColor = self.skinForegroundColour ;
            self.buttonSwapPlayer.layer.borderColor = self.skinForegroundColour.CGColor;
            self.labelStopwatch.hidden = true;

            self.labelStopwatch.textColor = self.skinForegroundColour;
            //[self.buttonSwapPlayer setTitleColor:self.skinMainFontColor forState:UIControlStateNormal];
            
        } else {
            self.isPaused=true;
            self.labelStopwatch.hidden = false;
            self.labelStopwatch.text=@"paused";
            [self.activeBreak setMatchid:self.activeMatchId];
            [self.activeBreak setFrameid:currentFrameId];
            [self.activeBreak setPlayerid:[NSNumber numberWithInt:0]];
            [self.activeBreak setLastshotid:[NSNumber numberWithInt:0]];
            [self.activeBreak setPoints:[NSNumber numberWithInt:0]];
            [self.activeBreak setActive:[NSNumber numberWithInt:activeFlag_PausedState]];
            [self.activeBreak setEndbreaktimestamp:rightNow];
            [self.activeBreak setDuration:[NSNumber numberWithInt:_frameTimeInSeconds]];
            [self addBreakToData :self.activeBreak];
            
            [self enableControls:false];
            
            self.buttonSwapPlayer.backgroundColor = [UIColor redColor];
            self.buttonSwapPlayer.layer.borderColor = [UIColor redColor].CGColor;
            //[self.buttonSwapPlayer setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
           self.labelStopwatch.textColor = [UIColor redColor];
        }
    }
}

/* created 20160711 */
/* last modified 20160711 */
-(void)enableControls :(bool) enabledFlag {
    self.buttonEnd.enabled=enabledFlag;
    self.buttonClear.enabled=enabledFlag;
    self.buttonAdjust.enabled=enabledFlag;
    self.buttonNew.enabled=enabledFlag;
    self.buttonRed.enabled=enabledFlag;
    self.buttonYellow.enabled=enabledFlag;
    self.buttonGreen.enabled=enabledFlag;
    self.buttonBrown.enabled=enabledFlag;
    self.buttonBlue.enabled=enabledFlag;
    self.buttonPink.enabled=enabledFlag;
    self.buttonBlack.enabled=enabledFlag;
}




- (IBAction)endMatchPressed:(id)sender {
    [self closeBreak];
    [self processMatchEnd];
    
}





/* created 20151004 */
-(void)setBallCounters {
    self.buttonRed.enabled=true;
    self.buttonYellow.enabled=true;
    self.buttonGreen.enabled=true;
    self.buttonBrown.enabled=true;
    self.buttonBlue.enabled=true;
    self.buttonPink.enabled=true;
    self.buttonBlack.enabled=true;
    
    self.buttonRed.colour = @"RED";
    self.buttonRed.ballColour=[UIColor colorWithRed:217.0f/255.0f green:23.0f/255.0f blue:60.0f/255.0f alpha:1.0];
    self.redIndicator.ballIndex = [NSNumber numberWithInt:1];
    self.buttonRed.foulPoints = 4;
    self.buttonRed.pottedPoints = 1;
    self.buttonRed.quantity =  15 - [common getQtyOfBallsByColor:self.activeFrameData :[NSNumber numberWithInt:0] :[NSNumber  numberWithInt:1]];
    if (self.buttonRed.quantity==0) {
        self.buttonRed.enabled=false;
    }
    self.buttonRed.imageNameLarge = @"red_01";
    self.buttonRed.imageNameSmall = @"red_01_small";
 
    
    self.buttonYellow.colour = @"YELLOW";
    self.buttonYellow.ballColour=[UIColor colorWithRed:222.0f/255.0f green:199.0f/255.0f blue:4.0f/255.0f alpha:1.0];
    self.yellowIndicator.ballIndex = [NSNumber numberWithInt:2];
    self.buttonYellow.foulPoints = 4;
    self.buttonYellow.pottedPoints = 2;
    // TODO HERE
    self.buttonYellow.quantity = 1;
    if (self.buttonRed.quantity==0) {
        self.buttonRed.enabled = false;
        if ([self isColourKilled :self.activeFrameData :[NSNumber numberWithInt:[self.buttonYellow pottedPoints]]]) {
            self.buttonYellow.quantity = 0;
            self.buttonYellow.enabled = false;
        } else {
            self.activeColour = self.buttonYellow.pottedPoints;
        }
    }
    self.buttonYellow.imageNameLarge = @"yellow_02";
    self.buttonYellow.imageNameSmall = @"yellow_02_small";
    
    self.buttonGreen.colour = @"GREEN";
    self.buttonGreen.ballColour=[UIColor colorWithRed:61.0f/255.0f green:191.0f/255.0f blue:61.0f/255.0f alpha:1.0];
    self.greenIndicator.ballIndex = [NSNumber numberWithInt:3];
    self.buttonGreen.foulPoints = 4;
    self.buttonGreen.pottedPoints = 3;
    self.buttonGreen.quantity = 1;
    if (self.buttonYellow.quantity==0) {
        if ([self isColourKilled :self.activeFrameData  :[NSNumber numberWithInt:[self.buttonGreen pottedPoints]]]) {
            self.buttonGreen.quantity = 0;
            self.buttonGreen.enabled = false;
        } else {
            self.activeColour = self.buttonGreen.pottedPoints;
        }
    }
    self.buttonGreen.imageNameLarge = @"green_03";
    self.buttonGreen.imageNameSmall = @"green_03_green";
    
    self.buttonBrown.colour = @"BROWN";
    self.buttonBrown.ballColour=[UIColor colorWithRed:120.0f/255.0f green:64.0f/255.0f blue:0.0f/255.0f alpha:1.0];
    self.brownIndicator.ballIndex = [NSNumber numberWithInt:4];
    self.buttonBrown.foulPoints = 4;
    self.buttonBrown.pottedPoints = 4;
    self.buttonBrown.quantity = 1;
    if (self.buttonGreen.quantity==0) {
        if ([self isColourKilled :self.activeFrameData :[NSNumber numberWithInt:[self.buttonBrown pottedPoints]]]) {
            self.buttonBrown.quantity = 0;
            self.buttonBrown.enabled = false;
        } else {
            self.activeColour = self.buttonBrown.pottedPoints;
        }
    }
    self.buttonBrown.imageNameLarge = @"brown_04";
    self.buttonBrown.imageNameSmall = @"brown_04_small";
    
    self.buttonBlue.colour = @"BLUE";
    self.buttonBlue.ballColour=[UIColor colorWithRed:39.0f/255.0f green:121.0f/255.0f blue:198.0f/255.0f alpha:1.0];
        self.blueIndicator.ballIndex = [NSNumber numberWithInt:5];
    self.buttonBlue.foulPoints = 5;
    self.buttonBlue.pottedPoints = 5;
    self.buttonBlue.quantity = 1;
    if (self.buttonBrown.quantity==0) {
        if ([self isColourKilled :self.activeFrameData :[NSNumber numberWithInt:[self.buttonBlue pottedPoints]]]) {
            self.buttonBlue.quantity = 0;
            self.buttonBlue.enabled = false;
        } else {
            self.activeColour = self.buttonBlue.pottedPoints;
        }
    }
    self.buttonBlue.imageNameLarge = @"blue_05";
    self.buttonBlue.imageNameSmall = @"blue_05_small";

    self.buttonPink.colour = @"PINK";
    self.buttonPink.ballColour=[UIColor colorWithRed:201.0f/255.0f green:78.0f/255.0f blue:184.0f/255.0f alpha:1.0];
    self.pinkIndicator.ballIndex = [NSNumber numberWithInt:6];
    self.buttonPink.foulPoints = 6;
    self.buttonPink.pottedPoints = 6;
    self.buttonPink.quantity = 1;
    if (self.buttonBlue.quantity==0) {
        if ([self isColourKilled: self.activeFrameData :[NSNumber numberWithInt:[self.buttonPink pottedPoints]]]) {
            self.buttonPink.quantity = 0;
            self.buttonPink.enabled = false;
        } else {
            self.activeColour = self.buttonPink.pottedPoints;
        }
    }
    self.buttonPink.imageNameLarge = @"pink_06";
    self.buttonPink.imageNameSmall = @"pink_06_small";
    
    /* black ball setup start */
    self.buttonBlack.colour = @"BLACK";
    self.buttonBlack.ballColour=[UIColor colorWithRed:33.0f/255.0f green:33.0f/255.0f blue:33.0f/255.0f alpha:1.0];
    self.blackIndicator.ballIndex = [NSNumber numberWithInt:7];
    self.buttonBlack.foulPoints = 7;
    self.buttonBlack.pottedPoints = 7;
    self.buttonBlack.quantity = 1;
    if (self.buttonPink.quantity==0) {
        if ([self isColourKilled: self.activeFrameData :[NSNumber numberWithInt:[self.buttonBlack pottedPoints]]]) {
            self.buttonBlack.quantity = 0;
            self.buttonBlack.enabled = false;
        } else {
            self.activeColour = self.buttonBlack.pottedPoints;
        }
    }
    self.buttonBlack.imageNameLarge = @"black_07";
    self.buttonBlack.imageNameSmall = @"black_07_small";
    /* black ball setup end */
}


-(void) setBallButtonImage :(ball*) ballButton {
    
        [common makeBallButton:ballButton :ballButton.frame.origin.x :ballButton.frame.origin.y :ballButton.frame.size.width :5.0f :ballButton.ballColour :self.isHollow];
    
}




- (void)addItemViewController:(embededMatchStatisticsVC *)controller keepDisplayState:(int)displayState {
    self.displayState = displayState;
}

- (NSTimer *)createTimer {
    return [NSTimer scheduledTimerWithTimeInterval:1.0
                                            target:self
                                          selector:@selector(timerTicked:)
                                          userInfo:nil
                                           repeats:YES];
}

- (void)timerTicked:(NSTimer *)timer {
    
    if (self.isPaused==false) {
        _frameTimeInSeconds++;
        _entryTimeInSeconds++;
        self.labelStopwatch.text = [self formattedShortTime:_entryTimeInSeconds];
        self.labelFrameStopwatch.text = [self formattedTime:_frameTimeInSeconds];
        
    }


}

- (NSString *)formattedTime:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}

- (NSString *)formattedShortTime:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    
    return [NSString stringWithFormat:@"%02d:%02d",minutes, seconds];
}





-(void)updateFrameVisitCounter {
    _frameVisitCounter ++;
    self.labelVisitCounter.text = [NSString stringWithFormat:@"Visits %d",
                               _frameVisitCounter];
    _entryTimeInSeconds = 0;
    self.labelStopwatch.text = [self formattedShortTime:_entryTimeInSeconds];
    
}

- (IBAction)swapPlayerPressed:(id)sender {
    
    if (!_isPaused) {
        self.pocketId = pocketNone;
        [self.activeBreak setMatchid:self.activeMatchId];
        [self.activeBreak setFrameid:currentFrameId];
        [self.activeBreak setPlayerid :[NSNumber numberWithInt:[self.currentPlayer playerIndex]]];
        [self.activeBreak setLastshotid:[NSNumber numberWithInt:Missed]];
        [self.activeBreak setDuration:[NSNumber numberWithInt:_entryTimeInSeconds]];
        [self.activeBreak setPoints:[NSNumber numberWithInt:0]];
        [self.activeBreak setActive:[NSNumber numberWithInt:activeFlag_PlayerSwapped]];
        [self addBreakToData :self.activeBreak];
        [self.activeBreak setPlayerid:[NSNumber numberWithInt:0]];
        [self swapPlayers];
        [self updateFrameVisitCounter];
    }
}

- (IBAction)closeCongratsPressed:(id)sender {
    self.blurView.hidden=true;
    self.skView.hidden=true;
}


@end
