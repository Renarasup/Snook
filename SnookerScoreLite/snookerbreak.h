//
//  snookerbreak.h
//  SnookerScorer
//
//  Created by andrew glew on 08/11/2014.
//  Copyright (c) 2014 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ball.h"

@interface snookerbreak : UITextField {
    int frameScore;
    int breakScore;
    int highestBreak;
    int nbrBallsPotted;
}
@property (assign) int frameScore;
@property (assign) int breakScore;
@property (assign) int highestBreak;
@property (assign) int highestBreakFrameNo;
@property (assign) int nbrBallsPotted;
@property (nonatomic, strong) NSMutableArray *pottedBalls;
@property (nonatomic, strong) NSMutableArray *shots;


@property (strong, nonatomic) ball     *currentBall;
-(void)clearBreak:(UIImageView*) imageCueBall;

-(bool)incrementScore:(ball*) pottedball :(UIImageView*) imagePottedBall :(UIView*) breakView :(int) shotType :(int)shotGroup1SegmentId :(int)shotGroup2SegmentId;

-(void)addDetail:(ball*) pottedball :(int) shotType :(int)shotGroup1SegmentId :(int)shotGroup2SegmentId;
-(NSMutableArray *)addBonusShots:(ball*) pottedball :(int) shotType :(int)shotGroup1SegmentId :(int)shotGroup2SegmentId;
-(void)incrementScore:(ball*) pottedball;
-(void)clearShots;


/* new methods*/
-(void)addBreakData:(ball*) pottedball :(NSNumber*) shotid :(NSNumber*)shotsegment1  :(NSNumber*)shotsegment2;
-(void)addShot:(ball*) pottedball :(UIImageView*) imagePottedBall :(UIView*) breakView :(int) shotType :(int)shotGroup1SegmentId :(int)shotGroup2SegmentId;
-(bool)validateShot;
@end
