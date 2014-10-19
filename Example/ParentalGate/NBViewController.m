//
//  NBViewController.m
//  ParentalGate
//
//  Created by @natbro on 10/18/2014.
//  Copyright (c) 2014 @natbro. All rights reserved.
//

#import "NBViewController.h"
#import "ParentalGate.h"

@interface NBViewController ()

@property IBOutlet UIButton *forParents;
@property IBOutlet UILabel *resultLabel;

@end

@implementation NBViewController

- (IBAction)didPressForParents:(id)sender
{
  _resultLabel.text = @"Checking for adulthood";
  
  [[ParentalGate newWithCompletion:^(BOOL passed) {
    if (passed) {
      _resultLabel.text = @"It seems you are an adult";
    } else {
      _resultLabel.text = @"You didn't prove you are an adult";
    }
  }] show];
}

@end
