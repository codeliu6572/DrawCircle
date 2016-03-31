//
//  ViewController.m
//  画圆
//
//  Created by 刘浩浩 on 16/3/30.
//  Copyright © 2016年 CodingFire. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    int start;
    int end;
    CAShapeLayer *layer;
    NSTimer *timer;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame=CGRectMake(0, 0, 100, 100);
    btn.center=self.view.center;
    btn.backgroundColor=[UIColor orangeColor];
    [btn addTarget:self action:@selector(clickForShake:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    

        [self draw];
}
- (void)draw
{
    
    
    start = 0;
    end = 0;
    //这里的方法上一篇博客有说过，不再详细解释。
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 200, 200)];
    if (layer)
    {
        [layer removeFromSuperlayer];
        layer = nil;
    }
    layer = [CAShapeLayer layer];
    layer.frame = CGRectMake(0, 0, 200, 200);
    layer.strokeColor = [UIColor redColor].CGColor;
    layer.path = circlePath.CGPath;
    layer.lineWidth = 5.0;
    layer.lineJoin = kCALineJoinRound;
    layer.lineCap = kCALineCapRound;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.position = self.view.center;
    layer.strokeStart = start/10.0;
    layer.strokeEnd = end/10.0;
    [self.view.layer addSublayer:layer];
//    layer.affineTransform=CGAffineTransformMakeRotation(M_PI_2);
    
}
- (void)updateLayer
{
    //起始点为0，结束点不断增加，圆的弧线越来越长，到结束点闭合就变成了圆
    if (start == 0 && end < 10)
    {
        end ++;
    }
    //闭合后，起始点追着结束点走的路线开始收缩到结束点，圆就消失了，这时起始点的值等于结束点的值
    else if (start < 10  && end == 10)
    {
        start ++;
    }
    //这时要开始重复之前的动作，把两个点的值都变为初始值，同时，重新调用画图方法，并结束上一个圆的刷新步骤，因为这个刷新步骤是定时器控制的，所以，结束后会在新的圆里面发挥作用
    else
    {
        start = end = 0;
        [self draw];
        return;
    }
    
    layer.strokeStart = start/10.0;
    layer.strokeEnd = end/10.0;
}


- (void)clickForShake:(UIButton *)btn
{
    //帧动画
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    //动画在x轴方向
    animation.keyPath = @"position.x";
    //表单所到的位置
    animation.values = @[@0,@10,@0,@-10,@0,@10,@0];
    //指定对应步动画发生的时间分数
    animation.keyTimes = @[@0,@(1/6.0),@(2/6.0),@(3/6.0),@(4/6.0),@(5/6.0),@1];
    //动画持续总时间
    animation.duration = 0.5;
    //使 Core Animation 在更新 presentation layer 之前将动画的值添加到 model layer 中去。这使我们能够对所有形式的需要更新的元素重用相同的动画，且无需提前知道它们的位置。因为这个属性从 CAPropertyAnimation 继承，所以你也可以在使用 CABasicAnimation 时使用它。（网上搜来的这句话，说的比较官方，没太懂,但是当设置为NO时，系统找不到当前的x位置，就在x＝0的地方摇动，效果差太明显，可以运行查看）
    animation.additive = NO;
    [btn.layer addAnimation:animation forKey:@"shake"];
    
    
    if (!timer)
    {
        timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                 target:self
                                               selector:@selector(updateLayer)
                                               userInfo:nil
                                                repeats:YES];
    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
