//
//  snookerTableStatsView.m
//  SnookerScoreMaster
//
//  Created by andrew glew on 10/11/2015.
//  Copyright © 2015 andrew glew. All rights reserved.
//

#import "snookerTableStatsView.h"



@implementation snookerTableStatsView

@synthesize statisticID;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.contentLabel.text = @"click to change statistics";
    }
    return self;
}








@end
