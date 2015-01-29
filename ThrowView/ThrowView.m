//
//  ThrowView.m
//  ThrowView
//
//  Created by Pål on 2014-01-26.
//  Copyright (c) 2014 Pål. All rights reserved.
//

#import "ThrowView.h"

@implementation ThrowView{
    UIDynamicAnimator *animator;
    UIAttachmentBehavior *attachment;
    UIPushBehavior *push;
    CGPoint startPoint;
}

@synthesize throwDelegate = _throwDelegate;

#define kMinSpeed 600
#define kMinDist 200
#define kDivFactor 7 //Bigger -> slower when thrown away

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
        UIPanGestureRecognizer *panner = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        panner.maximumNumberOfTouches = 1;
        [self addGestureRecognizer:panner];
    }
    return self;
}

//overrides addSubview.
-(void)addSubview:(UIView *)view{
    [super addSubview:view];
    view.userInteractionEnabled = YES;
}

//handles the users panning of view.
//moves the topmost view around and throws it away at end if velocity is high enough.
-(void)pan:(UIPanGestureRecognizer *)panner {
    CGPoint location = [panner locationInView:self];
    CGPoint velocity = [panner velocityInView:self];
    
    attachment.anchorPoint = location;
    
    if(panner.state == UIGestureRecognizerStateBegan){
        
        UIView *pannerview = self.subviews.lastObject;
        startPoint = pannerview.center;
        attachment = ({
            UIAttachmentBehavior *a = [[UIAttachmentBehavior alloc] initWithItem:pannerview
                                                                offsetFromCenter:UIOffsetMake(location.x - pannerview.center.x, location.y - pannerview.center.y)
                                                                attachedToAnchor:location];
            a;
        });
        [animator addBehavior:attachment];
        
    } else if(panner.state == UIGestureRecognizerStateEnded || panner.state == UIGestureRecognizerStateCancelled){
        
        [animator removeBehavior:attachment];
        attachment = nil;
        UIView *pannerview = self.subviews.lastObject;
        
        if(fabs(velocity.x) > kMinSpeed || fabs(velocity.y) > kMinSpeed){
            UIOffset o = UIOffsetMake(location.x - pannerview.center.x, location.y - pannerview.center.y);
            
            push = [[UIPushBehavior alloc] initWithItems:@[pannerview] mode:UIPushBehaviorModeInstantaneous];
            [push setTargetOffsetFromCenter:o forItem:pannerview];
            float div = kDivFactor;//Bigger -> slower
            push.pushDirection = CGVectorMake(velocity.x/div, velocity.y/div);
            
            [animator addBehavior:push];
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(checkToRemove:) userInfo:@{@"view": pannerview} repeats:YES];
            [timer fire];
            
            
        } else{
            [self restoreView:pannerview];
        }
    }
    
    [panner setTranslation:CGPointZero inView:self];
}

//Calculates the distance from view v to startpoint

-(float)dist:(UIView *)v{
    float distx = fabsf(v.center.x - startPoint.x);
    float disty = fabsf(v.center.y - startPoint.y);
    float disttot = fabsf(distx*distx+disty*disty);
    return disttot;
}

//check is view is out of superview, if so -> remove from view
-(void)checkToRemove:(NSTimer *)t{
    UIView *v = t.userInfo[@"view"];
    if(!CGRectIntersectsRect(v.frame, self.frame)){
        [t invalidate];
        t = nil;
        [self removeView:v];
    }
}

//removes view v from superview and calls delegate
-(void)removeView:(UIView *)v{
    if(!CGRectIntersectsRect(self.frame, v.frame)){
        [self.throwDelegate throwView:self willRemoveView:v];
        [v removeFromSuperview];
        [animator removeBehavior:push];
    }
}

//restores view v to center again.
-(void)restoreView:(UIView *)view{
    [UIView animateWithDuration:0.3 animations:^{
        view.center = self.center;
        view.transform = CGAffineTransformMakeRotation(0);
    }];
}

@end
