//
//  startView.h
//  web571
//
//  Created by 呵呵 on 14-4-19.
//  Copyright (c) 2014年 呵呵. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface startView : UIViewController<UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITextField *myText;
@property (weak, nonatomic) IBOutlet UISearchBar *mysb;
@property (nonatomic) NSString *passBack;
@end
