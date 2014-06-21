//
//  newsViewController.h
//  web571
//
//  Created by 呵呵 on 14-4-21.
//  Copyright (c) 2014年 呵呵. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface newsViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (strong,nonatomic) NSString * passedArray;

@end
