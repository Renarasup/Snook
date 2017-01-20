//
//  ballShot.h
//  SnookerScoreLite
//
//  Created by andrew glew on 11/09/2015.
//  Copyright © 2015 andrew glew. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ballShot : NSObject {
    NSNumber *breakid;
    NSNumber *value;
    NSNumber *opponentpoints;
    NSNumber *shotid;
    NSString *shottimestamp;
    NSNumber *distanceid;
    NSNumber *effortid;
    NSNumber *foulid;
    NSNumber *reftoentryid;
    NSNumber *safetyid;
    NSNumber *pocketid;
    NSString *colour;
    NSNumber *killed;
    NSString *imagenamelarge;
    NSString *notes;
}

@property (nonatomic) NSNumber *opponentpoints;
@property (nonatomic) NSNumber *value;
@property (nonatomic) NSNumber *breakid;
@property (nonatomic) NSNumber *shotid;
@property (nonatomic) NSString *shottimestamp;
@property (nonatomic) NSNumber *distanceid;
@property (nonatomic) NSNumber *effortid;
@property (nonatomic) NSNumber *foulid;
@property (nonatomic) NSNumber *killed;
@property (nonatomic) NSNumber *reftoentryid;
@property (nonatomic) NSNumber *safetyid;
@property (nonatomic) NSNumber *pocketid;
@property (nonatomic) NSString *colour;
@property (nonatomic) NSString *imageNameLarge;
@property (nonatomic) NSString *notes;

enum shotTypes {Standard, Potted, Foul, Missed, Safety, Bonus, Adjustment, Paused, Resumed};
enum shotDistanceSegTypes {Short,Medium,Long,Escape};
enum shotDifficultySegTypes {Easy,Average,Tough,Fluke};
enum shotSafetySegTypes {Superb, Good, Alright, Bad};
enum shotFoulTypes {notany, foulPotAndInOff, foulInOff, foulWrongPotOrHit, adjusted, foulWrongRedPot, foulMissedBall};

enum pocketReferences {pocketNone, pocketBulkLeft, pocketBulkRight,pocketMiddleLeft,pocketMiddleRight,pocketBottomLeft,pocketBottomRight};
enum flagType {activeFlag_Inactive, activeFlag_Active, activeFlag_FrameStart, activeFlag_PlayerSwapped,  activeFlag_PausedState, activeFlag_UnPausedState};


-(NSString *)getDistanceText :(NSNumber*)distanceValue  ;
-(NSString *)getEffortText :(NSNumber*)effortValue ;
-(NSString *)getFoulTypeText :(NSNumber*)foulValue ;
-(NSString *)getSafetyTypeText :(NSNumber*)safetyValue ;
-(NSString*) getBallDetailText;
-(NSString*) getBallShotText;
-(NSString*) getBallDetailDTText;

@end
