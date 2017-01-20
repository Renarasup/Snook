//
//  ViewController.h
//  SnookerScorer
//
//  Created by andrew glew on 05/11/2014.
//  Copyright (c) 2014 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "player.h"
#import "frameScore.h"
#import "adjustVC.h"
#import <iAd/iAd.h>
#import "AppDelegate.h"
#import "playerDetailVC.h"
#import "match.h"
#import "dbHelper.h"
#import "matchStatisticsVC.h"
#import "common.h"
#import "Foundation/Foundation.h"
#import <SpriteKit/SpriteKit.h>
#import "celebrationSceneSKV.h"


@interface scoreboardVC : UIViewController <MFMailComposeViewControllerDelegate,UIAlertViewDelegate, UIGestureRecognizerDelegate, AdjustPointsDelegate, UINavigationControllerDelegate> {
    int activeColour;
    bool ballReplaced;
    int colourStateAtStartOfBreak;
    int colourQuantityAtStartOfBreak;
    bool importedFile;
    ADBannerView *_adBanner;
}

@property (strong, nonatomic) dbHelper *db;
@property (nonatomic, strong) NSNumber *currentFrameId;
@property (nonatomic, strong) NSNumber *pocketId;
@property (nonatomic) NSNumber *activeMatchId;
@property (assign) int matchTxId;
@property (assign) int displayState;
@property (assign) int activeColour;
@property (assign) bool ballReplaced;
@property (nonatomic) NSString *skinPrefix;
@property (assign) bool importedFile;
@property (assign) int colourStateAtStartOfBreak;
@property (assign) int colourQuantityAtStartOfBreak;
@property (nonatomic, strong) NSMutableArray *matchData;
@property IBOutlet SKView *skView;


@property (strong, nonatomic) NSMutableArray *activeMatchData; /* added 20160118 */
@property (strong, nonatomic) NSMutableArray *activeFrameData;  /* added 20160118 */
@property (strong, nonatomic) NSMutableArray *selectedFrameData;

@property (assign) int shotTypeId;
@property (assign) int shotFoulId;
@property (assign) int shotTabId;
@property (assign) int shotGroup1SegmentId;
@property (assign) int shotGroup2SegmentId;
@property (strong, nonatomic) NSMutableArray     *joinedFrameResult;
@property (weak, nonatomic) IBOutlet UICollectionView *visitBallGrid;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;

@property (strong, nonatomic) UIColor *skinBackgroundColour;
@property (strong, nonatomic) UIColor *skinForegroundColour;
@property (strong, nonatomic) UIColor *skinPlayer1Colour;
@property (strong, nonatomic) UIColor *skinPlayer2Colour;
@property (strong, nonatomic) UIColor *skinSelectedScore;

/* https://www.youtube.com/watch?v=mdG6XpwwuwI */
-(void) processCurrentUsersHighestBreak;
-(void) processMatchEnd;
-(void) endOfFrame :(bool) showprompt;
-(void) endMatch :(NSString*) option;
-(NSString*)getSmallImage:(NSString*)ballcolour;




@end

