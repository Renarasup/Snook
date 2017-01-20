//
//  matchCellTVC.m
//  SnookerScoreMaster
//
//  Created by andrew glew on 14/01/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import "matchCellTVC.h"

@implementation matchCellTVC


- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    UIColor *backgroundColor = self.player1Badge.backgroundColor;
    [super setHighlighted:highlighted animated:animated];
    self.player1Badge.backgroundColor = backgroundColor;
    self.player2Badge.backgroundColor = backgroundColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    UIColor *backgroundColor = self.player1Badge.backgroundColor;
    [super setSelected:selected animated:animated];
    self.player1Badge.backgroundColor = backgroundColor;
    self.player2Badge.backgroundColor = backgroundColor;
}




@end
