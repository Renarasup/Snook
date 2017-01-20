//
//  playerDetailVC.m
//  SnookerScoreMaster
//
//  Created by andrew glew on 07/01/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import "playerDetailVC.h"


@interface playerDetailVC () <PlayerListingDelegate, Head2HeadDelegate, MatchesDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *historyHighestBreakBallsCollection;
@property (weak, nonatomic) IBOutlet UIButton *playerListButton;
@property (weak, nonatomic) IBOutlet UIButton *headToHeadButton;
@property (weak, nonatomic) IBOutlet UIButton *matchListButton;
@property (weak, nonatomic) IBOutlet UIButton *playerUpdateButton;
@property (weak, nonatomic) IBOutlet UIButton *playerStatButton;

@property (strong, nonatomic) UIColor *redColour;
@property (strong, nonatomic) UIColor *yellowColour;
@property (strong, nonatomic) UIColor *greenColour;
@property (strong, nonatomic) UIColor *brownColour;
@property (strong, nonatomic) UIColor *blueColour;
@property (strong, nonatomic) UIColor *pinkColour;
@property (strong, nonatomic) UIColor *blackColour;
enum themes {greenbaize, dark, light, modern, purplehaze, blur};

@end


/*
 TODO before release. 20170113
 
 the format of the players tablelist is not good.
 would like to be able to add an existing photo to the avatar as well as only taking a new one.
 head to head needs also a refresh.
 
 */



@implementation playerDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"backnav"]
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self.navigationController
                                                                  action:@selector(popViewControllerAnimated:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playerImageTapped:)];
    singleTap.numberOfTapsRequired = 1;
    singleTap.numberOfTouchesRequired = 1;
    [self.avatarPlayer addGestureRecognizer:singleTap];
    [self.avatarPlayer  setUserInteractionEnabled:YES];
    
    self.playerNickName.text = self.nickName;
    self.playerEmail.text = self.email;
    
    self.viewDismissed = true;
   
    self.photoUpdated = false;
    
    self.redColour = [UIColor colorWithRed:217.0f/255.0f green:23.0f/255.0f blue:60.0f/255.0f alpha:1.0];
    self.yellowColour = [UIColor colorWithRed:222.0f/255.0f green:199.0f/255.0f blue:4.0f/255.0f alpha:1.0];
    self.greenColour = [UIColor colorWithRed:61.0f/255.0f green:191.0f/255.0f blue:61.0f/255.0f alpha:1.0];
    self.brownColour = [UIColor colorWithRed:120.0f/255.0f green:64.0f/255.0f blue:0.0f/255.0f alpha:1.0];
    self.blueColour = [UIColor colorWithRed:39.0f/255.0f green:121.0f/255.0f blue:198.0f/255.0f alpha:1.0];
    self.pinkColour = [UIColor colorWithRed:201.0f/255.0f green:78.0f/255.0f blue:184.0f/255.0f alpha:1.0];
    self.blackColour = [UIColor colorWithRed:33.0f/255.0f green:33.0f/255.0f blue:33.0f/255.0f alpha:1.0];
 
}


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

    player *p;

    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    /* handle player key if this is a new record or an update to existing */
    if (self.playerIndex==0) {
        self.nextPlayerKey = [[NSUUID UUID] UUIDString];
    } else {
        p = [self.db getPlayerByPlayerNumber :[NSNumber numberWithInt:self.currentPlayerNumber]];
        self.currentPlayerKey = p.playerkey;
 
    }
    /* commented out 20170114
    if (self.playerIndex==1) {
        p = self.p1;
    } else {
        p = self.p2;
    }
    */

    if (((self.currentPlayerNumber == self.staticPlayer1Number && self.staticPlayer1CurrentBreak>0) || (self.currentPlayerNumber == self.staticPlayer2Number && self.staticPlayer2CurrentBreak>0)) && self.activeBreakShots.count>0) {

        self.historyBreakShots = self.activeBreakShots;
        
        ballShot *b = [self.activeBreakShots firstObject];
        
        NSString *dateString = b.shottimestamp;
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *timeStamp = [df dateFromString: dateString];
        
        NSString *ago = [timeStamp timeAgo];
        
        self.breakShownLabel.text = [NSString stringWithFormat:@"%d is players live break - started %@",self.staticPlayer1CurrentBreak+self.staticPlayer2CurrentBreak,ago];

    } else {

        
        self.historyBreakShots = [self.db findHistoryActivePlayersHiBreakBalls :[NSNumber numberWithInt:self.currentPlayerNumber] :[NSNumber numberWithInt:self.staticPlayer1Number] :[NSNumber numberWithInt:self.staticPlayer2Number] :p.hbEver.breakTotal :p.hbEver.breakBalls];
        p.hiBreak = [NSNumber numberWithInt: [common getBreakScoreFromBalls : self.historyBreakShots]];

        
    }
    
    p.hiBreak = [NSNumber numberWithInt: [common getBreakScoreFromBalls : self.historyBreakShots]];
    
    
    if (p.hiBreak==0) {
        self.breakShownLabel.text = @"no breaks yet!";
    } else {
        ballShot *b = [self.historyBreakShots firstObject];
            
        NSString *dateString = b.shottimestamp;
            
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *timeStamp = [df dateFromString: dateString];
            
        NSString *ago = [timeStamp timeAgo];

        if (self.activeBreakShots.count>0) {
            self.breakShownLabel.text = [NSString stringWithFormat:@"%@ is players current break score", p.hiBreak];
        } else if (p.hiBreak > [NSNumber numberWithInt:0]) {
            self.breakShownLabel.text = [NSString stringWithFormat:@"%@ is players highest recorded break - %@", p.hiBreak, ago];
        } else {
            self.breakShownLabel.text = @"No breaks yet!";
        }
        
    }


    self.historyHighestBreakBallsCollection.dataSource = self;
    self.historyHighestBreakBallsCollection.delegate = self;

    [self.historyHighestBreakBallsCollection reloadData];
    
    
    
    if (self.theme==greenbaize) {
        
        
        
    } else if (self.theme==dark) {
        
    } else if (self.theme==light) {
        
        self.playerNickName.textColor = self.skinForegroundColour;
        self.playerEmail.textColor = self.skinForegroundColour;
        self.breakShownLabel.textColor = self.skinForegroundColour;
        
    } else if (self.theme == modern) {
        //  [self.view setBackgroundColor:[UIColor colorWithRed:45.0f/255.0f green:45.0f/255.0f blue:45.0f/255.0f alpha:1.0]];
    }
    
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.view.bounds;
    
    if (self.currentPlayerNumber == self.staticPlayer1Number) {
        //[self.view setBackgroundColor: self.skinPlayer1Colour];
        gradient.colors = [NSArray arrayWithObjects:(id)[self.skinPlayer1Colour CGColor], (id)[self.skinBackgroundColour CGColor], nil];
    } else {
        //[self.view setBackgroundColor: self.skinPlayer2Colour];
        gradient.colors = [NSArray arrayWithObjects:(id)[self.skinPlayer2Colour CGColor], (id)[self.skinBackgroundColour CGColor], nil];
    }
    [self.view.layer insertSublayer:gradient atIndex:0];
    
    
    
}

/* created 20160203 */
/* modified 20160203 */
-(int)historyHighestBreakValue :(NSMutableArray*) balls {
    int hiBreak=0;
    
    for (ballShot *data in balls) {
        hiBreak+=[data.value intValue];
    }
    return hiBreak;
}

/* modified 20160716 */
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.avatarPlayer.hidden = false;
    AvatarV *av;
    
    long i=1;
    //long i = [self.avatarPlayer.subviews count];
    for (AvatarV *v in [self.avatarPlayer subviews]) {
        
        if (i < [self.avatarPlayer.subviews count]) {
            [v removeFromSuperview];
        } else {
            av = v;
        }

    }
    // aniimate if not a new player
    if (self.playerIndex!=0) {
        
        [av animateToBorderValues:[self.db getPlayerMatchStatistics: [NSNumber numberWithInt:self.currentPlayerNumber]] duration:1];
    }
    
    [self.avatarPlayer setNeedsDisplay];
}





- (void)viewDidLayoutSubviews {
    
    NSString *avatarImageName = self.imagePathPhoto;
    
    if (self.photoUpdated) {
        avatarImageName = @"tempavatar.png";
    }
    
    AvatarV *av = [[AvatarV alloc] initWithFrame:CGRectMake(0, 0, self.avatarPlayer.bounds.size.width, self.avatarPlayer.bounds.size.width)];
    
    if (avatarImageName == nil || [avatarImageName isEqualToString:@""]) {
        [av setAvatarImage:[UIImage imageNamed:@"avatar0.png"]];
        
    } else {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSData *pngData = [NSData dataWithContentsOfFile:[[paths objectAtIndex:0] stringByAppendingPathComponent:avatarImageName]];
        
        [av setAvatarImage:[UIImage imageWithData:pngData]];
    }
    
    if (self.playerIndex==0) {
        self.playerListButton.hidden = true;
        self.headToHeadButton.hidden = true;
        self.matchListButton.hidden = true;
        self.playerStatButton.hidden = true;
        
        [self.playerUpdateButton setTitle:@"Add Player" forState:UIControlStateNormal];
        
        self.navigationItem.title = @"New Player";
    } else {
        self.navigationItem.title = @"Preview";
    }
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:self.skinForegroundColour }];
    
    av.borderWidth = 10;
    if (self.playerIndex!=0) {
        av.borderColors = @[[UIColor colorWithRed:76.0/255.0 green:217.0/255.0 blue:100.0/255.0 alpha:1],
                            [UIColor colorWithRed:255.0/255.0 green:59.0/255.0 blue:48.0/255.0 alpha:1],
                            [UIColor colorWithRed:255.0/255.0 green:204.0/255.0 blue:0.0/255.0 alpha:1]];
        /* we will have animation so first state for avatar border will be empty */
        av.borderValues = @[@(0), @(0), @(0)];
        
    } else {
        av.borderColors = @[[UIColor yellowColor]];
        av.borderValues = @[@(1.0)];
        
    }
    
    [self.avatarPlayer addSubview:av];
    [self.avatarPlayer setNeedsDisplay];


}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 1 && [viewControllers objectAtIndex:viewControllers.count-2] == self) {
        // View is disappearing because a new view controller was pushed onto the stack
        // view controller was popped from the stack
  /*      for (UIView *v in [self.avatarPlayer subviews]) {
            [v removeFromSuperview];
        }
  */
        NSLog(@"New view controller was pushed");
        //self.photoUpdated = false;
        //self.photoUpdated=false;
    } else if ([viewControllers indexOfObject:self] == NSNotFound) {
        // view controller was popped from the stack
        for (UIView *v in [self.avatarPlayer subviews]) {
            [v removeFromSuperview];
        }
       self.photoUpdated=false;
        NSLog(@"View controller was popped");
    } else {
        // Call to camera!
        
        NSLog(@"Camera View controller was pushed");
    }
     
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"openListing"]){
        playerListingVC *controller = (playerListingVC *)segue.destinationViewController;
        controller.delegate = self;
        controller.viewOption = @"playerListing";
        controller.activePlayerNumber = [NSNumber numberWithInt:self.currentPlayerNumber];
        if (self.playerIndex == self.p1.playerIndex ) {
            controller.Player1Key = self.p1.playerkey;
            controller.Player2Key = self.p2.playerkey;
        } else {
            controller.Player1Key = self.p2.playerkey;
            controller.Player2Key = self.p1.playerkey;

        }
        
        controller.db = self.db;
        
        controller.skinForegroundColour = self.skinForegroundColour;
        controller.skinBackgroundColour = self.skinBackgroundColour;
        controller.skinPlayer1Colour = self.skinPlayer1Colour;
        controller.skinPlayer2Colour = self.skinPlayer2Colour;
        
        
        
    } else if([segue.identifier isEqualToString:@"HeadToHeads"]){
        headToHeadListingVC *controller = (headToHeadListingVC *)segue.destinationViewController;
        controller.delegate = self;
        controller.activePlayerNumber = [NSNumber numberWithInt:self.currentPlayerNumber];
        controller.staticPlayer1Number = self.staticPlayer1Number;
        controller.staticPlayer2Number = self.staticPlayer2Number;
        controller.db = self.db;
        
        controller.skinForegroundColour = self.skinForegroundColour;
        controller.skinBackgroundColour = self.skinBackgroundColour;
        controller.skinPlayer1Colour = self.skinPlayer1Colour;
        controller.skinPlayer2Colour = self.skinPlayer2Colour;
        
        
    } else if([segue.identifier isEqualToString:@"Matches"]){
        matchesVC *controller = (matchesVC *)segue.destinationViewController;
        controller.delegate = self;
        controller.activePlayerNumber = [NSNumber numberWithInt:self.currentPlayerNumber];
        controller.staticPlayer1Number = self.staticPlayer1Number;
        controller.staticPlayer2Number = self.staticPlayer2Number;
        controller.staticPlayer1CurrentBreak = self.staticPlayer1CurrentBreak;
        controller.staticPlayer2CurrentBreak = self.staticPlayer2CurrentBreak;
        controller.activeMatchId = self.activeMatchId;
        controller.activeMatchPlayers = self.activeMatchPlayers;
        controller.skinPrefix = self.skinPrefix;
        
        
        controller.activeFramePointsRemaining = self.activeFramePointsRemaining;
        controller.db = self.db;
    
        controller.skinForegroundColour = self.skinForegroundColour;
        controller.skinBackgroundColour = self.skinBackgroundColour;
        controller.skinPlayer1Colour = self.skinPlayer1Colour;
        controller.skinPlayer2Colour = self.skinPlayer2Colour;
        
        
    } else if ([segue.identifier isEqualToString:@"PlayerStatistics"]) {
        
        
    }
    
    
}




/* last updated 20170114 */
- (void)playerImageTapped:(UIGestureRecognizer *)gestureRecognizer {
    
    
    NSString *titleMessage = [NSString stringWithFormat:@"How would you like to add a photo to %@'s Avatar?", self.playerNickName.text];
    NSString *alertMessage = @"";

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:titleMessage
                                                               message:alertMessage
                                                        preferredStyle:UIAlertControllerStyleActionSheet];

    NSString *cameraOption = @"Take a photo with the camera";
    NSString *photorollOption = @"Choose a photo from camera roll";

    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:cameraOption
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                               if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                                                                   
                                                                   UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                                         message:@"Device has no camera"
                                                                                                                        delegate:nil
                                                                                                               cancelButtonTitle:@"OK"
                                                                                                               otherButtonTitles: nil];
                                                                   
                                                                   [myAlertView show];
                                                                   
                                                               }else
                                                               {
                                                                   
                                                                   UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                                                   picker.delegate = self;
                                                                   picker.allowsEditing = YES;
                                                                   picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                                                   picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
                                                                   
                                                                   [self presentViewController:picker animated:YES completion:NULL];
                                                                   
                                                               }

                                                               
                                                               NSLog(@"you wnt a photo");
                                                               
                                                           }];

    
    
    UIAlertAction *photorollAction = [UIAlertAction actionWithTitle:photorollOption
                                                             style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
                                                                 
                                                                 UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                                                                 picker.delegate = self;
                                                                 picker.allowsEditing = YES;
                                                                 picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                                                 [self presentViewController:picker animated:YES completion:nil];
                                                                 
                                                                 NSLog(@"you want to select a photo");
                                                                 
                                                             }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                                                               NSLog(@"You pressed cancel");
                                                           }];


    
    [alert addAction:cameraAction];
    [alert addAction:photorollAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}


/* last updated 20160207 */
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    /* obtain the image from the camera */
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.imageSelectedPlayer.image = chosenImage;

    /* get avatar instance in UIView */
    AvatarV *av;
    for (int i = 0; i < [self.avatarPlayer.subviews count]; i++) {
        // Get the subview at current index
        av = [self.avatarPlayer.subviews objectAtIndex:i];
    }

    [av setAvatarImage:chosenImage];

    /* now using player key set instance variable to expected image file name if user requests update later */
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if (self.playerIndex!=0) {
        self.imagePathPhoto =[ NSString stringWithFormat:@"avatar_%@.png",self.currentPlayerKey];
    } else {
        // this means we have a new player
        self.imagePathPhoto =[ NSString stringWithFormat:@"avatar_%@.png",self.nextPlayerKey];
        
        
    }
    
    self.photoUpdated = true;

    /* in the meantime we need to populate the current avatar display so use temporary image placeholder in the meantime */
    NSData *avatarImgData =  UIImagePNGRepresentation([av avatarImage]);
    [avatarImgData writeToFile:[[paths objectAtIndex:0] stringByAppendingPathComponent:@"tempavatar.png"] atomically:YES];

    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:NULL];
}



/* last updated 20160207 */
- (IBAction)updatePlayerPressed:(id)sender {
     self.viewDismissed = false;
    
    
    
    /* verify if the photo has been updated or not */
    if (self.photoUpdated) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //Get documents directory
        NSArray *directoryPaths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
        if ([fileManager fileExistsAtPath:[[directoryPaths objectAtIndex:0] stringByAppendingPathComponent:self.imagePathPhoto]]==YES) {
            if ([fileManager removeItemAtPath:[[directoryPaths objectAtIndex:0] stringByAppendingPathComponent:self.imagePathPhoto]     error:NULL]) {
                NSLog(@"Removed successfully");
            }
        }
        if ([fileManager copyItemAtPath:[[directoryPaths objectAtIndex:0] stringByAppendingPathComponent:@"tempavatar.png"]
                                 toPath:[[directoryPaths objectAtIndex:0] stringByAppendingPathComponent:self.imagePathPhoto]  error:NULL]) {
            NSLog(@"Copied successfully");
        }
    } else {
        if ((self.imagePathPhoto==nil || [self.imagePathPhoto isEqualToString:@""]) && self.playerIndex==0) {
             self.imagePathPhoto=@"avatar0.png";
            self.photoUpdated=true;
        }
    }
 
   // if (self.imagePathPhoto==nil) {
   //     self.imagePathPhoto=@"";
   // }
    
    
    /* last part of function is to determine if this is a new player or a modify existing. each handles database updates */
    if (self.playerIndex!=0) {
        [self.delegate addItemViewController:self didUpdatePlayer :[NSNumber numberWithInt:self.currentPlayerNumber] :self.playerIndex :self.playerNickName.text :self.playerEmail.text :self.imagePathPhoto :self.photoUpdated];
        
    } else {
        [  self.delegate addItemViewController:self didInsertPlayer:self.nextPlayerNumber :self.playerNickName.text :self.playerEmail.text :self.imagePathPhoto :self.photoUpdated :self.nextPlayerKey];
        
        
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)closePlayerDetailPressed:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)dismissKBNickName:(id)sender {
    
    [self.playerNickName becomeFirstResponder];
    [self.playerNickName resignFirstResponder];
    
}

- (IBAction)dismissKBEmail:(id)sender {
    
    [self.playerEmail becomeFirstResponder];
    [self.playerEmail resignFirstResponder];
}

- (void)addItemViewController:(playerDetailVC *)controller didUpdatePlayer :(NSNumber*) newPlayerNumber :(int)playerId :(NSString*) playerName :(NSString*) playerEmail :(NSString*) playerImageName :(bool)photoUpdated {
}

- (void)addItemViewController:(playerDetailVC *)controller didInsertPlayer :(int)nextPlayerNumber :(NSString*) playerName :(NSString*) playerEmail :(NSString*) playerImageName :(bool)photoUpdated :(NSString*) playerkey {
}



- (void)addItemViewController:(playerListingVC *)controller loadPlayerDetails :(player*) playerSelected {

    if (playerSelected.swappedPlayer==true) {
        [self.playerUpdateButton setTitle:@"Switch" forState:UIControlStateNormal];
    } else {
        [self.playerUpdateButton setTitle:@"Edit Player" forState:UIControlStateNormal];
    }

    

    if (self.currentPlayerNumber == [playerSelected.playerNumber intValue]) {
        /* nothing to do */
    } else {
        
        
        self.currentPlayerNumber = [playerSelected.playerNumber intValue];

        self.imagePathPhoto = playerSelected.photoLocation;
        self.nickName = playerSelected.nickName;
        self.email = playerSelected.emailAddress;
      
        
        
        AvatarV *av;
        
        for (int i = 0; i < [self.avatarPlayer.subviews count]; i++) {
            
            // Get the subview at current index
            av = [self.avatarPlayer.subviews objectAtIndex:i];
        }

        if (playerSelected.photoLocation==nil || [playerSelected.photoLocation isEqualToString:@""]) {
            [av setAvatarImage:[UIImage imageNamed:@"avatar0.png"] ];
            
        } else {
           
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSData *pngData = [NSData dataWithContentsOfFile:[[paths objectAtIndex:0] stringByAppendingPathComponent:self.imagePathPhoto]];

            [av setAvatarImage:[UIImage imageWithData:pngData]];
        }
        
       
        
        self.playerNickName.text = self.nickName;
        self.playerEmail.text = self.email;
 
    }
    
    
    
}


#pragma mark - CollectionView handling

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.historyBreakShots.count;
    
}






-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    breakBallCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"breakCell" forIndexPath:indexPath];
    [[cell contentView] setFrame:[cell bounds]];
    cell.ball = [self.historyBreakShots objectAtIndex:indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(breakBallCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.isHollow) {
        [cell setBorderWidth:0.0f];
    } else {
        [cell setBorderWidth:2.5f];
    }
    
    if ([cell.ball.imageNameLarge isEqualToString:@"red_01"]) {
        cell.ballStoreImage.layer.borderColor = self.redColour.CGColor;
        if (!self.isHollow) cell.ballStoreImage.backgroundColor = self.redColour;
    } else if ([cell.ball.imageNameLarge isEqualToString:@"yellow_02"]) {
        cell.ballStoreImage.layer.borderColor = self.yellowColour.CGColor;
        if (!self.isHollow) cell.ballStoreImage.backgroundColor = self.yellowColour;
    } else if ([cell.ball.imageNameLarge isEqualToString:@"green_03"]) {
        cell.ballStoreImage.layer.borderColor = self.greenColour.CGColor;
        if (!self.isHollow) cell.ballStoreImage.backgroundColor = self.greenColour;
    } else if ([cell.ball.imageNameLarge isEqualToString:@"brown_04"]) {
        cell.ballStoreImage.layer.borderColor = self.brownColour.CGColor;
        if (!self.isHollow) cell.ballStoreImage.backgroundColor = self.brownColour;
    } else if ([cell.ball.imageNameLarge isEqualToString:@"blue_05"]) {
        cell.ballStoreImage.layer.borderColor = self.blueColour.CGColor;
        if (!self.isHollow) cell.ballStoreImage.backgroundColor = self.blueColour;
    } else if ([cell.ball.imageNameLarge isEqualToString:@"pink_06"]) {
        cell.ballStoreImage.layer.borderColor = self.pinkColour.CGColor;
        if (!self.isHollow) cell.ballStoreImage.backgroundColor = self.pinkColour;
    } else if ([cell.ball.imageNameLarge isEqualToString:@"black_07"]) {
        cell.ballStoreImage.layer.borderColor = self.blackColour.CGColor;
        if (!self.isHollow) cell.ballStoreImage.backgroundColor = self.blackColour;
    }
    
}





@end

