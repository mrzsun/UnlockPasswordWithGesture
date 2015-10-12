//
//  UnLockView.m
//  test-unlock
//
//  Created by marco Sun on 15/9/30.
//  Copyright © 2015年 com.60. All rights reserved.
//

#import "UnLockView.h"

@interface UnLockView ()

@property (strong,nonatomic) NSMutableArray *buttons; //装着9个按钮的数组
@property (nonatomic,copy) NSMutableString *password; //手势密码
@property (assign,nonatomic) CGPoint currentPoint; 
@property (nonatomic,copy) passwordBlock block;

@end

@implementation UnLockView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        for (int index = 0 ; index < 9; index ++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = index + 1;
            [self addSubview:button];
        }
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    
    if (self = [super initWithCoder:aDecoder]) {
        for (int index = 0 ; index < 9; index ++) {
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = index + 1;
            button.userInteractionEnabled = NO;
            [self addSubview:button];
        }
    }
    return self;
}

- (NSMutableArray *)buttons {
    if (_buttons == nil) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}
- (NSMutableString *)password {
    if (!_password) {
        _password = [NSMutableString string];
    }
    return _password;
}

- (void)layoutSubviews {
    for (UIButton *button in self.subviews) {
        [button setBackgroundImage:[UIImage imageNamed:@"gesture_node_normal"] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"gesture_node_highlighted"] forState:UIControlStateSelected];
        NSInteger row = (button.tag - 1) / 3;
        NSInteger col = (button.tag - 1) % 3;
        CGFloat buttonW = 74;
        CGFloat buttonH = buttonW;
        CGFloat margin = (self.frame.size.width - buttonW * 3) / 4;
        CGFloat buttonX = margin * (col + 1) + buttonW * col;
        CGFloat buttonY = (buttonH + margin) * row;
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
    }
}

- (CGPoint)pointWithTouch:(NSSet *)touches {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:touch.view];
    return point;
}

- (void)selectedButtonsWithPoint:(CGPoint)point {
    if (!CGPointEqualToPoint(point, CGPointZero)) {
        _currentPoint = point;
    }
    for (UIButton *button in self.subviews) {
        CGRect frame = button.frame;
        frame.size.width = 24;
        frame.origin.x =  (button.frame.size.width - frame.size.width) / 2;
        frame.origin.y = frame.origin.x;
        if (CGRectContainsPoint(button.frame, point) && ![_buttons containsObject:button]) {
            [self.buttons addObject:button];
            button.selected = YES;
        }
        
    }
    [self setNeedsDisplay];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    _password = nil;
    CGPoint point = [self pointWithTouch:touches];
    [self selectedButtonsWithPoint:point];
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [self pointWithTouch:touches];

    [self selectedButtonsWithPoint:point];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
   
    for (UIButton *button in _buttons) {
        button.selected = NO;
        [self.password appendString:[NSString stringWithFormat:@"%ld",button.tag]];
    }
    if (_block) {
        _block(self.password);
    }


    [_buttons removeAllObjects];
    [self setNeedsDisplay];
    
}

- (void)drawRect:(CGRect)rect {
    if (_buttons.count == 0) {
        return;
    }
    UIBezierPath *path = [UIBezierPath bezierPath];
    if (_buttons) {
        for (UIButton *button in _buttons) {
            if (button == [_buttons firstObject]) {
                [path moveToPoint:button.center];
            } else {
                [path addLineToPoint:button.center];
            }
            
        }
        [path addLineToPoint:_currentPoint];
    }
  
    path.lineCapStyle = kCGLineCapButt;
    path.lineJoinStyle = kCGLineJoinBevel;
    path.lineWidth = 10;
    [[UIColor colorWithRed:32/255.0 green:210/255.0 blue:254/255.0 alpha:0.5] set];
    [path stroke];
}

- (void)getPasswordWithBlockCompletion:(passwordBlock)block {
    _block = block;
    block(_password);
    NSLog(@"%@",_password);
}

@end
