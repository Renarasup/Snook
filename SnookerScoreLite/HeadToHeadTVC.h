//
//  HeadToHeadTVC.h
//  SnookerScoreMaster
//
//  Created by andrew glew on 12/01/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeadToHeadTV.h"
#import "player.h"
#import "playerDetailVC.h"
#import "dbHelper.h"

@class HeadToHeadTVC;

@protocol HeadToHeadDelegate <NSObject>
@end

@interface HeadToHeadTVC : UITableViewController {
    
}

@property (nonatomic, weak) id <HeadToHeadDelegate> delegate;
@property (nonatomic) NSNumber *activePlayerNumber;
@property (strong, nonatomic) dbHelper *db;
@property (strong, nonatomic) player *activePlayer;
@property (strong, nonatomic) NSArray  *opponents;
@property (strong ,nonatomic) NSMutableDictionary *cachedImages;
@property (assign) int staticPlayer1Number;
@property (assign) int staticPlayer2Number;

@end