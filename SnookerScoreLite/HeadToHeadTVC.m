//
//  HeadToHeadTVC.m
//  SnookerScoreMaster
//
//  Created by andrew glew on 12/01/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import "HeadToHeadTVC.h"
#import "HeadToHeadCellTVC.h"



@interface HeadToHeadTVC () <PlayerDelegate>

@end

@implementation HeadToHeadTVC
@synthesize opponents;
@synthesize db;
@synthesize delegate;
@synthesize activePlayer;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.activePlayer = [self.db getPlayerByPlayerNumber :self.activePlayerNumber];
    self.opponents = [self.db findAllPlayers :[NSNumber numberWithInt:2] :self.activePlayerNumber];
    self.title = @"";
    self.navigationItem.title = @"HeadToHead";
    self.cachedImages = [[NSMutableDictionary alloc] init];
    
    [self.tableView reloadData];

}

-(void)viewWillAppear :(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:YES animated:YES];
    self.navigationController.view.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
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
    return [self.opponents count];
}


/* last modified 20160204 */

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"headtohead";

    HeadToHeadCellTVC *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[HeadToHeadCellTVC alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    //Here the dataSource array is of dictionary objects
    player *p = [self.opponents objectAtIndex:indexPath.row];
    
    if (([p.playerNumber intValue]  == self.staticPlayer1Number && [self.activePlayer.playerNumber intValue] == self.staticPlayer2Number) ||([p.playerNumber intValue]  == self.staticPlayer2Number && [self.activePlayer.playerNumber intValue] == self.staticPlayer1Number) ) {

        cell.contentView.superview.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    } else {
        cell.contentView.superview.backgroundColor = [UIColor whiteColor];
    }
    
    int winsRemainder = 100 - [p.playerWinsPC intValue];
    self.activePlayer.playerWinsPC = [NSNumber numberWithInt:winsRemainder];
    
    cell.selectedName.text = self.activePlayer.nickName;
    cell.selectedNumber = self.activePlayer.playerNumber;
    cell.selectedHiBreak.text = [NSString stringWithFormat:@"%@",p.selectedHiBreak];
    
    cell.selectedWinPC.text = [NSString stringWithFormat:@"%@",p.playerMatchLosses];
    
    
    cell.opponentName.text = p.nickName;
    cell.opponentNumber = p.playerNumber;
    cell.opponentHiBreak.text = [NSString stringWithFormat:@"%@",p.hiBreak];
    
    
    cell.opponentWinPC.text = [NSString stringWithFormat:@"%@",p.playerMatchWins];
    
    cell.HeadToHeadMatches.text = [NSString stringWithFormat:@"matches %@",p.playerMatchCount];
    
    if ([cell.opponentWinPC.text isEqualToString:@"-1%"]) {
        [cell.opponentWinPC setHidden:YES];
        [cell.selectedWinPC setHidden:YES];
    } else {
        [cell.opponentWinPC setHidden:NO];
        [cell.selectedWinPC setHidden:NO];
    }
    
    
    if ([cell.opponentHiBreak.text isEqualToString:@"0"]) {
        [cell.opponentBadge setHidden:YES];
    } else {
        [cell.opponentBadge setHidden:NO];
    }
    
    if ([cell.selectedHiBreak.text isEqualToString:@"0"]) {
        [cell.selectedBadge setHidden:YES];
    } else {
        [cell.selectedBadge setHidden:NO];
    }
   
    NSString *identifier = [NSString stringWithFormat:@"Cell%ld" ,
                            (long)indexPath.row];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    

    AvatarV *avOpponent = [[AvatarV alloc] initWithFrame:CGRectMake(0, 0, 75.0, 75.0)];
    AvatarV *avSelected = [[AvatarV alloc] initWithFrame:CGRectMake(0, 0, 75.0, 75.0)];

    if([self.cachedImages objectForKey:identifier] != nil){
        [avOpponent setAvatarImage:[self.cachedImages valueForKey:identifier]];
    }else{

        avSelected.avatarImage = nil;
        char const * s = [identifier UTF8String];
        dispatch_queue_t queue = dispatch_queue_create(s, 0);
        dispatch_async(queue, ^{
            UIImage *img = nil;
            
            NSData *data;
            data = [NSData dataWithContentsOfFile:[[paths objectAtIndex:0] stringByAppendingPathComponent:p.photoLocation]];
            img = [[UIImage alloc] initWithData:data];
            
            if (img==nil) {
                img = [UIImage imageNamed:@"avatar0"];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([tableView indexPathForCell:cell].row == indexPath.row) {
                    [self.cachedImages setValue:img forKey:identifier];
                    [avOpponent setAvatarImage:[self.cachedImages valueForKey:identifier]];
                }
            });
        });
    }
    
    NSData *data;
    data = [NSData dataWithContentsOfFile:[[paths objectAtIndex:0] stringByAppendingPathComponent:self.activePlayer.photoLocation]];
    UIImage *img = [[UIImage alloc] initWithData:data];
    
    if (img==nil) {
        img = [UIImage imageNamed:@"avatar0"];
    }
    [avSelected setAvatarImage:img];
    avSelected.borderWidth = 3;
    avOpponent.borderWidth = 3;
  
    if ([p.playerWinsPC intValue]==-1) {
        avSelected.borderColors = @[[UIColor colorWithRed:255.0/255.0 green:204.0/255.0 blue:0.0/255.0 alpha:1]];
         avOpponent.borderColors = @[[UIColor colorWithRed:255.0/255.0 green:204.0/255.0 blue:0.0/255.0 alpha:1]];
        avSelected.borderValues = @[@(1.0)];
        avOpponent.borderValues = @[@(1.0)];
    } else {
    
        avSelected.borderColors = @[[UIColor colorWithRed:76.0/255.0 green:217.0/255.0 blue:100.0/255.0 alpha:1],
                            [UIColor colorWithRed:255.0/255.0 green:59.0/255.0 blue:48.0/255.0 alpha:1]];
    
        avOpponent.borderColors = @[[UIColor colorWithRed:76.0/255.0 green:217.0/255.0 blue:100.0/255.0 alpha:1],
                            [UIColor colorWithRed:255.0/255.0 green:59.0/255.0 blue:48.0/255.0 alpha:1]];
    

        float selectedWin = winsRemainder/100.0f;
        float oppenentWin = [p.playerWinsPC floatValue]/100.0f;
    
        avSelected.borderValues = @[@(selectedWin),@(oppenentWin)];
        avOpponent.borderValues = @[@(oppenentWin),@(selectedWin)];
    }
    
    [cell.opponentAvatarView addSubview:avOpponent];
    [cell.selectedvatarView addSubview:avSelected];
    
    cell.layer.shouldRasterize = true;
    [cell.layer setRasterizationScale:[[UIScreen mainScreen] scale]];
    
    return cell;
}

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)tableView:(UITableView *)tableView willDisplayCell:(HeadToHeadCellTVC *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    cell.opponentBadge.layer.cornerRadius = 15;
    cell.selectedBadge.layer.cornerRadius = 15;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    player *p = [self.opponents objectAtIndex:indexPath.row];
    
    self.activePlayerNumber = p.playerNumber;
    
    self.activePlayer = [self.db getPlayerByPlayerNumber :self.activePlayerNumber];
    self.opponents = [self.db findAllPlayers :[NSNumber numberWithInt:2] :self.activePlayerNumber];
    
    self.cachedImages = [[NSMutableDictionary alloc] init];
    
    
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
//    [self.tableView reloadData];
    
    
}





- (void)addItemViewController:(playerDetailVC *)controller didInsertPlayer :(int)nextPlayerNumber :(NSString*) playerName :(NSString*) playerEmail :
(NSString*) playerImageName :(bool)photoUpdated {
}

- (void)addItemViewController:(playerListingVC *)controller loadPlayerDetails :(player*) playerSelected {
    
    // empty
}

- (void)addItemViewController:(playerDetailVC *)controller didUpdatePlayer :(NSNumber*) newPlayerNumber :(int)playerId :(NSString*) playerName :(NSString*) playerEmail :(NSString*) playerImageName :(bool)photoUpdated {
    
    // not used in this class
}


@end
