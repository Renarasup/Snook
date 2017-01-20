//
//  playerListingTVC.m
//  SnookerScoreMaster
//
//  Created by andrew glew on 09/01/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import "playerListingTVC.h"
#import "playerCellTVC.h"

@interface playerListingTVC () <PlayerDelegate,UITableViewDelegate, UITableViewDataSource>

@end


@implementation playerListingTVC
@synthesize players;
@synthesize db;
@synthesize delegate;
@synthesize viewOption;
@synthesize activePlayer;
@synthesize playerTableView;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.players = [self.db findAllPlayers :[NSNumber numberWithInt:1] :self.activePlayerNumber];
    /* search nsarray for number  */
    for (player* item in self.players)
    {
        if (item.playerNumber == self.activePlayerNumber) {
            self.activePlayer = item;
        }
    }
    self.title = @"Players";
    self.cachedAvatars = [[NSMutableDictionary alloc] init];
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO animated:YES];
    
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
    return [self.players count];
}


/* last modified 20160205 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"player";
    
    playerCellTVC *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[playerCellTVC alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    //Here the dataSource array is of dictionary objects
    player *p = [self.players objectAtIndex:indexPath.row];
    
    
    if (p.playerNumber  == self.activePlayer.playerNumber) {
        cell.contentView.superview.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    } else {
        cell.contentView.superview.backgroundColor = [UIColor whiteColor];
    }
    
    cell.playerName.text = p.nickName;
    cell.playerNumber = p.playerNumber;
    cell.playerEmail.text = p.emailAddress ;
    cell.playerHiBreak.text = [NSString stringWithFormat:@"%@",p.hiBreak];
    
    float matchWinsPC =0.0f;
    
    matchWinsPC = ([p.playerMatchWins floatValue] / [p.playerMatchCount floatValue]) * 100.0f;
    
    cell.playerWinPC.text = [NSString stringWithFormat:@"%.2f%% Won",matchWinsPC];
    
    
    cell.playerMatches.text = [NSString stringWithFormat:@"matches %@",p.playerMatchCount];
    
    if ([p.playerWinsPC intValue] == -1 ) {
        [cell.playerWinPC setHidden:YES];
    } else {
        [cell.playerWinPC setHidden:NO];
    }

    
    if ([cell.playerHiBreak.text isEqualToString:@"0"]) {
        [cell.badgeView setHidden:YES];
    } else {
        [cell.badgeView setHidden:NO];
    }
    
    NSString *identifier = [NSString stringWithFormat:@"Cell%ld" ,
                            (long)indexPath.row];
    

    if([self.cachedAvatars objectForKey:identifier] != nil){
        [cell.avatarView addSubview:[self.cachedAvatars valueForKey:identifier]];
    } else {
        AvatarV *av = [[AvatarV alloc] initWithFrame:CGRectMake(0, 0, 75.0, 75.0)];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        av.avatarImage = nil;

        char const * s = [identifier UTF8String];
        dispatch_queue_t queue = dispatch_queue_create(s, 0);
        dispatch_async(queue, ^{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([tableView indexPathForCell:cell].row == indexPath.row) {
                    NSData *data;
                    data = [NSData dataWithContentsOfFile:[[paths objectAtIndex:0] stringByAppendingPathComponent:p.photoLocation]];
                    UIImage *img = [[UIImage alloc] initWithData:data];
                    
                    if (img==nil) {
                        img = [UIImage imageNamed:@"avatar0"];
                    }
                    
                    [av setAvatarImage:img];
                    av.borderWidth = 3;

                    if ([p.playerWinsPC intValue]==-1) {
                        av.borderColors = @[[UIColor colorWithRed:255.0/255.0 green:204.0/255.0 blue:0.0/255.0 alpha:1]];
                        av.borderValues = @[@(1.0)];
                    } else {
                        
                        av.borderColors = @[[UIColor colorWithRed:76.0/255.0 green:217.0/255.0 blue:100.0/255.0 alpha:1],
                                            [UIColor colorWithRed:255.0/255.0 green:59.0/255.0 blue:48.0/255.0 alpha:1]];
                        
                        float winPC = [p.playerWinsPC floatValue]/100.0f;
                        float losePC = 1.0f - winPC;
                        av.borderValues = @[@(winPC),@(losePC)];
                        
                    }
                    [self.cachedAvatars setValue:av forKey:identifier];
                }
            });
        });
        [cell.avatarView addSubview:av];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(playerCellTVC *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.playerPhoto.frame = CGRectMake(cell.playerPhoto.frame.origin.x, cell.playerPhoto.frame.origin.y, 75, 75);
    cell.playerPhoto.clipsToBounds = YES;
    cell.playerPhoto.layer.cornerRadius = 75/2.0f;

       cell.playerPhoto.layer.borderColor=[UIColor orangeColor].CGColor;
 
    cell.playerPhoto.layer.borderWidth=3.0f;
    cell.badgeView.layer.cornerRadius = 15;
 

 
}

/*
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    return !self.tableView.isEditing;
}
*/



/* 20160109 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    player *p = [self.players objectAtIndex:indexPath.row];
    p.swappedPlayer=true;
    [self.db playerRetreive :p];
    [self.delegate addItemViewController:self loadPlayerDetails:p];
    [self.navigationController popViewControllerAnimated:YES];
  
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"NewPlayer"]){
        
        playerDetailVC *controller = (playerDetailVC *)segue.destinationViewController;
        controller.delegate = self;
        controller.playerIndex = 0;
        controller.nickName = @"Nick Name";
        controller.imagePathPhoto = nil;
        controller.email = @"email@address.com";
        controller.photoUpdated = false;
        controller.nextPlayerNumber = [[self.db getNewPlayerNumber] intValue];
        
    }
    
    
    
    
}

- (IBAction)backPressed:(id)sender {
    
    
    //- (void)addItemViewController:(playerDetailVC *)controller loadPlayerDetails :(int)playerId :(NSString*) playerName :(NSString*) playerEmail :(NSString*) playerImageName :(bool)photoUpdated;
    
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
/*
- (IBAction)toolbarbuttonTouched:(id)sender
{

    if ([self.toolbarButtonMerge.title isEqualToString:@"Merge"])
    {
       
        [self.playerTableView setEditing:YES animated:YES];
        
        
        self.toolbarButtonMerge.title = @"Done";
    }
    else
    {
        NSArray *rowsSelectedForMerger = [self.tableView indexPathsForSelectedRows];
        
        [self.playerTableView setEditing:NO animated:YES];
        self.toolbarButtonMerge.title = @"Merge";
    }
}
*/




- (void)addItemViewController:(playerDetailVC *)controller didInsertPlayer :(int)nextPlayerNumber :(NSString*) playerName :(NSString*) playerEmail :(NSString*) playerImageName :(bool)photoUpdated :(NSString*) playerkey {
    
    
    player *p = [[player alloc] init];
    p.playerIndex = nextPlayerNumber;
    p.nickName = playerName;
    p.emailAddress = playerEmail;
    p.photoLocation = playerImageName;
    p.hiBreak = 0;
    p.hiBreakDate = @"";
    p.trailBlazer = 0;
    p.playerkey = playerkey;

    [self.db insertPlayer:p];
    
    self.players = [self.db findAllPlayers:[NSNumber numberWithInt:1] :[NSNumber numberWithInt:nextPlayerNumber]];
    [self.tableView reloadData];
    
    
}

- (void)addItemViewController:(playerListingVC *)controller loadPlayerDetails :(player*) playerSelected {
    
    // empty
}

- (void)addItemViewController:(playerDetailVC *)controller didUpdatePlayer :(NSNumber*) newPlayerNumber :(int)playerId :(NSString*) playerName :(NSString*) playerEmail :(NSString*) playerImageName :(bool)photoUpdated {
    
    // not used in this class
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    player *p = [self.players objectAtIndex:indexPath.row];
    
    if ([p.playerMatchCount intValue]  == 0 && self.players.count>1) {
        return YES;
    } else {
        return NO;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {

    player *p = [self.players objectAtIndex:indexPath.row];
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.db deletePlayer:p.playerNumber];
        [self.players removeObjectAtIndex:indexPath.row];
        [tableView reloadData]; // tell table to refresh now
    }
 
}


@end
