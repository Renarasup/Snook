//
//  breakBallCell.h
//  SnookerScoreLite
//
//  Created by andrew glew on 06/09/2015.
//  Copyright © 2015 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ballShot.h"

@interface breakBallCell : UICollectionViewCell {
    ballShot *ball;
}
@property (strong, nonatomic) ballShot *ball;
@property (nonatomic, strong) UIImageView *imageBall;
@property (strong, nonatomic) IBOutlet UIImageView *ballStoreImage;
@property (strong, nonatomic) IBOutlet UIImageView *selectedImage;

-(void)setBorderWidth :(float) borderWidth;

@end
