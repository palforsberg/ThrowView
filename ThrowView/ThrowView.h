//
//  ThrowView.h
//  ThrowView
//
//  Created by Pål on 2014-01-26.
//  Copyright (c) 2014 Pål. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ThrowView;
@protocol ThrowViewDelegate <NSObject>

@optional
-(void)throwView:(ThrowView *)tv willRemoveView:(UIView *)v;

@end
@interface ThrowView : UIView{
    id<ThrowViewDelegate>throwDelegate;
}

@property (nonatomic, retain) id<ThrowViewDelegate>throwDelegate;

- (id)initWithFrame:(CGRect)frame;
@end
