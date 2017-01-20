//
//  hibreak.h
//  SnookerScoreMaster
//
//  Created by andrew glew on 19/07/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ball.h"


@interface hibreak : NSObject

@property (strong, nonatomic) NSMutableArray  *breakBalls;
@property (nonatomic) NSNumber *breakTotal;
@property (nonatomic) NSString *breakDate;
@property (nonatomic) NSNumber *matchid;
@end
