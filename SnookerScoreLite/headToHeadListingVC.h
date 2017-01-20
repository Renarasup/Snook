//
//  headToHeadListingVC.h
//  SnookerScoreMaster
//
//  Created by andrew glew on 17/01/2017.
//  Copyright © 2017 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "player.h"
#import "playerDetailVC.h"
#import "dbHelper.h"
#import "headToHeadListingTV.h"

@class headToHeadListingVC;

@protocol Head2HeadDelegate <NSObject>
@end

@interface headToHeadListingVC : UIViewController {
    
}


@property (nonatomic, weak) id <Head2HeadDelegate> delegate;
@property (nonatomic) NSNumber *activePlayerNumber;
@property (strong, nonatomic) dbHelper *db;
@property (strong, nonatomic) player *activePlayer;
@property (strong, nonatomic) NSArray  *opponents;
@property (strong ,nonatomic) NSMutableDictionary *cachedImages;

@property (assign) int staticPlayer1Number;
@property (strong, nonatomic) IBOutlet headToHeadListingTV *h2hTableView;
@property (assign) int staticPlayer2Number;
@property (strong, nonatomic) IBOutlet UIImageView *selectedAvatar;

@property (strong, nonatomic) UIColor *skinBackgroundColour;
@property (strong, nonatomic) UIColor *skinForegroundColour;
@property (strong, nonatomic) UIColor *skinPlayer1Colour;
@property (strong, nonatomic) UIColor *skinPlayer2Colour;

@end
