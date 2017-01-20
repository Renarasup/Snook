//
//  playerListingVC.h
//  SnookerScoreMaster
//
//  Created by andrew glew on 14/01/2017.
//  Copyright © 2017 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "player.h"
#import "playerDetailVC.h"
#import "dbHelper.h"


@class playerListingVC;

@protocol PlayerListingDelegate <NSObject>
-(void)addItemViewController:(playerListingVC *)controller loadPlayerDetails :(player *) playerSelected;
@end

@interface playerListingVC : UIViewController{
    
}
@property (nonatomic, weak) id <PlayerListingDelegate> delegate;
@property (nonatomic) NSString *viewOption;
@property (nonatomic) NSNumber *activePlayerNumber;
@property (nonatomic) NSString *Player1Key;
@property (nonatomic) NSString *Player2Key;
@property (strong, nonatomic) dbHelper *db;
@property (strong, nonatomic) player *activePlayer;
@property (strong, nonatomic) NSMutableArray  *players;
@property (strong, nonatomic) NSMutableDictionary  *cachedAvatars;


@property (strong, nonatomic) IBOutlet UITableView *playerTableView;

@property (strong, nonatomic) UIColor *skinBackgroundColour;
@property (strong, nonatomic) UIColor *skinForegroundColour;
@property (strong, nonatomic) UIColor *skinPlayer1Colour;
@property (strong, nonatomic) UIColor *skinPlayer2Colour;

@end
