//
//  buttonBall.m
//  SnookerScorer
//
//  Created by andrew glew on 06/11/2014.
//  Copyright (c) 2014 andrew glew. All rights reserved.
//

#import "ball.h"

@implementation ball

@synthesize pottedPoints;
@synthesize foulPoints;
@synthesize quantity;
@synthesize colour;
@synthesize imageNameSmall;
@synthesize potsInBreakCounter;
@synthesize ballColour;
@synthesize timeStamp;
@synthesize indicator;
@synthesize skinPrefix;


-(id)init {
    if (self = [super init])  {
        self.foulPoints = 4;
        self.quantity = 1;
    }
    return self;
}

-(int)pottedPoints {
    return pottedPoints;
}

-(void)setPottedPoints:(int) value {
    pottedPoints = value;
}

-(int)potsInBreakCounter {
    return potsInBreakCounter;
}

-(void)setPotsInBreakCounter:(int) value {
    potsInBreakCounter = value;
}

-(int)foulPoints {
    return foulPoints;
}

-(void)setFoulPoints:(int) value {
    foulPoints = value;
}

-(NSString *)colour {
    return colour;
}

-(void)setColour:(NSString *) value {
    colour = value;
}

-(NSString *)imageNameSmall {
    return imageNameSmall;
}

-(void)setImageNameSmall:(NSString *) value {
    imageNameSmall = value;
}

-(NSString *)imageNameLarge {
    return imageNameLarge;
}

-(void)setImageNameLarge:(NSString *) value {
    imageNameLarge = value;
}


-(UIColor *)ballColour {
    return ballColour;
}

-(void)setBallColour:(UIColor *) value {
    ballColour = value;
}

-(int)quantity {
    return quantity;
}

-(void)setQuantity:(int) value {
    quantity = value;
}


-(void)decreaseQty {

    quantity--;
    if (quantity == 0) {
       // self.hidden = true;
        self.enabled = false;
    }
}


- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    if (!enabled) {
    [self setAlpha:0.2];
    } else {
    [self setAlpha:1.0];
    }
}

/* created 20151013 */
-(id) copyWithZone: (NSZone *) zone
{
    ball *ballCopy = [[ball allocWithZone: zone] init];
    [ballCopy setColour:self.colour];
    [ballCopy setPottedPoints:self.pottedPoints];
    [ballCopy setFoulPoints:self.foulPoints];
    [ballCopy setQuantity:self.quantity];
    [ballCopy setSkinPrefix:self.skinPrefix];
    [ballCopy setImageNameSmall:self.imageNameSmall];
    [ballCopy setImageNameLarge:self.imageNameLarge];
    [ballCopy setTimeStamp:self.timeStamp];
    [ballCopy setIndicator:self.indicator];
    [ballCopy setBallColour:self.ballColour];
    [ballCopy setPotsInBreakCounter:self.potsInBreakCounter];
    return ballCopy;
}

@end
