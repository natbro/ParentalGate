//
//  BlockBackground.m
//
//  Extracted by @natbro from https://github.com/gpambrozio/BlockAlertsAnd-ActionSheets
//  by Gustavo Ambrozio on 29/11/11.
//  Copyright (c) 2011 N/A. All rights reserved.
//

#import "BlockBackground.h"
#import "BlockUI.h"

@implementation BlockBackground

@synthesize backgroundImage = _backgroundImage;
@synthesize vignetteBackground = _vignetteBackground;

static BlockBackground *_sharedInstance = nil;

+ (BlockBackground*)sharedInstance
{
  if (_sharedInstance != nil) {
    return _sharedInstance;
  }
  
  @synchronized(self) {
    if (_sharedInstance == nil) {
      _sharedInstance = [[[self alloc] init] autorelease];
    }
    [[NSNotificationCenter defaultCenter] addObserver:_sharedInstance
                                             selector:@selector(orientationChanged:)
                                                 name:@"UIDeviceOrientationDidChangeNotification"
                                               object:nil];
  }
  
  return _sharedInstance;
}

+ (id)allocWithZone:(NSZone*)zone
{
  @synchronized(self) {
    if (_sharedInstance == nil) {
      _sharedInstance = [super allocWithZone:zone];
      return _sharedInstance;
    }
  }
  NSAssert(NO, @ "[BlockBackground alloc] explicitly called on singleton class.");
  return nil;
}

- (id)copyWithZone:(NSZone*)zone
{
  return self;
}

- (id)retain
{
  return self;
}

- (NSUInteger)retainCount
{
  return UINT_MAX;
}

- (oneway void)release
{
}

- (id)autorelease
{
  return self;
}

CG_INLINE CGRect CGRectIntegralCenteredInRect(CGRect innerRect, CGRect outerRect)
{
  CGFloat originX = floorf((outerRect.size.width - innerRect.size.width) * 0.5f);
  CGFloat originY = floorf((outerRect.size.height - innerRect.size.height) * 0.5f);
  return CGRectMake(originX, originY, innerRect.size.width, innerRect.size.height);
}

- (id)init
{
  // make our frame big enough to cover screens at any orientation, in order to handle rotation events
  CGRect screenBounds = [[UIScreen mainScreen] bounds];
  CGRect bigFrame = screenBounds;
  if (bigFrame.size.height > bigFrame.size.width) {
    bigFrame.size.width = bigFrame.size.height;
  } else {
    bigFrame.size.height = bigFrame.size.width;
  }
  bigFrame = CGRectIntegralCenteredInRect(bigFrame, screenBounds);
  bigFrame = CGRectInset(bigFrame, -200, -200);
  self = [super initWithFrame:bigFrame];
  if (self) {
    self.windowLevel = UIWindowLevelStatusBar;
    self.hidden = YES;
    self.userInteractionEnabled = NO;
    self.backgroundColor = [UIColor colorWithWhite:0.4 alpha:0.5f];
    self.vignetteBackground = NO;
  }
  return self;
}

- (void)addToMainWindow:(UIView *)view
{
  if (self.hidden)
  {
    _previousKeyWindow = [[[UIApplication sharedApplication] keyWindow] retain];
    self.alpha = 0.0f;
    self.hidden = NO;
    self.userInteractionEnabled = YES;
    [self makeKeyWindow];
  }
  
  if (self.subviews.count > 0)
  {
    ((UIView*)[self.subviews lastObject]).userInteractionEnabled = NO;
  }
  
  if (_backgroundImage)
  {
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:_backgroundImage];
    backgroundView.frame = self.bounds;
    backgroundView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:backgroundView];
    [backgroundView release];
    [_backgroundImage release];
    _backgroundImage = nil;
  }
  
  // ensure correct orientation: we don't always get the notification from first-launch
  [self orientationChanged:nil];
  
  [self addSubview:view];
}

- (void)orientationChanged:(NSNotification *)notification
{
  NSTimeInterval animationDuration = [UIApplication sharedApplication].statusBarOrientationAnimationDuration;
  UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
  
  if (orientation == UIDeviceOrientationUnknown) {
    orientation = (UIDeviceOrientation)[UIApplication sharedApplication].statusBarOrientation;
  }
  
  void (^action)() = ^{
    switch (orientation) {
      case UIInterfaceOrientationLandscapeLeft:
        self.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(270.0));
        break;
      case UIInterfaceOrientationLandscapeRight:
        self.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(90.0));
        break;
      case UIInterfaceOrientationPortraitUpsideDown:
        self.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(180.0));
        break;
      default:
        self.transform = CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(0.0));
        break;
    }
  };
  
  if (nil != notification) {
    [UIView animateWithDuration:animationDuration
                          delay:0.0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:action
                     completion:nil];
  } else {
    action();
  }
}

- (void)reduceAlphaIfEmpty
{
  if (self.subviews.count == 1 || (self.subviews.count == 2 && [[self.subviews objectAtIndex:0] isKindOfClass:[UIImageView class]]))
  {
    self.alpha = 0.0f;
    self.userInteractionEnabled = NO;
  }
}

- (void)removeView:(UIView *)view
{
  [view removeFromSuperview];
  
  UIView *topView = [self.subviews lastObject];
  if ([topView isKindOfClass:[UIImageView class]])
  {
    // It's a background. Remove it too
    [topView removeFromSuperview];
  }
  
  if (self.subviews.count == 0)
  {
    self.hidden = YES;
    [_previousKeyWindow makeKeyWindow];
    [_previousKeyWindow release];
    _previousKeyWindow = nil;
  }
  else
  {
    ((UIView*)[self.subviews lastObject]).userInteractionEnabled = YES;
  }
}

- (void)drawRect:(CGRect)rect
{
  //    if (_backgroundImage || !_vignetteBackground) return;
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  size_t locationsCount = 2;
  CGFloat locations[2] = {0.0f, 1.0f};
  CGFloat colors[8] = {0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.0f,0.95f};
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, locationsCount);
  CGColorSpaceRelease(colorSpace);
  
  CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
  float radius = MIN(self.bounds.size.width , self.bounds.size.height) ;
  CGContextDrawRadialGradient (context, gradient, center, 0, center, radius, kCGGradientDrawsAfterEndLocation);
  CGGradientRelease(gradient);
}

@end
