//
//  dbHelper.m
//  SnookerScoreLite
//
//  Created by andrew glew on 08/09/2015.
//  Copyright © 2015 andrew glew. All rights reserved.
//

#import "dbHelper.h"


@implementation dbHelper



-(NSNumber *)entriesInsert :(NSNumber *) reqMatchId :(NSNumber *) reqPlayerId :(NSNumber *) reqFrameId :(NSNumber *) reqLastShotId :(NSNumber *) reqPoints :(NSNumber *) reqActive :(NSNumber *) reqDuration {
    
    NSNumber *returnValue = [NSNumber numberWithInt:-1];
    
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK) {
        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *rightNow = [dateFormatter stringFromDate:[NSDate date]];
        
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO frameentries (matchid,playerid,frameid,lastshotid,endbreaktimestamp, points, active, duration) VALUES (%@,%@,%@,%@,'%@',%@,%@,%@)", reqMatchId, reqPlayerId, reqFrameId, reqLastShotId, rightNow, reqPoints, reqActive, reqDuration];
        
        const char *insert_statement = [insertSQL UTF8String];
        sqlite3_prepare_v2(_DB, insert_statement, -1, &statement, NULL);
        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSLog(@"Failed to insert new record inside entries table");
        } else {
            /* get the last inserted row id */
            returnValue = @(sqlite3_last_insert_rowid(_DB));
        }
        sqlite3_finalize(statement);
        sqlite3_close(_DB);
    }
    
    return returnValue;
}


-(bool)shotsInsert :(NSNumber *) reqEntriesId :(NSMutableArray *) reqShots {
    
    bool returnValue = true;
    
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK) {
        
        sqlite3_stmt *statement = NULL;
        
        
        /* need to create new ballShot object */
        
        
        for (ballShot *shot in reqShots) {
            /* refactor needed here */
            NSNumber *shotId = shot.shotid;
            NSString *colour = shot.colour;
            NSString *imageNameLarge = shot.imageNameLarge;
            NSNumber *distance = shot.distanceid;
            NSNumber *effort = shot.effortid;
            NSNumber *foulid = shot.foulid;
            NSNumber *safetyid = shot.safetyid;
            NSNumber *value = shot.value;
            NSString *shotTimeStamp = shot.shottimestamp;
            NSNumber *killed = shot.killed;
            NSNumber *pocketid = shot.pocketid;

            NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO breakshots (reftoentryid, shotid, colour, imagenamelarge, distance, effort, foulid, safetyid, value, shottimestamp, killed, pocketid) VALUES (%@, %@, '%@','%@', %@, %@, %@, %@, %@,'%@', %@, %@)", reqEntriesId, shotId, colour, imageNameLarge, distance, effort, foulid, safetyid, value, shotTimeStamp, killed, pocketid];
            
            const char *insert_statement = [insertSQL UTF8String];
            
            sqlite3_prepare_v2(_DB, insert_statement, -1, &statement, NULL);
            if (sqlite3_step(statement) != SQLITE_DONE) {
                NSLog(@"Failed to insert new record inside shots table");
                returnValue = false;
            } else {
                NSLog(@"Added new shot record successfully");
            }
            // NOTE - needs to be inside the loop!
            sqlite3_finalize(statement);
        }
        
        sqlite3_close(_DB);
    } else {
        NSLog(@"Unable to open table to insert into breakshots table");
        returnValue = false;

    }
    return returnValue;
}



/* created 20160711 */
/* last modified 20160711 */
-(bool) deletePausedEntry {
    bool returnValue = true;
    sqlite3_stmt *statement;
    
    NSString *deleteSQL = @"DELETE FROM frameentries WHERE entryid = (SELECT MAX(entryid) FROM frameentries)";
    
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK) {
        
        const char *deleteStatement = [deleteSQL UTF8String];
        sqlite3_prepare_v2(_DB, deleteStatement, -1, &statement, NULL);
        
        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSLog(@"Failed to delete paused record from frameentries");
            returnValue = false;
        } else {
            NSLog(@"Successfuly deleted paused record from frameentries");
        }
        sqlite3_finalize(statement);
        sqlite3_close(_DB);
    }
    return returnValue;
    
}




/* created 20160711 */
/* last modified 20160711 */
-(breakEntry *)lastEntryRetreive {
    
    /* this will obtain the last record no matter what active flag it has */
    
    breakEntry *entry = [[breakEntry alloc] init];
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK) {
        
        NSString *selectSQL = @"SELECT entryid,matchid,playerid,frameid,lastshotid,endbreaktimestamp,points,active,duration FROM frameentries ORDER BY entryid DESC LIMIT 1";
        
        
        const char *select_statement = [selectSQL UTF8String];
        
        
        if (sqlite3_prepare_v2(_DB, select_statement, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                
                
                NSNumber *entryid = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
                
                entry.entryid = entryid;
                entry.matchid = [NSNumber numberWithInt:sqlite3_column_int(statement, 1)];
                entry.playerid = [NSNumber numberWithInt:sqlite3_column_int(statement, 2)];
                entry.frameid = [NSNumber numberWithInt:sqlite3_column_int(statement, 3)];
                entry.lastshotid = [NSNumber numberWithInt:sqlite3_column_int(statement, 4)];
                entry.endbreaktimestamp = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)] ;
                entry.points = [NSNumber numberWithInt:sqlite3_column_int(statement, 6)];
                entry.active =  [NSNumber numberWithInt:sqlite3_column_int(statement, 7)];
                entry.shots = [NSMutableArray arrayWithArray:[self breakShotsRetreiveRows:entryid]];
                entry.duration = [NSNumber numberWithInt:sqlite3_column_int(statement, 8)];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(_DB);
    } else {
        NSLog(@"Cannot open database");
    }
    
    return entry;
}






/* refactored 20150922 */
/* last modified 20160123 */
-(NSMutableArray *)entriesRetreive :(NSNumber *) reqMatchId :(NSNumber *) reqPlayerId :(NSNumber *) reqFrameId :(NSNumber *) reqLastShotId :(NSNumber *) reqPoints :(NSNumber *) reqActive :(NSNumber *) reqDuration  :(bool) excludeActives{
    
    
    /* idea is that match data contains all inactive frame data, and frame data contains only the active data */

    NSMutableArray *requestedDataSet = [[NSMutableArray alloc] init];
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK) {

        NSString *whereClause = @"WHERE";
    
        if (reqMatchId != NULL) {
            whereClause = [NSString stringWithFormat:@"%@ %@=%@ AND ", whereClause, @"matchid",reqMatchId];
        }
    
        if (reqPlayerId != NULL) {
            whereClause = [NSString stringWithFormat:@"%@ %@=%@ AND ", whereClause, @"playerid",reqPlayerId];
        }
        
        if (reqFrameId != NULL) {
            whereClause = [NSString stringWithFormat:@"%@ %@=%@ AND ", whereClause, @"frameid",reqFrameId];
        }
    
        if (reqLastShotId != NULL) {
            whereClause = [NSString stringWithFormat:@"%@ %@=%@ AND ", whereClause, @"lastshotid",reqLastShotId];
        }
        
        if (reqDuration != NULL) {
            whereClause = [NSString stringWithFormat:@"%@ %@=%@ AND ", whereClause, @"duration",reqDuration];
        }
        
        if (reqActive != NULL) {
            whereClause = [NSString stringWithFormat:@"%@ %@=%@ AND ", whereClause, @"active",reqActive];
        } else if (excludeActives) {
            whereClause = [NSString stringWithFormat:@"%@ %@<2 AND ", whereClause, @"active"];
        }
    
        if (![whereClause isEqualToString:@"WHERE"]) {
            whereClause = [whereClause substringToIndex:[whereClause length]-5];
        }
    
        NSString *selectSQL = [NSString stringWithFormat:@"SELECT entryid,matchid,playerid,frameid,lastshotid,endbreaktimestamp,points,active,duration FROM frameentries %@ ORDER BY entryid", whereClause];
    
    
        const char *select_statement = [selectSQL UTF8String];
    
    
        if (sqlite3_prepare_v2(_DB, select_statement, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {

                breakEntry *entry = [[breakEntry alloc] init];
                
                NSNumber *entryid = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
            
                entry.entryid = entryid;
                entry.matchid = [NSNumber numberWithInt:sqlite3_column_int(statement, 1)];
                entry.playerid = [NSNumber numberWithInt:sqlite3_column_int(statement, 2)];
                entry.frameid = [NSNumber numberWithInt:sqlite3_column_int(statement, 3)];
                entry.lastshotid = [NSNumber numberWithInt:sqlite3_column_int(statement, 4)];
                entry.endbreaktimestamp = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)] ;
                entry.points = [NSNumber numberWithInt:sqlite3_column_int(statement, 6)];
                entry.active =  [NSNumber numberWithInt:sqlite3_column_int(statement, 7)];
                entry.shots = [NSMutableArray arrayWithArray:[self breakShotsRetreiveRows:entryid]];
                entry.duration = [NSNumber numberWithInt:sqlite3_column_int(statement, 8)];

                [requestedDataSet addObject:entry];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(_DB);
    } else {
        NSLog(@"Cannot open database");
    }
    
    return requestedDataSet;
}

-(void) deleteDB :(NSString*) databaseName {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath =  [documentsDirectory stringByAppendingPathComponent:databaseName];
    
    if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    }
}

-(bool) shotsDeleteAll {
    
    bool returnValue = true;
    sqlite3_stmt *statement;
    
    NSString *deleteSQL = @"DELETE FROM breakshots";
    
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK) {
        
        const char *deleteStatement = [deleteSQL UTF8String];
        sqlite3_prepare_v2(_DB, deleteStatement, -1, &statement, NULL);
        
        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSLog(@"Failed to delete all content from table breakshots");
            returnValue = false;
        } else {
            NSLog(@"Successfuly deleted all content from table breakshots");
        }
        sqlite3_finalize(statement);
        sqlite3_close(_DB);
    }
    return returnValue;
}



-(bool) entriesDeleteAll {
    
    bool returnValue = true;
    sqlite3_stmt *statement;
    
    NSString *deleteSQL = @"DELETE FROM frameentries";
    
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK) {
    
        const char *deleteStatement = [deleteSQL UTF8String];
        sqlite3_prepare_v2(_DB, deleteStatement, -1, &statement, NULL);
        
        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSLog(@"Failed to delete all content from table breakshots");
            returnValue = false;
        } else {
            NSLog(@"Successfuly deleted all content from table breakshots");
        }
        sqlite3_finalize(statement);
        sqlite3_close(_DB);
    }
    return returnValue;
}


-(bool) deleteMatch :(NSNumber *) matchId {
    
    bool returnValue = true;
    sqlite3_stmt *statement;
    
    NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM matches WHERE matchid=%@",matchId];
    
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK) {
        
        const char *deleteStatement = [deleteSQL UTF8String];
        sqlite3_prepare_v2(_DB, deleteStatement, -1, &statement, NULL);
        
        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSLog(@"Failed to delete match from table matches");
            returnValue = false;
        } else {
            NSLog(@"Successfuly deleted match content from table matches");
        }
        sqlite3_finalize(statement);
        sqlite3_close(_DB);
    }
    return returnValue;
}


-(bool) shotDelete :(NSNumber *)entryId {
    bool returnValue = true;
    sqlite3_stmt *statement;
    
    NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM breakshots WHERE reftoentryid = %@", entryId];

    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK) {
        
        const char *deleteStatement = [deleteSQL UTF8String];
        sqlite3_prepare_v2(_DB, deleteStatement, -1, &statement, NULL);
        
        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSLog(@"Failed to delete entry content from table breakshots");
            returnValue = false;
        } else {
            NSLog(@"Successfuly deleted entry content from table breakshots");
        }
        sqlite3_finalize(statement);
        sqlite3_close(_DB);
    }
    return returnValue;
}





-(bool) entryDelete :(NSNumber *)entryId {
    
    bool returnValue = true;
    sqlite3_stmt *statement;
    
    NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM frameentries WHERE entryid = %@", entryId];
    
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK) {
        
        const char *deleteStatement = [deleteSQL UTF8String];
        sqlite3_prepare_v2(_DB, deleteStatement, -1, &statement, NULL);
        
        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSLog(@"Failed to delete all content from table breakshots");
            returnValue = false;
        } else {
            NSLog(@"Successfuly deleted all content from table breakshots");
        }
        sqlite3_finalize(statement);
        sqlite3_close(_DB);
    }
    return returnValue;
}


/* created 20160130 */
-(NSArray*) getPlayerMatchStatistics :(NSNumber *)playerNumber {
    
    int matchesWon=0;
    int matchesLost=0;
    int matchesDrawn=0;
    
    int won;
    int lost;
    
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];

    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK) {
        NSString *selectSQL = [NSString stringWithFormat:@" SELECT IFNULL(won,0), IFNULL(lost,0), enddate FROM (SELECT player1_frameswon as won, player2_frameswon as lost, enddate FROM matches WHERE player1_number=%@ UNION SELECT player2_frameswon as won, player1_frameswon as lost, enddate  FROM matches WHERE player2_number=%@)", playerNumber, playerNumber];
       
        const char *select_statement = [selectSQL UTF8String];
        
        if (sqlite3_prepare_v2(_DB, select_statement, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                won = sqlite3_column_int(statement, 0);
                lost = sqlite3_column_int(statement, 1);
                NSString *enddate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                
                
                
                if (![enddate isEqualToString:@""]) {
                    if (won==lost) {
                        matchesDrawn++;
                    } else if (won>lost) {
                        matchesWon++;
                    } else {
                        matchesLost++;
                    }
                }
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(_DB);
    } else {
        NSLog(@"Cannot open database");
    }

    
    int totalMatches = matchesDrawn+matchesLost+matchesWon;
    
    float mdrawn=0.0;
    float mlost=0.0;
    float mwon=0.0;
    
    if (totalMatches>0) {
        
        if (matchesDrawn>0)  {
            mdrawn = (float)matchesDrawn/totalMatches;
        }
        if (matchesLost>0)  {
            mlost = (float)matchesLost/totalMatches;
        }
        if (matchesWon>0)  {
            mwon = (float)matchesWon/totalMatches;
        }
    }
 
    
    return [NSArray arrayWithObjects:
     [NSString stringWithFormat:@"%.02f",mwon],
     [NSString stringWithFormat:@"%.02f",mlost],
     [NSString stringWithFormat:@"%.02f",mdrawn],
     nil];

}


-(NSMutableArray *)breakShotsRetreiveRows :(NSNumber *) reqEntryId {
    NSMutableArray *requestedDataSet = [[NSMutableArray alloc] init];
    
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK) {
        NSString *selectSQL = [NSString stringWithFormat:@"SELECT breakid, reftoentryid, shotid, colour, imagenamelarge, distance, effort, foulid, safetyid, value, shottimestamp, killed, pocketid FROM breakshots WHERE reftoentryid=%@", reqEntryId];

        const char *select_statement = [selectSQL UTF8String];
    
        if (sqlite3_prepare_v2(_DB, select_statement, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {

                ballShot *shot = [[ballShot alloc] init];
            
                shot.breakid = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
                shot.reftoentryid = [NSNumber numberWithInt:sqlite3_column_int(statement, 1)];
                shot.shotid = [NSNumber numberWithInt:sqlite3_column_int(statement, 2)];
                shot.colour = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                shot.imageNameLarge = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                shot.distanceid = [NSNumber numberWithInt:sqlite3_column_int(statement, 5)];
                shot.effortid = [NSNumber numberWithInt:sqlite3_column_int(statement, 6)];
                shot.foulid = [NSNumber numberWithInt:sqlite3_column_int(statement, 7)];
                shot.safetyid = [NSNumber numberWithInt:sqlite3_column_int(statement, 8)];
                shot.value = [NSNumber numberWithInt:sqlite3_column_int(statement, 9)];
                shot.shottimestamp = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                shot.killed = [NSNumber numberWithInt:sqlite3_column_int(statement, 11)];
                shot.pocketid = [NSNumber numberWithInt:sqlite3_column_int(statement, 12)];
                [requestedDataSet addObject:shot];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(_DB);
    } else {
        NSLog(@"Cannot open database");
    }
    
    return requestedDataSet;
}

/* created 20160506 */
/* modified 20160506 */

-(void) alterTableNewColumn
{
    BOOL columnExists = NO;
    
    sqlite3_stmt *selectStmt;
    
    const char *sqlStatement = "select duration from frameentries LIMIT 1";
    if(sqlite3_prepare_v2(_DB, sqlStatement, -1, &selectStmt, NULL) == SQLITE_OK)
        columnExists = YES;
    
    if (columnExists) {
        return;
    } else {
        
        sqlite3_stmt *statement;
        const char *dbpath = [_databasePath UTF8String];
        if (sqlite3_open(dbpath, &_DB) == SQLITE_OK) {
            NSString *alterSQL = [NSString stringWithFormat: @"ALTER TABLE frameentries ADD COLUMN duration INTEGER"];
            const char *alter_stmt = [alterSQL UTF8String];
            sqlite3_prepare_v2(_DB, alter_stmt, -1, &statement, NULL);
                        // Release the compiled statement from memory
            if (sqlite3_step(statement) != SQLITE_DONE) {
                NSLog(@"Failed to alter table inside frameentries table");
            }
            sqlite3_finalize(statement);
            sqlite3_close(_DB);
        }
    }
}



-(bool)addPlayer :(NSNumber*)playerIndex :(NSString*)playerName :(NSString*)playerEmail {
    
    NSString *playerkey = [[NSUUID UUID] UUIDString];
    UIImage *avatarImage = [UIImage imageNamed:[NSString stringWithFormat:@"avatar%@",playerIndex]];
    
    /* now using player key set instance variable to expected image file name if user requests update later */
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSData *avatarImgData =  UIImagePNGRepresentation(avatarImage);
    [avatarImgData writeToFile:[[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:  @"avatar%@.png",playerIndex]] atomically:YES];
    
    if (playerIndex==[NSNumber numberWithInt:0]) {
        return true;
    }
    
    NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO players (playernumber,nickname,email,photolocation,highestbreak,highestbreakdate,trailblaze,playerkey) VALUES (%@,'%@','%@','avatar%@.png', %d,'%@',%d,'%@')", playerIndex, playerName, playerEmail, playerIndex, 0, @"",0,playerkey];
    
    sqlite3_stmt *statement;
    const char *insert_statement = [insertSQL UTF8String];
    sqlite3_prepare_v2(_DB, insert_statement, -1, &statement, NULL);
    if (sqlite3_step(statement) != SQLITE_DONE) {
        NSLog(@"Failed to insert new player record inside entries table");
        return false;
    } else {
        NSLog(@"inserted new player two record inside players table!");
    }
    sqlite3_finalize(statement);
    return true;
}





/* modified 20160114 */
-(bool)dbCreate :(NSString*) databaseName {
    NSString *docsDir;
    NSArray *dirPaths;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    
    /* clean up old db */
   // [self deleteDB:@"snookmaster.db"];

    
    _databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:databaseName]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if([filemgr fileExistsAtPath:_databasePath] ==  NO) {
        const char *dbpath = [_databasePath UTF8String];
        
        if(sqlite3_open(dbpath, &_DB) == SQLITE_OK) {
            char *errorMessage;
 
            /* number 1:  players */
            
            const char *sql_statement = "CREATE TABLE players(playernumber INTEGER, nickname TEXT, email TEXT, photolocation TEXT, highestbreak INTEGER, highestbreakdate TEXT, trailblaze INTEGER, playerkey TEXT)";
            
            if(sqlite3_exec(_DB, sql_statement, NULL, NULL, &errorMessage) != SQLITE_OK) {
                NSLog(@"failed to create players frameentries");
                sqlite3_close(_DB);
                return false;
            }
            
            /* we write the default image to file */
            [self addPlayer:[NSNumber numberWithInt:0] :@"Dummy" :@"dummy@emailaddress.com"];
            /* create 'young man' avatar & image  */
            [self addPlayer:[NSNumber numberWithInt:1] :@"N.E. Body" :@"player1@emailaddress.com"];
            /* create the 'lady' avatar & image */
             [self addPlayer:[NSNumber numberWithInt:2] :@"A.N. Other" :@"player2@emailaddress.com"];
            /* create the 'seasoned professional man' avatar & image */
            [self addPlayer:[NSNumber numberWithInt:3] :@"A. Beard" :@"player3@emailaddress.com"];
            
            /* number 2: matches */
             sql_statement = "CREATE TABLE matches(matchid INTEGER PRIMARY KEY, player1_number INTEGER, player2_number INTEGER, startdate TEXT, enddate TEXT, player1_frameswon INTEGER, player2_frameswon INTEGER, player1_hibreak INTEGER, player2_hibreak INTEGER, matchkey TEXT, FOREIGN KEY(player1_number) REFERENCES players(playernumber), FOREIGN KEY(player2_number) REFERENCES players(playernumber))";
            
            
            
            if(sqlite3_exec(_DB, sql_statement, NULL, NULL, &errorMessage) != SQLITE_OK) {
                NSLog(@"failed to create players frameentries");
                sqlite3_close(_DB);
                return false;
            }
            
            NSString *matchkey = [[NSUUID UUID] UUIDString];
            
     
            NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *matchstart = [dateFormatter stringFromDate:[NSDate date]];
            
            NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO matches (matchid,player1_number,player2_number,startdate,enddate,player1_frameswon,player2_frameswon,player1_hibreak,player2_hibreak,matchkey) VALUES (%d,%d,%d,'%@','%@',%d,%d,%d,%d,'%@')", 0, 1, 2, matchstart, @"",0,0,0,0,matchkey];
            
            sqlite3_stmt *statement;
            const char *insert_statement = [insertSQL UTF8String];
            sqlite3_prepare_v2(_DB, insert_statement, -1, &statement, NULL);
            if (sqlite3_step(statement) != SQLITE_DONE) {
                NSLog(@"Failed to insert new player record inside entries table");
            } else {
                NSLog(@"inserted new player two record inside players table!");
            }
            sqlite3_finalize(statement);
    
            /* number 3:  frameentries */
            
            sql_statement = "CREATE TABLE frameentries(entryid INTEGER PRIMARY KEY, matchid INTEGER, playerid INTEGER, frameid INTEGER, lastshotid INTEGER, endbreaktimestamp  TEXT, points INTEGER, active INTEGER, FOREIGN KEY(matchid) REFERENCES matches(matchid))";
            
            
            if(sqlite3_exec(_DB, sql_statement, NULL, NULL, &errorMessage) != SQLITE_OK) {
                NSLog(@"failed to create table frameentries");
                sqlite3_close(_DB);
                return false;
            }
            
            /* number 4:  breakshots */
            
            sql_statement = "CREATE TABLE breakshots(breakid INTEGER PRIMARY KEY, reftoentryid INTEGER, shotid INTEGER, colour TEXT, imagenamelarge   TEXT, distance  INTEGER, effort INTEGER, foulid INTEGER, safetyid INTEGER, value INTEGER, shottimestamp TEXT, killed INTEGER, pocketid INTEGER, deleted INTEGER, FOREIGN KEY(reftoentryid) REFERENCES frameEntries(entryid))";
            
            if(sqlite3_exec(_DB, sql_statement, NULL, NULL, &errorMessage) != SQLITE_OK) {
                NSLog(@"failed to create table breakshots");
                return false;
            }
            //sqlite3_finalize(statement);
            sqlite3_close(_DB);
        } else {
            NSLog(@"failed to create table");
            return false;
        }
    }
    return true;
}






/* new 20160108 */

-(void) updatePlayer :(player *) reqPlayer {
    
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK) {
        
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE players SET nickname = '%@', email = '%@', photolocation = '%@', highestbreak = %@ WHERE playernumber= %@", reqPlayer.nickName, reqPlayer.emailAddress, reqPlayer.photoLocation, reqPlayer.hiBreak, reqPlayer.playerNumber];
        
        const char *update_statement = [updateSQL UTF8String];
        sqlite3_prepare_v2(_DB, update_statement, -1, &statement, NULL);
        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSLog(@"Failed to update record(s) inside player table");
        }
        sqlite3_finalize(statement);
        sqlite3_close(_DB);
    }
}



/* new 20160109 */

/* would like to use player key as well as number */

-(NSNumber*) getNewPlayerNumber {
    
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    NSNumber *newPlayerNumber;
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK) {
        
        NSString *selectSQL = @"SELECT MAX(playernumber) + 1 FROM players";
        
        
        const char *select_statement = [selectSQL UTF8String];
        
        
        if (sqlite3_prepare_v2(_DB, select_statement, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                newPlayerNumber = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
            }
        }

        sqlite3_finalize(statement);
        sqlite3_close(_DB);
    }
    return newPlayerNumber;
}



/* new 20160110 */
-(NSNumber*) updateActiveMatchData :(player *) p1 :(player *) p2 {
    
    NSNumber *matchId = [self getActiveMatchId];
    
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK) {

        
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *matchend = [dateFormatter stringFromDate:[NSDate date]];
        
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE matches SET enddate = '%@', player1_frameswon = IFNULL(%@,0), player2_frameswon =IFNULL(%@,0), player1_hibreak =IFNULL(%@,0), player2_hibreak =IFNULL(%@,0) WHERE matchid= %@", matchend, p1.wonframes, p2.wonframes, p1.hbMatch.breakTotal, p2.hbMatch.breakTotal, matchId];
        
        const char *update_statement = [updateSQL UTF8String];
        sqlite3_prepare_v2(_DB, update_statement, -1, &statement, NULL);
        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSLog(@"Failed to update record(s) inside macthes table");
        }
        sqlite3_finalize(statement);
        sqlite3_close(_DB);
        
    }
    return matchId;
}




/* new 20160110 */
-(NSNumber*) updateMatchPlayers :(NSNumber *) player1Number :(NSNumber *) player2Number {
    
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    NSNumber *matchId;
    
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK) {
        
        NSString *selectSQL = @"SELECT IFNULL(MAX(matchid), 0) FROM matches";
        
        
        const char *select_statement = [selectSQL UTF8String];
        
        
        if (sqlite3_prepare_v2(_DB, select_statement, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                matchId = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
            }
            
        }
        
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE matches SET player1_number = %@, player2_number = %@ WHERE matchid= %@", player1Number, player2Number, matchId];
            
        const char *update_statement = [updateSQL UTF8String];
        sqlite3_prepare_v2(_DB, update_statement, -1, &statement, NULL);
        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSLog(@"Failed to update record(s) inside macthes table");
        }
        sqlite3_finalize(statement);
        sqlite3_close(_DB);
        
    }
    return matchId;
}


/* new 20160111 */
-(NSNumber*) getActiveMatchId {
    
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    NSNumber *activeMatchId;
    
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK) {
        
        NSString *selectSQL = @"SELECT IFNULL(MAX(matchid), 0) FROM matches";
        const char *select_statement = [selectSQL UTF8String];
        
        if (sqlite3_prepare_v2(_DB, select_statement, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                activeMatchId = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
            }
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(_DB);
    }
    return activeMatchId;
}


/* HERE */
-(bool) isMatchActive :(NSNumber *) matchid {
    
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    NSString *endDate;
    
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK) {
        
        NSString *selectSQL = [NSString stringWithFormat:@"SELECT enddate FROM matches where matchid=%@", matchid];
        const char *select_statement = [selectSQL UTF8String];
        
        if (sqlite3_prepare_v2(_DB, select_statement, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                endDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
            }
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(_DB);
    }
    
    if ([endDate isEqualToString:@""] || endDate == nil) {
        return true;
    } else {
        return false;
    }
}



/* new 20160110 */
-(NSNumber*) insertMatch :(NSNumber *) player1Number :(NSNumber *) player2Number {
    
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    NSNumber *newMatchId;
    
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK) {
        
        NSString *selectSQL = @"SELECT IFNULL(MAX(matchid), 0) FROM matches";
        
        
        const char *select_statement = [selectSQL UTF8String];
        
        
        if (sqlite3_prepare_v2(_DB, select_statement, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                newMatchId = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)+1];
            }
            
        }
        
        NSString *randomKey = [[NSUUID UUID] UUIDString];
  
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *matchstart = [dateFormatter stringFromDate:[NSDate date]];
        
        NSString *insertSQL;
        
        insertSQL = [NSString stringWithFormat:@"INSERT INTO matches (matchid,player1_number,player2_number,startdate,enddate,player1_frameswon,player2_frameswon,player1_hibreak,player2_hibreak,matchkey) VALUES (%@,%@,%@,'%@','%@',%d,%d,%d,%d,'%@')", newMatchId, player1Number, player2Number, matchstart, @"",0,0,0,0,randomKey];
        
        const char *insert_statement = [insertSQL UTF8String];
        sqlite3_prepare_v2(_DB, insert_statement, -1, &statement, NULL);
        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSLog(@"Failed to insert new match record inside match table");
        } else {
            NSLog(@"inserted new match record inside match table!");
        }
        sqlite3_finalize(statement);
        sqlite3_close(_DB);
    }
    return newMatchId;
}





/* new 20160109 */
-(NSNumber*) insertPlayer :(player *) reqPlayer {
    
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    NSNumber *newPlayerNumber;
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK) {

        NSString *selectSQL = @"SELECT MAX(playernumber) FROM players";
        const char *select_statement = [selectSQL UTF8String];
        
        
        if (sqlite3_prepare_v2(_DB, select_statement, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
            newPlayerNumber = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)+1];
            }
        }

        if ([reqPlayer.playerkey isEqualToString:@""]) {
                reqPlayer.playerkey = [[NSUUID UUID] UUIDString];
        }
    
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO players (playernumber,nickname,email,photolocation,highestbreak,highestbreakdate,trailblaze,playerkey) VALUES (%@,'%@','%@','%@',%d,'%@',%d,'%@')", newPlayerNumber,reqPlayer.nickName, reqPlayer.emailAddress, reqPlayer.photoLocation, 0, @"",0,reqPlayer.playerkey];
        
        const char *insert_statement = [insertSQL UTF8String];
        sqlite3_prepare_v2(_DB, insert_statement, -1, &statement, NULL);
        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSLog(@"Failed to insert new player record inside entries table");
        } else {
            NSLog(@"inserted new player two record inside players table!");
        }
        sqlite3_finalize(statement);
        sqlite3_close(_DB);
    }
    return newPlayerNumber;
}



/* created 20160112 */

-(player *)getPlayerByPlayerNumber :(NSNumber *) reqPlayerNumber {

    
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    
    player *p  = [[player alloc] init];
    
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK) {
        
        NSString *selectSQL;
        const char *select_statement;
        
        selectSQL = [NSString stringWithFormat:@"SELECT playernumber,nickname,email,photolocation,highestbreak,highestbreakdate,trailblaze,playerkey FROM players WHERE playernumber = %@", reqPlayerNumber];
        
        select_statement = [selectSQL UTF8String];
        
        
        if (sqlite3_prepare_v2(_DB, select_statement, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                p.playerNumber = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
                p.nickName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)] ;
                p.emailAddress = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)] ;
                p.photoLocation = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)] ;
                p.hiBreak = [NSNumber numberWithInt:sqlite3_column_int(statement, 4)];
                p.hiBreakDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)] ;
                p.trailBlazer = [NSNumber numberWithInt:sqlite3_column_int(statement, 6)];
                p.playerkey = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)] ;
            }

        }
        sqlite3_finalize(statement);
        sqlite3_close(_DB);
    } else {
        NSLog(@"Cannot open database");
        p.playerNumber = [NSNumber numberWithInt:-1];
    }
    
    return p;
}







/* new 20160108 */
/* modified 20160110 */

-(player *)playerRetreive :(player *) reqPlayer {
    
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK) {
        
        NSString *selectSQL;
        const char *select_statement;
        
        /* Step 1 of 3 - get current player number if possible */
        
        selectSQL = @"SELECT IFNULL(player1_number, 1),IFNULL(player2_number, 2) FROM matches ORDER BY matchid DESC LIMIT 1";
        select_statement = [selectSQL UTF8String];
        
        
        if (sqlite3_prepare_v2(_DB, select_statement, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                if (reqPlayer.swappedPlayer==true) {
                } else {
                    if (reqPlayer.playerIndex==1) {
                        reqPlayer.playerNumber = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
                    } else {
                        reqPlayer.playerNumber = [NSNumber numberWithInt:sqlite3_column_int(statement, 1)];
                    }
                }
            }
        }
  
        /* Step 2 of 3 - */
        selectSQL = [NSString stringWithFormat:@"SELECT playernumber,nickname,email,photolocation,highestbreak,highestbreakdate,trailblaze,playerkey FROM players WHERE playernumber = %@", reqPlayer.playerNumber];
        select_statement = [selectSQL UTF8String];
        
        
        if (sqlite3_prepare_v2(_DB, select_statement, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                reqPlayer.nickName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)] ;
                reqPlayer.emailAddress = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)] ;
                reqPlayer.photoLocation = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)] ;
                reqPlayer.hiBreak = [NSNumber numberWithInt:sqlite3_column_int(statement, 4)];
                reqPlayer.hiBreakDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)] ;
                reqPlayer.trailBlazer = [NSNumber numberWithInt:sqlite3_column_int(statement, 6)];
                reqPlayer.playerkey = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)] ;
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(_DB);
        
        //reqPlayer.hiBreakHistory = [self playerHiBreakInPreviousMatches:reqPlayer.playerNumber];
        
    } else {
        NSLog(@"Cannot open database");
    }
    
    return reqPlayer;
}






/* last modified 20160202 */
- (NSMutableArray *) findAllPlayers :(NSNumber *) option :(NSNumber *) activePlayer {
    
    NSMutableArray *players = [NSMutableArray array];
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK) {
        NSString *selectSQL;
        
        if ( option == [NSNumber numberWithInt:1 ] ) {
        // player listing
            selectSQL = @"SELECT playerkey, playernumber,nickname,email,photolocation,highestbreakdate,trailblaze, IFNULL((select max(hi) as hibreak from (select player1_hibreak as hi from matches where player1_number=playernumber union select player2_hibreak as hi from matches where player2_number=playernumber)), 0) as highestbreak, (select sum(matcheswon) from (select case when player1_frameswon > player2_frameswon then 1 else 0 end as matcheswon from matches where player1_number=playernumber union all select case when player2_frameswon > player1_frameswon then 1 else 0 end as matcheswon from matches where player2_number=playernumber)) as matcheswon, (select case when IFNULL(sum(won),0)=0 and IFNULL(sum(lost),0)=0 then -1 else case when sum(won)=0 then 0 else case when sum(lost)=0 then 100.0 else sum(won)*1.0 / (sum(won) + sum(lost)) * 100 end end end as frameswonpc from (select player1_frameswon as won, player2_frameswon as lost from matches where player1_number=playernumber union select player2_frameswon as won, player1_frameswon as lost from matches where player2_number=playernumber)) as frameswonpc, (select count(1) as matchesplayed from matches where (player1_number=playernumber and matchid<>0) or (player2_number=playernumber and matchid<>0)) FROM players order by (select case when IFNULL(sum(won),0)=0 and IFNULL(sum(lost),0)=0 then -1 else case when sum(won)=0 then sum(lost) else case when sum(lost)=0 then sum(won) else sum(won) + sum(lost) end end end as framesplayed from (select player1_frameswon as won, player2_frameswon as lost from matches where player1_number=playernumber union select player2_frameswon as won, player1_frameswon as lost from matches where player2_number=playernumber)) desc";
        
        } else if (option == [NSNumber numberWithInt:2] ) {
            // head to head listing
            selectSQL = [NSString stringWithFormat:@"select players.playerkey, players.playernumber, players.nickname, players.email, players.photolocation, players.highestbreakdate, players.trailblaze, IFNULL((select max(hi) as hibreak from (select player1_hibreak as hi from matches where player1_number=playernumber and player2_number=%@ union select player2_hibreak as hi from matches where player2_number=playernumber and player1_number=%@)), 0) as highestbreak,(select sum(matcheswon) from (select case when player1_frameswon > player2_frameswon then 1 else 0 end as matcheswon from matches where player1_number=playernumber and player2_number=%@ union all select case when player2_frameswon > player1_frameswon then 1 else 0 end as matcheswon from matches where player2_number=playernumber and player1_number=%@)) as matcheswon,(select sum(matcheslost) from (select case when player1_frameswon < player2_frameswon then 1 else 0 end as matcheslost from matches where player1_number=playernumber and player2_number=%@ union all select case when player2_frameswon < player1_frameswon then 1 else 0 end as matcheslost from matches where player2_number=playernumber and player1_number=%@)) as matcheslost,IFNULL((select max(hi) as hibreak from (select player1_hibreak as hi from matches where player1_number=%@ and player2_number=playernumber union select player2_hibreak as hi from matches where player2_number=%@ and player1_number=playernumber)), 0) as selectedhighestbreak,(select case when IFNULL(sum(won),0)=0 and IFNULL(sum(lost),0)=0 then -1 else case when sum(won)=0 then 0 else case when sum(lost)=0 then 100.0 else sum(won)*1.0 / (sum(won) + sum(lost)) * 100 end end end as frameswonpc from (select player1_frameswon as won, player2_frameswon as lost from matches where player1_number=playernumber and player2_number=%@ union select player2_frameswon as won, player1_frameswon as lost from matches where player2_number=playernumber and player1_number=%@)) as frameswonpc,(select count(1) as matchesplayed from matches where (player2_number=%@ and player1_number=playernumber and matchid<>0) or (player2_number=playernumber and player1_number = %@ and matchid<>0)) from players where players.playernumber in (select player2_number as opponents from matches where player1_number = %@ union select player1_number as opponents from matches where player2_number = %@) order by (select case when IFNULL(sum(won),0)=0 and IFNULL(sum(lost),0)=0 then -1 else case when sum(won)=0 then sum(lost) else case when sum(lost)=0 then sum(won) else sum(won) + sum(lost) end end end as framesplayed from (select player1_frameswon as won, player2_frameswon as lost from matches where player1_number=playernumber union select player2_frameswon as won, player1_frameswon as lost from matches where player2_number=playernumber)) desc",activePlayer,activePlayer,activePlayer,activePlayer,activePlayer,activePlayer,activePlayer,activePlayer,activePlayer,activePlayer,activePlayer,activePlayer,activePlayer,activePlayer];
        }
                
        const char *select_statement = [selectSQL UTF8String];
        if (sqlite3_prepare_v2(_DB, select_statement, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                player *p = [[player alloc]init];
                p.playerkey = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                p.playerNumber = [NSNumber numberWithInt:sqlite3_column_int(statement, 1)];
                p.nickName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)] ;
                p.emailAddress = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)] ;
                p.photoLocation = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)] ;
                p.hiBreakDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)] ;
                p.trailBlazer = [NSNumber numberWithInt:sqlite3_column_int(statement, 6)];
                p.hiBreak = [NSNumber numberWithInt:sqlite3_column_int(statement, 7)];
                p.playerMatchWins = [NSNumber numberWithInt:sqlite3_column_int(statement, 8)];
                if (option == [NSNumber numberWithInt:2]) {
                    p.playerMatchLosses = [NSNumber numberWithInt:sqlite3_column_int(statement, 9)];
                    p.selectedHiBreak = [NSNumber numberWithInt:sqlite3_column_int(statement, 10)];
                    p.playerWinsPC = [NSNumber numberWithInt:sqlite3_column_int(statement, 11)];
                    p.playerMatchCount = [NSNumber numberWithInt:sqlite3_column_int(statement, 12)];
                } else {
                    p.playerWinsPC = [NSNumber numberWithInt:sqlite3_column_int(statement, 9)];
                    p.playerMatchCount = [NSNumber numberWithInt:sqlite3_column_int(statement, 10)];
                }
                
                [players addObject:p];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(_DB);
    } else {
        NSLog(@"Cannot open database");
    }

    return players;
}





/* next we need to find all matches */

- (NSMutableArray *)findAllMatches {
    
    NSMutableArray *matches = [NSMutableArray array];
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK) {
        NSString *selectSQL;

        
        selectSQL = @"SELECT matches.matchkey, matches.matchid, matches.startdate, matches.enddate, (select nickname from players where playernumber=player1_number), (select nickname from players where playernumber=player2_number), (select photolocation from players where playernumber=player1_number), (select photolocation from players where playernumber=player2_number), matches.player1_hibreak, matches.player2_hibreak, IFNULL(matches.player1_frameswon,0), IFNULL(matches.player2_frameswon,0),matches.player1_number, matches.player2_number from matches where matchid<>0 order by matches.startdate desc";
        
        
        const char *select_statement = [selectSQL UTF8String];
        if (sqlite3_prepare_v2(_DB, select_statement, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                match *m = [[match alloc]init];
        
                m.matchkey = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                m.matchid = [NSNumber numberWithInt:sqlite3_column_int(statement, 1)];
                m.matchDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                m.matchEndDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                m.player1Name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                m.player2Name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                m.player1PhotoLocation = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                m.player2PhotoLocation = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                m.Player1HiBreak = [NSNumber numberWithInt:sqlite3_column_int(statement, 8)];
                m.Player2HiBreak = [NSNumber numberWithInt:sqlite3_column_int(statement, 9)];
                m.Player1FrameWins = [NSNumber numberWithInt:sqlite3_column_int(statement, 10)];
                m.Player2FrameWins = [NSNumber numberWithInt:sqlite3_column_int(statement, 11)];
                m.Player1Number = [NSNumber numberWithInt:sqlite3_column_int(statement, 12)];
                m.Player2Number = [NSNumber numberWithInt:sqlite3_column_int(statement, 13)];
                m.matchDuration = [self getTimeElapsed :m.matchDate :m.matchEndDate];
                
                [matches addObject:m];
            }
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(_DB);
    } else {
        NSLog(@"Cannot open database");
    }
    
    return matches;
    
}


/* inserted 20160207 */
- (NSString *)stringFromTimeInterval:(NSTimeInterval)interval {
    NSInteger ti = (NSInteger)interval;
    NSInteger seconds = ti % 60;
    NSInteger minutes = (ti / 60) % 60;
    NSInteger hours = (ti / 3600);
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
}

/* created 20160207 */
-(NSString *)getTimeElapsed :(NSString *) from :(NSString *) to {
    
    if ([to isEqualToString:@""]) {
        return @"match ongoing";
    }
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *dateFirstEntry = [[NSDate alloc] init];
    NSDate *dateLastEntry = [[NSDate alloc] init];
    
    dateFirstEntry = [dateFormatter dateFromString:from];
    dateLastEntry = [dateFormatter dateFromString:to];
    NSTimeInterval interval = [dateLastEntry timeIntervalSinceDate:dateFirstEntry];
    return [self stringFromTimeInterval :interval];
}



/*
 modified  : 20160716
 refactored: 20160716
 */
-(NSNumber *) getCurrentFrameId :(NSNumber*) matchid {

    breakEntry *lastEntry = [self lastEntryRetreive];
    
    if (lastEntry.active==[NSNumber numberWithInt:activeFlag_Active] || lastEntry.active==[NSNumber numberWithInt:activeFlag_FrameStart]) {
        if (matchid == lastEntry.matchid) {
            return lastEntry.frameid;
        } else {
            /* unsure of this condition and if it gets called */
            return [NSNumber numberWithInt:1];
        }
    }
    /* falls through here only if the app is freshly loaded */
    return [NSNumber numberWithInt:0];

}



-(bool)setFrameActiveState :(NSNumber*) frameId :(NSNumber*) activefrom :(NSNumber*) activeto {
    
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK) {
        
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE frameentries SET active = %@ WHERE frameid= %@ AND active=%@", activeto, frameId, activefrom];
        
        const char *update_statement = [updateSQL UTF8String];
        sqlite3_prepare_v2(_DB, update_statement, -1, &statement, NULL);
        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSLog(@"Failed to update record(s) inside entries table");
        }
        sqlite3_finalize(statement);
        sqlite3_close(_DB);
    }
    return true;
}

-(NSNumber*)getIdOfLastEntry {
    NSNumber* entryId;
   
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK) {
        NSString *selectSQL = @"SELECT max(entryid) FROM frameentries";
        
        const char *select_statement = [selectSQL UTF8String];
        
        if (sqlite3_prepare_v2(_DB, select_statement, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                entryId = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(_DB);
    } else {
        NSLog(@"Cannot open database");
    }
    return entryId;
}



///this is it!!!

-(NSMutableArray *)findHistoryActivePlayersHiBreakBalls :(NSNumber*) activePlayerNumber :(NSNumber*)staticPlayer1Number :(NSNumber*)staticPlayer2Number :(NSNumber*)currentPlayerBreakAmount :(NSMutableArray*)currentPlayerBreakBalls {
    
    NSMutableArray *balls = [[NSMutableArray alloc] init];
    
    
    NSNumber* hiBreak;
    NSNumber* matchid;
    NSNumber* playerindex;

    
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK) {
        NSString *selectSQL;
    
        selectSQL = [NSString stringWithFormat:@"select max(hibreak.hi), hibreak.matchid, hibreak.playerindex from (select player1_hibreak as hi,matchid,1 as playerindex from matches where player1_number=%@ union select player2_hibreak as hi,matchid,2 as playerindex from matches where player2_number=%@) hibreak",activePlayerNumber,activePlayerNumber];

    
        const char *select_statement = [selectSQL UTF8String];
        
        if (sqlite3_prepare_v2(_DB, select_statement, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                hiBreak = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
                matchid = [NSNumber numberWithInt:sqlite3_column_int(statement, 1)];
                playerindex = [NSNumber numberWithInt:sqlite3_column_int(statement, 2)];
            }
        }
        sqlite3_finalize(statement);
        
        /* there might be 2 entries with the same break amount, what to do? */
        
        selectSQL = [NSString stringWithFormat:@"select reftoentryid, imagenamelarge, shotid, value, shottimestamp from breakshots where reftoentryid IN (select entryid from frameentries where points=%@ and matchid=%@ and playerid=%@)",hiBreak,matchid,playerindex];
        
        select_statement = [selectSQL UTF8String];
        
        if (sqlite3_prepare_v2(_DB, select_statement, -1, &statement, NULL) == SQLITE_OK)
        {
            NSNumber *entryId;
            NSNumber *firstEntryId;
            bool checkFlag=false;
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                entryId = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
                if (checkFlag==false) {
                    firstEntryId = entryId;
                    checkFlag=true;
                }
                if (entryId==firstEntryId) {
                
                    ballShot *b = [[ballShot alloc]init];
                    b.imageNameLarge = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)] ;
                    b.shotid = [NSNumber numberWithInt:sqlite3_column_int(statement, 2)];
                    b.value = [NSNumber numberWithInt:sqlite3_column_int(statement, 3)];
                    b.shottimestamp = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)] ;
                    if (b.shotid==[NSNumber numberWithInt:Potted]) {
                        [balls addObject:b];
                    }
                }
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(_DB);
        
        /* what about current match.. is activePlayerNumber one of the players in current match??  */
   
        if (activePlayerNumber==staticPlayer1Number || activePlayerNumber==staticPlayer2Number) {
            if (currentPlayerBreakAmount>hiBreak) {
                return currentPlayerBreakBalls;
            }
        }
        
    } else {
        NSLog(@"Cannot open database");
    }

    return balls;

}





-(hibreak *)findPastHB :(NSNumber*) playerNumber {
    
    NSNumber* playerindex;
    
    hibreak *hb = [hibreak alloc];
    
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK) {
        NSString *selectSQL;
        
        selectSQL = [NSString stringWithFormat:@"select max(hibreak.hi), hibreak.matchid, hibreak.playerindex from (select player1_hibreak as hi,matchid,1 as playerindex from matches where player1_number=%@ union select player2_hibreak as hi,matchid,2 as playerindex from matches where player2_number=%@) hibreak",playerNumber,playerNumber];
        
        
        const char *select_statement = [selectSQL UTF8String];
        
        if (sqlite3_prepare_v2(_DB, select_statement, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                hb.breakTotal = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
                hb.matchid = [NSNumber numberWithInt:sqlite3_column_int(statement, 1)];
                playerindex = [NSNumber numberWithInt:sqlite3_column_int(statement, 2)];
            }
        }
        sqlite3_finalize(statement);
        
                   /* there might be 2 entries with the same break amount, what to do? */
            selectSQL = [NSString stringWithFormat:@"select reftoentryid, imagenamelarge, shotid, value, shottimestamp from breakshots where reftoentryid IN (select entryid from frameentries where points=%@ and matchid=%@ and playerid=%@)",hb.breakTotal,hb.matchid,playerindex];
        
            select_statement = [selectSQL UTF8String];
        
            if (sqlite3_prepare_v2(_DB, select_statement, -1, &statement, NULL) == SQLITE_OK)
            {
                NSNumber *entryId;
                NSNumber *firstEntryId;
                bool checkFlag=false;
            
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                
                    entryId = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
                    if (checkFlag==false) {
                        firstEntryId = entryId;
                        checkFlag=true;
                        hb.breakBalls = [[NSMutableArray alloc] init];
                    }
                    if (entryId==firstEntryId) {
                    
                        ballShot *b = [[ballShot alloc]init];
                        b.imageNameLarge = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)] ;
                        b.shotid = [NSNumber numberWithInt:sqlite3_column_int(statement, 2)];
                        b.value = [NSNumber numberWithInt:sqlite3_column_int(statement, 3)];
                        b.shottimestamp = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)] ;
                        if (b.shotid==[NSNumber numberWithInt:Potted]) {
                            [hb.breakBalls addObject:b];
                        }
                    }
                }
            
            sqlite3_finalize(statement);
            
        }
        sqlite3_close(_DB);
        
        
        
    } else {
        NSLog(@"Cannot open database");
    }
    
    return hb;
    
}









/*
 
 CREATE TABLE matches(matchid INTEGER PRIMARY KEY, player1_number INTEGER, player2_number INTEGER, startdate TEXT, enddate TEXT, player1_frameswon INTEGER, player2_frameswon INTEGER, player1_hibreak INTEGER, player2_hibreak INTEGER, matchkey TEXT, FOREIGN KEY(player1_number) REFERENCES players(playernumber), FOREIGN KEY(player2_number) REFERENCES players(playernumber))
 
 CREATE TABLE players(playernumber INTEGER, nickname TEXT, email TEXT, photolocation TEXT, highestbreak INTEGER, highestbreakdate TEXT, trailblaze INTEGER, playerkey TEXT)
 
 CREATE TABLE breakshots(breakid INTEGER PRIMARY KEY, reftoentryid INTEGER, shotid INTEGER, colour TEXT, imagenamelarge   TEXT, distance  INTEGER, effort INTEGER, foulid INTEGER, safetyid INTEGER, value INTEGER, shottimestamp TEXT, killed INTEGER, pocketid INTEGER, FOREIGN KEY(reftoentryid) REFERENCES frameEntries(entryid))
 
 CREATE TABLE frameentries(entryid INTEGER PRIMARY KEY, matchid INTEGER, playerid INTEGER, frameid INTEGER, lastshotid INTEGER, endbreaktimestamp  TEXT, points INTEGER, active INTEGER, FOREIGN KEY(matchid) REFERENCES matches(matchid))
 
 
 
 
 
 
Below is a sample of the database content.
 
 
 sqlite> select * from breakshots
 ...> go
 1|2|1|RED|red_01.png|1|1|||1|2016-01-08 18:56:35||
 2|2|1|BROWN|brown_04.png|1|1|||4|2016-01-08 18:56:36||
 3|2|1|RED|red_01.png|1|1|||1|2016-01-08 18:56:37||
 4|2|1|BLUE|blue_05.png|1|1|||5|2016-01-08 18:56:38||
 5|2|1|RED|red_01.png|1|1|||1|2016-01-08 18:56:39||
 6|3|1|RED|red_01.png|1|1|||1|2016-01-08 18:56:42||
 7|3|1|BLUE|blue_05.png|1|1|||5|2016-01-08 18:56:43||
 8|3|1|RED|red_01.png|1|1|||1|2016-01-08 18:56:43||
 9|3|1|PINK|pink_06.png|1|1|||6|2016-01-08 18:56:44||
 10|4|1|RED|red_01.png|1|1|||1|2016-01-08 18:58:06||
 11|4|1|GREEN|green_03.png|1|1|||3|2016-01-08 18:58:06||
 12|4|1|RED|red_01.png|1|1|||1|2016-01-08 18:58:07||
 13|4|1|BROWN|brown_04.png|1|1|||4|2016-01-08 18:58:08||
 14|4|1|RED|red_01.png|1|1|||1|2016-01-08 18:58:09||
 15|4|1|BLACK|black_07.png|1|1|||7|2016-01-08 18:58:10||
 16|5|1|RED|red_01.png|1|1|||1|2016-01-08 18:58:13||
 17|6|1|RED|red_01.png|1|1|||1|2016-01-08 18:58:15||
 18|6|1|BROWN|brown_04.png|1|1|||4|2016-01-08 18:58:15||
 19|6|1|RED|red_01.png|1|1|||1|2016-01-08 18:58:16||
 20|6|1|PINK|pink_06.png|1|1|||6|2016-01-08 18:58:17||
 21|7|1|RED|red_01.png|1|1|||1|2016-01-08 18:58:20||
 22|7|1|GREEN|green_03.png|1|1|||3|2016-01-08 18:58:21||
 23|9|1|RED|red_01.png|1|1|||1|2016-01-08 18:58:47||
 24|9|1|GREEN|green_03.png|1|1|||3|2016-01-08 18:58:47||
 25|10|1|RED|red_01.png|1|1|||1|2016-01-08 18:58:50||
 26|10|1|BLUE|blue_05.png|1|1|||5|2016-01-08 18:58:51||
 27|10|1|RED|red_01.png|1|1|||1|2016-01-08 18:58:52||
 28|10|1|BLACK|black_07.png|1|1|||7|2016-01-08 18:58:52||
 29|11|1|RED|red_01.png|1|2|||1|2016-01-08 19:02:46||1
 30|11|1|YELLOW|yellow_02.png|0|1|||2|2016-01-08 19:02:53||3
 31|11|3|RED|red_01.png|2|1|||0|2016-01-08 19:03:01||2
 32|12|1|RED|red_01.png|1|1|||1|2016-01-08 19:04:27||
 33|13|1|RED|red_01.png|1|1|||1|2016-01-08 19:04:28||
 34|13|1|YELLOW|yellow_02.png|1|1|||2|2016-01-08 19:04:29||
 35|14|1|RED|red_01.png|1|1|||1|2016-01-08 19:04:30||
 36|14|1|GREEN|green_03.png|1|1|||3|2016-01-08 19:04:30||
 37|15|1|RED|red_01.png|1|1|||1|2016-01-08 19:04:32||
 38|15|1|YELLOW|yellow_02.png|1|1|||2|2016-01-08 19:04:32||
 39|16|1|RED|red_01.png|1|1|||1|2016-01-08 19:04:33||
 40|17|1|RED|red_01.png|1|1|||1|2016-01-08 19:04:35||
 41|18|1|RED|red_01.png|1|1|||1|2016-01-08 19:04:36||
 42|18|1|YELLOW|yellow_02.png|1|1|||2|2016-01-08 19:04:37||
 43|18|1|RED|red_01.png|1|1|||1|2016-01-08 19:04:38||
 44|18|1|GREEN|green_03.png|1|1|||3|2016-01-08 19:04:38||
 45|18|1|RED|red_01.png|1|1|||1|2016-01-08 19:04:39||
 46|18|1|BROWN|brown_04.png|1|1|||4|2016-01-08 19:04:39||
 47|19|1|RED|red_01.png|1|1|||1|2016-01-08 19:04:41||
 48|19|1|YELLOW|yellow_02.png|1|1|||2|2016-01-08 19:04:42||
 49|19|1|RED|red_01.png|1|1|||1|2016-01-08 19:04:42|1|
 50|19|1|GREEN|green_03.png|1|1|||3|2016-01-08 19:04:43||
 51|19|1|YELLOW|yellow_02.png|1|1|||2|2016-01-08 19:04:44|1|
 
 
 sqlite> select * from frameentries
 ...> go
 1|1|0|1|0|2016-01-08 18:56:34|0|2
 2|1|1|1|1|2016-01-08 18:56:40|12|0
 3|1|2|1|1|2016-01-08 18:56:45|13|0
 4|1|1|1|1|2016-01-08 18:58:11|17|0
 5|1|2|1|1|2016-01-08 18:58:13|1|0
 6|1|1|1|1|2016-01-08 18:58:19|12|0
 7|1|2|1|1|2016-01-08 18:58:22|4|0
 8|1|0|2|0|2016-01-08 18:58:44|0|2
 9|1|1|2|1|2016-01-08 18:58:49|4|1
 10|1|2|2|1|2016-01-08 18:58:53|14|1
 11|1|1|2|3|2016-01-08 19:03:01|3|1
 12|1|2|2|1|2016-01-08 19:04:27|1|1
 13|1|1|2|1|2016-01-08 19:04:29|3|1
 14|1|2|2|1|2016-01-08 19:04:31|4|1
 15|1|1|2|1|2016-01-08 19:04:33|3|1
 16|1|2|2|1|2016-01-08 19:04:34|1|1
 17|1|1|2|1|2016-01-08 19:04:36|1|1
 18|1|2|2|1|2016-01-08 19:04:40|12|1
 19|1|1|2|1|2016-01-08 19:04:44|9|1
 
 
 
 
 
 */


-(NSNumber *) getNewImportMatchId {
    
    NSNumber *newMatchId = false;
    
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK) {
        NSString *selectSQL;
        
        selectSQL = @"select MIN(matchid)-1 from matches";
        
        
        const char *select_statement = [selectSQL UTF8String];
        
        if (sqlite3_prepare_v2(_DB, select_statement, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                newMatchId = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];

            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(_DB);
    }
    return newMatchId;
}


-(bool) validateMatchKey :(NSString *) matchKey {
   
    bool matchKeyExists = false;
    
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK) {
        NSString *selectSQL;
        
        selectSQL = [NSString stringWithFormat:@"select matchkey from matches where matchkey = '%@'",matchKey];
        
        
        const char *select_statement = [selectSQL UTF8String];
        
        if (sqlite3_prepare_v2(_DB, select_statement, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                matchKeyExists = true;
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(_DB);
    }
    return matchKeyExists;
    
}


-(NSNumber *) validatePlayerKey :(NSString *) playerKey {

    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    NSNumber *existingPlayerNumber = [NSNumber numberWithInt:0];
    
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK) {
        NSString *selectSQL;
        selectSQL = [NSString stringWithFormat:@"select playernumber from players where playerkey = '%@'",playerKey];
        const char *select_statement = [selectSQL UTF8String];
        
        if (sqlite3_prepare_v2(_DB, select_statement, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                existingPlayerNumber = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(_DB);
    }
    return existingPlayerNumber;
}




/* new 20160110 */
-(bool) insertImportedMatchData :(match *) m :(player *) p1 :(player *) p2 {
    
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK) {
        
        NSString *insertSQL = [NSString stringWithFormat:@"INSERT INTO matches (matchid,player1_number,player2_number,startdate,enddate,player1_frameswon,player2_frameswon,player1_hibreak,player2_hibreak,matchkey) VALUES (%@,%@,%@,'%@','%@',%@,%@,%@,%@,'%@')", m.matchid, p1.playerNumber, p2.playerNumber, m.matchDate, m.matchEndDate, m.Player1FrameWins,m.Player2FrameWins,m.Player1HiBreak,m.Player2HiBreak,m.matchkey];
        
        const char *insert_statement = [insertSQL UTF8String];
        sqlite3_prepare_v2(_DB, insert_statement, -1, &statement, NULL);
        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSLog(@"Failed to insert new match record inside match table");
        } else {
            NSLog(@"inserted new match record inside match table!");
            sqlite3_close(_DB);
            return false;
        }
        sqlite3_finalize(statement);
        sqlite3_close(_DB);
    }
    return true;
}

/* new 20160117 */
-(NSNumber *) getNextEntryIDForInport {
    
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    NSNumber *nextEntryID = [NSNumber numberWithInt:0];
    
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK) {
        NSString *selectSQL;
        selectSQL = @"select MAX(entryid)+1 from frameentries";
        const char *select_statement = [selectSQL UTF8String];
        
        if (sqlite3_prepare_v2(_DB, select_statement, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW) {
                nextEntryID = [NSNumber numberWithInt:sqlite3_column_int(statement, 0)];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(_DB);
    }
    return nextEntryID;
}



/* created 20151012 */
/* last modified 20160202 */

/* TODO - needs some tidy up */
-(bool) importDataIntoDB :(NSArray *) datarows {
    

    NSNumber *previousEntryId = [NSNumber numberWithInt:0];
    NSNumber *nextEntryId = [self getNextEntryIDForInport];
    
    int totalPoints=0;
    int lineCounter=0;
    
    player *p1 = [[player alloc]init];
    player *p2 = [[player alloc]init];
    match *m = [[match alloc]init];

    breakEntry *entryData = [[breakEntry alloc] init];

    /* for each row in line */
    for (NSString *line in datarows) {
        lineCounter ++;

        
        if (lineCounter == 1) {
            
            NSArray *headerrecord = [line componentsSeparatedByString:@";"];
            m.matchkey = [headerrecord objectAtIndex:0];
            p1.nickName = [headerrecord objectAtIndex:1];
            m.Player1FrameWins = [headerrecord objectAtIndex:2];
            m.Player1HiBreak = [headerrecord objectAtIndex:3];
            p1.playerkey = [headerrecord objectAtIndex:4];
            p2.nickName = [headerrecord objectAtIndex:5];
            m.Player2FrameWins = [headerrecord objectAtIndex:6];
            m.Player2HiBreak = [headerrecord objectAtIndex:7];
            p2.playerkey = [headerrecord objectAtIndex:8];
            
            // need to validate this.
            if (headerrecord.count > 10) {
                m.matchDate = [headerrecord objectAtIndex:10];
                m.matchEndDate = [headerrecord objectAtIndex:11];
            } else {
                return false;
            }
                
            if ([self validateMatchKey :m.matchkey]) {
                return false;
            } else {
                
                p1.playerNumber = [self validatePlayerKey :p1.playerkey];
                if (p1.playerNumber == [NSNumber numberWithInt:0]) {
                    // create new player!
                    p1.emailAddress = @"imported@player.com";
                    p1.photoLocation =@"avatar0.png";
                    p1.hiBreak = m.Player1HiBreak;
                    p1.playerNumber = [self insertPlayer :p1];
                    
                }
                
                p2.playerNumber = [self validatePlayerKey :p2.playerkey];
                if (p2.playerNumber == [NSNumber numberWithInt:0]) {
                    p2.hiBreak = m.Player2HiBreak;
                    p2.emailAddress = @"imported@player.com";
                    p2.photoLocation =@"avatar0.png";
                    p2.playerNumber = [self insertPlayer :p2];
                }
                
                m.Player1Number = p1.playerNumber;
                m.Player2Number = p2.playerNumber;
                
                // create new match, as imported, should be negative!
                m.matchid = [self getNewImportMatchId];
                [self insertImportedMatchData :m :p1 :p2];
        
            }
            // skip past the header record
            continue;
        }
        
        NSArray *items = [line componentsSeparatedByString:@";"];
        
        if ([items objectAtIndex:0]!=previousEntryId) {
            
            if (previousEntryId != [NSNumber numberWithInt:0]) {
                ballShot *lastShot = [entryData.shots lastObject];
                entryData.lastshotid = lastShot.shotid;
                [self entriesInsert :m.matchid :entryData.playerid :entryData.frameid :entryData.lastshotid :entryData.points :entryData.active :entryData.duration];
                
                [self shotsInsert :entryData.entryid :entryData.shots];
                
                nextEntryId = [NSNumber numberWithInt:[nextEntryId intValue]+1];
                entryData.active=[NSNumber numberWithInt:0];
                
                totalPoints = 0;
            }
            previousEntryId = [items objectAtIndex:0];
            [entryData.shots removeAllObjects];
        }
        
        entryData.matchid=[NSNumber numberWithInt:1];
        ballShot *shot = [ballShot alloc];
        totalPoints += [[items objectAtIndex:8] intValue];
        entryData.points = [NSNumber numberWithInt:totalPoints];
        entryData.frameid = [NSNumber numberWithInt:[[items objectAtIndex:2] intValue]];
        
        /* for each column in a row */
        for (int itemindex=0; itemindex<items.count; itemindex++) {
            
            switch (itemindex)
            
            {
                case 0:
                    //entry id
                    entryData.entryid = nextEntryId;
                    
                    
                case 1:
                    
                    //last shot date time
                    entryData.endbreaktimestamp = [items objectAtIndex:itemindex];
                    break;
                    
                case 2:
                    
                    //frame id
                    entryData.frameid = [NSNumber numberWithInt:[[items objectAtIndex:2] intValue]];

                    break;
                    
                case 3:
                    
                    // player id
                    entryData.playerid = [NSNumber numberWithInt:[[items objectAtIndex:itemindex] intValue]];
                    
                    
                    break;
                    
                case 4:
                    
                    // shot id
                    shot.shotid = [NSNumber numberWithInt:[[items objectAtIndex:itemindex] intValue]];
                    break;
                    
                case 5:
                    
                    // shot segment 1
                    switch ([shot.shotid intValue])
                {
                    case 0:
                        entryData.active = [NSNumber numberWithInt:2];
                    case Potted:
                        shot.distanceid = [NSNumber numberWithInt:[[items objectAtIndex:itemindex] intValue]];
                        break;
                    case Missed:
                        shot.distanceid = [NSNumber numberWithInt:[[items objectAtIndex:itemindex] intValue]];
                        break;
                    case Foul:
                        shot.foulid = [NSNumber numberWithInt:[[items objectAtIndex:itemindex] intValue]];
                        break;
                    case Safety:
                        shot.safetyid = [NSNumber numberWithInt:[[items objectAtIndex:itemindex] intValue]];
                        break;
                    case Bonus:
                        shot.foulid = [NSNumber numberWithInt:[[items objectAtIndex:itemindex] intValue]];
                        break;
                    case Adjustment:
                        shot.foulid = [NSNumber numberWithInt:[[items objectAtIndex:itemindex] intValue]];
                        break;
                    default:
                        // statements
                        break;
                }
                    
                    break;
                    
                case 6:
                    
                    // shot segment 2
                    switch ([shot.shotid intValue])
                {
                    case Potted:
                        shot.effortid = [NSNumber numberWithInt:[[items objectAtIndex:itemindex] intValue]];
                        break;
                    case Missed:
                        shot.effortid = [NSNumber numberWithInt:[[items objectAtIndex:itemindex] intValue]];
                        break;
                        
                    default:
                        // statements
                        break;
                }
                    break;
                    
                case 7:
                    
                    shot.colour = [items objectAtIndex:itemindex];
                    
                    if ([shot.colour isEqualToString:@"RED"]) {
                        shot.imageNameLarge = @"red_01";
                    } else if ([shot.colour isEqualToString:@"YELLOW"]) {
                        shot.imageNameLarge = @"yellow_02";
                    } else if ([shot.colour isEqualToString:@"GREEN"]) {
                        shot.imageNameLarge = @"green_03";
                    } else if ([shot.colour isEqualToString:@"BROWN"]) {
                        shot.imageNameLarge = @"brown_04";
                    } else if ([shot.colour isEqualToString:@"BLUE"]) {
                        shot.imageNameLarge =@"blue_05";
                    } else if ([shot.colour isEqualToString:@"PINK"]) {
                        shot.imageNameLarge = @"pink_06";
                    } else if ([shot.colour isEqualToString:@"BLACK"]) {
                        shot.imageNameLarge = @"black_07";
                    }
                    break;
                    
                case 8:
                    
                    //shot points
                    if (![[items objectAtIndex:itemindex] isEqualToString:@"0"]) {
                        shot.value = [NSNumber numberWithInt:[[items objectAtIndex:itemindex] intValue]];
                    }
                    
                    break;
                    
                case 9:
                    
                    //shot date time
                    if (![[items objectAtIndex:itemindex] isEqualToString:@"0"]) {
                        shot.shottimestamp = [items objectAtIndex:itemindex];
                    }
                    
                    break;
                    
                    
                case 10:
                     entryData.duration = [NSNumber numberWithInt:[[items objectAtIndex:itemindex] intValue]];
                    break;
                   
                case 11:
                    shot.pocketid = [NSNumber numberWithInt:[[items objectAtIndex:itemindex] intValue]];
                    break;
                   
                default:
                    
                    // statements
                    break;
            }
        }
        
        
        
        
        
        if ([entryData.shots count] == 0) {
            entryData.shots = [NSMutableArray arrayWithObjects:shot, nil];
        } else {
            [entryData.shots addObject:shot];
        }
        
    }
    return entryData.frameid;
}







-(bool) deleteWholeMatchData :(NSNumber *) matchId {
    

    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK) {
        
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE breakshots SET deleted = 1 WHERE reftoentryid IN (select entryid from frameentries where matchid=%@)",matchId];
        
        const char *update_statement = [updateSQL UTF8String];
        sqlite3_prepare_v2(_DB, update_statement, -1, &statement, NULL);
        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSLog(@"Failed to update record(s) inside player table");
            sqlite3_close(_DB);
            return false;
        }
        sqlite3_finalize(statement);
        
        NSString *deleteSQL = @"DELETE FROM breakshots WHERE deleted = 1";
        
        const char *deleteStatement = [deleteSQL UTF8String];
        sqlite3_prepare_v2(_DB, deleteStatement, -1, &statement, NULL);
        
        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSLog(@"Failed to delete all content from table breakshots");
            sqlite3_close(_DB);
            return false;
        } else {
            NSLog(@"Successfuly deleted all content from table breakshots");
        }

        sqlite3_finalize(statement);
        
        deleteSQL = [NSString stringWithFormat:@"DELETE FROM frameentries WHERE matchid = %@",matchId];
        
        deleteStatement = [deleteSQL UTF8String];
        sqlite3_prepare_v2(_DB, deleteStatement, -1, &statement, NULL);
        
        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSLog(@"Failed to delete all content from table frameentries");
            sqlite3_close(_DB);
            return false;
        } else {
            NSLog(@"Successfuly deleted all content from table frameentries");
        }
        
        sqlite3_finalize(statement);

        deleteSQL = [NSString stringWithFormat:@"DELETE FROM matches WHERE matchid = %@",matchId];
        
        deleteStatement = [deleteSQL UTF8String];
        sqlite3_prepare_v2(_DB, deleteStatement, -1, &statement, NULL);
        
        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSLog(@"Failed to delete all content from table matches");
            sqlite3_close(_DB);
            return false;
        } else {
            NSLog(@"Successfuly deleted all content from table matches");
        }
        
        sqlite3_finalize(statement);
    }
    
    sqlite3_close(_DB);
    
    return true;
}


/* created 20160712 */
/* modfied 20161211 - fix bug where this method deleted all matches of frame reference passed in */
-(bool) deleteWholeFrameData :(NSNumber *) frameId :(NSNumber*) matchId {
    
    
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK) {
        
        NSString *updateSQL = [NSString stringWithFormat:@"UPDATE breakshots SET deleted = 1 WHERE reftoentryid IN (select entryid from frameentries where frameid=%@ and matchid=%@)",frameId, matchId];
        
        const char *update_statement = [updateSQL UTF8String];
        sqlite3_prepare_v2(_DB, update_statement, -1, &statement, NULL);
        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSLog(@"Failed to update record(s) inside player table");
            sqlite3_close(_DB);
            return false;
        }
        sqlite3_finalize(statement);
        
        NSString *deleteSQL = @"DELETE FROM breakshots WHERE deleted = 1";
        
        const char *deleteStatement = [deleteSQL UTF8String];
        sqlite3_prepare_v2(_DB, deleteStatement, -1, &statement, NULL);
        
        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSLog(@"Failed to delete all content from table breakshots");
            sqlite3_close(_DB);
            return false;
        } else {
            NSLog(@"Successfuly deleted all content from table breakshots");
        }
        
        sqlite3_finalize(statement);
        
        deleteSQL = [NSString stringWithFormat:@"DELETE FROM frameentries WHERE frameid = %@ and matchid=%@",frameId,matchId];
        
        deleteStatement = [deleteSQL UTF8String];
        sqlite3_prepare_v2(_DB, deleteStatement, -1, &statement, NULL);
        
        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSLog(@"Failed to delete content from table frameentries");
            sqlite3_close(_DB);
            return false;
        } else {
            NSLog(@"Successfuly deleted content from table frameentries");
        }
        
        sqlite3_finalize(statement);
        
    }
    
    sqlite3_close(_DB);
    
    return true;
}










-(bool) deletePlayer :(NSNumber *) playernumber {
    
    
    sqlite3_stmt *statement;
    const char *dbpath = [_databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &_DB) == SQLITE_OK) {
        
        NSString *deleteSQL = [NSString stringWithFormat:@"DELETE FROM players WHERE playernumber = %@", playernumber];
        
        const char *deleteStatement = [deleteSQL UTF8String];
        sqlite3_prepare_v2(_DB, deleteStatement, -1, &statement, NULL);
        
        if (sqlite3_step(statement) != SQLITE_DONE) {
            NSLog(@"Failed to delete record from table players");
            sqlite3_close(_DB);
            return false;
        } else {
            NSLog(@"Successfuly deleted record from table players");
        }
        
    }
    
    sqlite3_close(_DB);
    
    return true;
}




@end
