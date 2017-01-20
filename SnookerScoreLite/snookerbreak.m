//
//  snookerbreak.m
//  SnookerScorer
//
//  Created by andrew glew on 08/11/2014.
//  Copyright (c) 2014 andrew glew. All rights reserved.
//

#import "snookerbreak.h"
#import "ballShot.h"

@implementation snookerbreak
@synthesize frameScore;
@synthesize breakScore;
@synthesize highestBreak;
@synthesize highestBreakFrameNo;
@synthesize nbrBallsPotted;
@synthesize currentBall;
@synthesize pottedBalls;
@synthesize shots;


- (id)init{
    if ((self = [super init])) {
        if (!currentBall) {
            currentBall = [[ball alloc] init];
            self.pottedBalls = [[NSMutableArray alloc] init];
            self.shots = [[NSMutableArray alloc] init];
        }
    }
    return self;
}


-(int)breakScore {
    return breakScore;
}

-(void)setBreakScore:(int) value {
    breakScore = value;
}

-(int)highestBreak {
    return highestBreak;
}

-(void)setHighestBreak:(int) value {
    highestBreak = value;
}

-(int)nbrBallsPotted {
    return nbrBallsPotted;
}

-(void)setNbrBallsPotted:(int) value {
    nbrBallsPotted = nbrBallsPotted + value;
}






// used by ViewController
-(void)addDetail:(ball*) pottedball :(int) shotType :(int)shotGroup1SegmentId :(int)shotGroup2SegmentId {

}


-(NSMutableArray *)addBonusShots:(ball*) pottedball :(int) shotType :(int)shotGroup1SegmentId :(int)shotGroup2SegmentId {
    

    
    NSMutableArray *record = [[NSMutableArray alloc] init];
    
    return [NSMutableArray arrayWithObjects:record, nil];
    
}



// used by ViewController
-(bool)incrementScore:(ball*) pottedball :(UIImageView*) imagePottedBall :(UIView*) breakView :(int) shotType :(int)shotGroup1SegmentId :(int)shotGroup2SegmentId {
    

        return true;
}






/* created 20150911 */
-(void)addBreakData:(ball*) pottedball :(NSNumber*) shotid :(NSNumber*)shotsegment1  :(NSNumber*)shotsegment2 {
    

}


/* created 20150911 */
-(bool)validateShot {
    return true;
}



/* created 20150911 */
-(void)addShot:(ball*) pottedball :(UIImageView*) imagePottedBall :(UIView*) breakView :(int) shotType :(int)shotGroup1SegmentId :(int)shotGroup2SegmentId {

        
   

}



/* used by the frame object */
-(void)incrementScore:(ball*) pottedball {

  
}



// used by ViewController

-(void)clearBreak:(UIImageView*) imageCueBall {

}


-(void)clearShots {

}




@end
