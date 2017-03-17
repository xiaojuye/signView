//
//  ViewController.m
//  sign
//
//  Created by Gzedu on 2017/3/17.
//  Copyright © 2017年 Gzedu. All rights reserved.
//

#import "ViewController.h"
#import "LJsignView.h"
@interface ViewController ()<LJsignViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *image;

@property (nonatomic,strong)LJsignView *signView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _signView = [[LJsignView alloc]init];
    [self.view addSubview:_signView];
    _signView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 300);
    _signView.backgroundColor = [UIColor lightGrayColor];
    _signView.delegate = self;
    
}

- (void)LJsignViewDelegateWithImage:(UIImage *)image{
    self.image.image = image;
}
- (IBAction)clickResignBtn:(UIButton *)sender {
    [_signView clearSignature];
    
    self.image.image = nil;
}



@end
