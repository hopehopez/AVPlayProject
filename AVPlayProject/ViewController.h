//
//  ViewController.h
//  AVPlayProject
//
//  Created by Elean on 16/1/9.
//  Copyright (c) 2016年 Elean. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
- (IBAction)playClick:(id)sender;
- (IBAction)pauseClick:(id)sender;


@end

