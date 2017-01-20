//
//  PersistentBackgroundLabel.m
//  SnookerScoreMaster
//
//  Created by andrew glew on 15/01/2017.
//  Copyright © 2017 andrew glew. All rights reserved.
//

#import "PersistentBackgroundLabel.h"

@implementation PersistentBackgroundLabel




- (void)setPersistentBackgroundColor:(UIColor*)color {
    super.backgroundColor = color;
}

- (void)setBackgroundColor:(UIColor *)color {
    // do nothing - background color never changes
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
