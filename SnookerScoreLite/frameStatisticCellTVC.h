//
//  frameStatisticCellTVC.h
//  SnookerScoreMaster
//
//  Created by andrew glew on 08/11/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ballShot.h"
#import "breakBallCell.h"

@interface frameStatisticCellTVC : UITableViewCell <UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *playerLabel;
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *durationLabel;
@property (strong, nonatomic) IBOutlet UICollectionView *frameBallCollectionView;
@property (strong, nonatomic) NSMutableArray *balls;
@property (strong, nonatomic) UIColor *redColour;
@property (strong, nonatomic) UIColor *yellowColour;
@property (strong, nonatomic) UIColor *greenColour;
@property (strong, nonatomic) UIColor *brownColour;
@property (strong, nonatomic) UIColor *blueColour;
@property (strong, nonatomic) UIColor *pinkColour;
@property (strong, nonatomic) UIColor *blackColour;
@property (strong, nonatomic) IBOutlet UIView *cellContentView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *collectionHeightConstraint;
@property (strong, nonatomic) IBOutlet UIView *visitIndictorView;
@property (strong, nonatomic) IBOutlet UILabel *visitIndicatorIcon;




@end
