//
//  playerListingTVC.h
//  SnookerScoreMaster
//
//  Created by andrew glew on 09/01/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "player.h"
#import "playerDetailVC.h"
#import "dbHelper.h"

@class playerListingTVC;

@protocol PlayersListingDelegate <NSObject>
-(void)addItemViewController:(playerListingTVC *)controller loadPlayerDetails :(player *) playerSelected;
@end

@interface playerListingTVC : UITableViewController {
    
}
@property (nonatomic, weak) id <PlayersListingDelegate> delegate;
@property (nonatomic) NSString *viewOption;
@property (nonatomic) NSNumber *activePlayerNumber;
@property (strong, nonatomic) dbHelper *db;
@property (strong, nonatomic) player *activePlayer;
@property (strong, nonatomic) NSMutableArray  *players;
@property (strong, nonatomic) NSMutableDictionary  *cachedAvatars;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *toolbarButtonMerge;
@property (strong, nonatomic) IBOutlet UITableView *playerTableView;



@end





