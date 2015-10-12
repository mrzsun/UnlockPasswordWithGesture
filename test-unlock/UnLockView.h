//
//  UnLockView.h
//  test-unlock
//
//  Created by marco Sun on 15/9/30.
//  Copyright © 2015年 com.60. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^passwordBlock)(NSString *);

@interface UnLockView : UIView

- (void)getPasswordWithBlockCompletion:(passwordBlock)block;


@end
