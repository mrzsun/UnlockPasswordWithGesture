//
//  ViewController.m
//  test-unlock
//
//  Created by marco Sun on 15/9/29.
//  Copyright © 2015年 com.60. All rights reserved.
//

#import "ViewController.h"
#import "UnLockView.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UnLockView *unLockView;
@property (nonatomic,copy) NSString *password;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [_unLockView getPasswordWithBlockCompletion:^(NSString *password) {
        _password = password;
        NSLog(@"%@",_password);
        //_password的值即我们所获取的手势密码的值，利用这个值做我们想做的操作。
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}






@end
