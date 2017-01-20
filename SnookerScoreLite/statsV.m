//
//  graphView.m
//  SnookerScoreMaster
//
//  Created by andrew glew on 19/03/2015.
//  Copyright (c) 2015 andrew glew. All rights reserved.
//

#import "statsV.h"

#define degreesToRadian(x) (M_PI * (x) / 180.0)

@implementation statsV
@synthesize activeMatchData;
@synthesize activeFrameData;
@synthesize selectedFrameData;
@synthesize matchFramePoints;
@synthesize visitShots;
@synthesize visitPlayerIndex;
@synthesize visitShotType;
@synthesize scorePlayer1;
@synthesize scorePlayer2;
@synthesize currentBreakPlayer1;
@synthesize currentBreakPlayer2;
@synthesize visitNumberOfBalls;
@synthesize timeStamp;
@synthesize visitPoints;
@synthesize visitRef;
@synthesize visitId;
@synthesize printGraph;
@synthesize matchStatistics;
@synthesize numberOfFrames;
@synthesize matchMaxPoints;
@synthesize db;
@synthesize statFrameData;

CGRect touchAreas[100];

-(void) setPrint :(BOOL) enabled{
    printGraph = enabled;
}


#pragma DATABASE INTERFACE

/* created 20150909 */
-(void)initDB {
    /* most times the database is already existing */
    self.db = [[dbHelper alloc] init];
  //  [self.db deleteDB:@"snookmast.db"];
    [self.db dbCreate :@"snookmast.db"];
}


/* created 20150909 */
/* last modified 20160110 */

-(bool)initMatch {
    
    NSNumber *matchId = [self.db getActiveMatchId];
    
    [self.activeMatchData removeAllObjects];
    self.activeMatchData = [self.db entriesRetreive:matchId :nil :nil :nil :nil :[NSNumber numberWithInt:0] :false];
    if (self.activeMatchData.count>0) {
        return true;
    } else {
        if ([self.db entriesRetreive:matchId :nil :nil :nil :nil :nil :false].count>0) {
            return true;
        } else {
            return false;
        }
    }
}


-(NSNumber*) updateActiveMatch :(player *) p1 :(player *) p2 {
    return [self.db updateActiveMatchData :p1 :p2];
}



-(NSNumber*) addNewMatch :(NSNumber *) player1Number :(NSNumber *) player2Number {
    return [self.db insertMatch :player1Number :player2Number];
}

/* new 20160111 */
-(NSNumber*) getMatchId {
    return [self.db getActiveMatchId];
}


/* refactored 20150910 */
-(void)deleteMatchData {
    [self.db entriesDeleteAll];
    [self.db shotsDeleteAll];
    [self.activeMatchData removeAllObjects];
    [self.activeFrameData removeAllObjects];
    [self.db deleteMatch :[self.db getActiveMatchId]];
}


/* modified 20151005 */
-(void) initFrameData {

    self.selectedFrameData = [[NSMutableArray alloc] init];
    self.matchFramePoints = [[NSMutableArray alloc] init];

    if (!self.activeFrameData) {
        self.activeFrameData = [[NSMutableArray alloc] init];
        self.activeMatchData = [[NSMutableArray alloc] init];
        self.statFrameData = [[NSMutableArray alloc] init];
        self.selectedFrameData = [[NSMutableArray alloc] init];
        self.matchFramePoints = [[NSMutableArray alloc] init];
    }
}




/* created 20150910 */
-(void)initFrame :(NSNumber*)currentFrameId {
    [self.activeFrameData removeAllObjects];
    self.activeFrameData = [self.db entriesRetreive:[self getMatchId] :nil :currentFrameId :nil :nil :[NSNumber numberWithInt:1] :false];
    
    self.scorePlayer1=0;
    self.scorePlayer2=0;
    
    if ([currentFrameId intValue]>1) {
        // we need to find past frame winner(s).. but do we do that here?
    }
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
    
}



-(player *)setPlayerData :(player *) reqPlayer {
    
    //player *p  = [[player alloc] init];
    reqPlayer = [self.db playerRetreive :reqPlayer];
    
    if (self.activeMatchData.count!=0) {
        reqPlayer.highestBreakHistory = [self getHiBreakBalls:self.activeMatchData :[NSNumber numberWithInt:reqPlayer.playerIndex] :0];
        reqPlayer.highestBreak = [self getHiBreak:self.activeFrameData:[NSNumber numberWithInt:reqPlayer.playerIndex] :0];
    } else if (self.activeFrameData.count!=0) {
        reqPlayer.highestBreakHistory = [self getHiBreakBalls:self.activeFrameData :[NSNumber numberWithInt:reqPlayer.playerIndex] :0];
        reqPlayer.highestBreak = [self getHiBreak:self.activeFrameData:[NSNumber numberWithInt:reqPlayer.playerIndex] :0];
    } else {
        reqPlayer.highestBreak = 0;
    }
    return reqPlayer;
}

-(void) updatePlayerData :(player *) reqPlayer {
    
    [self.db updatePlayer :reqPlayer];
}

-(void) updateMatchPlayers :(NSNumber *) player1Number :(NSNumber *) player2Number {
    [self.db updateMatchPlayers :player1Number :player2Number];
}



-(void) insertPlayerData :(player *) reqPlayer {
    
    [self.db insertPlayer :reqPlayer];
}




/* created 20150922 */
/* last modified 20151010 */
-(void)addBreakToData :(breakEntry*) lastBreak {
    
    if (lastBreak.shots.count>0 || lastBreak.active==[NSNumber numberWithInt:2]) {
        /* first thing is to add to database */
        NSNumber *newRow = [self.db entriesInsert:lastBreak.matchid :lastBreak.playerid :lastBreak.frameid :lastBreak.lastshotid :lastBreak.points :lastBreak.active];
    
        if (newRow == [NSNumber numberWithInt:-1]) {
            // nothing to do
        } else {
            [self.db shotsInsert:newRow :lastBreak.shots];
        }
    
        /* lastly add to the active array */
        if ([lastBreak.active intValue] != 2) {
            [activeFrameData addObject:[lastBreak copy]];
        }
    }
}

/* created 20150927 */
-(bool)setFrameActive :(NSNumber*) frameId :(NSNumber*) activeto :(NSNumber*) activefrom {
    [self.db setFrameActiveState:frameId :activeto :activefrom ];
    return true;
}


#pragma STATS

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


/* created 20150928 */
-(NSMutableArray *)getHiBreakBalls:(NSMutableArray*) frameDataSet :(NSNumber*)playerId :(NSNumber*)frameId {
    int highestBreak=0;
    int ballsInBreak=0;
    NSMutableArray *balls;
    
    for (breakEntry *data in frameDataSet) {
        if (playerId == data.playerid && (frameId == data.frameid || frameId == 0)) {
            int totalBreak = 0;
            for (ballShot *ball in data.shots) {
                if (ball.shotid==[NSNumber numberWithInt:Potted]) {
                    totalBreak+=[ball.value intValue];
                }
            }
            if (totalBreak > highestBreak) {
                // update highest break!
                highestBreak = totalBreak;
                balls = data.shots;
                ballsInBreak = (int)balls.count;
            } else if (totalBreak == highestBreak && ballsInBreak > (int)data.shots.count) {
                // save the combination that has the most pots in it.
                balls = data.shots;
                ballsInBreak = (int)data.shots.count;
            }
        }
        
    }
    return balls;
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


/* refactored 20150911 */
-(int)getQtyOfBallsByColor:(NSMutableArray*) activeData  :(NSNumber*)playerid :(NSNumber*) reqBallPoint {
    
    int totalPotsOfWantedBall=0;
    for (breakEntry *singleBreak in activeData) {
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


/* refactored 20150918 */
/* last modified 20150920 */
-(int)getAmtBreakFromBalls:(NSMutableArray*)balls :(NSNumber *)reqShotId {
    /* works only for fouls and breaks */
    int breakAmount = 0;
    for (ballShot *ball in balls) {
        if (reqShotId == ball.shotid) {
            int points = [ball.value intValue];
            breakAmount += points;
        }
    }
    return breakAmount;
}


/* created 20150927 */
-(float)getAvgBreakAmt:(NSMutableArray*) frameDataSet :(NSNumber*)playerId {
    int totalPottedPoints = 0;
    int totalVisits = 0;
    totalPottedPoints = [self getScoreByShotId: frameDataSet :playerId :[NSNumber numberWithInt:Potted]];
    totalVisits = [self getTotalScoringVisits: frameDataSet :playerId];
    float avgAmount = 0.0;
    avgAmount = (float)totalPottedPoints / (float)totalVisits;
    if isnan(avgAmount) {
        avgAmount=0.0;
    }
    return avgAmount;
}


/*created 20150927 */
-(int)getTotalVisits:(NSMutableArray*) frameDataSet  :(NSNumber*)playerId {
    int totalVisits=0;
    for (breakEntry *data in frameDataSet) {
        ballShot *firstShot = [data.shots firstObject];
        if (playerId == data.playerid && firstShot.shotid!=[NSNumber numberWithInt:Bonus]) {
            totalVisits ++;
        }
    }
    return totalVisits;
}


/*created 20150927 */
-(int)getTotalScoringVisits:(NSMutableArray*) frameDataSet  :(NSNumber*)playerId {
    int totalVisits=0;
    for (breakEntry *data in frameDataSet) {
        ballShot *firstShot = [data.shots firstObject];
        if (playerId == data.playerid && firstShot.shotid==[NSNumber numberWithInt:Potted]) {
            totalVisits ++;
        }
    }
    return totalVisits;
}


/* created 20150927 */
-(int)getScoreByShotId:(NSMutableArray*) frameDataSet :(NSNumber*)playerId :(NSNumber*)shotId {
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


/* created 20150927 */
-(int)getPotsInPocket:(NSMutableArray*) frameDataSet :(NSNumber*)playerId :(NSNumber*)pocketId :(NSNumber*)shotId {
    /* Get pocket count in selection */
    
    int retValue=0;
    for (breakEntry *data in frameDataSet) {
        if (playerId == data.playerid) {
            for (ballShot *shot in data.shots) {
                if (shot.shotid == shotId) {
                    if (shot.pocketid == pocketId) {
                        retValue++;
                    }
                }
            }
        }
    }
    return retValue;
}







/* created 20150928 */
-(int)getAmtOfBallsPotted:(NSMutableArray*) frameDataSet :(NSNumber*)playerId :(NSNumber*)frameId {
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


/* created 20150927 */
-(int)getHiBreak:(NSMutableArray*) frameDataSet :(NSNumber*)playerId :(NSNumber*)frameId {
    int highestBreak=0;
    for (breakEntry *data in frameDataSet) {
        if (playerId == data.playerid) {
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


/* created 20150928 */
-(bool)checkElapsedTime :(NSNumber *) frameId {
    NSMutableArray *startDates = [self.db entriesRetreive :[self getMatchId] :nil :frameId :nil :nil :[NSNumber numberWithInt:2] :false];
    if (startDates.count>0) {
        return true;
    }
    return false;
}


/* created 20150927 */
-(NSString *)getElapsedTime :(NSNumber *) frameId :(bool)fromArchive {

    NSMutableArray *startDates;

    breakEntry *lastDate = [[breakEntry alloc] init];
    
    if (fromArchive) {
        for (breakEntry *singleBreak in activeMatchData) {
            if (singleBreak.lastshotid ==[NSNumber numberWithInt:0] && singleBreak.playerid==[NSNumber numberWithInt:0] && singleBreak.points==[NSNumber numberWithInt:0]) {
                if (!startDates) {
                    startDates = [[NSMutableArray alloc] init];
                }
                [startDates addObject:singleBreak];
            }
        }
        lastDate = [activeMatchData lastObject];
        
    } else {
        startDates = [self.db entriesRetreive :[self getMatchId] :nil :nil :nil :nil :[NSNumber numberWithInt:2] :false];
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
    return [self stringFromTimeInterval :interval];
}


#pragma STRING FORMATTING

- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
}




#pragma LINE-GRAPH

-(void)plotPlayerLines:(bool)fillGraph :(CGContextRef)ctx :(int) playerIndex :(int) breakOfPlayer  :(UIColor*) playerColour :(float) scalePointsY :(float) scaleVisitsX {
    
    CGContextSetLineWidth(ctx, 1.5);
    CGContextSetStrokeColorWithColor(ctx, [playerColour CGColor]);
    CGContextSetFillColorWithColor(ctx, [playerColour CGColor]);
    
    int graphHeight = self.frame.size.height;
    int maxGraphHeight = graphHeight - kOffsetY;
    int score=0;
    int dataIndex = 0; // incremental index to plot
    
    float plotVisitsX=0.0f;
    float plotPointsY=0.0f + graphHeight;
    CGGradientRef gradient = NULL;
    CGColorSpaceRef colorspace;
    CGPoint startPoint, endPoint;
    colorspace = CGColorSpaceCreateDeviceRGB();
    
    CGContextSetFillColorWithColor(ctx, [[UIColor colorWithRed:1.0 green:0.5 blue:0 alpha:0.5] CGColor]);
    
    if (fillGraph) {

        size_t num_locations = 2;
        CGFloat locations[2] = {0.0, 1.0};
        colorspace = CGColorSpaceCreateDeviceRGB();
        
        if (playerIndex == 2) {
            CGFloat components[8] = {209.0f/255.0f, 0.0, 0.0, 0.0,  // Start color
                209.0f/255.0f, 0.0, 0.0, 0.25}; // End color
            gradient = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
        } else {
            
            
            // CGFloat components[8] = {0.0f/255.0f, 0.0f/255.0f, 205.0f/255.0f, 0.1,  // Start color
            //    0.0f/255.0f, 0.0f/255.0f, 205.0f/255.0f, 0.4}; // End color
            CGFloat components[8] = {51.0f/255.0f, 255.0f/255.0f, 255.0f/255.0f, 0.0,  // Start color
                    51.0f/255.0f, 255.0f/255.0f, 255.0f/255.0f, 0.25}; // End color
                
            
            gradient = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
        }
        startPoint.x = kOffsetX;
        startPoint.y = maxGraphHeight;
        endPoint.x = kOffsetX;
        endPoint.y = kOffsetY;
    }
    
    /* first part is to draw the lines of data actually logged */
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, plotVisitsX, plotPointsY);
    /* run through player 1 and player 2 shared data array picking out only selected players data */
    for (breakEntry *entry in self.selectedFrameData) {
        dataIndex ++;
        NSNumber *scoreNbr=entry.playerid;
        int pIndex = [scoreNbr intValue];
        if (pIndex == playerIndex) {

            NSNumber *pointsValue = [NSNumber numberWithInt:0];
            if (entry.points!=nil) {
                pointsValue = entry.points;
            }

            score += [pointsValue intValue];
            float plotPoints = scalePointsY * score;
            plotVisitsX = kOffsetX + dataIndex * scaleVisitsX;
            plotPointsY = graphHeight - maxGraphHeight * plotPoints;
            CGContextAddLineToPoint(ctx, plotVisitsX ,plotPointsY );
        }
        
    }
    if (fillGraph) {
        
        CGContextAddLineToPoint(ctx, plotVisitsX, maxGraphHeight);
        CGContextClosePath(ctx);
        CGContextSaveGState(ctx);
        CGContextClip(ctx);
        CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
        CGContextRestoreGState(ctx);
        CGColorSpaceRelease(colorspace);
        CGGradientRelease(gradient);
        
    } else {
        
        CGContextDrawPath(ctx, kCGPathStroke);
    
        /* last part of method is to check if selected player has a break that is current or not */
        if (breakOfPlayer > 0) {
            /* break exists, draw one dotted line entry to signify entry on graph */
            CGContextSetLineWidth(ctx, 2.0);
            CGContextMoveToPoint(ctx, plotVisitsX, plotPointsY);
            /* turn dash on! */
            CGFloat dash[] = {5.0, 5.0};
            CGContextSetLineDash(ctx, 0.0, dash, 2);
        
            dataIndex ++;
            score += breakOfPlayer;
        
            float plotPoints = scalePointsY * score;
            plotVisitsX = kOffsetX + dataIndex * scaleVisitsX;
            plotPointsY = graphHeight - maxGraphHeight * plotPoints;
        
            CGContextAddLineToPoint(ctx, plotVisitsX ,plotPointsY );
            CGContextDrawPath(ctx, kCGPathStroke);
            /* remove dash */
            CGContextSetLineDash(ctx, 0, NULL, 0);
        }
    }
}


-(void)plotPlayerMarkers:(CGContextRef)ctx :(int) playerIndex  :(UIColor*) playerColour :(float) scalePointsY :(float) scaleVisitsX {
    
    CGContextSetLineWidth(ctx, 4.0);
    CGContextSetStrokeColorWithColor(ctx, [playerColour CGColor]);
    CGContextSetFillColorWithColor(ctx, [playerColour CGColor]);
    
    int graphHeight = self.frame.size.height;
    int maxGraphHeight = graphHeight - kOffsetY;
    float plotVisitsX=0.0f;     // maintains X position of line
    float plotPointsY=0.0f;     // maintains Y position of line
    int score=0; // variable used to store visit point value.
    int dataIndex = 0;
    for (breakEntry *entry in self.selectedFrameData) {

        dataIndex ++;
        NSNumber *playerValue=entry.playerid;
        int pIndex = [playerValue intValue];
    
        if (pIndex == playerIndex) {
        
           // NSLog(@"%@",[dataPoint valueForKey:@"ballTransaction"]);
            
            NSNumber *pointsValue=entry.points;
            score += [pointsValue intValue];
        
            float plotPoints = scalePointsY * score;
        
            plotVisitsX = kOffsetX + dataIndex * scaleVisitsX;
            plotPointsY = graphHeight - maxGraphHeight * plotPoints;
        
            CGRect rect;
            if (self.selectedFrameData.count > 30)
                rect = CGRectMake(plotVisitsX - kSmallCircleRadius, plotPointsY - kSmallCircleRadius, 2 * kSmallCircleRadius, 2 * kSmallCircleRadius);
            else {
                rect = CGRectMake(plotVisitsX - kCircleRadius, plotPointsY - kCircleRadius, 2 * kCircleRadius, 2 * kCircleRadius);
            }
            if (dataIndex<100) {
                touchAreas[dataIndex] = rect;
            }
            CGContextAddEllipseInRect(ctx, rect);
        }
    }
    CGContextDrawPath(ctx, kCGPathFillStroke);
}


- (void)drawLineGraphWithContext:(CGContextRef)ctx
{
    /* assist with scale of graph - height */
    int maxScore;
    if (self.scorePlayer1+self.currentBreakPlayer1 > self.scorePlayer2+self.currentBreakPlayer2) {
        maxScore = self.scorePlayer1+1+self.currentBreakPlayer1;
    } else {
        maxScore = self.scorePlayer2+1+self.currentBreakPlayer2;
    }
    float scalePoints = 1.0f/maxScore;
    /* assist with scale of graph - width */
    NSUInteger frameDataEntries = self.selectedFrameData.count;
    if (self.currentBreakPlayer1 + self.currentBreakPlayer2 > 0) {
        frameDataEntries ++;
    }
    float scaleVisits=0.0;
    if (frameDataEntries>0) {
        scaleVisits = (self.frame.size.width - 5) / frameDataEntries;
    }

    [self plotPlayerLines:false :ctx :1 :self.currentBreakPlayer1 :[UIColor colorWithRed:51.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f] :scalePoints :scaleVisits];
    [self plotPlayerLines:true :ctx :1 :self.currentBreakPlayer1 :[UIColor colorWithRed:51.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f] :scalePoints :scaleVisits];
    [self plotPlayerMarkers:ctx :1 :[UIColor colorWithRed:51.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f] :scalePoints :scaleVisits];
    
    
    [self plotPlayerLines:false :ctx :2 :self.currentBreakPlayer2 :[UIColor colorWithRed:209.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f] :scalePoints :scaleVisits];
    [self plotPlayerLines:true :ctx :2 :self.currentBreakPlayer2 :[UIColor colorWithRed:209.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f] :scalePoints :scaleVisits];
    [self plotPlayerMarkers:ctx :2 :[UIColor colorWithRed:209.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f] :scalePoints :scaleVisits];
    
}


#pragma USER EVENTS

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    //NSLog(@"Touch x:%f, y:%f", point.x, point.y);
    for (int i = 0; i < 100; i++)
    {
        if (CGRectContainsPoint(touchAreas[i], point))
        {
            if (self.matchStatistics) {
                [self updateStatBox:i :TRUE];
            } else {
                [self loadVisitWindow:i :TRUE];
            }
            break;
        }
    }
}

#pragma VISUALS/OUTPUT

-(void) updateStatBox:(int) pointerIndex :(BOOL) fromGraph {
    
    int realPointer=pointerIndex;
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];;
    int pointsPlayer1;
    int pointsPlayer2;
    int playerIndex;
    
    if (pointerIndex > self.numberOfFrames) {
        realPointer -= (self.numberOfFrames + 1);
        data = [self.matchFramePoints objectAtIndex:realPointer];
        playerIndex = 2;
        realPointer++;
    } else {
        data = [self.matchFramePoints objectAtIndex:realPointer-1];
        playerIndex = 1;
    }
    pointsPlayer1 = [[data valueForKeyPath:@"player1"] intValue];
    pointsPlayer2 = [[data valueForKeyPath:@"player2"] intValue];
    
    [self.delegate displayMatchPoint :pointsPlayer1 :pointsPlayer2 :playerIndex :realPointer];
    
    //need to delegate update of box
    NSLog(@"Tapped a match stat with index %d, value", pointerIndex);
}


-(void) loadVisitWindow:(int) visitIndex :(BOOL) fromGraph {
    // example.  need to obtain items ball count..
    
    int index = visitIndex;
    if (self.selectedFrameData.count < visitIndex) {
        index = (int)self.selectedFrameData.count;
    }
    if (index ==0) {
        return;
    }
    breakEntry *data = [self.selectedFrameData objectAtIndex:index-1];
    self.visitShots = data.shots;
    
    self.visitNumberOfBalls = data.shots.count;
    self.visitPlayerIndex = data.playerid;
    self.visitShotType = data.lastshotid;
    
    if (data.shots.count>1 && [self.visitShotType integerValue] != Potted  ) {
        self.visitShotType = [NSNumber numberWithInt:Potted];
    }
    
    ballShot *shotData = [data.shots lastObject];
    self.timeStamp = shotData.shottimestamp;
    self.visitPoints = data.points;
    self.visitRef = [NSString stringWithFormat:@"%d/%d",index,(int)self.selectedFrameData.count];
    self.visitId = index;
    if (fromGraph) {
        
        [self.delegate reloadGrid];
   
        self.visitBreakDown.alpha=0.0f;
        
 
        [UIView animateWithDuration:0.5f animations:^{
            self.visitBreakDown.hidden = false;
             self.visitBreakDown.alpha=1.0f;
            //[self.visitBreakDown layoutIfNeeded];
        } completion:^(BOOL finished){
            nil;
        }
         ];
  
    }
    NSLog(@"Tapped a bar with index %d, value", index);
}


- (UIImage *) imageWithView:(statsV *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}


/* created 20150929 */
- (UIImage *) imageWithCollectionView:(UICollectionView *)collectionBreakView
{
    CGSize widthHeight = CGSizeMake(collectionBreakView.contentSize.width, collectionBreakView.contentSize.height);
    UIGraphicsBeginImageContextWithOptions(widthHeight, collectionBreakView.opaque, 0.0);
    [collectionBreakView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


/* created 20150928 */
/* last modified 20151029 */
-(NSString*) composeResultsFile :(NSMutableArray*) frameDataSet :(NSString*) playerName1 :(NSString*) playerName2 {
    
    NSString *fileData = @"EntryID,BreakEndDT,Frame,Player,shotType,shotDetail1,shotDetail2,BallColor,Points,PotDT,pocketID";
    
    int tempFrameid=1;
    NSNumber *frameIdx = [NSNumber numberWithInt:0];
    int tempEntryid=0;
    
    for (breakEntry *data in frameDataSet) {
        
        if (frameIdx != data.frameid) {
            tempFrameid ++;
            frameIdx = data.frameid;
            NSMutableArray *startDate = [self.db entriesRetreive:[self getMatchId] :nil :frameIdx :nil :nil :[NSNumber numberWithInt:2] :false];
            breakEntry *tempEntry = [[breakEntry alloc] init];
            tempEntry = [startDate objectAtIndex:0];
            fileData = [NSString stringWithFormat:@"%@\n%@,%@,%@,%@,%s,%@,%@,%@,%d,%@,%@",fileData, tempEntry.entryid,tempEntry.endbreaktimestamp,tempEntry.frameid,@"n/a","FrameStart",@"n/a",@"n/a",@"n/a",0,@"n/a",@"n/a"];
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
            fileData = [NSString stringWithFormat:@"%@\n%@,%@,%@,%@,%@,%@,%@,%@,%d,%@,%@",fileData, data.entryid,data.endbreaktimestamp,data.frameid,playerName,shotName,shotDetail1,shotDetail2,ball.colour,ballPoint,potTimeStamp,pocketid];
            
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


/* created 20151012 */
/* last modified 20151029 */
-(NSString*) composeDataFile :(NSMutableArray*) frameDataSet :(NSString*) playerName1 :(NSString*) playerName2 {
    
    NSDate *date = [NSDate date];
    NSDateFormatter *longDateFormatter = [[NSDateFormatter alloc] init];
    [longDateFormatter setDateStyle:NSDateFormatterLongStyle];
    NSString *longDate = [longDateFormatter stringFromDate:date];
    
    NSString *fileData = [NSString stringWithFormat:@"%@;%@;%@",playerName1,playerName2,longDate];
    
    int tempFrameid=1;
    NSNumber *frameIdx = [NSNumber numberWithInt:0];
    int tempEntryid=0;

    for (breakEntry *data in frameDataSet) {
        
        if (frameIdx != data.frameid) {
            tempFrameid ++;
            frameIdx = data.frameid;
            NSMutableArray *startDate = [self.db entriesRetreive:[self getMatchId] :nil :frameIdx :nil :nil :[NSNumber numberWithInt:2] :false];
            breakEntry *tempEntry = [[breakEntry alloc] init];
            tempEntry = [startDate objectAtIndex:0];
            fileData = [NSString stringWithFormat:@"%@\n%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@",fileData, tempEntry.entryid,tempEntry.endbreaktimestamp,tempEntry.frameid,@"0",@"0",@"0",@"0",@"FS",@"0",@"0",@"0"];
        }
        int potIndex = 0;
        
        for (ballShot *ball in data.shots) {
            int ballPoint;
            ballPoint = [ball.value intValue];
            NSNumber *shotDetail1;
            NSNumber *shotDetail2;
            NSNumber *pocketid;
            
            pocketid = ball.pocketid;
            
            if (ball.shotid == [NSNumber numberWithInt:Potted]) {
                shotDetail1 = ball.distanceid;
                shotDetail2 = ball.effortid;
            } else if (ball.shotid == [NSNumber numberWithInt:Foul]) {
                shotDetail1 = ball.foulid;
                shotDetail2 = [NSNumber numberWithInt:0];
            } else if (ball.shotid == [NSNumber numberWithInt:Missed]) {
                shotDetail1 = ball.distanceid;
                shotDetail2 = ball.effortid;
            } else if (ball.shotid == [NSNumber numberWithInt:Safety]) {
                shotDetail1 = ball.safetyid;
                shotDetail2 = [NSNumber numberWithInt:0];
            } else if (ball.shotid == [NSNumber numberWithInt:Bonus]) {
                shotDetail1 = ball.foulid;
                shotDetail2 =[NSNumber numberWithInt:0];
            }  else if (ball.shotid == [NSNumber numberWithInt:Adjustment]) {
                shotDetail1 = ball.foulid;
                shotDetail2 = [NSNumber numberWithInt:0];
            }
            fileData = [NSString stringWithFormat:@"%@\n%@;%@;%@;%@;%@;%@;%@;%@;%d;%@;%@",fileData, data.entryid, data.endbreaktimestamp,data.frameid,data.playerid,ball.shotid,shotDetail1,shotDetail2,ball.colour,ballPoint,ball.shottimestamp,pocketid];
            
            potIndex ++;
            
        }
        tempEntryid = [data.entryid intValue];
    }
    
    frameIdx = [NSNumber numberWithInt:tempFrameid];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    fileData = [NSString stringWithFormat:@"%@\n%d;%@;%@;%@;%@;%@;%@;%@;%@;%@",fileData, tempEntryid+1 ,[dateFormatter stringFromDate:[NSDate date]],frameIdx,@"0",@"0",@"0",@"0",@"ME",@"0",@"0"];
    
    
    
    return fileData;
}







/* created 20151012 */
/* last modified 20151029 */
-(NSNumber*) loadArchiveMatch :(NSArray*)lines :(UITextField*)player1 :(UITextField*)player2 :(breakEntry*)breakText :(int)skins{
    
    
    
    
    NSString *prefixColourName = @"";
    if (skins==2) {
        prefixColourName = @"hollow_";
    }
    
    
    self.activeMatchData = [[NSMutableArray alloc] init];
    self.activeFrameData = [[NSMutableArray alloc] init];
    self.selectedFrameData = [[NSMutableArray alloc] init];
    
    NSNumber *previousEntryId = [NSNumber numberWithInt:0];
    
    int totalPoints=0;
    int lineCounter=0;
    
    breakEntry *entryData = [[breakEntry alloc] init];
    
    /* for each row in line */
    for (NSString *line in lines) {
        lineCounter ++;
        if (lineCounter == 1) {
            NSArray *players = [line componentsSeparatedByString:@";"];
            player1.text = [players objectAtIndex:0];
            player2.text = [players objectAtIndex:1];
            
            UIFont *smallerFont = [UIFont fontWithName:@"HelveticaNeue" size:35];
            [breakText setFont:smallerFont];
            breakText.hidden = false;
            breakText.text = [NSString stringWithFormat:@"%@",[players objectAtIndex:2]];
            // skip the header record
            continue;
        }
        
        NSArray *items = [line componentsSeparatedByString:@";"];
        
        if ([items objectAtIndex:0]!=previousEntryId) {
            
            if (previousEntryId != [NSNumber numberWithInt:0]) {
                ballShot *lastShot = [entryData.shots lastObject];
                entryData.lastshotid = lastShot.shotid;
                
                [activeMatchData addObject:[entryData copy]];
                
                totalPoints = 0;
            }
            previousEntryId = [items objectAtIndex:0];
            [entryData.shots removeAllObjects];
        }
        
        entryData.matchid=[NSNumber numberWithInt:1];
        ballShot *shot = [ballShot alloc];
        totalPoints += [[items objectAtIndex:8] intValue];
        entryData.points = [NSNumber numberWithInt:totalPoints];
        entryData.frameid = [NSNumber numberWithInt:[[items objectAtIndex:2] intValue]];
        
        /* for each column in a row */
        for (int itemindex=0; itemindex<items.count; itemindex++) {
            
            switch (itemindex)
            
            {
                case 0:
                    //entry id
                    entryData.entryid = [NSNumber numberWithInt:[[items objectAtIndex:itemindex] intValue]];
                    break;
                    
                case 1:
                    
                    //last shot date time
                    entryData.endbreaktimestamp = [items objectAtIndex:itemindex];
                    break;
                    
                case 2:
                    
                    //frame id
                    entryData.frameid = [NSNumber numberWithInt:[[items objectAtIndex:2] intValue]];
                    break;
                    
                case 3:
                    
                    // player id
                    entryData.playerid = [NSNumber numberWithInt:[[items objectAtIndex:itemindex] intValue]];
                    break;
                    
                case 4:
                    
                    // shot id
                    shot.shotid = [NSNumber numberWithInt:[[items objectAtIndex:itemindex] intValue]];
                    break;
                    
                case 5:
                    
                    // shot segment 1
                    switch ([shot.shotid intValue])
                {
                    case Potted:
                        shot.distanceid = [NSNumber numberWithInt:[[items objectAtIndex:itemindex] intValue]];
                        break;
                    case Missed:
                        shot.distanceid = [NSNumber numberWithInt:[[items objectAtIndex:itemindex] intValue]];
                        break;
                    case Foul:
                        shot.foulid = [NSNumber numberWithInt:[[items objectAtIndex:itemindex] intValue]];
                        break;
                    case Safety:
                        shot.safetyid = [NSNumber numberWithInt:[[items objectAtIndex:itemindex] intValue]];
                        break;
                    case Bonus:
                        shot.foulid = [NSNumber numberWithInt:[[items objectAtIndex:itemindex] intValue]];
                        break;
                    case Adjustment:
                        shot.foulid = [NSNumber numberWithInt:[[items objectAtIndex:itemindex] intValue]];
                        break;
                    default:
                        // statements
                        break;
                }
                    
                    break;
                    
                case 6:
                    
                    // shot segment 2
                    switch ([shot.shotid intValue])
                {
                    case Potted:
                        shot.effortid = [NSNumber numberWithInt:[[items objectAtIndex:itemindex] intValue]];
                        break;
                    case Missed:
                        shot.effortid = [NSNumber numberWithInt:[[items objectAtIndex:itemindex] intValue]];
                        break;
                        
                    default:
                        // statements
                        break;
                }
                    break;
                    
                case 7:

                    shot.colour = [items objectAtIndex:itemindex];
                    
                    if ([shot.colour isEqualToString:@"RED"]) {
                        shot.imageNameLarge = [NSString stringWithFormat:@"%@red_01.png",prefixColourName];
                    } else if ([shot.colour isEqualToString:@"YELLOW"]) {
                        shot.imageNameLarge = [NSString stringWithFormat:@"%@yellow_02.png",prefixColourName];
                    } else if ([shot.colour isEqualToString:@"GREEN"]) {
                        shot.imageNameLarge = [NSString stringWithFormat:@"%@green_03.png",prefixColourName];
                    } else if ([shot.colour isEqualToString:@"BROWN"]) {
                        shot.imageNameLarge = [NSString stringWithFormat:@"%@brown_04.png",prefixColourName];
                    } else if ([shot.colour isEqualToString:@"BLUE"]) {
                        shot.imageNameLarge = [NSString stringWithFormat:@"%@blue_05.png",prefixColourName];
                    } else if ([shot.colour isEqualToString:@"PINK"]) {
                        shot.imageNameLarge = [NSString stringWithFormat:@"%@pink_06.png",prefixColourName];
                    } else if ([shot.colour isEqualToString:@"BLACK"]) {
                        shot.imageNameLarge = [NSString stringWithFormat:@"%@black_07.png",prefixColourName];
                    }
                    
                    break;
                    
                case 8:
                    
                    //shot points
                    if (![[items objectAtIndex:itemindex] isEqualToString:@"0"]) {
                        shot.value = [NSNumber numberWithInt:[[items objectAtIndex:itemindex] intValue]];
                    }
                    
                    break;
                    
                case 9:
                    
                    //shot date time
                    if (![[items objectAtIndex:itemindex] isEqualToString:@"0"]) {
                        shot.shottimestamp = [items objectAtIndex:itemindex];
                    }
                    
                    break;
                 
                    
                case 10:
                    shot.pocketid = [NSNumber numberWithInt:[[items objectAtIndex:itemindex] intValue]];
                    break;
                    
                    break;
                default:
                    
                    // statements
                    break;
            }
        }
        if ([entryData.shots count] == 0) {
            entryData.shots = [NSMutableArray arrayWithObjects:shot, nil];
        } else {
            [entryData.shots addObject:shot];
        }
        
    }
    return entryData.frameid;
}


#pragma MATCH STACK-BAR-GRAPH

/* created 20151003 */
-(int)plotMatchPlayerStakedbar:(bool)fillGraph :(CGContextRef)ctx :(int) playerIndex :(NSMutableArray*) matchData  :(UIColor*) playerColour :(float) scalePointsY :(float) scaleFramesX :(int) touchIndex {
    
    CGContextSetLineWidth(ctx, 1.5);
    CGContextSetStrokeColorWithColor(ctx, [[UIColor blackColor] CGColor] );
    CGContextSetFillColorWithColor(ctx, [playerColour CGColor]);
    int graphHeight = self.frame.size.height;
    int maxGraphHeight = graphHeight - kOffsetY;
    int score=0;
    int dataIndex = 0;
    int scoreOffset=0;
    
    CGColorSpaceRef colorspace;
    
    colorspace = CGColorSpaceCreateDeviceRGB();
    float plotFramesMaxX = 0.0;
    float plotFramesMinX = 0.0;
    
    float colPadding = 10.0f;
    if (self.numberOfFrames>12) {
        colPadding = 2.0f;
    }
    
    /* run through player 1 and player 2 shared data array picking out only selected players data */
    for (NSMutableArray *dataPoint in matchData) {
        
        dataIndex ++;
        touchIndex ++;
        
        NSNumber *pointsValue;
        NSNumber *pointsOffset;
        if (playerIndex==1) {
            pointsValue=[dataPoint valueForKeyPath:@"player1"];
            pointsOffset = [dataPoint valueForKeyPath:@"player1Offset"];
        } else {
            pointsValue=[dataPoint valueForKeyPath:@"player2"];
            pointsOffset = [dataPoint valueForKeyPath:@"player2Offset"];
        }
        
        score = [pointsValue intValue];
        scoreOffset = [pointsOffset intValue];
        
        float plotPointsMinY = graphHeight - (maxGraphHeight * (scalePointsY * scoreOffset));
        float plotPointsMaxY = graphHeight - (maxGraphHeight * (scalePointsY * (score + scoreOffset)));
        
        plotFramesMinX=plotFramesMaxX;
        plotFramesMaxX=kOffsetX + dataIndex * scaleFramesX;
        
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, plotFramesMinX+colPadding, plotPointsMinY);
        CGContextAddLineToPoint(ctx, plotFramesMaxX-colPadding, plotPointsMinY);
        CGContextAddLineToPoint(ctx, plotFramesMaxX-colPadding, plotPointsMaxY);
        CGContextAddLineToPoint(ctx, plotFramesMinX+colPadding, plotPointsMaxY);
        CGContextClosePath(ctx);
        CGContextFillPath(ctx);
        
        CGRect rect;
        rect = CGRectMake(plotFramesMinX+colPadding, plotPointsMaxY, plotFramesMaxX - plotFramesMinX - (colPadding*2.0f), plotPointsMinY - plotPointsMaxY);
        
        if (dataIndex<100) {
            touchAreas[touchIndex] = rect;
        }
        
    }
    return touchIndex;
}








- (void)drawMatchStackedbarGraphWithContext:(CGContextRef)ctx
{
    float scalePoints = 1.0f/ (float)self.matchMaxPoints;
    /* assist with scale of graph - width */
    NSUInteger frameDataEntries = self.matchFramePoints.count;
    int touchIndex=0;
    
    float scaleFrames=0.0;
    int colsScale = (int)self.matchFramePoints.count;
    if (frameDataEntries>0) {
        if (frameDataEntries<8) {
            colsScale = 8;
        }
        scaleFrames = ((int)self.frame.size.width) / colsScale;
    }
    
    // Player 1 plotting
    touchIndex = [self plotMatchPlayerStakedbar:false :ctx :1 :self.matchFramePoints :[UIColor colorWithRed:51.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f] :scalePoints :scaleFrames :touchIndex];
    
    // Player 2 plotting
    touchIndex = [self plotMatchPlayerStakedbar:false :ctx :2 :self.matchFramePoints :[UIColor colorWithRed:209.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0f] :scalePoints :scaleFrames :touchIndex];
    
}


/* last modified 20151003 */
-(void)initMatchGraphData  {
    [self.matchFramePoints removeAllObjects];
    self.matchMaxPoints=0;
    
    for (int frameIndex = 1; frameIndex <= self.numberOfFrames; frameIndex++)
    {
        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
        if (frameIndex==self.numberOfFrames) {
            // add currentbreak to last frame if it exists
            [data setValue:[NSNumber numberWithInt:[self getFramePoints:[self selectedFrameData] :[NSNumber numberWithInt:1] :[NSNumber numberWithInt:frameIndex]] + self.currentBreakPlayer1] forKey:@"player1"];
            
            [data setValue:[NSNumber numberWithInt:[self getFramePoints:[self selectedFrameData] :[NSNumber numberWithInt:2] :[NSNumber numberWithInt:frameIndex]] + self.currentBreakPlayer2] forKey:@"player2"];
        } else {
            [data setValue:[NSNumber numberWithInt:[self getFramePoints:[self selectedFrameData] :[NSNumber numberWithInt:1] :[NSNumber numberWithInt:frameIndex]]] forKey:@"player1"];
            
            [data setValue:[NSNumber numberWithInt:[self getFramePoints:[self selectedFrameData] :[NSNumber numberWithInt:2] :[NSNumber numberWithInt:frameIndex]]] forKey:@"player2"];
        }

        [data setValue:[NSNumber numberWithInt:0] forKey:@"player1Offset"];
        [data setValue:[data valueForKey:@"player1"] forKey:@"player2Offset"];
        
        /* match points maximum is player1 points + player2 points as we are going for stacked bar graph */
        if (([[data valueForKeyPath:@"player1"] intValue] + [[data valueForKeyPath:@"player2"] intValue]) > self.matchMaxPoints) {
            self.matchMaxPoints = [[data valueForKeyPath:@"player1"] intValue] + [[data valueForKeyPath:@"player2"] intValue];
        }
        
        [self.matchFramePoints addObject:data];
    }
    self.matchMaxPoints ++;
}

#pragma STANDARD UIView METHODS

- (void)drawRect:(CGRect)rect {
    
    if (self.printGraph) {
        [self initMatchGraphData];
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, [[UIColor grayColor] CGColor]);
    
    CGFloat dash[] = {1.0, 1.0};
    CGContextSetLineDash(context, 0.0, dash, 2);
    
    int graphBottom = self.frame.size.height;

    if (self.matchStatistics == false) {
        NSUInteger frameDataEntries = self.selectedFrameData.count;
        if (self.currentBreakPlayer1 + self.currentBreakPlayer2 > 0) {
            frameDataEntries ++;
        }
        float scaleVisits = 0.0;
        if (frameDataEntries>0) {
            scaleVisits = ((int)self.frame.size.width - 5) / frameDataEntries;
        }
        if (scaleVisits==0) {
            scaleVisits=50;
        }
        if (frameDataEntries <= 30) {
            // How many lines?
            int howMany = (self.frame.size.width - kOffsetX) + 11 / scaleVisits;
            // Here the lines go
            for (int i = 0; i < howMany; i++)
            {
                CGContextMoveToPoint(context, kOffsetX + i * scaleVisits, kGraphTop);
                CGContextAddLineToPoint(context, kOffsetX + i * scaleVisits, graphBottom);
            }
            
            int howManyHorizontal = (graphBottom - kGraphTop - kOffsetY) / scaleVisits;
            for (int i = 0; i <= howManyHorizontal; i++)
            {
                CGContextMoveToPoint(context, kOffsetX, graphBottom - kOffsetY - i * scaleVisits);
                CGContextAddLineToPoint(context, self.frame.size.width, graphBottom - kOffsetY - i * scaleVisits    );
            }
            CGContextStrokePath(context);
        }
        CGContextSetLineDash(context, 0, NULL, 0); // Remove the dash
        [self drawLineGraphWithContext:context];
        
    } else {
        // draw stacked bar graph for match
        float scaleFrames = 0.0;
        int colsScale = self.numberOfFrames;
        if (self.numberOfFrames>0) {
            if (self.numberOfFrames<8) {
                colsScale = 8;
            }
            scaleFrames = ((int)self.frame.size.width) / colsScale;
        }
        if (scaleFrames==0) {
            scaleFrames=10;
        }
        // How many lines?
        int howMany = (self.frame.size.width - kOffsetX) + 11 / scaleFrames;
        
        // Here the lines go
        for (int i = 0; i < howMany; i++)
        {
            CGContextMoveToPoint(context, kOffsetX + i * scaleFrames, kGraphTop);
            CGContextAddLineToPoint(context, kOffsetX + i * scaleFrames, graphBottom);
        }
        int howManyHorizontal = (graphBottom - kGraphTop - kOffsetY) / scaleFrames;
        for (int i = 0; i <= howManyHorizontal; i++)
        {
            CGContextMoveToPoint(context, kOffsetX, graphBottom - kOffsetY - i * scaleFrames);
            CGContextAddLineToPoint(context, self.frame.size.width, graphBottom - kOffsetY - i * scaleFrames    );
        }
        CGContextStrokePath(context);
        CGContextSetLineDash(context, 0, NULL, 0); // Remove the dash
        [self drawMatchStackedbarGraphWithContext:context];

    }
    
}

@end
