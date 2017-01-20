//
//  DeductPointsViewController.h
//  snookerScorer2
//
//  Created by andrew glew on 16/11/2014.
//  Copyright (c) 2014 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>

@class adjustVC;

@protocol AdjustPointsDelegate <NSObject>
- (void)addItemViewController:(adjustVC *)controller didPickDeduction:(int)selectedPoints;
- (void)addItemViewController:(adjustVC *)controller didPickBallAdjust:(int)startBallIndex :(int)ballIndex;
@end

@interface adjustVC : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>
@property (nonatomic, weak) id <AdjustPointsDelegate> delegate;
@property (assign) int sumOfPlayerFouls;
@property (assign) int ballIndex;
@property (assign) int selectedValue;
@property (strong, nonatomic) NSString *playerName;
@property (assign) int skins;
@property (strong, nonatomic) NSString *skinPrefix;
@property (weak, nonatomic) IBOutlet UIButton *adjustButton;

@property (strong, nonatomic) UIColor *skinBackgroundColour;
@property (strong, nonatomic) UIColor *skinForegroundColour;
@property (strong, nonatomic) UIColor *skinPlayer1Colour;
@property (strong, nonatomic) UIColor *skinPlayer2Colour;

@property (strong, nonatomic) UIColor *redColour;
@property (strong, nonatomic) UIColor *yellowColour;
@property (strong, nonatomic) UIColor *greenColour;
@property (strong, nonatomic) UIColor *brownColour;
@property (strong, nonatomic) UIColor *blueColour;
@property (strong, nonatomic) UIColor *pinkColour;
@property (strong, nonatomic) UIColor *blackColour;


@end
