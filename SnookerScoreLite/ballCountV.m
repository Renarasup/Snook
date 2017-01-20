//
//  ballCountV.m
//  SnookerScoreMaster
//
//  Created by andrew glew on 14/07/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import "ballCountV.h"

@implementation ballCountV

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSString *className = NSStringFromClass([self class]);
        self.view = [[[NSBundle mainBundle] loadNibNamed:className owner:self options:nil] firstObject];
        [self addSubview:self.view];
        return self;
    }
    return nil;
}


@end
