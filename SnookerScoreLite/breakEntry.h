//
//  breakEntry.h
//  SnookerScoreLite
//
//  Created by andrew glew on 20/09/2015.
//  Copyright © 2015 andrew glew. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "ballShot.h"
#import "ball.h"

@interface breakEntry : UILabel <NSCopying>  {
    NSNumber *matchid;
    NSNumber *entryid;
    NSNumber *playerid;
    NSNumber *frameid;
    NSNumber *lastshotid;
    NSString *endbreaktimestamp;
    NSNumber *points;
    NSNumber *active;
    NSMutableArray *shots;
    NSNumber *breakscore;
    NSString *skinPrefix;
    NSNumber *duration;
}

@property (nonatomic) NSNumber *matchid;
@property (nonatomic) NSNumber *entryid;
@property (nonatomic) NSNumber *playerid;
@property (nonatomic) NSNumber *frameid;
@property (nonatomic) NSNumber *lastshotid;
@property (nonatomic) NSString *endbreaktimestamp;
@property (nonatomic) NSNumber *points;
@property (nonatomic) NSNumber *active;
@property (strong, nonatomic) NSMutableArray *shots;
@property (nonatomic) NSNumber *breakscore;
@property (strong, nonatomic) ballShot *ballPotted;
@property (nonatomic) NSString *skinPrefix;
@property (nonatomic) NSNumber *duration;

-(bool)validateShot;
-(void)addShotToBreak:(ball*) pottedball :(UIImageView*) imagePottedBall :(UIView*) breakView :(NSNumber*) shotid :(NSNumber*)shotsegment1  :(NSNumber*)shotsegment2 :(NSNumber*)pocketid :(ball*)pottedFreeBall :(bool)isHollow ;
-(void)clearBreak:(UIView*) viewBreakBall;
-(id) copyWithZone: (NSZone *) zone;
@end
