//
//  matchListingTVC.m
//  SnookerScoreMaster
//
//  Created by andrew glew on 14/01/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import "matchListingTVC.h"
#import "matchCellTVC.h"
#import "matchStatisticsVC.h"

@interface matchListingTVC () <PlayerDelegate, MatchStatisticsDelegate, UITableViewDelegate, UITableViewDataSource>

@end

@implementation matchListingTVC
@synthesize matches;
@synthesize db;
@synthesize delegate;
@synthesize activePlayer;


-(void)viewWillAppear :(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:YES animated:YES];
    self.navigationController.view.backgroundColor = [UIColor clearColor];
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
    
    if (([m.Player1Number intValue]  == self.staticPlayer1Number && [m.Player2Number intValue] == self.staticPlayer2Number)) {
        cell.contentView.superview.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    } else {
        cell.contentView.superview.backgroundColor = [UIColor whiteColor];
    }
    
    
    cell.Player1Name.text = m.player1Name;
    cell.Player2Name.text = m.player2Name;
    cell.Player1Number = m.Player1Number;
    cell.Player2Number = m.Player2Number;
    cell.matchDuration.text = m.matchDuration;
    
    if (self.activeMatchId == m.matchid) {
        cell.Player1HiBreak.text = [NSString stringWithFormat:@"%@",self.activeMatchPlayers.Player1HiBreak];
        cell.Player2HiBreak.text = [NSString stringWithFormat:@"%@",self.activeMatchPlayers.Player1HiBreak];
        cell.Player1FrameWins .text = [NSString stringWithFormat:@"%@",self.activeMatchPlayers.Player1FrameWins];
        cell.Player2FrameWins.text = [NSString stringWithFormat:@"%@",self.activeMatchPlayers.Player2FrameWins];
    } else {
    
        cell.Player1HiBreak.text = [NSString stringWithFormat:@"%@",m.Player1HiBreak];
        cell.Player2HiBreak.text = [NSString stringWithFormat:@"%@",m.Player2HiBreak];
        cell.Player1FrameWins.text = [NSString stringWithFormat:@"%@",m.Player1FrameWins];
        cell.Player2FrameWins.text = [NSString stringWithFormat:@"%@",m.Player2FrameWins];
    }
    
    
    cell.matchDate.text = [NSString stringWithFormat:@"%@",[self relativeDateStringForDate  :m.matchDate]];
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
    
    
    cell.player1Photo.layer.borderWidth=3.0f;
    
    cell.player1Badge.layer.cornerRadius = 15;
    
    cell.player2Photo.frame = CGRectMake(cell.player2Photo.frame.origin.x, cell.player2Photo.frame.origin.y, 75, 75);
    cell.player2Photo.clipsToBounds = YES;
    cell.player2Photo.layer.cornerRadius = 75/2.0f;
    
    cell.player2Photo.layer.borderColor=[UIColor orangeColor].CGColor;
    cell.player2Photo.layer.borderWidth=3.0f;
    cell.player2Badge.layer.cornerRadius = 15;

    
    
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




/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


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
    }  
    
    
    
    //matchliststatistics
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
    
    if (([m.Player1Number intValue]  == self.staticPlayer1Number && [m.Player2Number intValue] == self.staticPlayer2Number)) {
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
        [self.db deleteWholeMatchData:m.matchid];
        [self.matches removeObjectAtIndex:indexPath.row];
        [tableView reloadData]; // tell table to refresh now
    }
}


- (void)addItemViewController:(embededMatchStatisticsVC *)controller keepDisplayState:(int)displayState {
    self.displayState = displayState;
}


@end
