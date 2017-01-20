//
//  hibreak.m
//  SnookerScoreMaster
//
//  Created by andrew glew on 19/07/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import "hibreak.h"

@implementation hibreak
@synthesize breakBalls;
@synthesize breakTotal;
@synthesize breakDate;
@synthesize matchid;


-(id)init {
    if (self = [super init])  {
        breakBalls = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
