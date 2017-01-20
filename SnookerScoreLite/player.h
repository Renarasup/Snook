//
//  textScore.h
//  SnookerScorer
//
//  Created by andrew glew on 06/11/2014.
//  Copyright (c) 2014 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "frame.h"
#import "hibreak.h"

@interface player : UILabel {
    int frameScore;
    int breakScore;
    int highestBreak;
    int nbrBallsPotted;
    int currentFrameIndex;
    int nbrOfBreaks;
    int sumOfBreaks;
    int playerIndex;
    bool swappedPlayer;
    NSMutableArray     *highestBreakHistory;
    NSMutableArray *playersBreaks;
    NSMutableArray *frames;
    NSString *nickName;
    NSString *emailAddress;
    NSString *photoLocation;
    NSString *hiBreakDate;
    NSString *playerkey;
    NSNumber *playerNumber;
    NSNumber *hiBreak;
    NSNumber *hiBreakHistory;
    NSNumber *trailBlazer;
    NSNumber *wonFrames;
    NSNumber *activeBreak;
    
}

@property (assign) int frameScore;
@property (assign) int breakScore;
@property (assign) int highestBreak;
@property (assign) int highestBreakFrameNo;
@property (assign) int nbrBallsPotted;
@property (assign) int currentFrameIndex;
@property (assign) int nbrOfBreaks;
@property (assign) int sumOfBreaks;
@property (assign) int playerIndex;
@property (assign) bool swappedPlayer;
@property (nonatomic) NSString *nickName;
@property (nonatomic) NSString *emailAddress;
@property (nonatomic) NSString *photoLocation;
@property (nonatomic) NSString *hiBreakDate;
@property (nonatomic) NSString *playerkey;
@property (nonatomic) NSNumber *playerNumber;
@property (nonatomic) NSNumber *activeBreak;
@property (nonatomic) NSNumber *hiBreak;
@property (nonatomic) NSNumber *hiBreakHistory;
@property (nonatomic) NSNumber *trailBlazer;
@property (nonatomic) NSNumber *wonframes;
@property (nonatomic) NSNumber *playerWinsPC;
@property (nonatomic) NSNumber *playerMatchCount;
@property (nonatomic) NSNumber *playerMatchWins;
@property (nonatomic) NSNumber *playerMatchLosses;
@property (nonatomic) NSNumber *selectedHiBreak;
@property (nonatomic) NSNumber *selectedPlayerWinsPC;
@property (strong, nonatomic) hibreak *hbFrame;
@property (strong, nonatomic) hibreak *hbMatch;
@property (strong, nonatomic) hibreak *hbEver;

@property (nonatomic, strong) NSMutableArray *frames;
@property (strong, nonatomic) frame     *currentFrame;
@property (strong, nonatomic) NSMutableArray     *playersBreaks;
@property (strong, nonatomic) NSMutableArray     *highestBreakHistory;


-(void)resetFrameScore:(int) value;
-(void)addBreakScore:(int) value;
-(void)updateFrameScore:(int) value;
-(void)setHighestBreak:(int) value :(int) frameno :(NSMutableArray*) breakHistory;
-(void)displayHighestBreak;
-(void)displayBallsPotted;
-(void)setFoulScore:(int) value;
-(void)incrementNbrBalls:(int) value;
-(void)createFrame:(int) value;
-(void)createCurrentFrame:(NSNumber *) value;

@end
