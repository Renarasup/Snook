//
//  ballShot.m
//  SnookerScoreLite
//
//  Created by andrew glew on 11/09/2015.
//  Copyright © 2015 andrew glew. All rights reserved.
//

#import "ballShot.h"

@implementation ballShot

@synthesize  reftoentryid;
@synthesize opponentpoints;
@synthesize  value;
@synthesize shotid;
@synthesize breakid;
@synthesize shottimestamp;
@synthesize distanceid;
@synthesize effortid;
@synthesize foulid;
@synthesize safetyid;
@synthesize pocketid;
@synthesize colour;
@synthesize killed;
@synthesize imageNameLarge;
@synthesize notes;




-(NSString *)getDistanceText :(NSNumber*)distanceValue  {
    NSString *distance;
    
    if ([distanceValue intValue]==Short) {
        distance = @"Short";
    } else if ([distanceValue intValue]==Medium) {
        distance = @"Medium";
    } else if ([distanceValue intValue]==Long) {
        distance = @"Long";
    } else if ([distanceValue intValue]==Escape) {
        distance = @"Escape";
    }
    return distance;
}



-(NSString *)getEffortText :(NSNumber*)effortValue {
    NSString *effort;
    
    if ([effortValue intValue]==Easy) {
        effort = @"Easy";
    } else if ([effortValue intValue]==Average) {
        effort = @"Average";
    } else if ([effortValue intValue]==Tough) {
        effort = @"Tough";
    } else if ([effortValue intValue]==Fluke) {
        effort = @"Fluke";
    }
    return effort;
}

-(NSString *)getFoulTypeText :(NSNumber*)foulValue  {
    NSString *foul;
    if ([foulValue intValue]==foulInOff) {
        foul = @"in-off";
    } else if ([foulValue intValue]==foulPotAndInOff) {
        foul = @"Potted with in-off";
    } else if ([foulValue intValue]==foulWrongPotOrHit) {
        foul = @"Potted/Hit Wrong Ball";
    } else if ([foulValue intValue]==foulWrongRedPot) {
        foul = @"Potted Red On Colour";
    } else if ([foulValue intValue]==adjusted) {
        foul = @"Adjust";
    } else if ([foulValue intValue]==foulMissedBall) {
        foul = @"Missed Ball playing Colour";
    }
    return foul;
}

-(NSString *)getSafetyTypeText :(NSNumber*)safetyValue  {
    NSString *safety;
    if ([safetyValue intValue]==Superb) {
        safety = @"Superb";
    } else if ([safetyValue intValue]==Good) {
        safety = @"Good";
    } else if ([safetyValue intValue]==Alright) {
        safety = @"Alright";
    } else if ([safetyValue intValue]==Bad) {
        safety = @"Bad";
    }
    return safety;
}


-(NSString*) getBallShotText {
    NSString *text;
    
    if ([self.shotid intValue] == Foul) {
        text = [NSString stringWithFormat:@"Foul"];
    } else if ([self.shotid intValue] == Potted) {
        text = [NSString stringWithFormat:@"%@",self.value];
    } else if ([self.shotid intValue] == Safety) {
        text = [NSString stringWithFormat:@"Safety"];
    } else if ([self.shotid intValue] == Missed) {
        text = [NSString stringWithFormat:@"No Pot"];
    } else if ([self.shotid intValue] == Bonus) {
        text = [NSString stringWithFormat:@"Bonus:%@",self.value];
    } else if ([self.shotid intValue] == Adjustment) {
        text = [NSString stringWithFormat:@"%@",self.value];
    } else if ([self.shotid intValue] == Paused) {
        text = @"Paused";
    } else if ([self.shotid intValue] == Resumed) {
        text = @"Resumed";
    }
    return text;
}

-(NSString*) getBallDetailText {
    NSString *text;
    if ([self.shotid intValue] == Foul) {
        text = [NSString stringWithFormat:@"Type=%@",[self getFoulTypeText:self.foulid]];
    } else if ([self.shotid intValue] == Potted) {
        text = [NSString stringWithFormat:@"Distance=%@ Effort=%@",[self getDistanceText:self.distanceid],[self getEffortText:self.effortid]];
    } else if ([self.shotid intValue] == Safety) {
        text = [NSString stringWithFormat:@"%@",[self getSafetyTypeText:self.safetyid]];
    } else if ([self.shotid intValue] == Missed) {
        text =  [NSString stringWithFormat:@"Distance=%@ Effort=%@",[self getDistanceText:self.distanceid],[self getEffortText:self.effortid]];
    } else if ([self.shotid intValue] == Bonus) {
        text = [NSString stringWithFormat:@"Type=%@",[self getFoulTypeText:self.foulid]];
    } else if ([self.shotid intValue] == Adjustment) {
        text = [NSString stringWithFormat:@"Type=%@",[self getFoulTypeText:self.foulid]];
    }
    return text;
}

-(NSString*) getBallDetailDTText {
    
    return self.shottimestamp;
}



@end
