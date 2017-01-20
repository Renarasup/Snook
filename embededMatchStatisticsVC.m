//
//  matchStatisticsVC.m
//  SnookerScoreMaster
//
//  Created by andrew glew on 15/01/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import "embededMatchStatisticsVC.h"
#import "breakEntry.h"
#import "breakBallCell.h"

@interface embededMatchStatisticsVC () < UICollectionViewDataSource, UICollectionViewDelegate, MFMailComposeViewControllerDelegate, graphViewDelegate>
@end



@implementation embededMatchStatisticsVC {
    UISwipeGestureRecognizer *swipeRight;
    enum themes {greenbaize, dark, light, modern,purplehaze,blur};
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.activeMatchData = [self.db entriesRetreive :self.m.matchid :nil :nil :nil :nil :nil :nil :true];
    self.breakShots = [[NSMutableArray alloc] init];
    NSData *pngdata;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    pngdata = [NSData dataWithContentsOfFile:[[paths objectAtIndex:0] stringByAppendingPathComponent:self.p1.photoLocation]];
    
    UIImage *img = [UIImage imageWithData:pngdata];
    
    if (img==nil) {
        img = [UIImage imageNamed:@"avatar0"];
    }

    [self.player1Photo setImage:img];
    
    self.player1Photo.frame = CGRectMake(self.player1Photo.frame.origin.x, self.player1Photo.frame.origin.y, 50, 50);
    self.player1Photo.clipsToBounds = YES;
    self.player1Photo.layer.cornerRadius = 50/2.0f;

    
    pngdata = [NSData dataWithContentsOfFile:[[paths objectAtIndex:0] stringByAppendingPathComponent:self.p2.photoLocation]];
    
    img = [UIImage imageWithData:pngdata];
    
    if (img==nil) {
        img = [UIImage imageNamed:@"avatar0"];
    }
    
    [self.player2Photo setImage:img];
    
    self.player2Photo.frame = CGRectMake(self.player2Photo.frame.origin.x, self.player2Photo.frame.origin.y, 50, 50);
    self.player2Photo.clipsToBounds = YES;
    self.player2Photo.layer.cornerRadius = 50/2.0f;
    
    self.player1Name.text=self.p1.nickName;
    self.player2Name.text=self.p2.nickName;
    
    [self.graphStatisticView initColours :self.skinPlayer1Colour :self.skinPlayer2Colour];
    
    self.graphStatisticView.overlay=false;
    self.graphStatisticsOverlayView.overlay=true;
    
    
    self.graphStatisticView.p1 = self.p1;
    self.graphStatisticView.p2 = self.p2;
    
    self.graphStatisticsOverlayView.p1 = self.p1;
    self.graphStatisticsOverlayView.p2 = self.p2;

    self.graphStatisticView.numberOfFrames=[self.m.Player1FrameWins intValue] + [self.m.Player2FrameWins intValue];
    
    if (self.activeMatchStatistcsShown)  {
        self.graphStatisticView.numberOfFrames ++;
        self.graphStatisticsOverlayView.numberOfFrames ++;
    }
    
    self.graphStatisticView.selectedData = self.activeMatchData;
    self.graphStatisticsOverlayView.selectedData = self.activeMatchData;
    
    if (self.graphStatisticView.numberOfFrames==0) {
        // maybe we have selected the current frame..
        breakEntry *stateOfSelectedMatch = [self.activeMatchData lastObject];
        if (stateOfSelectedMatch.active==[NSNumber numberWithInt:1]) {
            self.graphStatisticView.numberOfFrames = [stateOfSelectedMatch.frameid intValue];
                    } else if (stateOfSelectedMatch.active==[NSNumber numberWithInt:2] && self.activeMatchData.count>1) {
            self.graphStatisticView.numberOfFrames = [stateOfSelectedMatch.frameid intValue] - 1;
            
        }
        self.graphStatisticsOverlayView.numberOfFrames = self.graphStatisticView.numberOfFrames;
    }
    
    /* maximum stepper will be frame */
    self.graphStepper.maximumValue = self.graphStatisticView.numberOfFrames;
    
    if (self.activeMatchStatistcsShown) {
        self.borderLabel.hidden = false;
        
        swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightPopPlayersStats:)];
        swipeRight.numberOfTouchesRequired = 1;//give required num of touches here ..
        swipeRight.delegate = (id)self;
        swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
        [self.view addGestureRecognizer:swipeRight];
        self.graphStatisticView.matchStatistics=false;
        self.graphStatisticsOverlayView.matchStatistics=false;
        self.graphStepper.value = self.graphStatisticView.numberOfFrames;
    } else {
        self.graphStatisticView.matchStatistics=true;
        self.graphStatisticsOverlayView.matchStatistics=true;
        self.graphStepper.value = 0;
    }


    self.graphStatisticView.matchFramePoints = [[NSMutableArray alloc] init];
    self.graphStatisticView.frameData = [[NSMutableArray alloc] init];
    
    
    self.graphStatisticsOverlayView.matchFramePoints = [[NSMutableArray alloc] init];
    self.graphStatisticsOverlayView.frameData = [[NSMutableArray alloc] init];

    self.breakCollection.dataSource = self;
    self.breakCollection.delegate = self;

    
    self.p1HiBreakCollection.dataSource = self;
    self.p1HiBreakCollection.delegate = self;
    
    self.p2HiBreakCollection.dataSource = self;
    self.p2HiBreakCollection.delegate = self;
    
    
    [self reloadActiveGraph];
    
    if (self.stepperFrame.value==0) {
        self.displayState=0;
        self.buttonDetailStats.enabled=false;
        self.buttonListStats.enabled=false;
        self.tweetButton.enabled=false;
    }
    

    self.P2BreakInfo.hidden = true;
    self.p2BreakInfoBall.hidden = true;
    self.P1BreakInfo.hidden = true;
    self.p1BreakInfoBall.hidden = true;
    
    self.P1AmountBreak.hidden = false;
    self.P2AmountBreak.hidden = false;
    
    [self updateSummaryLabelContent :self.graphSummaryLabel];
    
    if (self.activeMatchStatistcsShown) {
        self.frameDuration = [common getFrameDuration :self.graphStatisticView.frameData];
        [self updateDurationVisitLabelContent:self.DurationVisitsLabel];
    }
    
    
    // some necessary formatting required of player stats
    
    [self.p1TopBreaks sizeToFit];
    [self.p2TopBreaks sizeToFit];
    
    
    /* colour setup */
    self.redColour = [UIColor colorWithRed:217.0f/255.0f green:23.0f/255.0f blue:60.0f/255.0f alpha:1.0];
    self.yellowColour = [UIColor colorWithRed:222.0f/255.0f green:199.0f/255.0f blue:4.0f/255.0f alpha:1.0];
    self.greenColour = [UIColor colorWithRed:61.0f/255.0f green:191.0f/255.0f blue:61.0f/255.0f alpha:1.0];
    self.brownColour = [UIColor colorWithRed:120.0f/255.0f green:64.0f/255.0f blue:0.0f/255.0f alpha:1.0];
    self.blueColour = [UIColor colorWithRed:39.0f/255.0f green:121.0f/255.0f blue:198.0f/255.0f alpha:1.0];
    self.pinkColour = [UIColor colorWithRed:201.0f/255.0f green:78.0f/255.0f blue:184.0f/255.0f alpha:1.0];
    self.blackColour = [UIColor colorWithRed:33.0f/255.0f green:33.0f/255.0f blue:33.0f/255.0f alpha:1.0];
    
    UIImage *changecolourimage = [[UIImage imageNamed:@"backbutton"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.backButton setImage:changecolourimage forState:UIControlStateNormal];
    self.backButton.tintColor = self.skinForegroundColour;
    changecolourimage = [[UIImage imageNamed:@"forwardbutton"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.forwardButton setImage:changecolourimage forState:UIControlStateNormal];
    self.forwardButton.tintColor = self.skinForegroundColour;
    
    self.footerView.backgroundColor = self.skinBackgroundColour;
    self.player1View.backgroundColor = self.skinPlayer1Colour;
    self.player2View.backgroundColor = self.skinPlayer2Colour;
    self.graphStepper.tintColor = self.skinForegroundColour;
    self.player1Name.textColor = [UIColor whiteColor];
    self.player2Name.textColor = [UIColor whiteColor];
    self.frameStatisticView.backgroundColor = self.skinBackgroundColour;
    self.tableFrameStatistics.backgroundColor = self.skinBackgroundColour;
    self.tableFrameStatistics.separatorColor = self.skinBackgroundColour;
    self.graphStatisticView.backgroundColor = self.skinBackgroundColour;
    self.player1StatView.backgroundColor = self.skinPlayer1Colour;
    self.player2StatView.backgroundColor = self.skinPlayer2Colour;
    self.view.backgroundColor = self.skinForegroundColour;
    self.sliderBorderLabel.backgroundColor = self.skinForegroundColour;
    self.graphReferenceLabel.textColor = self.skinForegroundColour;
    
    
    self.player1Score.textColor = [UIColor whiteColor];
    self.player2Score.textColor = [UIColor whiteColor];
    self.P1AmountBreak.textColor = [UIColor whiteColor];
    self.P2AmountBreak.textColor = [UIColor whiteColor];
    self.P1BreakInfo.textColor = [UIColor whiteColor];
    self.P2BreakInfo.textColor = [UIColor whiteColor];
    self.player1BreakInfoView.backgroundColor = self.skinPlayer1Colour;
    self.player2BreakInfoView.backgroundColor = self.skinPlayer2Colour;
    
    if (self.theme == greenbaize) {
        self.background.backgroundColor = [UIColor lightGrayColor];
        
    } else if (self.theme == purplehaze) {
         self.graphStatisticView.backgroundColor = [UIColor whiteColor];
    }
    
    if (self.displayState==8) {
        [self presentBreakStats:0];
    } else if (self.displayState==4) {
        [self presentFrameStats:0];
    } else {
        if (self.displayState>=2) {
            [self presentPlayer2Stats:0];
        }
        if (self.displayState==3 || self.displayState==1) {
            [self presentPlayer1Stats:0];
        }
    }
    
//    self.breakStatistcsView.backgroundColor = [UIColor clearColor];
    

    
}

-(void)viewWillAppear :(BOOL)animated {
    [super viewWillAppear:animated];
    
   
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self.navigationController setToolbarHidden:YES animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage =[UIImage new];
    
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];



    
}




-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.delegate addItemViewController:self keepDisplayState:self.displayState];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)swipeRightPopPlayersStats:(UISwipeGestureRecognizer *)gesture {
    
    [self.delegate addItemViewController:self keepDisplayState:self.displayState];
    [self.navigationController popViewControllerAnimated:YES];
    
}


/* last modified 20160203 */
/* frame/match graph */

-(void)reloadActiveGraph {
    
    if (self.graphStepper.value==0.0f) {
        self.graphReferenceLabel.text = @"Match";
        self.graphStatisticView.graphReferenceId=0;
        
         self.graphStatisticsOverlayView.graphReferenceId=0;
        
        if (self.m.matchid == self.activeMatchPlayers.matchid) {
            self.player1Score.text = [NSString stringWithFormat:@"%@", self.activeMatchPlayers.Player1FrameWins];
            self.player2Score.text = [NSString stringWithFormat:@"%@", self.activeMatchPlayers.Player2FrameWins];
        } else {
            if (self.m.Player1FrameWins==nil) {
                self.player1Score.text = @"0";
            } else {
                self.player1Score.text = [NSString stringWithFormat:@"%@", self.m.Player1FrameWins];
            }
            if (self.m.Player2FrameWins==nil) {
                 self.player2Score.text = @"0";
            } else {
                self.player2Score.text = [NSString stringWithFormat:@"%@", self.m.Player2FrameWins];
            }
        }
        
        
    } else {
        self.graphStatisticView.graphReferenceId=self.graphStepper.value;
        
        self.graphStatisticsOverlayView.graphReferenceId=self.graphStepper.value;
        
        [self.graphStatisticView loadSharedData];
        [self.graphStatisticsOverlayView loadSharedData];
        
     
        if (self.graphStatisticView.graphReferenceId == self.graphStatisticView.numberOfFrames) {
            self.player1Score.text = [NSString stringWithFormat:@"%d", self.graphStatisticView.scorePlayer1+[self.p1.activeBreak intValue]];
            self.player2Score.text = [NSString stringWithFormat:@"%d", self.graphStatisticView.scorePlayer2+[self.p2.activeBreak intValue]];
            
        } else {
            self.player1Score.text = [NSString stringWithFormat:@"%d", self.graphStatisticView.scorePlayer1];
            self.player2Score.text = [NSString stringWithFormat:@"%d", self.graphStatisticView.scorePlayer2];
        }
        
        self.graphReferenceLabel.text = [NSString stringWithFormat:@"Frame no%d",self.graphStatisticView.graphReferenceId];
        
        
    }

    
    if (self.player2StatView.hidden == false) {
        [self loadPlayerStatistics:[NSNumber numberWithInt:2]];
        [self loadBreakBalls:[NSNumber numberWithInt:2]];
    }
    if (self.player1StatView.hidden == false) {
        [self loadPlayerStatistics:[NSNumber numberWithInt:1]];
        [self loadBreakBalls:[NSNumber numberWithInt:1]];
    }
    
    [self.graphStatisticView setNeedsDisplay];

}








/* player frame/match statistics */

-(void)loadBreakBalls :(NSNumber *) playerIndex {
    if (self.graphStatisticView.graphReferenceId>0) {
        if (playerIndex==[NSNumber numberWithInt:1]) {
            self.p1BreakBalls = [common getHiBreakBalls:[self.graphStatisticView frameData] :playerIndex :[NSNumber numberWithInt:self.graphStatisticView.graphReferenceId]];
        } else {
            self.p2BreakBalls = [common getHiBreakBalls:[self.graphStatisticView frameData] :playerIndex :[NSNumber numberWithInt:self.graphStatisticView.graphReferenceId]];
        }
    } else {

        if (playerIndex==[NSNumber numberWithInt:1]) {
            self.p1BreakBalls = [common getHiBreakBalls:self.activeMatchData :playerIndex :[NSNumber numberWithInt:self.graphStatisticView.graphReferenceId]];
        } else {
            self.p2BreakBalls = [common getHiBreakBalls:self.activeMatchData :playerIndex :[NSNumber numberWithInt:self.graphStatisticView.graphReferenceId]];
        }
    }
 
    if ([playerIndex intValue]==1) {

        [self.p1HiBreakCollection reloadData];
        [self.p1HiBreakCollection layoutIfNeeded];
    } else {

        [self.p2HiBreakCollection reloadData];
        [self.p2HiBreakCollection layoutIfNeeded];
    }
}




/* player frame/match statistics */
/* modified 20161124 */

-(void)loadPlayerStatistics :(NSNumber *) playerIndex {
    
    
    int hibreak = [common getHiBreak :self.activeMatchData :playerIndex :[NSNumber numberWithInt:self.graphStatisticView.graphReferenceId]];
    float avgbreak, avgball, avgShotTime;
    int redcount, yellowcount, greencount, browncount, bluecount, pinkcount, blackcount;
    NSString *potfouls, *topbreaks;
    
    //getTotalPottedPoints
    
    if (self.graphStatisticView.graphReferenceId>0) {
        redcount = [common getQtyOfBallsByColor :[self.graphStatisticView frameData] :playerIndex :[NSNumber numberWithInt:1]];
        yellowcount = [common getQtyOfBallsByColor :[self.graphStatisticView frameData] :playerIndex :[NSNumber numberWithInt:2]];
        greencount = [common getQtyOfBallsByColor :[self.graphStatisticView frameData] :playerIndex :[NSNumber numberWithInt:3]];
        browncount = [common getQtyOfBallsByColor :[self.graphStatisticView frameData] :playerIndex :[NSNumber numberWithInt:4]];
        bluecount = [common getQtyOfBallsByColor :[self.graphStatisticView frameData] :playerIndex :[NSNumber numberWithInt:5]];
        pinkcount = [common getQtyOfBallsByColor :[self.graphStatisticView frameData] :playerIndex :[NSNumber numberWithInt:6]];
        blackcount = [common getQtyOfBallsByColor :[self.graphStatisticView frameData] :playerIndex :[NSNumber numberWithInt:7]];
        avgbreak = [common getAvgBreakAmt :[self.graphStatisticView frameData] :playerIndex];
        avgball = [common getAvgBallAmt :[self.graphStatisticView frameData] :playerIndex];
        
        potfouls = [NSString stringWithFormat:@"%d : %d", [common getSumOfShotsByType :[self.graphStatisticView frameData] :playerIndex :Potted], [common getSumOfShotsByType :[self.graphStatisticView frameData] :playerIndex :Foul]];
        
        topbreaks = [common getTopRangeOfPlayerBreaks:[self.graphStatisticView frameData] :playerIndex];
        
        
        avgShotTime = [common getAvgShotDuration:[self.graphStatisticView frameData]  :playerIndex];
        
        
    } else {
        redcount = [common getQtyOfBallsByColor :self.activeMatchData :playerIndex :[NSNumber numberWithInt:1]];
        yellowcount = [common getQtyOfBallsByColor :self.activeMatchData :playerIndex :[NSNumber numberWithInt:2]];
        greencount = [common getQtyOfBallsByColor :self.activeMatchData :playerIndex :[NSNumber numberWithInt:3]];
        browncount = [common getQtyOfBallsByColor :self.activeMatchData :playerIndex :[NSNumber numberWithInt:4]];
        bluecount = [common getQtyOfBallsByColor :self.activeMatchData :playerIndex :[NSNumber numberWithInt:5]];
        pinkcount = [common getQtyOfBallsByColor :self.activeMatchData :playerIndex :[NSNumber numberWithInt:6]];
        blackcount = [common getQtyOfBallsByColor :self.activeMatchData :playerIndex :[NSNumber numberWithInt:7]];
        avgbreak = [common getAvgBreakAmt :self.activeMatchData :playerIndex];
        avgball = [common getAvgBallAmt :self.activeMatchData :playerIndex];
        
        potfouls = [NSString stringWithFormat:@"%d : %d", [common getSumOfShotsByType :self.activeMatchData :playerIndex :Potted], [common getSumOfShotsByType :self.activeMatchData :playerIndex :Foul]];
        topbreaks = [common getTopRangeOfPlayerBreaks:self.activeMatchData :playerIndex];
        avgShotTime = [common getAvgShotDuration:self.activeMatchData :playerIndex];
    }
    
    if ([playerIndex intValue]==1) {
        self.p1HiBreakLabel.text = [NSString stringWithFormat:@"%d",hibreak];
        self.p1AvgBreakLabel.text = [NSString stringWithFormat:@"%.02f",avgbreak];
        self.p1BallAvgLabel.text = [NSString stringWithFormat:@"%.02f",avgball];
        
        if (redcount==0) {
            self.p1ImageBallRed.hidden=true;
            self.p1RedCountLabel.hidden=true;
        } else {
            self.p1ImageBallRed.hidden=false;
            self.p1RedCountLabel.hidden=false;
            self.p1RedCountLabel.text = [NSString stringWithFormat:@"%d",redcount];
        }
        if (yellowcount==0) {
            self.p1ImageBallYellow.hidden=true;
            self.p1YellowCountLabel.hidden=true;
        } else {
            self.p1ImageBallYellow.hidden=false;
            self.p1YellowCountLabel.hidden=false;
            self.p1YellowCountLabel.text = [NSString stringWithFormat:@"%d",yellowcount];
        }
        if (greencount==0) {
            self.p1ImageBallGreen.hidden=true;
            self.p1GreenCountLabel.hidden=true;
        } else {
            self.p1ImageBallGreen.hidden=false;
            self.p1GreenCountLabel.hidden=false;
            self.p1GreenCountLabel.text = [NSString stringWithFormat:@"%d",greencount];
        }
        if (browncount==0) {
            self.p1ImageBallBrown.hidden=true;
            self.p1BrownCountLabel.hidden=true;
        } else {
            self.p1ImageBallBrown.hidden=false;
            self.p1BrownCountLabel.hidden=false;
            self.p1BrownCountLabel.text = [NSString stringWithFormat:@"%d",browncount];
        }
        if (bluecount==0) {
            self.p1ImageBallBlue.hidden=true;
            self.p1BlueCountLabel.hidden=true;
        } else {
            self.p1ImageBallBlue.hidden=false;
            self.p1BlueCountLabel.hidden=false;
            self.p1BlueCountLabel.text = [NSString stringWithFormat:@"%d",bluecount];
        }
        if (pinkcount==0) {
            self.p1ImageBallPink.hidden=true;
            self.p1PinkCountLabel.hidden=true;
        } else {
            self.p1ImageBallPink.hidden=false;
            self.p1PinkCountLabel.hidden=false;
            self.p1PinkCountLabel.text = [NSString stringWithFormat:@"%d",pinkcount];
        }
        if (blackcount==0) {
            self.p1ImageBallBlack.hidden=true;
            self.p1BlackCountLabel.hidden=true;
        } else {
            self.p1ImageBallBlack.hidden=false;
            self.p1BlackCountLabel.hidden=false;
            self.p1BlackCountLabel.text = [NSString stringWithFormat:@"%d",blackcount];
        }

        self.p1SumPotsFouls.text = potfouls;
        self.p1TopBreaks.text = topbreaks;
        self.p1ShotAvgTimeLabel.text = [NSString stringWithFormat:@"%.02f",avgShotTime];
    } else {
        self.p2HiBreakLabel.text = [NSString stringWithFormat:@"%d",hibreak];
        self.p2AvgBreakLabel.text = [NSString stringWithFormat:@"%.02f",avgbreak];
        self.p2BallAvgLabel.text = [NSString stringWithFormat:@"%.02f",avgball];
        
        if (redcount==0) {
            self.p2ImageBallRed.hidden=true;
            self.p2RedCountLabel.hidden=true;
        } else {
            self.p2ImageBallRed.hidden=false;
            self.p2RedCountLabel.hidden=false;
            self.p2RedCountLabel.text = [NSString stringWithFormat:@"%d",redcount];
        }
        
        if (yellowcount==0) {
            self.p2ImageBallYellow.hidden=true;
            self.p2YellowCountLabel.hidden=true;
        } else {
            self.p2ImageBallYellow.hidden=false;
            self.p2YellowCountLabel.hidden=false;
            self.p2YellowCountLabel.text = [NSString stringWithFormat:@"%d",yellowcount];
        }
        if (greencount==0) {
            self.p2ImageBallGreen.hidden=true;
            self.p2GreenCountLabel.hidden=true;
        } else {
            self.p2ImageBallGreen.hidden=false;
            self.p2GreenCountLabel.hidden=false;
            self.p2GreenCountLabel.text = [NSString stringWithFormat:@"%d",greencount];
        }
        if (browncount==0) {
            self.p2ImageBallBrown.hidden=true;
            self.p2BrownCountLabel.hidden=true;
        } else {
            self.p2ImageBallBrown.hidden=false;
            self.p2BrownCountLabel.hidden=false;
            self.p2BrownCountLabel.text = [NSString stringWithFormat:@"%d",browncount];
        }
        if (bluecount==0) {
            self.p2ImageBallBlue.hidden=true;
            self.p2BlueCountLabel.hidden=true;
        } else {
            self.p2ImageBallBlue.hidden=false;
            self.p2BlueCountLabel.hidden=false;
            self.p2BlueCountLabel.text = [NSString stringWithFormat:@"%d",bluecount];
        }
        if (pinkcount==0) {
            self.p2ImageBallPink.hidden=true;
            self.p2PinkCountLabel.hidden=true;
        } else {
            self.p2ImageBallPink.hidden=false;
            self.p2PinkCountLabel.hidden=false;
            self.p2PinkCountLabel.text = [NSString stringWithFormat:@"%d",pinkcount];
        }
        if (blackcount==0) {
            self.p2ImageBallBlack.hidden=true;
            self.p2BlackCountLabel.hidden=true;
        } else {
            self.p2ImageBallBlack.hidden=false;
            self.p2BlackCountLabel.hidden=false;
            self.p2BlackCountLabel.text = [NSString stringWithFormat:@"%d",blackcount];
        }
        
        self.p2SumPotsFouls.text = potfouls;
        self.p2TopBreaks.text = topbreaks;
        self.p2ShotAvgTimeLabel.text = [NSString stringWithFormat:@"%.02f",avgShotTime];
    }
 
}




- (NSInteger) collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    if (collectionView == self.p1HiBreakCollection) {
        return self.p1BreakBalls.count;
    }
    else if (collectionView == self.p2HiBreakCollection) {
        return self.p2BreakBalls.count;
    } else {
        return self.breakShotsCount;
    }
    
}

/* last modified 20160206 */
- (UICollectionViewCell *) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (collectionView == self.p1HiBreakCollection) {
        /* player 1 highest break in current frame/match */
        
        breakBallCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"P1Cell" forIndexPath:indexPath];
        [[cell contentView] setFrame:[cell bounds]];
        cell.ball = [self.p1BreakBalls objectAtIndex:indexPath.row];
        
        if (!self.isHollow) {
            [cell setBorderWidth:0.0f];
        } else {
            [cell setBorderWidth:2.5f];
        }
        
        
        return cell;
        
    } else if (collectionView == self.p2HiBreakCollection) {
        /* player 2 highest break in current frame/match */
        
        breakBallCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"P2Cell" forIndexPath:indexPath];
        [[cell contentView] setFrame:[cell bounds]];
        cell.ball = [self.p2BreakBalls objectAtIndex:indexPath.row];
        
        if (!self.isHollow) {
            [cell setBorderWidth:0.0f];
        } else {
            [cell setBorderWidth:2.5f];
        }
        
        
        return cell;
        
    } else {
        /* player visit level */
        
        breakBallCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"breakCell" forIndexPath:indexPath];
        //[[cell contentView] setFrame:[cell bounds]];
        cell.ball = [self.breakShots objectAtIndex:indexPath.row];
        
        
        cell.ballStoreImage.highlightedImage = [UIImage imageNamed:@"selected.png"];

        if (!self.isHollow) {
            [cell setBorderWidth:0.0f];
        } else {
            [cell setBorderWidth:3.5f];
        }
        
        return cell;
        
    }


}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == self.breakCollection) {
        NSLog(@"clicked cell in breakCollection View");

       
        ballShot *ball = [self.breakShots objectAtIndex:indexPath.row];
        int currentRow = (int)indexPath.row;
        [self loadBall :ball :currentRow];
        
        
    }
}




/* last modified 20160714 */
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(breakBallCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    cell.ballStoreImage.layer.borderColor = [self getColourFromBallName:cell.ball].CGColor;
    if (!self.isHollow) cell.ballStoreImage.backgroundColor = [self getColourFromBallName:cell.ball];
}


/* used by tweeting process to obtain break to share on twitter */
/* created 20150929 */
- (UIImage *) imageWithCollectionView:(UICollectionView *)collectionBreakView
{
    CGSize widthHeight = CGSizeMake(collectionBreakView.contentSize.width, collectionBreakView.contentSize.height);
    
    UIGraphicsBeginImageContextWithOptions(widthHeight, NO, 0.0);
    [collectionBreakView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return img;
}


- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView == self.breakCollection) {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        float cellWidth = screenWidth / 10.0; //Replace the divisor with the column count requirement. Make sure to have it in float.
        CGSize size = CGSizeMake(cellWidth, cellWidth);
    return size;
    }
    else {
        /* return something back that is expected for other collection views */
        CGSize defaultSize = [(UICollectionViewFlowLayout*)collectionViewLayout itemSize];
        return defaultSize    ;
    }
}

- (void)didUpdateFocusInContext:(UIFocusUpdateContext *)context
       withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator {
    
    context.nextFocusedView.layer.backgroundColor = [UIColor yellowColor].CGColor;
    
    //GameCell is a subclass of UICollectionViewCell
    if ([context.previouslyFocusedView isKindOfClass:[breakBallCell class]]) {
        context.previouslyFocusedView.layer.backgroundColor = self.breakCollection.backgroundColor.CGColor;
    }
}


/* visit level detail - displays balls in visit/break */

-(bool) loadBreakShots:(int) breakShotsIndex :(BOOL) fromGraph {
    // example.  need to obtain items ball count..
    
    int index = breakShotsIndex;

    if (self.graphStatisticView.frameData.count < breakShotsIndex) {
        index = (int)self.graphStatisticView.frameData.count;
    }
    if (index == 0) {
        return false;
    }
    
    if (self.player1StatView.hidden==false || self.player2StatView.hidden==false) {
        return false;
    }
    
    
    breakEntry *data = [self.graphStatisticView.frameData objectAtIndex:index-1];

    
    self.breakShots = data.shots;
    
    
    self.breakShotsCount = data.shots.count;
    self.breakShotsPlayerId = data.playerid;
    self.breakShotsType = data.lastshotid;
    
    if (self.breakShotsPlayerId==[NSNumber numberWithInt:1]) {
        self.P1AmountBreak.text = [NSString stringWithFormat:@"%@",data.points];
    } else {
        self.P2AmountBreak.text = [NSString stringWithFormat:@"%@",data.points];
    }
    
    
    
    if (self.breakShotsCount>1 && [self.breakShotsType integerValue] != Potted  ) {
        self.breakShotsType = [NSNumber numberWithInt:Potted];
    }

    self.breakShotsPoints = data.points;
    self.breakShotsReference = [NSString stringWithFormat:@"%d/%d",index,(int)self.activeFrameData.count];
    self.breakShotsIndex = index;
    if (fromGraph) {
        //[self manageMoreBreak :false];
       // [self manageMoreFrame :false];
    }
    [self reloadGrid];
    
    NSLog(@"Tapped a bar with index %d, value", index);
    
    [self updateDurationVisitLabelContent :self.DurationVisitsLabel];
    
    return true;
}



/* visit level detail - displays balls in visit/break */
-(void)reloadGrid {
    
    NSString *typeOfPoints;
    
    NSNumber *shotId;
    shotId = self.breakShotsType;
    
    if ([shotId integerValue] == Potted) {
        typeOfPoints = @"break";
    } else if ([shotId integerValue] == Foul) {
        typeOfPoints = @"foul shot";
    } else if ([shotId integerValue] == Missed) {
        typeOfPoints = @"missed pot";
    } else if ([shotId integerValue] == Safety) {
        typeOfPoints = @"safety shot";
    } else if ([shotId integerValue] == Bonus) {
        typeOfPoints = @"bonus points";
    }
    
    int points = 0;
    if (self.breakShotsPoints != nil) {
        points = [self.breakShotsPoints intValue];
    }
    
    if (!self.graphStatisticsOverlayView.hidden) {
    if (self.breakShotsPlayerId==[NSNumber numberWithInt:1]) {
        self.player2View.hidden=true;
        self.player1View.hidden=false;
        
    } else {
        self.player2View.hidden=false;
        self.player1View.hidden=true;
    }
    
    }
    
    //self.visitDetailsLable.text = [NSString stringWithFormat:@"%@ %@ %d", playerName, typeOfPoints,points];
    //self.VisitPlayer.text = [NSString stringWithFormat:@"%@ : %@", [self.statsView visitRef], [self.statsView timeStamp]];
    
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        // Reload the respective collection view row using the main thread.
        [self.breakCollection reloadData];

        
        [self.view layoutIfNeeded];
        
    }];
    
   

}





-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}




/* frame level stepper to switch between each frame or match graph view */
/* last modified 20160206 */
- (IBAction)stepperChanged:(id)sender {
    
    UIStepper *stepper = sender;
    
    
    [self reloadActiveGraph];
    
    if (self.breakStatistcsView.hidden==false) {
    
    
        [self loadBreakShots:1 :false];
    
        self.graphStatisticsOverlayView.plotHighlightIndex = 1;
        if (stepper.value>0) {
            [self.graphStatisticsOverlayView loadSharedData];
            self.frameDuration = [common getFrameDuration :self.graphStatisticView.frameData];
        }
        [self.graphStatisticsOverlayView setNeedsDisplay];

        
        self.P2BreakInfo.hidden = true;
        self.p2BreakInfoBall.hidden = true;
        self.P1BreakInfo.hidden = true;
        self.p1BreakInfoBall.hidden = true;
        
        self.P1AmountBreak.hidden = false;
        self.P2AmountBreak.hidden = false;

        
    } else if (self.frameStatisticView.hidden==false) {
        [self.tableFrameStatistics reloadData];
    }
    
    if (stepper.value==0) {
        self.buttonListStats.enabled = false;
        self.buttonDetailStats.enabled = false;
    } else {
        if (self.displayState==0) {
            self.buttonListStats.enabled = true;
            self.buttonDetailStats.enabled = true;
        }
    }
    
    /*if ( self.frameStatisticView.hidden==false) {
    self.backgroundView.backgroundColor = [UIColor clearColor];
    
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleProminent];
        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        blurEffectView.frame = self.backgroundView.bounds;
        blurEffectView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self.backgroundView addSubview:blurEffectView];
    }*/
    
    
    [self updateSummaryLabelContent :self.graphSummaryLabel];
    [self updateDurationVisitLabelContent :self.DurationVisitsLabel];
    
    
    
}






/* when a single frame graph is in view, user may press the frame detail */
-(void)manageMoreBreak :(bool)toload {

    if (self.player1StatView.hidden && self.player2StatView.hidden && self.stepperFrame.value>0 && self.frameStatisticView.hidden) {
        if (!toload) {
            //self.overlayView.hidden = !self.overlayView.hidden;
            self.graphStatisticsOverlayView.hidden = !self.graphStatisticsOverlayView.hidden;
            self.background.hidden = !self.background.hidden;
            self.frameStatisticView.hidden = !self.frameStatisticView.hidden;
            self.breakStatistcsView.hidden = !self.breakStatistcsView.hidden;
             self.backgroundView.hidden = !self.backgroundView.hidden;
            
        } else {
            self.graphStatisticsOverlayView.hidden = false;
            self.background.hidden = false;
            self.breakStatistcsView.hidden = false;
            self.backgroundView.hidden = false;
        }
        self.buttonListStats.enabled = self.breakStatistcsView.hidden;
        self.MorePlayer1Button.enabled = self.breakStatistcsView.hidden;
        self.MorePlayer2Button.enabled = self.breakStatistcsView.hidden;
        
        if (self.graphStatisticsOverlayView.hidden == false) {
            
            self.tweetButton.enabled = true;
            
            
            
            [self loadBreakShots:self.breakShotsIndex :false];
            
            self.stepperFrame.minimumValue=1;
            
            if (!toload) {
                self.displayState += 4;
            }
        } else {
            
            self.player2View.hidden=false;
            self.player1View.hidden=false;
            self.graphStatisticsOverlayView.hidden = true;
            self.background.hidden = true;
            self.breakStatistcsView.hidden = true;
            self.backgroundView.hidden = true;
            
            self.graphStatisticsOverlayView.hidden=true;
            
            self.tweetButton.enabled = true;
            
            
            
            if (!toload) {
                self.displayState -= 4;
            }
            self.stepperFrame.minimumValue=0;
        }
    }
}

/* when a single frame graph is in view, user may press the frame detail */
-(void)manageMoreFrame :(bool)toload {
    
    if (self.player1StatView.hidden && self.player2StatView.hidden && self.stepperFrame.value>0) {
        if (!toload) {
            self.graphStatisticsOverlayView.hidden = !self.graphStatisticsOverlayView.hidden;
            self.background.hidden = !self.background.hidden;
            self.frameStatisticView.hidden = !self.frameStatisticView.hidden;
        } else {
            self.graphStatisticsOverlayView.hidden = false;
            self.background.hidden = false;
            self.frameStatisticView.hidden = false;
        }
        if (self.frameStatisticView.hidden==false) {
            [self.tableFrameStatistics reloadData];
        }
        self.buttonDetailStats.enabled = self.frameStatisticView.hidden;
        

        
        
        if (self.graphStatisticsOverlayView.hidden == false) {
            
            
            self.tweetButton.enabled = true;
            
            
            self.stepperFrame.minimumValue=1;
            
            if (!toload) {
                self.displayState += 8;
            }
        } else {
            
            self.player2View.hidden=false;
            self.player1View.hidden=false;
            self.graphStatisticsOverlayView.hidden = true;
            self.background.hidden = true;
            self.frameStatisticView.hidden = true;
            
            self.graphStatisticsOverlayView.hidden=true;
            
            
            self.tweetButton.enabled = false;
            
            
            if (!toload) {
                self.displayState -= 8;
            }
            self.stepperFrame.minimumValue=0;
        }
    }
    
}




/* called when user presses more button for either player or when view is loaded */
-(void)manageMorePlayer:(UIView*) playerStat :(NSNumber*)playerId :(int)displayValue :(bool) toload {
    

    if (self.graphStatisticsOverlayView.hidden) {
        [self  loadPlayerStatistics:playerId];
        if (!toload) {
            playerStat.hidden = !playerStat.hidden;
        } else {
            [self loadBreakBalls:playerId];
            playerStat.hidden = false;
        }
        if (playerStat.hidden == false) {
            if (!toload) {
                [self  loadBreakBalls:playerId];
                self.displayState += displayValue;
            }
        } else {
            if (!toload) {
                self.displayState -= displayValue;
            }
        }
    }
    self.buttonDetailStats.enabled = self.graphStatisticsOverlayView.hidden;
    self.buttonListStats.enabled = self.graphStatisticsOverlayView.hidden;

    
}





/* visit level - next */

- (IBAction)forwardButtonPressed:(id)sender {
    [self loadBreakShots:self.breakShotsIndex + 1 :false];
    if (self.breakShots.count > 0) {

        self.graphStatisticsOverlayView.plotHighlightIndex = self.breakShotsIndex;
        [self.graphStatisticsOverlayView loadSharedData];
        [self.graphStatisticsOverlayView setNeedsDisplay];
        
        
        self.P1BreakInfo.hidden = true;
        self.p1BreakInfoBall.hidden = true;
        
        self.P2BreakInfo.hidden = true;
        self.p2BreakInfoBall.hidden = true;
        
        self.P1AmountBreak.hidden = false;
        self.P2AmountBreak.hidden = false;
        
    }
}



/* visit level - previous */

- (IBAction)backButtonPressed:(id)sender {
    
    if (self.breakShotsIndex>0) {
 
        if ([self loadBreakShots :self.breakShotsIndex - 1 :false]) {;
            if (self.breakShots.count > 0) {
         
                self.graphStatisticsOverlayView.plotHighlightIndex = self.breakShotsIndex;
                [self.graphStatisticsOverlayView loadSharedData];
                [self.graphStatisticsOverlayView setNeedsDisplay];
                
                self.P1BreakInfo.hidden = true;
                self.p1BreakInfoBall.hidden = true;
                
                self.P2BreakInfo.hidden = true;
                self.p2BreakInfoBall.hidden = true;
                
                self.P1AmountBreak.hidden = false;
                self.P2AmountBreak.hidden = false;
                
            }

        }
    }
}

/* frame detail view level */


-(UIColor*) getColourFromBallName :(ballShot*) ball {
    
    
    if ([ball.colour isEqualToString:@"RED"]) {
        return self.redColour;
    } else if ([ball.colour isEqualToString:@"YELLOW"]) {
        return self.yellowColour;
    } else if ([ball.colour isEqualToString:@"GREEN"]) {
        return self.greenColour;
    } else if ([ball.colour isEqualToString:@"BROWN"]) {
        return self.brownColour;
    } else if ([ball.colour isEqualToString:@"BLUE"]) {
        return self.blueColour;
    } else if ([ball.colour isEqualToString:@"PINK"]) {
        return self.pinkColour;
    } else if ([ball.colour isEqualToString:@"BLACK"]) {
        return self.blackColour;
    } else {
         return [UIColor clearColor];
    }
}



-(void) loadBall :(ballShot*) ball :(int)currentRow {
    
    if (self.player1View.hidden==true) {
        //self.p2BreakInfoBall.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@.png",self.skinPrefix,ball.imageNameLarge]];
       
        self.p2BreakInfoBall.backgroundColor = [self getColourFromBallName:ball];
        
    } else {
        //self.p1BreakInfoBall.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@.png",self.skinPrefix,ball.imageNameLarge]];
        self.p1BreakInfoBall.backgroundColor = [self getColourFromBallName:ball];
    }
    
    if (ball.shotid==[NSNumber numberWithInt:Potted]) {
        int breakInTime=0;
        for (int i=0; i<= currentRow; i++ ) {
            ballShot *item = [self.breakShots objectAtIndex:i];
            breakInTime += [item.value intValue];
        }
         if (self.player1View.hidden==true) {
             self.P2BreakInfo.text = [NSString stringWithFormat:@"Points = %@\nSequence = %d\nBreak = %d\nTime = %@\n%@", [ball getBallShotText], currentRow+1,breakInTime, [ball.getBallDetailDTText substringFromIndex: [ball.getBallDetailDTText length] - 8], ball.getBallDetailText];
         } else {
             self.P1BreakInfo.text = [NSString stringWithFormat:@"Points = %@\nSequence = %d\nBreak = %d\nTime = %@\n%@", [ball getBallShotText], currentRow+1,breakInTime, [ball.getBallDetailDTText substringFromIndex: [ball.getBallDetailDTText length] - 8], ball.getBallDetailText];
         }

    } else {
        if (self.player1View.hidden==true) {
            self.P2BreakInfo.text = [NSString stringWithFormat:@"Points = %@\nSequence = %d\nTime = %@\n%@", [ball getBallShotText], currentRow+1, [ball.getBallDetailDTText substringFromIndex: [ball.getBallDetailDTText length] - 8], ball.getBallDetailText];
        } else {
            self.P1BreakInfo.text = [NSString stringWithFormat:@"Points = %@\nSequence = %d\nTime = %@\n%@", [ball getBallShotText], currentRow+1, [ball.getBallDetailDTText substringFromIndex: [ball.getBallDetailDTText length] - 8], ball.getBallDetailText];
        }
    }
    
    if (ball.pocketid==[NSNumber numberWithInt:0]) {
        self.snookerTable.hidden=true;
    } else {
        self.snookerTable.hidden=false;
    }
    
    if (!self.graphStatisticsOverlayView.hidden) {
    
    self.P1AmountBreak.hidden = true;
    self.P2AmountBreak.hidden = true;
    
    
    self.P1BreakInfo.hidden = false;
    self.p1BreakInfoBall.hidden = false;
    
    self.P2BreakInfo.hidden = false;
    self.p2BreakInfoBall.hidden = false;
    
    }
}



-(void)updateDurationVisitLabelContent :(UILabel*) titleInfo {
    
    
    if (self.frameDuration!=NULL || self.frameDuration!=nil) {
        titleInfo.text = [NSString stringWithFormat:@"Duration:%@\nVisits:%d/%lu",self.frameDuration, self.breakShotsIndex, (unsigned long)self.graphStatisticView.frameData.count];
    } else {
         titleInfo.text = [NSString stringWithFormat:@"Visits:%d/%lu",self.breakShotsIndex, (unsigned long)self.graphStatisticView.frameData.count];
    }
}

/* created 20160204 */
/* last modified 20160205 */

 -(void)updateSummaryLabelContent :(UILabel*) frameInfo {
 
// missing optional text if match is still ongoing
     
 NSString *data;
     
     int player1Score;
     int player2Score;
     
     if (self.stepperFrame.value==0) {
         player1Score = [self.m.Player1FrameWins intValue];
         player2Score = [self.m.Player2FrameWins intValue];
     } else {
         
         if (self.graphStatisticView.graphReferenceId == self.graphStatisticView.numberOfFrames) {
             player1Score = self.graphStatisticView.scorePlayer1+[self.p1.activeBreak intValue];
             player2Score = self.graphStatisticView.scorePlayer2+[self.p2.activeBreak intValue];
         } else {
             player1Score = self.graphStatisticView.scorePlayer1+[self.p1.activeBreak intValue];
             player2Score = self.graphStatisticView.scorePlayer2+[self.p2.activeBreak intValue];
         }
             
     }
 

     if (player1Score > player2Score) {
         //  player one has either won or is winning
         if (self.graphStatisticView.graphReferenceId == self.graphStatisticView.numberOfFrames && ([self.m.matchEndDate isEqualToString:@""] || self.m.matchEndDate==nil)) {
             
             /* we need to locate remaining points */
             data = [NSString stringWithFormat:@"%d points remain. %@ leads %@ by %d",self.activeFramePointsRemaining,self.player1Name.text,self.player2Name.text, player1Score - player2Score];
 
         } else if (self.graphStatisticView.graphReferenceId != 0) {
             data = [NSString stringWithFormat:@"%@ beat %@ by %d point(s)",self.player1Name.text,self.player2Name.text, player1Score - player2Score];
 
         } else if ([self.m.matchEndDate isEqualToString:@""] || self.m.matchEndDate==nil) {
             data = [NSString stringWithFormat:@"%@ is beating %@ by %d frame(s)" ,self.player1Name.text,self.player2Name.text, player1Score - player2Score];
             
         } else {
             data = [NSString stringWithFormat:@"%@ beat %@ by %d frame(s)" ,self.player1Name.text,self.player2Name.text, player1Score - player2Score];
             
         }
         
         frameInfo.textColor = self.skinPlayer1Colour;
 
     } else if (player2Score > player1Score) {
        //  player two has either won or is winning
         if (self.graphStatisticView.graphReferenceId == self.graphStatisticView.numberOfFrames && ([self.m.matchEndDate isEqualToString:@""] || self.m.matchEndDate==nil)) {
             
             /* we need to locate remaining points */
             
             data = [NSString stringWithFormat:@"%d points remain. %@ leads %@ by %d",self.activeFramePointsRemaining,self.player2Name.text,self.player1Name.text, player2Score - player1Score];
         } else if (self.graphStatisticView.graphReferenceId != 0) {
             data = [NSString stringWithFormat:@"%@ beat %@ by %d point(s)",self.player2Name.text,self.player1Name.text, player2Score - player1Score];
         } else if ([self.m.matchEndDate isEqualToString:@""] || self.m.matchEndDate==nil) {
             data = [NSString stringWithFormat:@"%@ is beating %@ by %d frame(s)" ,self.player2Name.text,self.player1Name.text, player2Score - player1Score];
             
         } else {
             data = [NSString stringWithFormat:@"%@ beat %@ by %d frame(s)" ,self.player2Name.text,self.player1Name.text, player2Score - player1Score];
             
         }

         
         frameInfo.textColor = self.skinPlayer2Colour;
     } else {
         // players tied
         if (self.graphStatisticView.graphReferenceId != 0) {
             if (self.activeFramePointsRemaining>0) {
                 data = [NSString stringWithFormat:@"%d remain. %@ and %@ are level",self.activeFramePointsRemaining,self.player1Name.text,self.player2Name.text];
             } else {
                 data = [NSString stringWithFormat:@"%@ and %@ are level",self.player1Name.text,self.player2Name.text];
             }
         } else {
             // general text to fit both cases of match completed and current
             data = [NSString stringWithFormat:@"%@ and %@ are tied",self.player1Name.text,self.player2Name.text];
         }
         //player 1 colour
         frameInfo.textColor = [UIColor colorWithRed:255.0/255.0 green:204.0/255.0 blue:0.0/255.0 alpha:1];
 
     }
     frameInfo.text = data;
 }






- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.graphStatisticView.frameDataReversed count] ;
}



- (frameStatisticCellTVC *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"frameVisitCell";
    
    frameStatisticCellTVC *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[frameStatisticCellTVC alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    
    breakEntry *entry = [self.graphStatisticView.frameDataReversed objectAtIndex:indexPath.row];
    cell.balls = entry.shots;
    
    cell.scoreLabel.text = [NSString stringWithFormat:@"%@",entry.points];
    
    NSLog(@"Number test:%@ %@",entry.lastshotid, [NSNumber numberWithInt:Bonus]);
    
    /* normal text within cell */
    if(entry.playerid==[NSNumber numberWithInt:1]) {
        cell.playerLabel.text = self.p1.nickName;
        cell.cellContentView.backgroundColor = self.skinPlayer1Colour;
    } else if(entry.playerid==[NSNumber numberWithInt:2]) {
        cell.playerLabel.text = self.p2.nickName;
        cell.cellContentView.backgroundColor = self.skinPlayer2Colour;
    } else {
        cell.playerLabel.text = @"Adjustment";
        cell.cellContentView.backgroundColor = self.skinBackgroundColour;
    }
    if ([entry.duration intValue]!=0 || entry.duration!=nil) {
        cell.durationLabel.text = [NSString stringWithFormat:@"%@ s.",entry.duration];
    }
    /* indicator icon/white ball for fouls */
    if (entry.lastshotid==[NSNumber numberWithInt:Foul] || entry.lastshotid==[NSNumber numberWithInt:Bonus] ) {
        cell.visitIndictorView.hidden = false;
        if (entry.lastshotid==[NSNumber numberWithInt:Foul]) {
            cell.visitIndicatorIcon.text = @"!";
        }
        else {
            cell.visitIndicatorIcon.text = @"+";
        }
        
    } else {
        cell.visitIndictorView.hidden = true;
    }
 
    [cell.frameBallCollectionView reloadData];
    
    
    cell.collectionHeightConstraint.constant = cell.frameBallCollectionView.collectionViewLayout.collectionViewContentSize.height;
    
    
    return cell;
}


-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*) indexPath
{
    static NSString *CellIdentifier = @"frameVisitCell";
    
    frameStatisticCellTVC *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[frameStatisticCellTVC alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }

    breakEntry *entry = [self.graphStatisticView.frameDataReversed objectAtIndex:indexPath.row];
    cell.balls = entry.shots;

    [cell.frameBallCollectionView reloadData];
    
    
    cell.collectionHeightConstraint.constant = cell.frameBallCollectionView.collectionViewLayout.collectionViewContentSize.height;
    

    return cell.frameBallCollectionView.collectionViewLayout.collectionViewContentSize.height + 50;
    
}



/* manage the display state of the view components */
- (IBAction)buttonMorePlayer1Pressed:(id)sender {
    [self presentPlayer1Stats:1];
}

/* last modified 20161211 */
-(void)presentPlayer1Stats:(int)adjustment {
    
    if (self.player1StatView.hidden) {
        [self  loadPlayerStatistics:[NSNumber numberWithInt:1]];
        [self loadBreakBalls:[NSNumber numberWithInt:1]];
        self.buttonListStats.enabled=false;
        self.buttonDetailStats.enabled=false;
        
        self.displayState += adjustment;
    } else {
        if (self.player2StatView.hidden)  {
            self.buttonListStats.enabled=true;
            self.buttonDetailStats.enabled=true;
            
        }
         self.displayState -= adjustment;
    }
    if (self.breakStatistcsView.hidden==true && self.frameStatisticView.hidden==true) {
     
        self.player1StatView.hidden = !self.player1StatView.hidden;
        
    }
}

- (IBAction)buttonMorePlayer2Pressed:(id)sender {
    [self presentPlayer2Stats:2];
}

/* last modified 20161211 */
-(void)presentPlayer2Stats:(int)adjustment {

    if (self.player2StatView.hidden) {
        [self loadPlayerStatistics:[NSNumber numberWithInt:2]];
        [self loadBreakBalls:[NSNumber numberWithInt:2]];
        
        
        
        self.buttonListStats.enabled=false;
        self.buttonDetailStats.enabled=false;
        
        self.displayState += adjustment;
    } else {
        if (self.player1StatView.hidden)  {
            self.buttonListStats.enabled=true;
            self.buttonDetailStats.enabled=true;
            
        }
        self.displayState -= adjustment;
    }
    if (self.breakStatistcsView.hidden==true && self.frameStatisticView.hidden==true) {
        self.player2StatView.hidden = !self.player2StatView.hidden;
    }
}


/* created 20161108 */
- (IBAction)frameStatisticsPressed:(id)sender {
    [self presentFrameStats:4];
}

-(void)presentFrameStats:(int)adjustment {
    
    if (self.frameStatisticView.hidden) {
        
        self.MorePlayer1Button.enabled = false;
        self.MorePlayer2Button.enabled = false;
        self.buttonDetailStats.enabled = false;
        self.stepperFrame.minimumValue=1;
        [self.tableFrameStatistics reloadData];
        self.displayState += adjustment;
    } else {
       
        self.MorePlayer1Button.enabled = true;
        self.MorePlayer2Button.enabled = true;
        self.buttonDetailStats.enabled = true;
        self.stepperFrame.minimumValue=0;
        self.displayState -= adjustment;
    }
    
    if (self.player2StatView.hidden && self.self.player1StatView.hidden && self.stepperFrame.value>0 && self.breakStatistcsView.hidden) {
        self.frameStatisticView.hidden=!self.frameStatisticView.hidden;

    }
}

- (IBAction)breakStatisticsPressed:(id)sender {
    [self presentBreakStats:8];
}

-(void)presentBreakStats:(int)adjustment {
    if (self.breakStatistcsView.hidden) {
        [self loadBreakShots:self.breakShotsIndex :false];
        self.tweetButton.enabled = true;
       
        self.MorePlayer1Button.enabled = false;
        self.MorePlayer2Button.enabled = false;
        self.buttonListStats.enabled = false;
        self.stepperFrame.minimumValue=1;
        self.displayState += adjustment;
    } else {
        self.tweetButton.enabled = false;
        
        self.MorePlayer1Button.enabled = true;
        self.MorePlayer2Button.enabled = true;
        self.buttonListStats.enabled = true;
        self.player2View.hidden=false;
        self.player1View.hidden=false;
        self.stepperFrame.minimumValue=0;
        self.displayState -= adjustment;
    }
    if (self.player1StatView.hidden && self.player2StatView.hidden && self.stepperFrame.value>0 && self.frameStatisticView.hidden) {
        self.breakStatistcsView.hidden=!self.breakStatistcsView.hidden;
        self.backgroundView.hidden =!self.backgroundView.hidden;
        self.graphStatisticsOverlayView.hidden=!self.graphStatisticsOverlayView.hidden;
    }
}


- (void)addItemViewController:(embededMatchStatisticsVC *)controller keepDisplayState:(int)displayState {
    
}

- (IBAction)tweetButtonPressed:(id)sender {
/* tweet break selected */

 UIImage *image;
 
 image = [self imageWithCollectionView :self.breakCollection];
 
 if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
 {
     SLComposeViewController *tweetSheetOBJ = [SLComposeViewController
                                               composeViewControllerForServiceType:SLServiceTypeTwitter];
     
     //breakshotsplayerid
     NSString *nickname;
     
     if (self.breakShotsPlayerId==[NSNumber numberWithInt:1]) {
         nickname = self.p1.nickName;
     } else {
         nickname = self.p2.nickName;
     }
     [tweetSheetOBJ setInitialText: [NSString stringWithFormat:@"%@ nice Break of %@! @snookerscorem #snooker #scoreboard",nickname,self.breakShotsPoints ]];
     [tweetSheetOBJ addImage:image];
     [self presentViewController:tweetSheetOBJ animated:YES completion:nil];
 }

}



@end
