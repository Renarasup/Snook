//
//  playerCellTVC.h
//  SnookerScoreMaster
//
//  Created by andrew glew on 09/01/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface playerCellTVC : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *playerPhoto;
@property (weak, nonatomic) IBOutlet UILabel *playerName;
@property (weak, nonatomic) IBOutlet UILabel *playerEmail;
@property (nonatomic) NSNumber *playerNumber;
@property (weak, nonatomic) IBOutlet UIView *badgeView;
@property (weak, nonatomic) IBOutlet UILabel *playerHiBreak;
@property (weak, nonatomic) IBOutlet UILabel *playerWinPC;
@property (weak, nonatomic) IBOutlet UILabel *playerMatches;
@property (weak, nonatomic) IBOutlet UIView *avatarView;





@end
