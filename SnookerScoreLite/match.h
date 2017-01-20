//
//  match.h
//  SnookerScoreMaster
//
//  Created by andrew glew on 14/01/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface match : NSObject

@property (nonatomic) NSString *player1Name;
@property (nonatomic) NSString *player2Name;
@property (nonatomic) NSString *player1PhotoLocation;
@property (nonatomic) NSString *player2PhotoLocation;
@property (nonatomic) NSNumber *Player1Number;
@property (nonatomic) NSNumber *Player2Number;
@property (nonatomic) NSNumber *Player1HiBreak;
@property (nonatomic) NSNumber *Player2HiBreak;
@property (nonatomic) NSNumber *Player1FrameWins;
@property (nonatomic) NSNumber *Player2FrameWins;
@property (nonatomic) NSString *matchDate;
@property (nonatomic) NSString *matchEndDate;
@property (nonatomic) NSString *matchDuration;
@property (nonatomic) NSNumber *matchid;
@property (nonatomic) NSString *matchkey;

@end
