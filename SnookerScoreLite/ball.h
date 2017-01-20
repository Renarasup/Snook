//
//  buttonBall.h
//  SnookerScorer
//
//  Created by andrew glew on 06/11/2014.
//  Copyright (c) 2014 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ball : UIButton <NSCopying>{
    int pottedPoints;
    int foulPoints;
    int potsInBreakCounter;
    int quantity;
    NSString *colour;
    UIColor *ballColour;
    NSString *imageNameSmall;
    NSString *imageNameLarge;
    NSString *skinPrefix;
    NSString *timeStamp;
}

@property (assign) int pottedPoints;
@property (assign) int foulPoints;
@property (assign) int quantity;
@property (assign) int potsInBreakCounter;
@property (nonatomic) NSString *colour;
@property (nonatomic) NSString *skinPrefix;
@property (nonatomic) NSString *imageNameSmall;
@property (nonatomic) NSString *imageNameLarge;
@property (nonatomic) NSString *timeStamp;
@property (nonatomic) UIColor *ballColour;
@property (strong, nonatomic) UILabel *indicator;
-(id) copyWithZone: (NSZone *) zone;
-(void)decreaseQty;
@end
