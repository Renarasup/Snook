//
//  indicator.h
//  SnookerScoreLite
//
//  Created by andrew glew on 02/10/2015.
//  Copyright © 2015 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface indicator : UILabel {
    NSNumber *ballIndex;
    NSNumber *amount;
}

@property (nonatomic) NSNumber *ballIndex;
@property (nonatomic) NSNumber *amount;

@end
