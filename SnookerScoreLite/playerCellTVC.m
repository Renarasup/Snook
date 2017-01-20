//
//  playerCellTVC.m
//  SnookerScoreMaster
//
//  Created by andrew glew on 09/01/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import "playerCellTVC.h"

@implementation playerCellTVC



- (void)awakeFromNib {
    // Initialization code
     [super awakeFromNib];
}



- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    UIColor *backgroundColor = self.badgeView.backgroundColor;
    [super setHighlighted:highlighted animated:animated];
    self.badgeView.backgroundColor = backgroundColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
     UIColor *backgroundColor = self.badgeView.backgroundColor;
    [super setSelected:selected animated:animated];
     self.badgeView.backgroundColor = backgroundColor;
}







@end
