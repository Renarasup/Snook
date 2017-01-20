//
//  IntroPVC.m
//  SnookerScoreMaster
//
//  Created by andrew glew on 03/12/2016.
//  Copyright © 2016 andrew glew. All rights reserved.
//

#import "IntroPVC.h"

@interface IntroPVC ()

@end

@implementation IntroPVC
{
    NSArray *myViewControllers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    self.dataSource = self;
    
    self.view.backgroundColor = [UIColor blackColor];
    
    UIViewController *p1 = [self.storyboard
                            instantiateViewControllerWithIdentifier:@"Intro1ID"];
    UIViewController *p2 = [self.storyboard
                            instantiateViewControllerWithIdentifier:@"Intro2ID"];
    UIViewController *p3 = [self.storyboard
                            instantiateViewControllerWithIdentifier:@"Intro3ID"];
    
    UIViewController *p4 = [self.storyboard
                            instantiateViewControllerWithIdentifier:@"Intro4ID"];
    
    UIViewController *p5 = [self.storyboard
                            instantiateViewControllerWithIdentifier:@"Intro5ID"];
    
    UIViewController *p6 = [self.storyboard
                            instantiateViewControllerWithIdentifier:@"Intro6ID"];
    
    UIViewController *p7 = [self.storyboard
                            instantiateViewControllerWithIdentifier:@"Intro7ID"];
    
    
    myViewControllers = @[p1,p2,p3,p4,p5,p6,p7];
    
    [self setViewControllers:@[p1]
                   direction:UIPageViewControllerNavigationDirectionForward
                    animated:NO completion:nil];
    
    NSLog(@"loaded!");
}

-(UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    return myViewControllers[index];
}





-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
     viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger currentIndex = [myViewControllers indexOfObject:viewController];
    // get the index of the current view controller on display
    
    if (currentIndex > 0)
    {

        return [myViewControllers objectAtIndex:currentIndex-1];
    
        // return the previous viewcontroller
    } else
    {
        return nil;
        // do nothing
    }
}
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger currentIndex = [myViewControllers indexOfObject:viewController];
    // get the index of the current view controller on display
    // check if we are at the end and decide if we need to present
    // the next viewcontroller
    if (currentIndex < [myViewControllers count]-1)
    {
        return [myViewControllers objectAtIndex:currentIndex+1];
        // return the next view controller
    } else
    {
        return nil;
        // do nothing
    }
}











-(NSInteger)presentationCountForPageViewController:
(UIPageViewController *)pageViewController
{
    return myViewControllers.count;
}

-(NSInteger)presentationIndexForPageViewController:
(UIPageViewController *)pageViewController
{
    return 0;
}

@end
