//
//  common.m
//  SnookerScoreMaster
//
//  Created by andrew glew on 08/02/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import "common.h"

@implementation common

/*
created 20160207
last modified -
 
20160208 moved into common class
*/

+ (NSString *)getTimeElapsed :(NSString *) from :(NSString *) to {
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *dateFirstEntry = [[NSDate alloc] init];
    NSDate *dateLastEntry = [[NSDate alloc] init];
    
    dateFirstEntry = [dateFormatter dateFromString:from];
    dateLastEntry = [dateFormatter dateFromString:to];
    NSTimeInterval interval = [dateLastEntry timeIntervalSinceDate:dateFirstEntry];
    return [self stringFromTimeInterval :interval];
}


/*
created unknown
last modified -
 
20160208 moved into common class
*/

+ (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
}



/*
created 20160207
last modified -
 
20160208 moved into common class
20160208 possibly we could locate the first entry when frame is really started.
*/
+ (NSString *) getFrameDuration :(NSMutableArray *) data {
    
    
    int duration=0;
    for (breakEntry *entry in data) {
        duration += [entry.duration intValue];
    }
    if (duration!=0) {

        int seconds = duration % 60;
        int minutes = (duration / 60) % 60;
        int hours = duration / 3600;
        
        return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
    }
    
    if (data.count>0) {
        breakEntry *firstEntry = [[breakEntry alloc] init];
        firstEntry = [data objectAtIndex:0];
        ballShot *firstShot = [[ballShot alloc] init];
        firstShot = [firstEntry.shots firstObject];
        breakEntry *lastEntry = [[breakEntry alloc] init];
        lastEntry = [data lastObject];
        ballShot *lastShot = [[ballShot alloc] init];
        lastShot = [lastEntry.shots lastObject];
        return [self getTimeElapsed:firstShot.shottimestamp :lastShot.shottimestamp];
    } else {
        return @"no entries in frame";
    }
}

/*
 created 20160507
 last modified -
*/
+ (int) getIntFrameDuration :(NSMutableArray *) data {
    
    if (data.count>0) {
        breakEntry *firstEntry = [[breakEntry alloc] init];
        firstEntry = [data objectAtIndex:0];
        
        NSString *fromDateTime = firstEntry.endbreaktimestamp;
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSDate *from = [[NSDate alloc] init];
        
        from = [dateFormatter dateFromString:fromDateTime];
        
        NSDate *to = [NSDate date];
        
        NSTimeInterval interval = [to timeIntervalSinceDate:from];
        
        return (int)interval;
        
    } else {
        return 0;
    }
}

/*
 created - 20160710
 last modified - 2016-710
 */
    
+ (int) getRealFrameDuration :(NSMutableArray *) frameDataSet {
    int totalDuration=0;
    for (breakEntry *data in frameDataSet) {
        totalDuration += [data.duration intValue];
    }
    return totalDuration;
}





/*
created unknown
last modified -
 
20160208 moved into common class
*/

+ (void)makeRoundButtonOwnColour :(UIButton*) shotButton :(float) x :(float) y :(float) heightWidth :(UIColor*) colour {
    //width and height should be same value
    shotButton.frame = CGRectMake(x, y, heightWidth, heightWidth);
    //Clip/Clear the other pieces whichever outside the rounded corner
    shotButton.clipsToBounds = YES;
    //half of the width
    shotButton.layer.cornerRadius = heightWidth/2.0f;
    shotButton.layer.borderColor=colour.CGColor;
    shotButton.layer.borderWidth=1.5f;
}

/*
 created 20160712
 last modified -
 
 20160208 moved into common class
 */
+ (void)makeBallImage :(UIImageView*) imageBall :(float) x :(float) y :(float) heightWidth :(float) border {
    //width and height should be same value
    imageBall.frame = CGRectMake(x, y, heightWidth, heightWidth);
    //Clip/Clear the other pieces whichever outside the rounded corner
    imageBall.clipsToBounds = YES;
    //half of the width
    imageBall.layer.cornerRadius = heightWidth/2.0f;
    imageBall.layer.borderWidth=border;
}

/*
 created 20160712
 last modified -
 
 20160208 moved into common class
 */
+ (void)makeBallButton :(UIButton*) buttonBall :(float) x :(float) y :(float) heightWidth :(float) border :(UIColor*) bordercolour :(bool)isHollow  {
    //width and height should be same value
    buttonBall.frame = CGRectMake(x, y, heightWidth, heightWidth);
    //Clip/Clear the other pieces whichever outside the rounded corner
    buttonBall.clipsToBounds = YES;
    //half of the width
    buttonBall.layer.cornerRadius = heightWidth/2.0f;
    
    if (!isHollow) {
        buttonBall.layer.backgroundColor=bordercolour.CGColor;
        //buttonBall.layer.borderColor=[UIColor blackColor].CGColor;
        //buttonBall.layer.borderWidth=0.75f;
    } else {
        buttonBall.layer.borderColor=bordercolour.CGColor;
        buttonBall.layer.borderWidth=border;
    }
}

/*
created unknown
last modified -
 
20160208 moved into common class
*/

+ (NSString*) getTimeStamp {
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *rightNow = [dateFormatter stringFromDate:[NSDate date]];
    return rightNow;
}

/*
created 20160204
last modified -
 
20160208 moved into common class
*/

+ (int) getPointsRemainingInFrame  :(ball*) redBall : (breakEntry*) activeBreak :(int) liveColour {
    
    int pointsRemaining=0;
    int currentBreak=0;
    // How many points remaining?
    for (int i = 7; i >= 1; i--)
    {
        if (i==1) {
            pointsRemaining += (redBall.quantity * 8);
        } else if (liveColour <= i) {
            pointsRemaining += i;
        } else {
            i=1;
        }
    }
    // get difference between players scores..
    currentBreak = [activeBreak.points intValue];
    if (currentBreak>0) {
        if ([activeBreak.ballPotted.value intValue] == 1) {
            pointsRemaining += 7;
        }
    }
    return pointsRemaining;
}



/* 
created 20150928
last modified 20161123
 
20160206 fixed bug with returned ballshot array, it was not excluding the balls that were not needed in the break count 
20160208 moved into common class
*/

+ (NSMutableArray *) getHiBreakBalls :(NSMutableArray*) activeDataSet :(NSNumber*)playerId :(NSNumber*)frameId {
    int highestBreak=0;
    int ballsInBreak=0;
    NSMutableArray *balls;
    
    for (breakEntry *data in activeDataSet) {
        if (playerId == data.playerid && (frameId == data.frameid || frameId == [NSNumber numberWithInt:0])) {
            int totalBreak = 0;
            int potCount = 0;
            
            for (ballShot *ball in data.shots) {
                if (ball.shotid==[NSNumber numberWithInt:Potted]) {
                    totalBreak+=[ball.value intValue];
                    potCount ++;
                }
            }
            if (totalBreak > highestBreak) {
                // update highest break!
                highestBreak = totalBreak;
                balls = [[data.shots subarrayWithRange:NSMakeRange(0, potCount) ] mutableCopy];
                ballsInBreak = potCount;
            } else if (totalBreak == highestBreak && ballsInBreak < potCount) {
                // save the combination that has the most pots in it.
                balls = data.shots;
                ballsInBreak = potCount;
            }
        }
    }
    return balls;
}



+ (NSString *) formatValue :(int)value forDigits:(int)zeros {
    NSString *format = [NSString stringWithFormat:@"%%0%dd", zeros];
    return [NSString stringWithFormat:format,value];
}


/*
created 20150928
last modified -
 
20160208 moved into common class
*/

+ (int) getAmtOfBallsPotted :(NSMutableArray *) frameDataSet :(NSNumber *) playerId :(NSNumber *) frameId {
    int totalBalls=0;
    for (breakEntry *data in frameDataSet) {
        if (playerId == data.playerid && (frameId == data.frameid || frameId==[NSNumber numberWithInt:0])) {
            for (ballShot *shot in data.shots) {
                if (shot.shotid==[NSNumber numberWithInt:Potted]) {
                    totalBalls ++;
                }
            }
        }
    }
    return totalBalls;
}



/*
 created 20160711
 last modified -
 */

+ (float) getAvgShotDuration :(NSMutableArray *) activeDataSet :(NSNumber *) playerId {
    int totalDuration=0;
    int totalShots=0;

    for (breakEntry *data in activeDataSet) {
        if (playerId == data.playerid) {
            totalDuration += [data.duration intValue];
            int totalShotsInEntry = 0;
            for (ballShot *shot in data.shots) {
                if (shot.shotid==[NSNumber numberWithInt:Potted]) {
                    totalShotsInEntry ++;
                }
            }
            if (totalShotsInEntry==0) {
                totalShots++;
            } else {
                totalShots+=totalShotsInEntry;
            }
            
        }
    }
    float avgShotTime = 0.0;
    avgShotTime = (float)totalDuration / (float)totalShots;
    if isnan(avgShotTime) {
        avgShotTime=0.0;
    }
    return avgShotTime ;
}



/*
+ (int) getHiBreak :(NSMutableArray *) dataSet :(NSString *) playerIndex {
    int highestBreak=0;
    for (breakEntry *data in dataSet) {
        if (playerId == data.playerid && (frameId == data.frameid || frameId == [NSNumber numberWithInt:0])) {
            int totalBreak = 0;
            for (ballShot *shot in data.shots) {
                if (shot.shotid==[NSNumber numberWithInt:Potted]) {
                    totalBreak += [shot.value intValue];
                }
            }
            if (totalBreak > highestBreak) {
                highestBreak = totalBreak;
            }
        }
    }
    return highestBreak;
}
*/


+ (NSNumber*) getHBTotal :(NSMutableArray *) activeDataSet :(NSNumber *) playerId :(NSNumber *) frameId {
    int highestBreak = 0;
    for (breakEntry *data in activeDataSet) {
        if (playerId == data.playerid && (frameId == data.frameid || frameId == nil)) {
            int totalBreak = 0;
            for (ballShot *shot in data.shots) {
                if (shot.shotid==[NSNumber numberWithInt:Potted]) {
                    totalBreak += [shot.value intValue];
                }
            }
            if (totalBreak > highestBreak) {
                highestBreak = totalBreak;
            }
        }
    }
    return [NSNumber numberWithInt:highestBreak];
}



+ (NSMutableArray *) getHBBalls :(NSMutableArray*) activeDataSet :(NSNumber*)playerId :(NSNumber*)frameId {
    int highestBreak=0;
    int ballsInBreak=0;
    NSMutableArray *balls;
    
    for (breakEntry *data in activeDataSet) {
        if (playerId == data.playerid && (frameId == data.frameid || frameId == nil)) {
            int totalBreak = 0;
            int potCount = 0;
            
            for (ballShot *ball in data.shots) {
                if (ball.shotid==[NSNumber numberWithInt:Potted]) {
                    totalBreak+=[ball.value intValue];
                    potCount ++;
                }
            }
            if (totalBreak > highestBreak) {
                // update highest break!
                highestBreak = totalBreak;
                balls = [[data.shots subarrayWithRange:NSMakeRange(0, potCount) ] mutableCopy];
                ballsInBreak = potCount;
            } else if (totalBreak == highestBreak && ballsInBreak < potCount) {
                // save the combination that has the most pots in it.
                balls = data.shots;
                ballsInBreak = potCount;
            }
        }
        
    }
    return balls;
}








/*
created 20150927
last modified - 20161123
 
20160208 moved into common class
*/

+ (int) getHiBreak :(NSMutableArray *) frameDataSet :(NSNumber *) playerId :(NSNumber *) frameId {
    int highestBreak=0;
    for (breakEntry *data in frameDataSet) {
        if (playerId == data.playerid && (frameId == data.frameid || frameId == [NSNumber numberWithInt:0])) {
            int totalBreak = 0;
            for (ballShot *shot in data.shots) {
                if (shot.shotid==[NSNumber numberWithInt:Potted]) {
                    totalBreak += [shot.value intValue];
                }
            }
            if (totalBreak > highestBreak) {
                highestBreak = totalBreak;
            }
        }
    }
    return highestBreak;
}

/*
created 20150927
last modified -
 
20160208 moved into common class
*/

+ (float) getAvgBreakAmt :(NSMutableArray *) activeDataSet :(NSNumber *) playerId {
    int totalPottedPoints = 0;
    int totalVisits = 0;
    totalPottedPoints = [self getScoreByShotId: activeDataSet :playerId :[NSNumber numberWithInt:Potted]];
    totalVisits = [self getTotalScoringVisits: activeDataSet :playerId];
    float avgAmount = 0.0;
    avgAmount = (float)totalPottedPoints / (float)totalVisits;
    if isnan(avgAmount) {
        avgAmount=0.0;
    }
    return avgAmount;
}


/*
created 20160207
last modified -
 
20160208 moved into common class
*/

+ (float) getAvgBallAmt :(NSMutableArray*) activeDataSet :(NSNumber*)playerId {
    int totalPottedBalls = 0;
    int totalVisits = 0;
    totalPottedBalls = [self getSumOfShotsByType: activeDataSet :playerId :Potted];
    totalVisits = [self getTotalScoringVisits: activeDataSet :playerId];
    float avgAmount = 0.0;
    avgAmount = (float)totalPottedBalls / (float)totalVisits;
    if isnan(avgAmount) {
        avgAmount=0.0;
    }
    return avgAmount;
}

/*
created 20150927
last modified -
 
20160208 moved into common class
*/

+ (int) getTotalScoringVisits :(NSMutableArray *) frameDataSet  :(NSNumber *) playerId {
    int totalVisits=0;
    for (breakEntry *data in frameDataSet) {
        ballShot *firstShot = [data.shots firstObject];
        if (playerId == data.playerid && firstShot.shotid==[NSNumber numberWithInt:Potted]) {
            totalVisits ++;
        }
    }
    return totalVisits;
}


/*
created 20150927
last modified -
 
20160208 moved into common class
*/

+ (int) getTotalVisits :(NSMutableArray*) frameDataSet  :(NSNumber *) playerId {
    int totalVisits=0;
    for (breakEntry *data in frameDataSet) {
        ballShot *firstShot = [data.shots firstObject];
        if (playerId == data.playerid && firstShot.shotid!=[NSNumber numberWithInt:Bonus]) {
            totalVisits ++;
        }
    }
    return totalVisits;
}



/*
created 20150927
last modified -
 
20160208 moved into common class
*/

+ (int) getScoreByShotId :(NSMutableArray *) frameDataSet :(NSNumber *) playerId :(NSNumber *) shotId {
    // This method is used to obtain either the potted points a player has made or the foul points a
    // player has received.
    
    int retValue=0;
    for (breakEntry *data in frameDataSet) {
        if (playerId == data.playerid) {
            if (shotId==[NSNumber numberWithInt:Potted]) {
                for (ballShot *shot in data.shots) {
                    if (shot.shotid == [NSNumber numberWithInt:Potted]) {
                        retValue+=[shot.value intValue];
                    }
                }
            } else if (shotId==[NSNumber numberWithInt:Bonus]) {
                
                for (ballShot *shot in data.shots) {
                    if (shot.shotid == [NSNumber numberWithInt:Bonus]) {
                        retValue+=[shot.value intValue];
                    }
                }
            }
        }
    }
    return retValue;
}

/*
created 20160207
last modified -
 
20160208 moved into common class
*/

+ (int) getSumOfShotsByType :(NSMutableArray *) frameDataSet  :(NSNumber *) playerId :(int) shotType {
    int totalShots=0;
    for (breakEntry *data in frameDataSet) {
        if (data.playerid == playerId) {
            for (ballShot *shot in data.shots) {
                if ([shot.shotid isEqualToNumber:[NSNumber numberWithInt:shotType]]) {
                    totalShots ++;
                }
            }
        }
    }
    return totalShots;
}

/*
created 20160207
last modified -
 
20160208 moved into common class
*/

+ (NSString *) getTopRangeOfPlayerBreaks :(NSMutableArray *) data :(NSNumber *) playerid {
    
    NSMutableDictionary *breakdown  = [[NSMutableDictionary alloc] init];;
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"points"
                                                 ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSArray *sortedArray;
    sortedArray = [data sortedArrayUsingDescriptors:sortDescriptors];
    // obtain totals
    for (breakEntry *data in sortedArray) {
        if (playerid == data.playerid && data.lastshotid != [NSNumber numberWithInt:Bonus]) {
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
        breakstats = [NSString stringWithFormat:@"%@ > %@ = %@%@",breakstats, key, value, @"\n"];
    }
    if ([breakstats length] > 0) {
        breakstats = [breakstats substringToIndex:[breakstats length] - 1];
    }
    if([breakstats isEqualToString:@""]) {
        breakstats = @"none!";
    }
    return breakstats;
}


/*
created unknown
last modified -
 
20160208 moved into common class
*/

+ (int) getQtyOfBallsByColor :(NSMutableArray *) activeDataSet  :(NSNumber *) playerid :(NSNumber *) reqBallPoint {
    int totalPotsOfWantedBall=0;
    for (breakEntry *singleBreak in activeDataSet) {
        if ([playerid isEqualToNumber:singleBreak.playerid] || [playerid intValue] == 0) {
            NSNumber *ballPoint;
            for (ballShot *shot in singleBreak.shots) {
                ballPoint = shot.value;
                if ([ballPoint isEqualToNumber:reqBallPoint] && ([shot.shotid isEqualToNumber:[NSNumber numberWithInt:Potted]] || [shot.foulid isEqualToNumber:[NSNumber numberWithInt:adjusted]])) {
                    totalPotsOfWantedBall ++;
                }
            }
        }
    }
    return totalPotsOfWantedBall;
}



+(int) getBreakScoreFromBalls : (NSMutableArray *) balls {
    
    int pointsScored=0;
    for (ballShot *shot in balls) {
        if (shot.shotid==[NSNumber numberWithInt:Potted]) {
            pointsScored += [shot.value intValue];
        }
    }

    return pointsScored;
}



@end
