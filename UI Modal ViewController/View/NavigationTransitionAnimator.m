//
//  NavigationTransitionAnimator.m
//  UI Modal ViewController
//
//  Created by Markandayan Perumandi on 13/10/18.
//  Copyright © 2018 Markandayan Perumandi. All rights reserved.
//

#import "NavigationTransitionAnimator.h"

@implementation NavigationTransitionAnimator

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 1;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    [[transitionContext containerView] addSubview:toViewController.view];
    toViewController.view.alpha = 0;

    [UIView animateWithDuration:1
                     animations:^{
                         fromViewController.view.transform = CGAffineTransformMakeScale(0.1, 0.1);
                         toViewController.view.alpha = 1;
                     }
                     completion:^(BOOL finished) {
                         fromViewController.view.transform = CGAffineTransformIdentity;
                         [transitionContext completeTransition:![transitionContext transitionWasCancelled]];

                     }];
}

- (id <UIViewImplicitlyAnimating>)interruptibleAnimatorForTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return nil;
}


- (void)animationEnded:(BOOL)transitionCompleted {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
