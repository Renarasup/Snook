//
//  DeductPointsViewController.m
//  snookerScorer2
//
//  Created by andrew glew on 16/11/2014.
//  Copyright (c) 2014 andrew glew. All rights reserved.
//

#import "adjustVC.h"
#import "ball.h"

@interface adjustVC () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (strong, nonatomic) UIColor *skinMainFontColor;
@property (weak, nonatomic) IBOutlet UILabel *backgroundLabel;

@property (weak, nonatomic) IBOutlet UIPickerView *PointsPicker;
@property (weak, nonatomic) IBOutlet UILabel *labelExplanation;

@property (weak, nonatomic) IBOutlet UILabel *ballCounter;

@property (weak, nonatomic) IBOutlet UIStepper *stepperBallAdjuster;
@property (weak, nonatomic) IBOutlet UILabel *labelPointsRemaining;

@property (weak, nonatomic) IBOutlet UIButton *ballImage;
@property (weak, nonatomic) IBOutlet UIButton *selectPlayerButton;

@property (weak, nonatomic) IBOutlet UIView *ballAdjustView;

@property (weak, nonatomic) IBOutlet UIButton *closeButton;


@end

@implementation adjustVC

@synthesize selectedValue;
@synthesize skins;

- (void)viewDidLoad {
    [super viewDidLoad];
    /* colour setup */
    self.redColour = [UIColor colorWithRed:217.0f/255.0f green:23.0f/255.0f blue:60.0f/255.0f alpha:1.0];
    self.yellowColour = [UIColor colorWithRed:222.0f/255.0f green:199.0f/255.0f blue:4.0f/255.0f alpha:1.0];
    self.greenColour = [UIColor colorWithRed:61.0f/255.0f green:191.0f/255.0f blue:61.0f/255.0f alpha:1.0];
    self.brownColour = [UIColor colorWithRed:120.0f/255.0f green:64.0f/255.0f blue:0.0f/255.0f alpha:1.0];
    self.blueColour = [UIColor colorWithRed:39.0f/255.0f green:121.0f/255.0f blue:198.0f/255.0f alpha:1.0];
    self.pinkColour = [UIColor colorWithRed:201.0f/255.0f green:78.0f/255.0f blue:184.0f/255.0f alpha:1.0];
    self.blackColour = [UIColor colorWithRed:33.0f/255.0f green:33.0f/255.0f blue:33.0f/255.0f alpha:1.0];
    
    
    // Do any additional setup after loading the view.
    if (self.sumOfPlayerFouls == 0) {
        self.labelExplanation.text = [NSString stringWithFormat:@"%@ has not received any foul points from the other player in this frame.\nYou may increase this players score however.",self.playerName];
    } else {
    self.labelExplanation.text = [NSString stringWithFormat:@"%@ has a total of %d foul points awarded.\nYou may  deduct this amount from the score.\nAlternatively you can increase this score.",self.playerName,self.sumOfPlayerFouls];
    }
    self.stepperBallAdjuster.value = self.ballIndex;
    self.stepperBallAdjuster.maximumValue = self.ballIndex;
    
    self.ballImage.layer.cornerRadius = self.ballImage.frame.size.width /2.0f;
    
    [self updateBallCounter];
    
    self.ballCounter.textColor = self.skinForegroundColour;

    [self.ballImage setTitleColor:self.skinForegroundColour forState:UIControlStateNormal];
    
    
   
    self.stepperBallAdjuster.tintColor = self.skinForegroundColour;
    
    self.view.backgroundColor=self.skinBackgroundColour;

    self.labelExplanation.textColor = self.skinForegroundColour;
}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return (NSInteger)self.sumOfPlayerFouls + 1 + 50;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%ld", (long)row - self.sumOfPlayerFouls];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
{
   self.selectedValue = (int)row;
    /* modified 20160315 */
    // TODO - needs visualization of switch
    self.selectPlayerButton.enabled = true;
    self.adjustButton.enabled = false;
}

- (void)addItemViewController:(adjustVC *)controller didPickDeduction:(int)selectedPoints {
}

- (void)addItemViewController:(adjustVC *)controller didPickBallAdjust:(int)ballIndex {

}


- (IBAction)selectClicked:(id)sender {
    self.selectedValue = ( self.selectedValue - self.sumOfPlayerFouls);
    [self.delegate addItemViewController:self didPickDeduction:self.selectedValue];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)ballAdjustorClicked:(id)sender {
    
    [self.delegate addItemViewController:self didPickBallAdjust:(int)self.ballIndex :(int)self.stepperBallAdjuster.value ];
    [self.navigationController popViewControllerAnimated:YES];
}



-(void)updateBallCounter {
    int ballRedAmount=0;
    int ballColourIndex=0;
    

    UIColor *currentBallColour;
    
    if (self.stepperBallAdjuster.value > 6) {
        // its a red
        
        self.ballCounter.text =[NSString stringWithFormat:@"%.f",self.stepperBallAdjuster.value - 6.0];
        ballRedAmount = self.stepperBallAdjuster.value - 6.0;
        ballColourIndex = 1;
        
        currentBallColour = self.redColour;
        
        
        //ballImageName = [NSString stringWithFormat:@"%@red_01",prefixColourName];
        
        
    } else {
        self.ballCounter.text =@"1";
        // it's a colour
        // black is actually equal to 1 so to get black we must have 8 and subtract.
        ballColourIndex = 8 - self.stepperBallAdjuster.value;
        
        if (ballColourIndex == 2 ) {
           // ballImageName = [NSString stringWithFormat:@"%@yellow_02",prefixColourName];
            currentBallColour = self.yellowColour;
        } else if (ballColourIndex==3) {
            //ballImageName = [NSString stringWithFormat:@"%@green_03",prefixColourName];
            currentBallColour = self.greenColour;
        } else if (ballColourIndex==4) {
            currentBallColour = self.brownColour;
            //ballImageName = [NSString stringWithFormat:@"%@brown_04",prefixColourName];
        } else if (ballColourIndex==5) {
            currentBallColour = self.blueColour;

            //ballImageName = [NSString stringWithFormat:@"%@blue_05",prefixColourName];
        } else if (ballColourIndex==6) {
             currentBallColour = self.pinkColour;
            //ballImageName = [NSString stringWithFormat:@"%@pink_06",prefixColourName];
        } else if (ballColourIndex==7) {
             currentBallColour = self.blackColour;
           // ballImageName = [NSString stringWithFormat:@"%@black_07",prefixColourName];
        }
    }
    
    //UIImage *buttonImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png",ballImageName ]];
    
    self.ballImage.backgroundColor = currentBallColour;
    
    //[self.ballImage setImage:buttonImage forState:UIControlStateNormal];

    int pointsRemaining=0;

    for (int i = 7; i >= ballColourIndex; i--)
    {
        if (i==1) {
            pointsRemaining += (ballRedAmount * 8);
        } else {
            pointsRemaining += i;
        }
    }
    
    self.labelPointsRemaining.text = [NSString stringWithFormat:@"%d Points Remaining",pointsRemaining];
    if (pointsRemaining == 0) {
        self.ballImage.enabled = false;
        self.ballCounter.text = @"0";
    } else {
        self.ballImage.enabled = true;
        
    }
}

/* modified 20160315 */
- (IBAction)stepperClicked:(id)sender {
    // TODO needs visualization of switch
    [self updateBallCounter];
    
    self.selectPlayerButton.enabled = false;
    self.adjustButton.enabled = true;
    
   
}

- (IBAction)closeClicked:(id)sender {
   // [self dismissModalViewControllerAnimated:YES];
    NSLog(@"%@",self.navigationController.viewControllers);
    
    [self.navigationController popViewControllerAnimated:YES];
    //[self.navigationController popToRootViewControllerAnimated:YES];
    
}




@end
