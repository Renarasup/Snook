//
//  breakBallCell.m
//  SnookerScoreLite
//
//  Created by andrew glew on 06/09/2015.
//  Copyright © 2015 andrew glew. All rights reserved.
//

#import "breakBallCell.h"

@implementation breakBallCell

@synthesize ball;

/* TODO - pull required details from ball so we can get nice content for collection view when user clicks on ball. */


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.contentView.translatesAutoresizingMaskIntoConstraints  = YES;
        
        
        
        /* new code.. */
       // self.contentView.clipsToBounds = YES;
       // self.contentView.layer.cornerRadius = self.contentView.frame.size.height/2.0f;
      
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.ballStoreImage.layer.cornerRadius = self.frame.size.width / 2.0;
   // self.ballStoreImage.layer.borderWidth = 2.5;
    
}

-(void)setBorderWidth :(float) borderWidth {
    self.ballStoreImage.layer.borderWidth = borderWidth;
}



@end
