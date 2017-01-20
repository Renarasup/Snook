//
//  snookerTableStatsView.h
//  SnookerScoreMaster
//
//  Created by andrew glew on 10/11/2015.
//  Copyright © 2015 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface snookerTableStatsView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *snookerTableView;
@property (weak, nonatomic) IBOutlet UILabel *bulkLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *bulkRightLabel;
@property (weak, nonatomic) IBOutlet UILabel *middleLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *middleRightLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomRightLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (assign) int statisticID;







@end
