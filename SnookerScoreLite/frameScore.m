//
//  frameScore.m
//  SnookerScoreLite
//
//  Created by andrew glew on 25/09/2015.
//  Copyright © 2015 andrew glew. All rights reserved.
//

#import "frameScore.h"

@implementation frameScore

@synthesize playerid;
@synthesize framesWon;


/* create 20150925 */
-(NSNumber*) incrementFramesWon {
    int frames = [framesWon intValue];
    frames ++;
    framesWon = [NSNumber numberWithInt:frames];
    self.text = [NSString stringWithFormat:@"%@",framesWon];
    return framesWon;
}

/* create 20150925 */
-(void) resetFramesWon {
    framesWon = [NSNumber numberWithInt:0];
}


@end
