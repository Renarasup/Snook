//
//  frameScore.h
//  SnookerScoreLite
//
//  Created by andrew glew on 25/09/2015.
//  Copyright © 2015 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StatsV.h"


@interface frameScore : UILabel {
    NSNumber *playerid;
    NSNumber *framesWon;
}

@property (nonatomic) NSNumber *playerid;
@property (nonatomic) NSNumber *framesWon;


-(NSNumber*) incrementFramesWon;
-(void) resetFramesWon;

@end
