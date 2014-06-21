//
//  newtestViewController.m
//  web571
//
//  Created by 呵呵 on 14-4-21.
//  Copyright (c) 2014年 呵呵. All rights reserved.
//

#import "newtestViewController.h"
#import "newsViewController.h"

@interface newtestViewController ()

@end

@implementation newtestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
                UIWebView *webView=[[UIWebView alloc] initWithFrame:CGRectMake(0,44,320,680)];
                [self.view addSubview:webView];
    
                NSURL *urlforWebView=[NSURL URLWithString:_urlString];
                NSURLRequest *urlRequest=[NSURLRequest requestWithURL:urlforWebView];
                [webView loadRequest:urlRequest];
    
	// Do any additional setup after loading the view.
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"goBack"]){
        
        newsViewController *des = segue.destinationViewController;
        des.passedArray = _total;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
