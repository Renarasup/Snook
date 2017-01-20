//
//  matchCellTVC.h
//  SnookerScoreMaster
//
//  Created by andrew glew on 14/01/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "match.h"
#import "PersistentBackgroundLabel.h"

@interface matchCellTVC : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *player1Photo;
@property (weak, nonatomic) IBOutlet UIImageView *player2Photo;
@property (weak, nonatomic) IBOutlet UIView *player1Badge;
@property (weak, nonatomic) IBOutlet UIView *player2Badge;
@property (weak, nonatomic) IBOutlet UILabel *Player1HiBreak;
@property (weak, nonatomic) IBOutlet UILabel *Player2HiBreak;
@property (nonatomic) NSNumber *Player1Number;
@property (nonatomic) NSNumber *Player2Number;
@property (nonatomic) NSNumber *numberOfFrames;
@property (nonatomic) NSNumber *MatchId;
@property (nonatomic) match *m;
@property (weak, nonatomic) IBOutlet UILabel *Player1Name;
@property (weak, nonatomic) IBOutlet UILabel *Player2Name;
@property (weak, nonatomic) IBOutlet UILabel *Player1FrameWins;
@property (weak, nonatomic) IBOutlet UILabel *Player2FrameWins;
@property (weak, nonatomic) IBOutlet PersistentBackgroundLabel  *matchDate;
@property (strong, nonatomic) NSString *matchEndDate;
@property (weak, nonatomic) IBOutlet UILabel *matchDuration;
@property (strong, nonatomic) IBOutlet UILabel *framesWonLabel;


@end

