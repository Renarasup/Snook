//
//  HeadToHeadCellTVC.m
//  SnookerScoreMaster
//
//  Created by andrew glew on 12/01/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import "HeadToHeadCellTVC.h"

@implementation HeadToHeadCellTVC


- (void)awakeFromNib {
    // Initialization code
    [super awakeFromNib];
}


- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    UIColor *opponentBGColor = self.opponentBadge.backgroundColor;
    UIColor *selectedBGColor = self.selectedBadge.backgroundColor;
    [super setHighlighted:highlighted animated:animated];
    
    self.opponentBadge.backgroundColor = opponentBGColor;
    self.selectedBadge.backgroundColor = selectedBGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    UIColor *opponentBGColor = self.opponentBadge.backgroundColor;
    UIColor *selectedBGColor = self.selectedBadge.backgroundColor;
    
    [super setSelected:selected animated:animated];
    
    self.opponentBadge.backgroundColor = opponentBGColor;
    self.selectedBadge.backgroundColor = selectedBGColor;
}





@end
