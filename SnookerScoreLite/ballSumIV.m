//
//  ballSumIV.m
//  SnookerScoreMaster
//
//  Created by andrew glew on 14/07/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import "ballSumIV.h"

@implementation ballSumIV

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/




- (void)layoutSubviews {
    [super layoutSubviews];
    self.layer.cornerRadius = self.frame.size.width / 2.0;
    //self.layer.borderWidth = 0.5;
    
    
    
    
    if (self.tag==1) {
        self.layer.backgroundColor = [UIColor colorWithRed:217.0f/255.0f green:23.0f/255.0f blue:60.0f/255.0f alpha:1.0].CGColor;
    } else if (self.tag==2 ) {
        self.layer.backgroundColor = [UIColor colorWithRed:222.0f/255.0f green:199.0f/255.0f blue:4.0f/255.0f alpha:1.0].CGColor;
    } else if (self.tag==3 ) {
        self.layer.backgroundColor = [UIColor colorWithRed:61.0f/255.0f green:191.0f/255.0f blue:61.0f/255.0f alpha:1.0].CGColor;
    } else if (self.tag==4 ) {
        self.layer.backgroundColor = [UIColor colorWithRed:120.0f/255.0f green:64.0f/255.0f blue:0.0f/255.0f alpha:1.0].CGColor;
    } else if (self.tag==5 ) {
        self.layer.backgroundColor = [UIColor colorWithRed:39.0f/255.0f green:121.0f/255.0f blue:198.0f/255.0f alpha:1.0].CGColor;
    } else if (self.tag==6 ) {
        self.layer.backgroundColor = [UIColor colorWithRed:201.0f/255.0f green:78.0f/255.0f blue:184.0f/255.0f alpha:1.0].CGColor;
    } else if (self.tag==7 ) {
        self.layer.backgroundColor = [UIColor colorWithRed:0.0f/255.0f green:0.0f/255.0f blue:0.0f/255.0f alpha:1.0].CGColor;
    }
}

@end
