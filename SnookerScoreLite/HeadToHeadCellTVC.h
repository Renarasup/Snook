//
//  HeadToHeadCellTVC.h
//  SnookerScoreMaster
//
//  Created by andrew glew on 12/01/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HeadToHeadCellTVC : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *opponentPhoto;
@property (weak, nonatomic) IBOutlet UIImageView *selectedPhoto;
@property (weak, nonatomic) IBOutlet UIView *opponentBadge;
@property (weak, nonatomic) IBOutlet UILabel *opponentHiBreak;
@property (weak, nonatomic) IBOutlet UIView *selectedBadge;
@property (weak, nonatomic) IBOutlet UILabel *selectedHiBreak;
@property (weak, nonatomic) IBOutlet UILabel *HeadToHeadMatches;
@property (weak, nonatomic) IBOutlet UILabel *opponentName;
@property (weak, nonatomic) IBOutlet UILabel *selectedName;
@property (weak, nonatomic) IBOutlet UILabel *opponentWinPC;
@property (weak, nonatomic) IBOutlet UILabel *selectedWinPC;
@property (nonatomic) NSNumber *opponentNumber;
@property (nonatomic) NSNumber *selectedNumber;

@property (weak, nonatomic) IBOutlet UIView *opponentAvatarView;

@property (weak, nonatomic) IBOutlet UIView *selectedvatarView;

@end
