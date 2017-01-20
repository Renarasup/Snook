//
//  graph.m
//  SnookerScoreMaster
//
//  Created by andrew glew on 16/01/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import "graphV.h"
#import "embededMatchStatisticsVC.h"


@implementation graphV 

#define degreesToRadian(x) (M_PI * (x) / 180.0)


CGRect touchAreas[100];

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


/*
 
 self.graphStatisticView.frameData = [[[self.graphStatisticView.frameData reverseObjectEnumerator] allObjects] mutableCopy];
 
 */




#pragma MATCH STACK-BAR-GRAPH

/* created 20151003 */
-(int)plotMatchPlayerStakedbar:(bool)fillGraph :(CGContextRef)ctx :(int) playerIndex :(NSMutableArray*) matchData  :(UIColor*) playerColour :(float) scalePointsY :(float) scaleFramesX :(int) touchIndex {

CGContextSetLineWidth(ctx, 1.5);
CGContextSetStrokeColorWithColor(ctx, [[UIColor blackColor] CGColor] );
CGContextSetFillColorWithColor(ctx, [playerColour CGColor]);
int graphHeight = self.frame.size.height;
int maxGraphHeight = graphHeight - kOffsetY;
int score=0;
int dataIndex = 0;
int scoreOffset=0;

CGColorSpaceRef colorspace;

colorspace = CGColorSpaceCreateDeviceRGB();
float plotFramesMaxX = 0.0;
float plotFramesMinX = 0.0;

float colPadding = 10.0f;
if (self.numberOfFrames>12) {
colPadding = 2.0f;
}

/* run through player 1 and player 2 shared data array picking out only selected players data */
for (NSMutableArray *dataPoint in matchData) {

dataIndex ++;
touchIndex ++;

NSNumber *pointsValue;
    NSNumber *pointsOffset;
    if (playerIndex==1) {
        pointsValue=[dataPoint valueForKeyPath:@"player1"];
        pointsOffset = [dataPoint valueForKeyPath:@"player1Offset"];
    } else {
        pointsValue=[dataPoint valueForKeyPath:@"player2"];
        pointsOffset = [dataPoint valueForKeyPath:@"player2Offset"];
    }
    
    score = [pointsValue intValue];
    scoreOffset = [pointsOffset intValue];

float plotPointsMinY = graphHeight - (maxGraphHeight * (scalePointsY * scoreOffset));
float plotPointsMaxY = graphHeight - (maxGraphHeight * (scalePointsY * (score + scoreOffset)));

plotFramesMinX=plotFramesMaxX;
plotFramesMaxX=kOffsetX + dataIndex * scaleFramesX;

CGContextBeginPath(ctx);
CGContextMoveToPoint(ctx, plotFramesMinX+colPadding, plotPointsMinY);
CGContextAddLineToPoint(ctx, plotFramesMaxX-colPadding, plotPointsMinY);
CGContextAddLineToPoint(ctx, plotFramesMaxX-colPadding, plotPointsMaxY);
CGContextAddLineToPoint(ctx, plotFramesMinX+colPadding, plotPointsMaxY);
CGContextClosePath(ctx);
CGContextFillPath(ctx);

CGRect rect;
rect = CGRectMake(plotFramesMinX+colPadding, plotPointsMaxY, plotFramesMaxX - plotFramesMinX - (colPadding*2.0f), plotPointsMinY - plotPointsMaxY);
    
    if (dataIndex<100) {
        touchAreas[touchIndex] = rect;
    }
    
}
    return touchIndex;
}







- (void)drawMatchStackedbarGraphWithContext:(CGContextRef)ctx
{
    float scalePoints = 1.0f/ (float)self.matchMaxPoints;
    /* assist with scale of graph - width */
    NSUInteger frameDataEntries = self.matchFramePoints.count;
    int touchIndex=0;
    
    float scaleFrames=0.0;
    int colsScale = (int)self.matchFramePoints.count;
    if (frameDataEntries>0) {
        if (frameDataEntries<8) {
            colsScale = 8;
        }
        scaleFrames = ((int)self.frame.size.width) / colsScale;
    }
    
    
    
    // Player 1 plotting
    touchIndex = [self plotMatchPlayerStakedbar:false :ctx :1 :self.matchFramePoints :self.skinPlayer1Colour :scalePoints :scaleFrames :touchIndex];
    
    // Player 2 plotting
    touchIndex = [self plotMatchPlayerStakedbar:false :ctx :2 :self.matchFramePoints :self.skinPlayer2Colour :scalePoints :scaleFrames :touchIndex];
    
}


-(int)getFramePoints:(NSMutableArray*) activeData :(NSNumber*)playerid :(NSNumber *)frameid {
    int retValue=0;
    for (breakEntry *singleBreak in activeData) {
        if (playerid == singleBreak.playerid && (frameid == singleBreak.frameid || frameid == 0)) {
            retValue+=[singleBreak.points intValue];
        }
    }
    return retValue;
}


/* created 20150927 */
/* last modified 20151013 */
-(NSMutableArray*) getData :(NSMutableArray*) frameDataSet :(NSNumber*)frameId {
    
    NSMutableArray *frame = [[NSMutableArray alloc] init];
    
    for (breakEntry *singleBreak in frameDataSet) {
        if (singleBreak.frameid == frameId) {
            
            ballShot *shot = [singleBreak.shots firstObject];
            
            if (![shot.colour isEqualToString:@"FS"]) {
                [frame addObject:singleBreak];
            }
            
        } else if (singleBreak.frameid > frameId) {
            break;
        }
    }
    return frame;
}





/* last modified 20151003 */
/*               20160116 */

-(void)initMatchGraphData  {
    
    [self.matchFramePoints removeAllObjects];
    self.matchMaxPoints=0;
    
    for (int frameIndex = 1; frameIndex <= self.numberOfFrames; frameIndex++)
    {
        NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
        
        if (frameIndex==self.numberOfFrames) {
            // add currentbreak to last frame if it exists
            [data setValue:[NSNumber numberWithInt:[self getFramePoints:[self selectedData] :[NSNumber numberWithInt:1] :[NSNumber numberWithInt:frameIndex]] + [self.p1.activeBreak intValue]] forKey:@"player1"];
            
            [data setValue:[NSNumber numberWithInt:[self getFramePoints:[self selectedData] :[NSNumber numberWithInt:2] :[NSNumber numberWithInt:frameIndex]] + [self.p2.activeBreak intValue]] forKey:@"player2"];
        } else {
            [data setValue:[NSNumber numberWithInt:[self getFramePoints:[self selectedData] :[NSNumber numberWithInt:1] :[NSNumber numberWithInt:frameIndex]]] forKey:@"player1"];
            
            [data setValue:[NSNumber numberWithInt:[self getFramePoints:[self selectedData] :[NSNumber numberWithInt:2] :[NSNumber numberWithInt:frameIndex]]] forKey:@"player2"];
        }
        
 
        
        
        [data setValue:[NSNumber numberWithInt:0] forKey:@"player1Offset"];
        [data setValue:[data valueForKey:@"player1"] forKey:@"player2Offset"];
        
        /* match points maximum is player1 points + player2 points as we are going for stacked bar graph */
        if (([[data valueForKeyPath:@"player1"] intValue] + [[data valueForKeyPath:@"player2"] intValue]) > self.matchMaxPoints) {
            self.matchMaxPoints = [[data valueForKeyPath:@"player1"] intValue] + [[data valueForKeyPath:@"player2"] intValue];
        }
        
        [self.matchFramePoints addObject:data];
    }
    self.matchMaxPoints ++;
}


#pragma LINE-GRAPH

-(void)plotPlayerLines:(bool)fillGraph :(CGContextRef)ctx :(int) playerIndex :(int) breakOfPlayer  :(UIColor*) playerColour {
    
    CGContextSetLineWidth(ctx, 1.5);
    CGContextSetStrokeColorWithColor(ctx, [playerColour CGColor]);
    CGContextSetFillColorWithColor(ctx, [playerColour CGColor]);
    
    int graphHeight = self.frame.size.height;
    int maxGraphHeight = graphHeight - kOffsetY;
    int score=0;
    int dataIndex = 0; // incremental index to plot
    
    float plotVisitsX=0.0f;
    float plotPointsY=0.0f + graphHeight;
    CGGradientRef gradient = NULL;
    CGColorSpaceRef colorspace;
    CGPoint startPoint, endPoint;
    colorspace = CGColorSpaceCreateDeviceRGB();
    
    CGContextSetFillColorWithColor(ctx, [[UIColor colorWithRed:1.0 green:0.5 blue:0 alpha:0.5] CGColor]);

    
    if (fillGraph) {
        
        size_t num_locations = 2;
        CGFloat locations[2] = {0.0, 1.0};
        colorspace = CGColorSpaceCreateDeviceRGB();
        
        if (playerIndex == 2) {
            const CGFloat *componentsP2 = CGColorGetComponents(self.skinPlayer2Colour.CGColor);

            CGFloat components[8] = {componentsP2[0], componentsP2[1], componentsP2[2], 0.65,  // Start color
                componentsP2[0], componentsP2[1], componentsP2[2], 0.05}; // End color
            
            
            gradient = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
        } else {
            
             const CGFloat *componentsP1 = CGColorGetComponents(self.skinPlayer1Colour.CGColor);

            CGFloat components[8] = {componentsP1[0], componentsP1[1], componentsP1[2], 0.65,  // Start color
                componentsP1[0], componentsP1[1], componentsP1[2], 0.05}; // End color
            
            
            gradient = CGGradientCreateWithColorComponents(colorspace, components, locations, num_locations);
        }
        startPoint.x = kOffsetX;
        startPoint.y = maxGraphHeight;
        endPoint.x = kOffsetX;
        endPoint.y = kOffsetY;
    }
    
    /* first part is to draw the lines of data actually logged */
    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, plotVisitsX, plotPointsY);
    /* run through player 1 and player 2 shared data array picking out only selected players data */
    for (breakEntry *entry in self.frameData) {
        dataIndex ++;
        NSNumber *scoreNbr=entry.playerid;
        int pIndex = [scoreNbr intValue];
        if (pIndex == playerIndex) {
            
            NSNumber *pointsValue = [NSNumber numberWithInt:0];
            if (entry.points!=nil) {
                pointsValue = entry.points;
            }
            
            score += [pointsValue intValue];
            float plotPoints = self.scalePointsY * score;
            plotVisitsX = kOffsetX + dataIndex * self.scaleVisitsX;
            plotPointsY = graphHeight - maxGraphHeight * plotPoints;
            CGContextAddLineToPoint(ctx, plotVisitsX ,plotPointsY );
        }
        
    }
    if (fillGraph) {
        
        CGContextAddLineToPoint(ctx, plotVisitsX, maxGraphHeight);
        CGContextClosePath(ctx);
        CGContextSaveGState(ctx);
        CGContextClip(ctx);
        CGContextDrawLinearGradient(ctx, gradient, startPoint, endPoint, 0);
        CGContextRestoreGState(ctx);
        CGColorSpaceRelease(colorspace);
        CGGradientRelease(gradient);
        
    } else {
        
        CGContextDrawPath(ctx, kCGPathStroke);
        
        /* last part of method is to check if selected player has a break that is current or not */
        if (breakOfPlayer > 0) {
            /* break exists, draw one dotted line entry to signify entry on graph */
            CGContextSetLineWidth(ctx, 2.0);
            CGContextMoveToPoint(ctx, plotVisitsX, plotPointsY);
            /* turn dash on! */
            CGFloat dash[] = {5.0, 5.0};
            CGContextSetLineDash(ctx, 0.0, dash, 2);
            
            dataIndex ++;
            score += breakOfPlayer;
            
            float plotPoints = self.scalePointsY * score;
            plotVisitsX = kOffsetX + dataIndex * self.scaleVisitsX;
            plotPointsY = graphHeight - maxGraphHeight * plotPoints;
            
            CGContextAddLineToPoint(ctx, plotVisitsX ,plotPointsY );
            CGContextDrawPath(ctx, kCGPathStroke);
            /* remove dash */
            CGContextSetLineDash(ctx, 0, NULL, 0);
        }
    }
}





-(void)plotHighlighter:(CGContextRef)ctx :(UIColor*) highlightColour :(int) breakIndex {
    
    CGContextSetLineWidth(ctx, 4.0);
    CGContextSetStrokeColorWithColor(ctx, [highlightColour CGColor]);
    CGContextSetFillColorWithColor(ctx, [highlightColour CGColor]);
    
    /* assist with scale of graph - height */
    int maxScore, p1ActiveBreak=0, p2ActiveBreak=0;
    
    breakEntry *checkData = [self.selectedData lastObject];
    
    if (self.graphReferenceId == [checkData.frameid intValue]) {
        if (self.p1.activeBreak>0) {
            p1ActiveBreak=[self.p1.activeBreak intValue];
        }
        if (self.p2.activeBreak>0) {
            p2ActiveBreak=[self.p2.activeBreak intValue];
        }
    }
    
    if (self.scorePlayer1+p1ActiveBreak > self.scorePlayer2+p2ActiveBreak) {
        maxScore = self.scorePlayer1+1+p1ActiveBreak;
    } else {
        maxScore = self.scorePlayer2+1+p2ActiveBreak;
    }
    self.scalePointsY = 1.0f/maxScore;
    
    
    int graphHeight = self.frame.size.height;
    int maxGraphHeight = graphHeight - kOffsetY;
    float plotVisitsX=0.0f;     // maintains X position of line
    float plotPointsY=0.0f;     // maintains Y position of line
    
    int p1_score=0; // variable used to store visit point value.
    int p2_score=0; // variable used to store visit point value.
    int dataIndex = 0;
    for (breakEntry *entry in self.frameData) {
        
        
        
        float plotPoints;
        dataIndex ++;
        NSNumber *pointsValue=entry.points;

        if (entry.playerid==[NSNumber numberWithInt:1]) {
            p1_score += [pointsValue intValue];
            plotPoints = self.scalePointsY * p1_score;
        } else if (entry.playerid==[NSNumber numberWithInt:2]) {
            p2_score += [pointsValue intValue];
            plotPoints = self.scalePointsY * p2_score;
        } else if (entry.playerid==[NSNumber numberWithInt:0]) {
            plotPoints = 0;
        }
  
        plotVisitsX = kOffsetX + dataIndex * self.scaleVisitsX;
        
        
        plotPointsY = graphHeight - maxGraphHeight * plotPoints;
 
        if (breakIndex==dataIndex) {
     
        
            CGRect rect;
            if (self.frameData.count > 30)
                rect = CGRectMake(plotVisitsX - kSmallCircleRadius, plotPointsY - kSmallCircleRadius, 2 * kSmallCircleRadius, 2 * kSmallCircleRadius);
            else {
                rect = CGRectMake(plotVisitsX - kCircleRadius, plotPointsY - kCircleRadius, 2 * kCircleRadius, 2 * kCircleRadius);
            }

            CGContextBeginPath(ctx);
            
            CGContextAddEllipseInRect(ctx, rect);
            
            CGContextDrawPath(ctx, kCGPathFillStroke);
                
            return;
        }
    }
    
}





-(void)plotPlayerMarkers:(CGContextRef)ctx :(int) playerIndex  :(UIColor*) playerColour :(int) breakIndex {
    
    CGContextSetLineWidth(ctx, 4.0);
    CGContextSetStrokeColorWithColor(ctx, [playerColour CGColor]);
    CGContextSetFillColorWithColor(ctx, [playerColour CGColor]);
    
    int graphHeight = self.frame.size.height;
    int maxGraphHeight = graphHeight - kOffsetY;
    float plotVisitsX=0.0f;     // maintains X position of line
    float plotPointsY=0.0f;     // maintains Y position of line
    int score=0; // variable used to store visit point value.
    int dataIndex = 0;
    for (breakEntry *entry in self.frameData) {
        
        dataIndex ++;
        NSNumber *playerValue=entry.playerid;
        int pIndex = [playerValue intValue];
        
        if (pIndex == playerIndex) {
            
            // NSLog(@"%@",[dataPoint valueForKey:@"ballTransaction"]);
            
            NSNumber *pointsValue=entry.points;
            score += [pointsValue intValue];
            
            float plotPoints = self.scalePointsY * score;
            
            plotVisitsX = kOffsetX + dataIndex * self.scaleVisitsX;
            plotPointsY = graphHeight - maxGraphHeight * plotPoints;
            
            UIColor *useColour = playerColour;
            if (breakIndex==dataIndex) {
                useColour = [UIColor orangeColor];
            }
            
                CGRect rect;
                if (self.frameData.count > 30)
                    rect = CGRectMake(plotVisitsX - kSmallCircleRadius, plotPointsY - kSmallCircleRadius, 2 * kSmallCircleRadius, 2 * kSmallCircleRadius);
                else {
                    rect = CGRectMake(plotVisitsX - kCircleRadius, plotPointsY - kCircleRadius, 2 * kCircleRadius, 2 * kCircleRadius);
                }
                if (dataIndex<100) {
                    touchAreas[dataIndex] = rect;
                }
                CGContextAddEllipseInRect(ctx, rect);
            
        }
    }
    CGContextDrawPath(ctx, kCGPathFillStroke);
}


- (void)drawLineGraphWithContext:(CGContextRef)ctx
{
    /* assist with scale of graph - height */
    int maxScore, p1ActiveBreak=0, p2ActiveBreak=0;
    
    breakEntry *checkData = [self.selectedData lastObject];
    
    if (self.graphReferenceId == [checkData.frameid intValue]) {
        if (self.p1.activeBreak>0) {
            p1ActiveBreak=[self.p1.activeBreak intValue];
        }
        if (self.p2.activeBreak>0) {
            p2ActiveBreak=[self.p2.activeBreak intValue];
        }
    }
    
    if (self.scorePlayer1+p1ActiveBreak > self.scorePlayer2+p2ActiveBreak) {
        maxScore = self.scorePlayer1+1+p1ActiveBreak;
    } else {
        maxScore = self.scorePlayer2+1+p2ActiveBreak;
    }
    self.scalePointsY = 1.0f/maxScore;
    /* assist with scale of graph - width */
    NSUInteger frameDataEntries = self.frameData.count;
     if (p1ActiveBreak+p2ActiveBreak > 0) {
        frameDataEntries ++;
    }

    [self plotPlayerLines:false :ctx :1 :p1ActiveBreak :self.skinPlayer1Colour];
    //[self plotPlayerLines:true :ctx :1 :p1ActiveBreak :self.skinPlayer1Colour];
    [self plotPlayerMarkers:ctx :1 :self.skinPlayer1Colour :0];
 

    [self plotPlayerLines:false :ctx :2 :p2ActiveBreak :self.skinPlayer2Colour];
    //[self plotPlayerLines:true :ctx :2 :p2ActiveBreak :self.skinPlayer2Colour];
    [self plotPlayerMarkers:ctx :2 :self.skinPlayer2Colour:0];

    
    
}

#pragma USER EVENTS



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
   
    CGPoint point = [touch locationInView:self];
    
    for (int i = 0; i < 100; i++)
    {
        if (CGRectContainsPoint(touchAreas[i], point))
        {
            if (self.graphReferenceId!=0) {
                
               // [self showFrameDuration:i];
                
                //[self updateStatBox:i :TRUE];
            } else {

                [self.delegate loadBreakShots:i :TRUE];
            }
            break;
        }
    }
}

/* created 14/11/16 */
-(void) initColours:(UIColor*) skinPlayer1Colour :(UIColor*) skinPlayer2Colour {
    
    self.skinPlayer1Colour = skinPlayer1Colour;
    self.skinPlayer2Colour = skinPlayer2Colour;
}




-(void) loadSharedData {
   if (self.graphReferenceId !=0 ) {
       self.frameData = [self getData:self.selectedData :[NSNumber numberWithInt:self.graphReferenceId]];
       
       
       if (self.graphReferenceId==self.numberOfFrames) {
            // somehow construct breakentry here for the table view.
           
       }

       self.frameDataReversed = [[[self.frameData reverseObjectEnumerator] allObjects] mutableCopy];
       
       self.scorePlayer1 = [self getFramePoints:self.frameData :[NSNumber numberWithInt:1] :[NSNumber numberWithInt:self.graphReferenceId]];
       self.scorePlayer2 = [self getFramePoints:self.frameData :[NSNumber numberWithInt:2] :[NSNumber numberWithInt:self.graphReferenceId]];
       
   } else {
       
       
   }
    
    
    
}

#pragma STANDARD UIView METHODS

- (void)drawRect:(CGRect)rect {
    
    //if (self.printGraph) {
    [self initMatchGraphData];
    //}
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, [[UIColor grayColor] CGColor]);
    
    CGFloat dash[] = {1.0, 1.0};
    CGContextSetLineDash(context, 0.0, dash, 2);
    
    int graphBottom = self.frame.size.height;
    
    breakEntry *checkData = [self.selectedData lastObject];
    
    
    if (self.graphReferenceId !=0 ) {
   
        NSUInteger frameDataEntries = self.frameData.count;
        if ([self.p1.activeBreak intValue] + [self.p2.activeBreak intValue] > 0 && self.graphReferenceId == [checkData.frameid intValue]) {
            frameDataEntries ++;
        }
        
        self.scaleVisitsX = 0.0;
        if (frameDataEntries>0) {
            self.scaleVisitsX = ((int)self.frame.size.width - 5) / frameDataEntries;
        }
        if (self.scaleVisitsX==0) {
            self.scaleVisitsX=50;
        }
        
        
        if (self.overlay==false) {
        
            if (frameDataEntries <= 30) {
                // How many lines?
                int howMany = (self.frame.size.width - kOffsetX) + 11 / self.scaleVisitsX;
                // Here the lines go
                for (int i = 0; i < howMany; i++)
                {
                    CGContextMoveToPoint(context, kOffsetX + i * self.scaleVisitsX, kGraphTop);
                    CGContextAddLineToPoint(context, kOffsetX + i * self.scaleVisitsX, graphBottom);
                }
            
                int howManyHorizontal = (graphBottom - kGraphTop - kOffsetY) / self.scaleVisitsX;
                for (int i = 0; i <= howManyHorizontal; i++)
                {
                    CGContextMoveToPoint(context, kOffsetX, graphBottom - kOffsetY - i * self.scaleVisitsX);
                    CGContextAddLineToPoint(context, self.frame.size.width, graphBottom - kOffsetY - i * self.scaleVisitsX    );
                }
                CGContextStrokePath(context);
            }
            CGContextSetLineDash(context, 0, NULL, 0); // Remove the dash
            [self drawLineGraphWithContext:context];
        } else {
            CGContextSetLineDash(context, 0, NULL, 0); // Remove the dash
            
            
            [self plotHighlighter:context :[UIColor colorWithRed:90.0f/255.0f green:200.0f/255.0f blue:250.0f/255.0f alpha:1.0f] :self.plotHighlightIndex];
        }
    } else {
        if (self.overlay==false) {
            // draw stacked bar graph for match
            float scaleFrames = 0.0;
            int colsScale = self.numberOfFrames;
            if (self.numberOfFrames>0) {
                if (self.numberOfFrames<8) {
                    colsScale = 8;
                }
                scaleFrames = ((int)self.frame.size.width) / colsScale;
            }
            if (scaleFrames==0) {
                scaleFrames=10;
            }
            // How many lines?
            int howMany = (self.frame.size.width - kOffsetX) + 11 / scaleFrames;
    
            // Here the lines go
            for (int i = 0; i < howMany; i++)
            {
                CGContextMoveToPoint(context, kOffsetX + i * scaleFrames, kGraphTop);
                CGContextAddLineToPoint(context, kOffsetX + i * scaleFrames, graphBottom);
            }
            int howManyHorizontal = (graphBottom - kGraphTop - kOffsetY) / scaleFrames;
            for (int i = 0; i <= howManyHorizontal; i++)
            {
                CGContextMoveToPoint(context, kOffsetX, graphBottom - kOffsetY - i * scaleFrames);
                CGContextAddLineToPoint(context, self.frame.size.width, graphBottom - kOffsetY - i * scaleFrames    );
            }
        
        
            CGContextStrokePath(context);
            CGContextSetLineDash(context, 0, NULL, 0); // Remove the dash
            [self drawMatchStackedbarGraphWithContext:context];
            
        }
        
    }
    
}

@end
