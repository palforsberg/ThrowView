# ThrowView
iOS. Add subview and let the user throw it away with a swipe.
## Example use
Just add a throwview and then the views that you'd like to throw to that view.
```Objective-C
ThrowView *throw = [[ThrowView alloc] initWithFrame:self.view.frame];
throw.throwDelegate = self;
[self.view addSubview:throw];
UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
v.backgroundColor = [UIColor colorWithWhite:0.f alpha:1.f];
v.center = self.view.center;
[throw addSubview:v];
```
