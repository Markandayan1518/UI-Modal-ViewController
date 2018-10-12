//
//  ViewController.m
//  UI Modal ViewController
//
//  Created by Markandayan Perumandi on 12/10/18.
//  Copyright © 2018 Markandayan Perumandi. All rights reserved.
//

#import "ViewController.h"
#import "NavigationTransitionAnimator.h"

@interface ViewController () <UINavigationControllerDelegate>
@property(weak, nonatomic) IBOutlet UIPickerView *modalPresentationStylePicker;

@property(strong, nonatomic, readonly) NSArray <NSString *> *pickerData;
@property(nonatomic) UIModalPresentationStyle presentationStyle;
@property(nonatomic) UIModalTransitionStyle transitionStyle;
@property(nonatomic) UIPopoverArrowDirection arrowDirections;
@property(nonatomic) BOOL presentationContext;
@property(strong, nonatomic) id <UIViewControllerAnimatedTransitioning> animator;
@property(strong, nonatomic) UIPercentDrivenInteractiveTransition *interactionController;

// Hidden Option Views
@property(weak, nonatomic) IBOutlet UILabel *arrowLabel;
@property(weak, nonatomic) IBOutlet UISegmentedControl *arrowSegment;
@property(weak, nonatomic) IBOutlet UIButton *custom;

@end

@implementation ViewController

@synthesize transitionStyle = _transitionStyle;

- (UIModalTransitionStyle)transitionStyle {
    if (!_transitionStyle) {
        _transitionStyle = UIModalTransitionStyleCoverVertical;  // default
    }
    return _transitionStyle;
}

@synthesize presentationStyle = _presentationStyle;

- (UIModalPresentationStyle)presentationStyle {
    if (!_presentationStyle) {
        _presentationStyle = UIModalPresentationFullScreen; // default
    }
    return _presentationStyle;
}

@synthesize arrowDirections = _arrowDirections;

- (UIPopoverArrowDirection)arrowDirections {
    if (!_arrowDirections) {
        _arrowDirections = UIPopoverArrowDirectionAny;
    }
    return _arrowDirections;
}

@synthesize pickerData = _pickerData;

- (NSArray<NSString *> *)pickerData {
    if (self.transitionStyle == UIModalTransitionStyleCoverVertical) {
        _pickerData = @[@"Full Screen",
            @"Page Sheet",
            @"Form Sheet",
            @"Current Context",
            @"Custom",
            @"Over Full Screen",
            @"Over Current Context",
            @"Pop Over",
            @"Blur Over Full Screen (tvOS)",
            @"None"];
    } else if (self.transitionStyle == UIModalTransitionStylePartialCurl) { // UIModalTransitionStylePartialCurl support only the Full Screen
        _pickerData = @[@"Full Screen"];
    } else {
        _pickerData = @[@"Full Screen",
            @"Page Sheet",
            @"Form Sheet",
//            @"Current Context",
            @"Custom",
            @"Over Full Screen"];
//            @"Over Current Context",
//            @"Pop Over",
//            @"Blur Over Full Screen (tvOS)",
//            @"None"];
    }
    return _pickerData;
}

@synthesize animator = _animator;

- (id <UIViewControllerAnimatedTransitioning>)animator {
    if (!_animator) {
        _animator = [[NavigationTransitionAnimator alloc] init];
    }
    return _animator;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.modalPresentationStylePicker.dataSource = self;
    self.modalPresentationStylePicker.delegate = self;
    [self.arrowLabel setHidden:YES];
    [self.arrowSegment setHidden:YES];
    [self.custom setHidden:YES];
}

#pragma mark - Controller

- (IBAction)onChangeModalTransitionStyle:(UISegmentedControl *)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    switch (sender.selectedSegmentIndex) {
        case 0:
            self.transitionStyle = UIModalTransitionStyleCoverVertical;
            break;
        case 1:
            self.transitionStyle = UIModalTransitionStyleFlipHorizontal;
            break;
        case 2:
            self.transitionStyle = UIModalTransitionStyleCrossDissolve;
            break;
        case 3:
            self.transitionStyle = UIModalTransitionStylePartialCurl;
            self.presentationStyle = UIModalPresentationFullScreen;
            break;
        default:
            break;

    }

    [self.modalPresentationStylePicker reloadAllComponents];
}

- (IBAction)onClickDefault:(UIButton *)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    UIViewController *viewController = [[UIViewController alloc] init];
    viewController.title = @"Root View Controller";
    viewController.view.backgroundColor = [UIColor whiteColor];

    UIViewController *blueVC = [[UIViewController alloc] init];
    viewController.title = @"Sub View Controller";
    blueVC.view.backgroundColor = [UIColor blueColor];


    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    viewController.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                                     target:self
                                                                                                     action:@selector(dismissView)];
    navigationController.preferredContentSize = CGSizeMake(400, 600);
    navigationController.definesPresentationContext = self.presentationContext;
    navigationController.modalTransitionStyle = self.transitionStyle;
    navigationController.modalPresentationStyle = self.presentationStyle;
    navigationController.delegate =self;
    [navigationController pushViewController:blueVC animated:YES];

    UIPopoverPresentationController *presentationController = navigationController.popoverPresentationController;
    presentationController.sourceView = sender;
    presentationController.sourceRect = sender.bounds;
    presentationController.permittedArrowDirections = self.arrowDirections;

    [self presentViewController:navigationController animated:YES completion:^{
        NSLog(@"Shown Default Modal View");
    }];

    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(pan:)];
    [self.navigationController.view addGestureRecognizer:panRecognizer];
}

- (void)dismissView {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self dismissViewControllerAnimated:YES completion:^{
        NSLog(@"Dismiss Modal View");
    }];
}

- (IBAction)onClickCustom:(UIButton *)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)onChangeModalPresentationStyle:(NSInteger)row {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    [self.arrowLabel setHidden:YES];
    [self.arrowSegment setHidden:YES];
    [self.custom setHidden:YES];

    switch (row) {
        case 0:
            self.presentationStyle = UIModalPresentationFullScreen;
            break;
        case 1:
//          width is set to the width of the screen in a portrait orientation
//          height is set to the height of the screen
            self.presentationStyle = UIModalPresentationPageSheet;
            break;
        case 2:
            self.presentationStyle = UIModalPresentationFormSheet;
            break;
        case 3:
            self.presentationStyle = UIModalPresentationCurrentContext;
            break;
        case 4:
//          TODO Custom Presentation Style
            self.presentationStyle = UIModalPresentationCustom;
            [self.custom setHidden:NO];
            break;
        case 5:
            self.presentationStyle = UIModalPresentationOverFullScreen;
            break;
        case 6:
            self.presentationStyle = UIModalPresentationOverCurrentContext;
            break;
        case 7:
            self.presentationStyle = UIModalPresentationPopover;
            [self.arrowLabel setHidden:NO];
            [self.arrowSegment setHidden:NO];
            break;
        case 8:
            self.presentationStyle = UIModalPresentationFullScreen;
//          Not Support for iOS and iPad
            NSLog(@"UIModalPresentationBlurOverFullScreen is not Support for iOS and iPad");
//            self.presentationStyle = UIModalPresentationBlurOverFullScreen;
//            self.presentationStyle = UIModalPresentationNone;
//            break;
//        case 9:
//            self.presentationStyle = UIModalPresentationNone;
//            break;
        default:
            break;
    }
}

- (IBAction)onChangePresentationContext:(UISwitch *)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    self.presentationContext = sender.isOn;
}

- (IBAction)onChangeDirection:(UISegmentedControl *)sender {
    NSLog(@"%s", __PRETTY_FUNCTION__);

    switch (sender.selectedSegmentIndex) {
        case 0:
            self.arrowDirections = UIPopoverArrowDirectionUp;
            break;
        case 1:
            self.arrowDirections = UIPopoverArrowDirectionDown;
            break;
        case 2:
            self.arrowDirections = UIPopoverArrowDirectionLeft;
            break;
        case 3:
            self.arrowDirections = UIPopoverArrowDirectionRight;
            break;
        case 4:
            self.arrowDirections = UIPopoverArrowDirectionAny;
            break;
        case 5:
            self.arrowDirections = UIPopoverArrowDirectionUnknown;
            break;
        default:
            break;
    }
}

- (void)pan:(UIPanGestureRecognizer *)recognizer {
    UIView *view = self.navigationController.view;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint location = [recognizer locationInView:view];
        if (location.x < CGRectGetMidX(view.bounds) && self.navigationController.viewControllers.count > 1) { // left half
            self.interactionController = [UIPercentDrivenInteractiveTransition new];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:view];
        CGFloat d = fabs(translation.x / CGRectGetWidth(view.bounds));
        [self.interactionController updateInteractiveTransition:d];
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        if ([recognizer velocityInView:view].x > 0) {
            [self.interactionController finishInteractiveTransition];
        } else {
            [self.interactionController cancelInteractiveTransition];
        }
        self.interactionController = nil;
    }
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.pickerData.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.pickerData[row];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    UILabel *label = [[UILabel alloc] init];
    if (row == 8 || row == 9) {
        label.textColor = [UIColor lightGrayColor];
    } else {
        label.textColor = [UIColor blackColor];
    }
    label.textAlignment = NSTextAlignmentCenter;
    label.text = self.pickerData[row];
    return label;
}


#pragma mark  - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    [self onChangeModalPresentationStyle:row];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    if (operation == UINavigationControllerOperationPop || operation == UINavigationControllerOperationPush) {
        return self.animator;
    }
    return nil;
}

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>)animationController {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return self.interactionController;
}

@end
