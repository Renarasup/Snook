//
//  DraggableView.m
//  SnookerScoreLite
//
//  Created by andrew glew on 01/10/2015.
//  Copyright © 2015 andrew glew. All rights reserved.
//

#import "DraggableView.h"

@implementation DraggableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@synthesize location;

-(void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *aTouch = [touches anyObject];
    location = [aTouch locationInView:self.superview];
    
    [UIView beginAnimations:@"Dragging A DraggableView" context:nil];
    self.frame = CGRectMake(location.x-offset.x, location.y-offset.y,
                            self.frame.size.width, self.frame.size.height);
    [UIView commitAnimations];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *aTouch = [touches anyObject];
    
    offset = [aTouch locationInView: self];
}

-(CGPoint) getLocation {
    
    return self.location;
}


@end
