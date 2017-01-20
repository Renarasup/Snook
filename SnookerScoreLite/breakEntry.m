//
//  breakEntry.m
//  SnookerScoreLite
//
//  Created by andrew glew on 20/09/2015.
//  Copyright © 2015 andrew glew. All rights reserved.
//

#import "breakEntry.h"

@implementation breakEntry
@synthesize matchid;
@synthesize entryid;
@synthesize playerid;
@synthesize frameid;
@synthesize lastshotid;
@synthesize endbreaktimestamp;
@synthesize points;
@synthesize active;
@synthesize shots;
@synthesize breakscore;
@synthesize ballPotted;
@synthesize skinPrefix;
@synthesize duration;


/* TODO, find longest ball string succession in a break, highest break etc?? */

- (id)init {
    self = [super init];
    if (self) {
        self.points = [NSNumber numberWithInt:0];
    }
    return self;
}


/* created 20150911 */
-(bool)validateShot {
    
    int pointsScoredSoFar = [self.points intValue];
    int activeBallScore = [ballPotted.value intValue];
    
    if ((pointsScoredSoFar + activeBallScore) > 155) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Unforunately it is impossible to score such a high break!" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        alert.alertViewStyle = UIAlertViewStyleDefault;
        [alert show];
        return false;
    } else {
        return true;
    }
}

/*
 created 20160712
 last modified -
 
 20160208 moved into common class
 */
- (void)makeHollowBallImage :(UIImageView*) imageBall :(float) x :(float) y :(float) heightWidth :(float) border :(UIColor*) colour {
    //width and height should be same value
    imageBall.frame = CGRectMake(x, y, heightWidth, heightWidth);
    //Clip/Clear the other pieces whichever outside the rounded corner
    imageBall.clipsToBounds = YES;
    //half of the width
    imageBall.layer.cornerRadius = heightWidth/2.0f;
    imageBall.layer.borderColor=colour.CGColor;
    imageBall.layer.borderWidth=border;
}


/* created 20150911 */
/* last modified 20161210 */
-(void)addShotToBreak:(ball*) pottedball :(UIImageView*) imagePottedBall :(UIView*) breakView :(NSNumber*) shotid :(NSNumber*)shotfoulid  :(NSNumber*)shotsegment2 :(NSNumber*)pocketid :(ball*)pottedFreeBall :(bool)isHollow {
    
    //20150504 new amendment START
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *rightNow = [dateFormatter stringFromDate:[NSDate date]];
    //20150504 new amendment END

    ballShot *record = [[ballShot alloc] init];
    
    record.shotid = shotid;
    if ([shotid intValue]==Potted || [shotid intValue]==Standard) {
        record.value = [NSNumber numberWithInt:pottedball.pottedPoints];
        record.pocketid = pocketid;
        int sumOfPoints = [points intValue] + pottedball.pottedPoints;
        if (shotfoulid!=[NSNumber numberWithInt:notany]) {
            record.foulid = shotfoulid;
            points = [NSNumber numberWithInt:0];
        } else {
            record.distanceid = shotfoulid;
            record.effortid = shotsegment2;
            points = [NSNumber numberWithInt:sumOfPoints];
        }
    } else if ([shotid intValue]==Missed) {
        record.distanceid = shotfoulid;
        record.effortid = shotsegment2;
        record.pocketid = pocketid;
        record.value = [NSNumber numberWithInt:0];
    } else if ([shotid intValue]==Safety) {
        record.safetyid = shotfoulid;
        record.pocketid = pocketNone;
        record.value = [NSNumber numberWithInt:0];;
    } else if ([shotid intValue]==Foul) {
        record.foulid = shotfoulid;
        record.pocketid = pocketNone;
        record.value = [NSNumber numberWithInt:0];
    } else if ([shotid intValue]==Bonus) {
        record.foulid = shotfoulid;
        record.pocketid = pocketNone;
        record.value = [NSNumber numberWithInt:pottedball.foulPoints];
    } else if ([shotid intValue]==Adjustment) {
        record.foulid = shotfoulid;
        record.pocketid = pocketNone;
        record.value = [NSNumber numberWithInt:pottedball.pottedPoints];
    } else {
        record.pocketid = pocketNone;
        record.value = [NSNumber numberWithInt:-1];
    }
    
    record.shottimestamp = rightNow;

    if (pottedFreeBall==nil) {
        record.imageNameLarge = pottedball.imageNameLarge;
        record.colour = pottedball.colour;
    } else {
        record.imageNameLarge = pottedFreeBall.imageNameLarge;
        record.colour = pottedFreeBall.colour;
    }
        
    if (pottedball.quantity==0) {
        record.killed = [NSNumber numberWithInt:1];
    }
    
    if ([record.value intValue] != -1) {

        if ([self.shots count] == 0) {
            self.hidden = false;
            self.shots = [NSMutableArray arrayWithObjects:record, nil];
            //breakView.hidden = false;
        } else {
            [self.shots addObject:record];
        }

        ballPotted = record;

    }
}

-(void)clearBreak:(UIView*) viewBreakBall {
    points = 0;
    [self.shots removeAllObjects];
    viewBreakBall.hidden = true;
    self.hidden = true;
}

/* created 20150924 */
-(id) copyWithZone: (NSZone *) zone
{
    breakEntry *b = [[[self class] allocWithZone:zone] init];
    [b setMatchid: self.matchid];
    [b setEntryid: self.entryid];
    [b setPlayerid: self.playerid];
    [b setFrameid: self.frameid];
    [b setLastshotid: self.lastshotid];
    [b setEndbreaktimestamp: self.endbreaktimestamp];
    [b setPoints:self.points];
    [b setActive:self.active];
    [b setDuration:self.duration];
    NSMutableArray *copiedshots = [[self shots] mutableCopyWithZone:zone];
    [b setShots: copiedshots];
    [b setBreakscore:self.breakscore];

    return b;
}



@end
