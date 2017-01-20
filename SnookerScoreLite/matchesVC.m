//
//  matchListingTVC.m
//  SnookerScoreMaster
//
//  Created by andrew glew on 14/01/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import "matchesVC.h"
#import "matchCellTVC.h"
#import "matchStatisticsVC.h"

@interface matchesVC () <PlayerDelegate, MatchStatisticsDelegate, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate>

@end

@implementation matchesVC
@synthesize matches;
@synthesize db;
@synthesize delegate;
@synthesize activePlayer;


-(void)viewWillAppear :(BOOL)animated {
    [super viewWillAppear:animated];
    
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    [self.navigationController setToolbarHidden:YES animated:YES];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage =[UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];

    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
}

/* last modified 20160205 */
- (void)viewDidLoad {
    [super viewDidLoad];
    self.activePlayer = [self.db getPlayerByPlayerNumber :self.activePlayerNumber];
    self.matches = [self.db findAllMatches];
    self.title = @"";
    self.navigationItem.title = @"Matches";
    // to be removed
    self.cachedImages = [[NSMutableDictionary alloc] init];
    
    self.cachedAvatarP1 = [[NSMutableDictionary alloc] init];
    self.cachedAvatarP2 = [[NSMutableDictionary alloc] init];
    
    [self.tableView reloadData];
    
    //UIImage *changecolourimage = [[UIImage imageNamed:@"export2"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    //[self.exportButton setImage:changecolourimage forState:UIControlStateNormal];
    self.exportButton.tintColor = [UIColor whiteColor];
    [self.exportButton setTitle:@"Set Export Mode" forState:UIControlStateNormal];
    [self.exportButton setBackgroundColor:[UIColor darkGrayColor]];
    
    
    self.view.backgroundColor = self.skinBackgroundColour;
    self.tableView.backgroundColor = self.skinBackgroundColour;
    
    self.selectionStyleHighlight=1;
  
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.matches.count;
}

/* last modified 20160204 */





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"matchrow";
    
    matchCellTVC *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[matchCellTVC alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    //Here the dataSource array is of dictionary objects
    match *m = [self.matches objectAtIndex:indexPath.row];
    /*
    if (([m.Player1Number intValue]  == self.staticPlayer1Number && [m.Player2Number intValue] == self.staticPlayer2Number)) {
        //cell.contentView.superview.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    } else {
        //cell.contentView.superview.backgroundColor = [UIColor whiteColor];
    }
    */
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor clearColor];
    [cell setSelectedBackgroundView:bgColorView];
    
    
    
    if ([m.matchDuration isEqualToString:@"match ongoing"]) {
        cell.userInteractionEnabled = NO;
    } else {
        cell.userInteractionEnabled = YES;
    }
  /*
    if (self.selectionStyleHighlight==1) {
        [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
    }
    else
    {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    */
    
    cell.Player1Name.text = m.player1Name;
    cell.Player1Name.textColor = self.skinForegroundColour;
    cell.Player2Name.text = m.player2Name;
    cell.Player2Name.textColor = self.skinForegroundColour;
    cell.Player1Number = m.Player1Number;
    
    cell.Player2Number = m.Player2Number;
    cell.matchDuration.text = m.matchDuration;
    cell.matchDuration.textColor = self.skinForegroundColour;
    
    if (self.activeMatchId == m.matchid) {
        cell.Player1HiBreak.text = [NSString stringWithFormat:@"%@",self.activeMatchPlayers.Player1HiBreak];
        cell.Player1HiBreak.textColor = self.skinBackgroundColour;
        cell.Player2HiBreak.text = [NSString stringWithFormat:@"%@",self.activeMatchPlayers.Player1HiBreak];
        cell.Player2HiBreak.textColor = self.skinBackgroundColour;
        cell.Player1FrameWins .text = [NSString stringWithFormat:@"%@",self.activeMatchPlayers.Player1FrameWins];
        cell.Player1FrameWins.textColor = self.skinForegroundColour;
        cell.Player2FrameWins.text = [NSString stringWithFormat:@"%@",self.activeMatchPlayers.Player2FrameWins];
        cell.Player2FrameWins.textColor = self.skinForegroundColour;
    } else {
        
        cell.Player1HiBreak.text = [NSString stringWithFormat:@"%@",m.Player1HiBreak];
        cell.Player1HiBreak.textColor = self.skinBackgroundColour;
        cell.Player2HiBreak.text = [NSString stringWithFormat:@"%@",m.Player2HiBreak];
        cell.Player2HiBreak.textColor = self.skinBackgroundColour;
        cell.Player1FrameWins.text = [NSString stringWithFormat:@"%@",m.Player1FrameWins];
        cell.Player1FrameWins.textColor = self.skinForegroundColour;
        cell.Player2FrameWins.text = [NSString stringWithFormat:@"%@",m.Player2FrameWins];
        cell.Player2FrameWins.textColor = self.skinForegroundColour;
    }
    
    
    cell.matchDate.text = [NSString stringWithFormat:@"%@",[self relativeDateStringForDate  :m.matchDate]];
    cell.matchDate.textColor = self.skinBackgroundColour;
    [cell.matchDate setPersistentBackgroundColor:self.skinForegroundColour];
    cell.framesWonLabel.textColor= self.skinForegroundColour;
    cell.matchEndDate = [NSString stringWithFormat:@"%@",[self relativeDateStringForDate  :m.matchEndDate]];
    
    cell.MatchId = m.matchid;
    
    
    if ([cell.Player1HiBreak.text isEqualToString:@"0"]) {
        [cell.player1Badge setHidden:YES];
    } else {
        [cell.player1Badge setHidden:NO];
    }
    
    if ([cell.Player2HiBreak.text isEqualToString:@"0"]) {
        [cell.player2Badge setHidden:YES];
    } else {
        [cell.player2Badge setHidden:NO];
    }
    
    cell.layer.shouldRasterize = true;
    [cell.layer setRasterizationScale:[[UIScreen mainScreen] scale]];
    
    
    NSString *identifier1 = [NSString stringWithFormat:@"Avatar1%ld" ,
                             (long)indexPath.row];
    NSString *identifier2 = [NSString stringWithFormat:@"Avatar2%ld" ,
                             (long)indexPath.row];
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    
    if([self.cachedImages objectForKey:identifier1] != nil){
        cell.player1Photo.image = [self.cachedImages valueForKey:identifier1];
        cell.player2Photo.image = [self.cachedImages valueForKey:identifier2];
    }else{
        
        
        
        cell.player1Photo.image = nil;
        char const * s = [identifier1 UTF8String];
        dispatch_queue_t queue = dispatch_queue_create(s, 0);
        dispatch_async(queue, ^{
            UIImage *img = nil;
            
            NSData *data;
            data = [NSData dataWithContentsOfFile:[[paths objectAtIndex:0] stringByAppendingPathComponent:m.player1PhotoLocation]];
            img = [[UIImage alloc] initWithData:data];
            
            if (img==nil) {
                img = [UIImage imageNamed:@"avatar0"];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([tableView indexPathForCell:cell].row == indexPath.row) {
                    [self.cachedImages setValue:img forKey:identifier1];
                    cell.player1Photo.image = [self.cachedImages valueForKey:identifier1];
                }
            });
        });
        
        cell.player2Photo.image = nil;
        s = [identifier1 UTF8String];
        queue = dispatch_queue_create(s, 0);
        dispatch_async(queue, ^{
            UIImage *img = nil;
            
            NSData *data;
            data = [NSData dataWithContentsOfFile:[[paths objectAtIndex:0] stringByAppendingPathComponent:m.player2PhotoLocation]];
            img = [[UIImage alloc] initWithData:data];
            
            if (img==nil) {
                img = [UIImage imageNamed:@"avatar0"];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([tableView indexPathForCell:cell].row == indexPath.row) {
                    [self.cachedImages setValue:img forKey:identifier2];
                    cell.player2Photo.image = [self.cachedImages valueForKey:identifier2];
                }
            });
        });
        
    }
    return cell;
}




- (void)tableView:(UITableView *)tableView willDisplayCell:(matchCellTVC *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    match *m = [self.matches objectAtIndex:indexPath.row];
    
    cell.m = m;
    
    cell.player1Photo.frame = CGRectMake(cell.player1Photo.frame.origin.x, cell.player1Photo.frame.origin.y, 75, 75);
    cell.player1Photo.clipsToBounds = YES;
    cell.player1Photo.layer.cornerRadius = 75/2.0f;
    
    
    cell.player1Photo.layer.borderWidth=1.5f;
    
    cell.player1Badge.layer.cornerRadius = 15;
    
    cell.player2Photo.frame = CGRectMake(cell.player2Photo.frame.origin.x, cell.player2Photo.frame.origin.y, 75, 75);
    cell.player2Photo.clipsToBounds = YES;
    cell.player2Photo.layer.cornerRadius = 75/2.0f;
    
    cell.player2Photo.layer.borderColor=[UIColor orangeColor].CGColor;
    cell.player2Photo.layer.borderWidth=1.5f;
    cell.player2Badge.layer.cornerRadius = 15;
    
    cell.backgroundColor = self.skinBackgroundColour;
 
    cell.tintColor = self.skinForegroundColour;
    
    if (m.Player1FrameWins > m.Player2FrameWins) {
        
        cell.player1Photo.layer.borderColor=[UIColor colorWithRed:76.0/255.0 green:217.0/255.0 blue:100.0/255.0 alpha:1].CGColor;
        cell.player2Photo.layer.borderColor=[UIColor colorWithRed:255.0/255.0 green:59.0/255.0 blue:48.0/255.0 alpha:1].CGColor;
        
        
    } else if (m.Player1FrameWins < m.Player2FrameWins) {
        
        cell.player1Photo.layer.borderColor=[UIColor colorWithRed:255.0/255.0 green:59.0/255.0 blue:48.0/255.0 alpha:1].CGColor;
        cell.player2Photo.layer.borderColor=[UIColor colorWithRed:76.0/255.0 green:217.0/255.0 blue:100.0/255.0 alpha:1].CGColor;
        
    } else {
        cell.player1Photo.layer.borderColor=[UIColor colorWithRed:255.0/255.0 green:204.0/255.0 blue:0.0/255.0 alpha:1].CGColor;
        cell.player2Photo.layer.borderColor=[UIColor colorWithRed:255.0/255.0 green:204.0/255.0 blue:0.0/255.0 alpha:1].CGColor;
        
    }
    
    
}




#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    
    
    if([segue.identifier isEqualToString:@"matchliststatistics"]) {
        matchStatisticsVC *controller = (matchStatisticsVC *)segue.destinationViewController;
        controller.delegate = self;
        
        player *p1 = [self.db getPlayerByPlayerNumber:[sender Player1Number]];
        player *p2 = [self.db getPlayerByPlayerNumber:[sender Player2Number]];
        
        controller.p1 = p1;
        
        controller.p2 = p2;
        controller.m = [sender m];
        
        if (controller.m.matchid== self.activeMatchId) {
            if (p1.playerNumber == [NSNumber numberWithInt:self.staticPlayer1Number]) {
                p1.activeBreak = [NSNumber numberWithInt:self.staticPlayer1CurrentBreak];
                
            } else if (p1.playerNumber == [NSNumber numberWithInt:self.staticPlayer2Number]) {
                p1.activeBreak = [NSNumber numberWithInt:self.staticPlayer2CurrentBreak];
                
            }
            
            if (p2.playerNumber == [NSNumber numberWithInt:self.staticPlayer1Number]) {
                p2.activeBreak = [NSNumber numberWithInt:self.staticPlayer1CurrentBreak];
                
            } else if (p2.playerNumber == [NSNumber numberWithInt:self.staticPlayer2Number]) {
                p2.activeBreak = [NSNumber numberWithInt:self.staticPlayer2CurrentBreak];
                
            }
        }
        controller.activeMatchPlayers =self.activeMatchPlayers;
        controller.activeMatchStatistcsShown = false;
        controller.displayState = self.displayState;
        controller.skinPrefix = self.skinPrefix;
        controller.activeFramePointsRemaining = self.activeFramePointsRemaining;
        controller.db = self.db;
        controller.skinForegroundColour = self.skinForegroundColour;
        controller.skinBackgroundColour = self.skinBackgroundColour;
        controller.skinPlayer1Colour = self.skinPlayer1Colour;
        controller.skinPlayer2Colour = self.skinPlayer2Colour;
    }
    
    
    
    //matchliststatistics
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    return !self.tableView.isEditing;
}


- (NSString *)relativeDateStringForDate:(NSString *)wanteddate
{
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    //2016-01-17 00:19:20
    // [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSDate *dateFromString = [[NSDate alloc] init];
    // voila!
    dateFromString = [dateFormatter dateFromString:wanteddate];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEE, d MMM, yyyy h:mm a"];
    
    return [formatter stringFromDate:dateFromString];
    
}



- (void)addItemViewController:(playerDetailVC *)controller didInsertPlayer :(int)nextPlayerNumber :(NSString*) playerName :(NSString*) playerEmail :(NSString*) playerImageName :(bool)photoUpdated :(NSString*) playerkey {
}

- (void)addItemViewController:(playerListingVC *)controller loadPlayerDetails :(player*) playerSelected {
    
    // empty
}

- (void)addItemViewController:(playerDetailVC *)controller didUpdatePlayer :(NSNumber*) newPlayerNumber :(int)playerId :(NSString*) playerName :(NSString*) playerEmail :(NSString*) playerImageName :(bool)photoUpdated {
    
    // not used in this class
}





- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    //Here the dataSource array is of dictionary objects
    match *m = [self.matches objectAtIndex:indexPath.row];
    
    if ([m.matchDuration isEqualToString:@"match ongoing"]) {
        // nothing to do here
        return NO;
    } else {
        return YES;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Here the dataSource array is of dictionary objects
    match *m = [self.matches objectAtIndex:indexPath.row];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if (([m.Player1Number intValue]  == self.staticPlayer1Number && [m.Player2Number intValue] == self.staticPlayer2Number)) {
            // cannot delete items
        }
        else {
            [self.db deleteWholeMatchData:m.matchid];
            [self.matches removeObjectAtIndex:indexPath.row];
            [tableView reloadData]; // tell table to refresh now
        }
        
    }
}




- (void)addItemViewController:(embededMatchStatisticsVC *)controller keepDisplayState:(int)displayState {
    self.displayState = displayState;
}


/* created      20160717
 last modified  20170113
 */

- (IBAction)cancelExportPressed:(id)sender {
    [self.tableView setEditing:FALSE animated:true];
    self.exportButton.tintColor = [UIColor whiteColor];
      [self.exportButton setTitle:@"Set Export Mode" forState:UIControlStateNormal];
    [self.exportButton setBackgroundColor:[UIColor darkGrayColor]];
    [self.exportButton setSelected:false];
    self.cancelExportButton.hidden=true;
     self.selectionStyleHighlight=0;
}

/*
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if (self.selectionStyleHighlight==1) {
     [cell setSelectionStyle:UITableViewCellSelectionStyleDefault];
        
        
    } else {
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
       
        
    }
}
*/


/* created      20160717
 last modified  20160717
 */
- (IBAction)exportPressed:(UIButton*)sender {
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    //need to sort out selection
    
    
    
    sender.selected =!sender.selected;
    
    if (sender.selected==true) {
        
        
        [self.tableView setEditing:sender.selected animated:true];
        
        
       // UIImage *changecolourimage = [[UIImage imageNamed:@"export2"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
       // [self.exportButton setImage:changecolourimage forState:UIControlStateNormal];
        [self.exportButton setTitle:@"Export Selected" forState:UIControlStateNormal];
        [self.exportButton setBackgroundColor:[UIColor darkGrayColor]];
        self.exportButton.tintColor = [UIColor lightGrayColor];
        
        self.cancelExportButton.hidden=false;
        self.selectionStyleHighlight=1;
        
    } else {
        
        
        
        NSArray *rowsSelectedForExport = [self.tableView indexPathsForSelectedRows];
        BOOL selectedRows = rowsSelectedForExport.count > 0;
        
        if (selectedRows && rowsSelectedForExport.count<50)
        {
            BOOL ok = [MFMailComposeViewController canSendMail];
            if (!ok) return;
            
            
            NSString *body = [NSString stringWithFormat:@"%lu Matches for export from Snooker Score Master Application",(unsigned long)rowsSelectedForExport.count];
            
            MFMailComposeViewController* snookerScorerMailComposer = [MFMailComposeViewController new];
            snookerScorerMailComposer.mailComposeDelegate = self;
            [snookerScorerMailComposer setSubject:@"Snooker Score Master - Export"];
            
            //[snookerScorerMailComposer setToRecipients:[NSArray arrayWithObjects:self.p1.emailAddress, self.p2.emailAddress, nil]];
            
            [snookerScorerMailComposer setMessageBody:body isHTML:YES];

           
            int attachmentIndex = 0;
            for (NSIndexPath *selectionIndex in rowsSelectedForExport)
            {
                
                attachmentIndex++;
                
                match *m = [self.matches objectAtIndex:selectionIndex.row];
            
                player *p1 = [self.db getPlayerByPlayerNumber:m.Player1Number];
                player *p2 = [self.db getPlayerByPlayerNumber:m.Player2Number];
                
                self.exportMatchData = [self.db entriesRetreive:m.matchid :nil :nil :nil :nil :nil :nil :false];

                NSString *filecontent = [self exportDataFile :self.exportMatchData :m :p1 :p2];

                NSFileManager *fileManager = [NSFileManager defaultManager];
                
                NSString *filePathSSM = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"MatchData.ssm"];
            
                
                [fileManager removeItemAtPath:filePathSSM error:nil];
         
                NSError *error;
            
                [filecontent writeToFile:filePathSSM atomically:YES encoding:NSUTF8StringEncoding error:&error];
            
            
            
                /* attach files */
                NSData *ssmFile = [NSData dataWithContentsOfFile:filePathSSM];
                [snookerScorerMailComposer addAttachmentData:ssmFile
                                                mimeType:@"text/plain"
                                                    fileName:[NSString stringWithFormat:@"MatchData%d.ssm",attachmentIndex]];
            
                [self presentViewController:snookerScorerMailComposer animated:YES completion:nil];
            
                NSLog(@"%ld",(long)selectionIndex.row);
            }
            
            [self presentViewController:snookerScorerMailComposer animated:YES completion:nil];
            
           
        }
        [self setEditing:sender.selected animated:true];
       // UIImage *changecolourimage = [[UIImage imageNamed:@"export2"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        //[self.exportButton setImage:changecolourimage forState:UIControlStateNormal];
          [self.exportButton setTitle:@"Set Export Mode" forState:UIControlStateNormal];
        self.exportButton.tintColor = [UIColor grayColor];
        self.cancelExportButton.hidden=true;
        self.selectionStyleHighlight=0;
    }
    
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}


/* export file functions */

/* created 20151012 */
/* last modified 20170119 */
-(NSString*) exportDataFile :(NSMutableArray*) matchDataSet :(match*) m :(player*) p1 :(player*) p2 {
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *exportDate = [dateFormatter stringFromDate:date];
    
    
    NSString *fileData = [NSString stringWithFormat:@"%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@",m.matchkey, p1.nickName, m.Player1FrameWins, m.Player1HiBreak, p1.playerkey, p2.nickName, m.Player2FrameWins, m.Player2HiBreak, p2.playerkey,exportDate, m.matchDate, m.matchEndDate];
    
    int tempFrameid=1;
    NSNumber *frameIdx = [NSNumber numberWithInt:0];
    int tempEntryid=0;
    
    for (breakEntry *data in matchDataSet) {
        
        if (frameIdx != data.frameid) {
            tempFrameid ++;
            frameIdx = data.frameid;
            NSMutableArray *startDate = [self.db entriesRetreive:m.matchid :nil :frameIdx :nil :nil :nil :nil :false];
            breakEntry *tempEntry = [[breakEntry alloc] init];
            tempEntry = [startDate objectAtIndex:0];
            fileData = [NSString stringWithFormat:@"%@\n%@;%@;%@;%@;%@;%@;%@;%@;%@;%@;%@",fileData, tempEntry.entryid,tempEntry.endbreaktimestamp,tempEntry.frameid,@"0",@"0",@"0",@"0",@"FS",@"0",@"0",@"0"];
        }
        
        int potIndex = 0;
        
        NSString *duration;
        
        
        duration = [NSString stringWithFormat:@"%@",data.duration];
        
        for (ballShot *ball in data.shots) {
            int ballPoint;
            ballPoint = [ball.value intValue];
            NSNumber *shotDetail1;
            NSNumber *shotDetail2;

            
            if (ball.shotid == [NSNumber numberWithInt:Potted]) {
                shotDetail1 = ball.distanceid;
                shotDetail2 = ball.effortid;
            } else if (ball.shotid == [NSNumber numberWithInt:Foul]) {
                shotDetail1 = ball.foulid;
                shotDetail2 = [NSNumber numberWithInt:0];
            } else if (ball.shotid == [NSNumber numberWithInt:Missed]) {
                shotDetail1 = ball.distanceid;
                shotDetail2 = ball.effortid;
            } else if (ball.shotid == [NSNumber numberWithInt:Safety]) {
                shotDetail1 = ball.safetyid;
                shotDetail2 = [NSNumber numberWithInt:0];
            } else if (ball.shotid == [NSNumber numberWithInt:Bonus]) {
                shotDetail1 = ball.foulid;
                shotDetail2 =[NSNumber numberWithInt:0];
            }  else if (ball.shotid == [NSNumber numberWithInt:Adjustment]) {
                shotDetail1 = ball.foulid;
                shotDetail2 = [NSNumber numberWithInt:0];
            }
            
            fileData = [NSString stringWithFormat:@"%@\n%@;%@;%@;%@;%@;%@;%@;%@;%d;%@;%@",fileData, data.entryid, data.endbreaktimestamp,data.frameid,data.playerid,ball.shotid,shotDetail1,shotDetail2,ball.colour,ballPoint,ball.shottimestamp,duration];
            
            duration=@"";
            
            potIndex ++;
            
        }
        tempEntryid = [data.entryid intValue];
    }
    
    frameIdx = [NSNumber numberWithInt:tempFrameid];
    
    fileData = [NSString stringWithFormat:@"%@\n%d;%@;%@;%@;%@;%@;%@;%@;%@;%@",fileData, tempEntryid+1 ,[dateFormatter stringFromDate:[NSDate date]],frameIdx,@"0",@"0",@"0",@"0",@"ME",@"0",@"0"];
    
    
    return fileData;
}







@end
