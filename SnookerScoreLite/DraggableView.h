//
//  DraggableView.h
//  SnookerScoreLite
//
//  Created by andrew glew on 01/10/2015.
//  Copyright © 2015 andrew glew. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DraggableView : UIView {
CGPoint offset;
CGPoint location;
}
@property(nonatomic) CGPoint location;

-(CGPoint) getLocation;

@end
