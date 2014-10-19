//
//  ParentalGate.m
//
//  Created by @natbro on 2/22/14.
//

#import "ParentalGate.h"
#import "BlockBackground.h"

@interface ParentalGate ()
@property IBOutlet UILabel *parentsOnlyTop;
@property IBOutlet UILabel *parentsOnlyBottom;
@property IBOutlet UILabel *gateInstructions;
@property NSUInteger numberOfTouchesRequired;
@property UISwipeGestureRecognizerDirection directionRequired;
@property NSMutableArray *swipeGestureRecognizers;
@property UITapGestureRecognizer *tapGestureRecognizer;
@property UIView *itemView;
@end

@implementation ParentalGate

+ (ParentalGate *)newWithCompletion:(ParentalGateCompletion)completion
{
  NSBundle *parentalGateBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"ParentalGate" ofType:@"bundle"]];
  ParentalGate *parentalGate = [parentalGateBundle loadNibNamed:@"ParentalGate" owner:nil options:nil][0];
  parentalGate.completion = completion;
  return parentalGate;
}

+ (void)showWithSuccess:(ParentalGateSuccess)completion;
{
  ParentalGate *parentalGate = [ParentalGate newWithCompletion:^(BOOL success) {
    if (success && completion) {
      completion();
    }
  }];
  [parentalGate show];
}

- (void)awakeFromNib
{
  [super awakeFromNib];
  
  // defaults to a single tap by a single touch, whish is what we want
  self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognized:)];
  
  self.swipeGestureRecognizers = NSMutableArray.new;
  
  NSArray *swipeDirections = @[@(UISwipeGestureRecognizerDirectionRight),@(UISwipeGestureRecognizerDirectionLeft),@(UISwipeGestureRecognizerDirectionUp),@(UISwipeGestureRecognizerDirectionDown)];
  
  // that's just a ridonculous number of gesture recognizers, ugh
  for (NSUInteger numberOfTouches = 1; numberOfTouches < 4; numberOfTouches++) {
    for (NSNumber *swipeDirection in swipeDirections) {
      UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRecognized:)];
      swipeGestureRecognizer.direction = swipeDirection.integerValue;
      swipeGestureRecognizer.numberOfTouchesRequired = numberOfTouches;
      [self.swipeGestureRecognizers addObject:swipeGestureRecognizer];
    }
  }

  // choose a random number of fingers, 1 to 3, a random swipe direction
  self.numberOfTouchesRequired = (arc4random() % 3) + 1;
  self.directionRequired = ((NSNumber *)swipeDirections[arc4random() % 4]).integerValue;

  // localize a whole lot of number of fingers & direction strings in each language :(
  NSString *gateInstructionsKey = [NSString stringWithFormat:@"kParentalGateInstructions%02lu%02lu",(unsigned long)self.numberOfTouchesRequired, (unsigned long)self.directionRequired];
  
  NSBundle *parentalGateBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"ParentalGate" ofType:@"bundle"]];
  self.parentsOnlyTop.text    = [parentalGateBundle localizedStringForKey:@"kParentalGateTop" value:@"" table:@"ParentalGate"]; //NSLocalizedStringFromTable(@"kParentalGateTop", @"ParentalGate", @"");
  self.parentsOnlyBottom.text = [parentalGateBundle localizedStringForKey:@"kParentalGateBottom" value:@"" table:@"ParentalGate"]; //NSLocalizedStringFromTable(@"kParentalGateBottom", @"ParentalGate", @"");
  self.gateInstructions.text  = [parentalGateBundle localizedStringForKey:gateInstructionsKey value:@"" table:@"ParentalGate"]; //NSLocalizedStringFromTable(gateInstructionsKey, @"ParentalGate", @"");

  UIColor *stopSignRedColor = [UIColor colorWithRed:(191.0/255.0) green:(21.0/255.0) blue:(51.0/255.0) alpha:1.0];
  self.backgroundColor = stopSignRedColor;
  self.layer.masksToBounds = YES;
  self.layer.cornerRadius = self.frame.size.width / 2.0;
  self.layer.borderColor = stopSignRedColor.CGColor;
  self.layer.borderWidth = 10.5f;
  self.layer.shadowOffset = CGSizeZero;
  self.layer.shadowRadius = 10;
  self.layer.shadowOpacity = 0.5;
}

- (void)show
{
  // TODO: on iOS6+ would be nice to gaussian blur the background
  BlockBackground *blockBackground = [BlockBackground sharedInstance];
  UIImageView *modalBackground = [[UIImageView alloc] initWithFrame:self.bounds];
  modalBackground.contentMode = UIViewContentModeScaleToFill;
  [self insertSubview:modalBackground atIndex:0];
  
  [blockBackground addToMainWindow:self];
  
  [blockBackground addGestureRecognizer:self.tapGestureRecognizer];
  for (UIGestureRecognizer *swipeGestureRecognizer in self.swipeGestureRecognizers) {
    [blockBackground addGestureRecognizer:swipeGestureRecognizer];
  }
  
  CGPoint center = self.center;
  center.x = blockBackground.bounds.size.width / 2.0;
  center.y = blockBackground.bounds.size.height / 2.0;
  self.transform = CGAffineTransformMakeScale(1.5, 1.5);
  self.center = center;
  
  [UIView animateWithDuration:0.4
                        delay:0.0
                      options:UIViewAnimationOptionCurveEaseOut
                   animations:^{
                     [BlockBackground sharedInstance].alpha = 1.0f;
                     self.transform = CGAffineTransformIdentity;
                   }
                   completion:^(BOOL finished) {
                     [[NSNotificationCenter defaultCenter] postNotificationName:@"AlertViewFinishedAnimations" object:nil];
                   }];
  [self retain];  // allows caller to let go of the gate UI while it's displaying
}

- (void)tapRecognized:(UITapGestureRecognizer *)tapRecognizer
{
  [self dismissWithResult:false animated:true];
}

- (void)swipeRecognized:(UISwipeGestureRecognizer *)swipeRecognizer
{
  NSLog(@"swipe: %@", swipeRecognizer);
  BOOL properSwipe = ((swipeRecognizer.direction == self.directionRequired) &&
                      (swipeRecognizer.numberOfTouches == self.numberOfTouchesRequired));
  [self dismissWithResult:properSwipe animated:true];
}

- (void)dismissWithResult:(BOOL)passed animated:(BOOL)animated
{
  void (^finished)(BOOL) = ^(BOOL animationFinished) {
    if (self.completion) {
      self.completion(passed);
    }
    [[BlockBackground sharedInstance] removeView:self];
    //[self autorelease];
  };

  if (animated) {
    void (^closeAnimation)() = ^{
      [UIView animateWithDuration:0.4
                            delay:0.0
                          options:UIViewAnimationOptionCurveEaseIn
                       animations:^{
                         self.transform = CGAffineTransformMakeScale(1.5, 1.5);
                         [[BlockBackground sharedInstance] reduceAlphaIfEmpty];
                       }
                       completion:finished];
    };
    if (passed) {
      closeAnimation();
    } else {
      self.transform = CGAffineTransformMakeTranslation(2.0, -2.0);
      [UIView animateWithDuration:0.07
                            delay:0.0
                          options:UIViewAnimationOptionAutoreverse
                       animations:^{
                         UIView.animationRepeatCount = 4;
                         self.transform = CGAffineTransformMakeTranslation(-2.0, 2.0);
                       }
                       completion:^(BOOL finished){
                         self.transform = CGAffineTransformIdentity;
                         closeAnimation();
                       }];
    }
  } else {
    finished(true);
  }
}

@end