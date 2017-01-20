//
//  dbHelper.h
//  SnookerScoreLite
//
//  Created by andrew glew on 08/09/2015.
//  Copyright © 2015 andrew glew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "ballShot.h"
#import "breakEntry.h"
#import "player.h"
#import "match.h"

@interface dbHelper : NSObject

@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *DB;


-(bool)dbCreate :(NSString*) databaseName;

-(NSNumber *)entriesInsert :(NSNumber *) reqMatchId :(NSNumber *) reqPlayerId :(NSNumber *) reqFrameId :(NSNumber *) reqLastShotId :(NSNumber *) reqPoints :(NSNumber *) reqActive :(NSNumber *) reqDuration;

-(bool)shotsInsert :(NSNumber *) reqEntriesId :(NSMutableArray *) reqShots;


-(NSMutableArray *)entriesRetreive :(NSNumber *) reqMatchId :(NSNumber *) reqPlayerId :(NSNumber *) reqFrameId :(NSNumber *) reqLastShotId :(NSNumber *) reqPoints :(NSNumber *) reqActive :(NSNumber *) reqDuration :(bool) excludeActives;

-(NSMutableArray *)breakShotsRetreiveRows :(NSNumber *) reqEntryId;

-(bool) entriesDeleteAll;

-(bool) shotsDeleteAll;

-(bool) shotDelete :(NSNumber *)entryId;

-(bool) entryDelete :(NSNumber *)entryId;

-(NSNumber *) getCurrentFrameId :(NSNumber*) matchid;

-(void) deleteDB :(NSString*) databaseName;

-(bool)setFrameActiveState :(NSNumber*) frameId :(NSNumber*) activefrom :(NSNumber*) activeto;

-(NSNumber*)getIdOfLastEntry;

-(player *)playerRetreive :(player *) reqPlayer;

-(void) updatePlayer :(player *) reqPlayer;

-(NSNumber*) insertPlayer :(player *) reqPlayer;

-(NSNumber*) getNewPlayerNumber;

- (NSMutableArray *)findAllPlayers :(NSNumber *) option :(NSNumber *) activePlayer;

- (NSMutableArray *)findAllMatches;

-(NSNumber*) insertMatch :(NSNumber *) player1Number :(NSNumber *) player2Number;

-(NSNumber*) updateMatchPlayers :(NSNumber *) player1Number :(NSNumber *) player2Number;

-(NSNumber*) updateActiveMatchData :(player *) p1 :(player *) p2;

-(NSNumber*) getActiveMatchId;

-(bool) isMatchActive :(NSNumber *) matchid;

-(bool) deleteMatch :(NSNumber *) matchId;

-(player *)getPlayerByPlayerNumber :(NSNumber *) reqPlayerNumber;

-(NSMutableArray *)findHistoryActivePlayersHiBreakBalls :(NSNumber*) activePlayerNumber :(NSNumber*)staticPlayer1Number :(NSNumber*)staticPlayer2Number :(NSNumber*)currentPlayerBreakAmount :(NSMutableArray*)currentPlayerBreakBalls;

-(bool) importDataIntoDB :(NSArray *) datarows;
-(bool) deletePlayer :(NSNumber *) playernumber;
-(bool) deleteWholeMatchData :(NSNumber *) matchId;
-(NSArray*) getPlayerMatchStatistics :(NSNumber *)playerNumber;
-(void) alterTableNewColumn;

-(breakEntry *)lastEntryRetreive;
-(bool) deletePausedEntry;

-(bool) deleteWholeFrameData :(NSNumber *) frameId :(NSNumber*) matchId;

-(hibreak *)findPastHB :(NSNumber*) playerNumber;

@end
