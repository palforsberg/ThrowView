//
//  ViewController.m
//  ThrowView
//
//  Created by Pål on 2014-01-26.
//  Copyright (c) 2014 Pål. All rights reserved.
//

#import "ViewController.h"


@interface ViewController (){
}

@end

@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    ThrowView *throw = [[ThrowView alloc] initWithFrame:self.view.frame];
    throw.throwDelegate = self;
    [self.view addSubview:throw];
    for(int i = 0; i<10; i++){
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        v.backgroundColor = [UIColor colorWithWhite:0.9 - (float)i/10.f alpha:1.f];
        v.center = self.view.center;
        [throw addSubview:v];
    }
}


-(void)throwView:(ThrowView *)tv willRemoveView:(UIView *)v{
        NSLog(@"Did remove view");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
