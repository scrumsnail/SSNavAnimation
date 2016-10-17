//
//  ViewController.m
//  SSNavAnimation
//
//  Created by allthings_LuYD on 2016/10/17.
//  Copyright © 2016年 scrum_snail. All rights reserved.
//

#import "ViewController.h"
#define VH self.view.frame.size.height
#define VD self.view.frame.size.width
@interface ViewController ()

//The status state
@property (nonatomic,assign) BOOL statusBarHidden;

//The popView
@property (nonatomic,strong) UIView *popView;

//Control popView show
@property (nonatomic,strong) UIButton *popBtn;

//control popView hide
@property (nonatomic,strong) UIButton *backBtn;
@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBar.hidden = YES;
    //The info.plist should setting :key:View controller-based status bar appearance  value:NO
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    self.title = @"scrum_snail";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.popBtn];
}

- (UIButton *)popBtn{
    if (!_popBtn) {
        _popBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_popBtn setTitle:@"pop" forState:UIControlStateNormal];
        [_popBtn setBackgroundColor:[UIColor whiteColor]];
        [_popBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_popBtn setFrame:CGRectMake(0, VH - 50, VD, 50)];
        [_popBtn addTarget:self action:@selector(popViewToPop) forControlEvents:UIControlEventTouchUpInside];
    }
    return _popBtn;
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _backBtn.frame = CGRectMake(10, 10, 13, 20);
        [_backBtn setBackgroundImage:[UIImage imageNamed:@"back(white)"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(hidePopView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UIView *)popView{
    if (!_popView) {
        _popView = [[UIView alloc] initWithFrame:CGRectMake(0, VH, VD, VH)];
        _popView.backgroundColor = [UIColor whiteColor];
        _popView.userInteractionEnabled = YES;
        UIPanGestureRecognizer *panHandle = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panHandle:)];
        [_popView addGestureRecognizer:panHandle];
    }
    return _popView;
}

- (void)popViewToPop{
    [self.view addSubview:self.popView];
    [UIApplication sharedApplication].statusBarHidden = YES;
    [[UIApplication sharedApplication].keyWindow addSubview:self.backBtn];
    [UIView animateWithDuration:0.5 delay:0.05 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect rect = self.popView.frame;
        rect.origin.y = VH / 3.0;
        self.popView.frame = rect;
    } completion:^(BOOL finished) {

    }];
}

- (void)hidePopView{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect rect = self.popView.frame;
        rect.origin.y = VH;
        self.popView.frame = rect;
        if (self.navigationController.navigationBarHidden == NO) {
            [self.navigationController setNavigationBarHidden:YES animated:YES];
        }
        [self.backBtn removeFromSuperview];
    } completion:^(BOOL finished) {
        self.backBtn = nil;
        [UIApplication sharedApplication].statusBarHidden = NO;
    }];
}

- (void)panHandle:(UIPanGestureRecognizer *)sender{
    //Offset
    CGPoint transPoint = [sender translationInView:sender.view];
    CGPoint senderViewPoint = sender.view.center;
    senderViewPoint.y += transPoint.y;
    if (senderViewPoint.y <= self.view.center.y + self.navigationController.navigationBar.frame.size.height) {
        senderViewPoint.y = self.view.center.y + self.navigationController.navigationBar.frame.size.height;
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self.backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    }else{
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [self.backBtn setBackgroundImage:[UIImage imageNamed:@"back(white)"] forState:UIControlStateNormal];
    }
    //qq animation
    if (senderViewPoint.y >= VH / 3.0 + self.view.center.y + 50) {
        senderViewPoint.y = VH / 3.0 + self.view.center.y + 50;
    }
    if (sender.state == UIGestureRecognizerStateEnded) {
        if (senderViewPoint.y >= VH / 3.0 + self.view.center.y) {
            senderViewPoint.y = VH / 3.0 + self.view.center.y;
        }
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            sender.view.center = senderViewPoint;
        } completion:^(BOOL finished) {

        }];
    }else{
        sender.view.center = senderViewPoint;
    }

    [sender setTranslation:CGPointZero inView:sender.view];
}
@end
