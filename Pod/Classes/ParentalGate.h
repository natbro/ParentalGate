//
//  ParentalGate.h
//
//  Created by @natbro on 2/22/14.
//

#import <UIKit/UIKit.h>

typedef void(^ParentalGateCompletion)(BOOL passed);
typedef void(^ParentalGateSuccess)(void);

@interface ParentalGate : UIView
@property (nonatomic, copy) ParentalGateCompletion completion;

+ (ParentalGate *)newWithCompletion:(ParentalGateCompletion)completion;
+ (void)showWithSuccess:(ParentalGateSuccess)completion;
- (void)show;
- (void)dismissWithResult:(BOOL)result animated:(BOOL)animated;

@end
