//
//  common.h
//  SnookerScoreMaster
//
//  Created by andrew glew on 08/02/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "frameScore.h"
#import "ball.h"
#import "player.h"
#import "frame.h"
#import "snookerbreak.h"
#import "breakEntry.h"
#import "breakBallCell.h"

@interface common : NSObject




+ (NSString *) stringFromTimeInterval :(NSTimeInterval) interval;
+ (NSString *) getTimeElapsed :(NSString *) from :(NSString *) to;
+ (NSString *) getFrameDuration :(NSMutableArray *) data;
+ (void) makeRoundButtonOwnColour :(UIButton*) shotButton :(float) x :(float) y :(float) heightWidth :(UIColor*) colour;
+ (void)makeBallImage :(UIImageView*) imageBall :(float) x :(float) y :(float) heightWidth :(float) border;
+ (void)makeBallButton :(UIButton*) buttonBall :(float) x :(float) y :(float) heightWidth :(float) border :(UIColor*) bordercolour :(bool)isHollow;
+ (NSString*) getTimeStamp;
+ (int) getPointsRemainingInFrame :(ball*) redBall : (breakEntry*) activeBreak :(int) liveColour;
+ (NSString *) formatValue :(int)value forDigits:(int)zeros;
+ (NSMutableArray *) getHiBreakBalls :(NSMutableArray*) activeDataSet :(NSNumber*) playerId :(NSNumber*) frameId;
+ (int) getAmtOfBallsPotted :(NSMutableArray *) frameDataSet :(NSNumber *) playerId :(NSNumber *) frameId;
+ (int) getHiBreak :(NSMutableArray *) frameDataSet :(NSNumber *) playerId :(NSNumber *) frameId;
+ (float) getAvgBreakAmt :(NSMutableArray *) activeDataSet :(NSNumber *) playerId;
+ (float) getAvgBallAmt :(NSMutableArray *) activeDataSet :(NSNumber *) playerId;
+ (int) getTotalScoringVisits :(NSMutableArray *) frameDataSet  :(NSNumber *) playerId;
+ (int) getTotalVisits :(NSMutableArray*) frameDataSet  :(NSNumber *) playerId;
+ (int) getScoreByShotId :(NSMutableArray *) frameDataSet :(NSNumber *) playerId :(NSNumber *) shotId;
+ (int) getSumOfShotsByType :(NSMutableArray *) frameDataSet  :(NSNumber *) playerId :(int) shotType;
+(int) getBreakScoreFromBalls : (NSMutableArray *) balls;
+ (NSString *) getTopRangeOfPlayerBreaks :(NSMutableArray *) data :(NSNumber *) playerid;
+ (int) getQtyOfBallsByColor :(NSMutableArray *) activeDataSet  :(NSNumber *) playerid :(NSNumber *) reqBallPoint;
+ (int) getIntFrameDuration :(NSMutableArray *) data;
+ (int) getRealFrameDuration :(NSMutableArray *) frameDataSet;
+ (float) getAvgShotDuration :(NSMutableArray *) activeDataSet :(NSNumber *) playerId ;

+ (NSNumber*) getHBTotal :(NSMutableArray *) activeDataSet :(NSNumber *) playerId :(NSNumber *) frameId;
+ (NSMutableArray *) getHBBalls :(NSMutableArray*) activeDataSet :(NSNumber*)playerId :(NSNumber*)frameId;


@end
