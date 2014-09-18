//
//  newsViewController.m
//  web571
//
//  Created by 呵呵 on 14-4-21.
//  Copyright (c) 2014年 呵呵. All rights reserved.
//

#import "newsViewController.h"
#import "startView.h"
#import "AFNetworking.h"
#import "newtestViewController.h"
#import "startView.h"
#import "specialviewCell.h"

@interface newsViewController ()
@property (weak, nonatomic) IBOutlet UIView *container;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backbutton;
@property (nonatomic) NSString *symbol;
@property (weak, nonatomic) IBOutlet UILabel *labelText;
@property (weak, nonatomic) IBOutlet UITableView *titletableview;
@property(strong,nonatomic) NSArray* titleArray;
@property(strong,nonatomic) NSArray* linkArray;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property(nonatomic) NSInteger itemnum;
@property (strong,nonatomic) specialviewCell *spc;
@end

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f

@implementation newsViewController
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
    
    _toolBar.hidden = YES;

    
    _titletableview.delegate = self;
    _titletableview.dataSource = self;
    
    NSArray *broken = [_passedArray componentsSeparatedByString:@","];
    
    _symbol = broken[0];
    
    NSString *urlString = [@"http://default-environment-cpfjs3sgdp.elasticbeanstalk.com/?symbol=" stringByAppendingString:_symbol];
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    //NSLog(@"%@\n---------",urlString);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSString* tArray=@"";
        NSString* lArray=@"";
        
        NSString *responseString  = [operation responseString];
        
        NSData *jsonData = [responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *e;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:nil error:&e];
        
        NSDictionary *monday = dict[@"result"];
        
        //NSString *symbol = monday[@"Symbol"] ;
        
        NSDictionary *news = monday[@"News"];
        
        NSDictionary *item = news[@"Item"];
        
        for ( NSDictionary *theCourse in item )
        {
            if([theCourse[@"Title"] isEqualToString:@"Yahoo! Finance: RSS feed not found"]){
                [[[UIAlertView alloc] initWithTitle:@"" message:@"Financial Company News Is Not Available" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                break;
            }
            else{
                
                NSString *astr = theCourse[@"Title"];
                 NSString *bstr = theCourse[@"Link"];
                
                tArray = [tArray stringByAppendingString:astr];
                tArray =[tArray stringByAppendingString:@"$$$$$$"];
                
                lArray=[lArray stringByAppendingString:bstr];
                lArray=[lArray stringByAppendingString:@"$$$$$$"];
                
                _titleArray = [tArray componentsSeparatedByString:@"$$$$$$"];
                _linkArray = [lArray componentsSeparatedByString:@"$$$$$$"];
                
            }
            
        }
        
        //NSLog(@"%@",_titleArray);
       
        [self.titletableview reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

	// Do any additional setup after loading the view.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Number of rows is the number of time zones in the region for the specified section.
    return ([_titleArray count]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    specialviewCell *Cell = [self.myTableView dequeueReusableCellWithIdentifier:@"specialcell"];
   
    Cell.mylabel.text = self.titleArray[indexPath.row];
    
    return Cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _itemnum = indexPath.item;
    [[[UIAlertView alloc] initWithTitle:@"View News" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles: @"View",nil] show];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    CGSize constraintSize = {280.0, 20000};
    CGSize neededSize = [self.titleArray[indexPath.row] sizeWithFont:[UIFont systemFontOfSize:14.0f] constrainedToSize:constraintSize  lineBreakMode:UILineBreakModeCharacterWrap];
    if ( neededSize.height <= 31)
        
        return 45;
        else return neededSize.height + 15;
            //18 is the size of your text with the requested font (systemFontOfSize 14). if you change fonts you have a different number to use
            // 45 is what is required to have a nice cell as the neededSize.height is the "text"'s height only
            //not the cell.
            
            }

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex) {
        case 0:
            //NSLog(@"Cancel Button Pressed");
            break;
        case 1:
            NSLog(@"Button 1 Pressed");
            
            NSString *url = _linkArray[_itemnum];
            
            //NSLog(url);
            
            
            
            [self performSegueWithIdentifier:@"toview" sender:self];
            
//            UIWebView *webView=[[UIWebView alloc] initWithFrame:CGRectMake(0,44,320,680)];
//            [self.view addSubview:webView];
//            
//            NSURL *urlforWebView=[NSURL URLWithString:url];
//            NSURLRequest *urlRequest=[NSURLRequest requestWithURL:urlforWebView];
//            [webView loadRequest:urlRequest];
//            
//            _toolBar.hidden = false;
           
            //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
            break;
    }
    
}


-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"toview"]){
        
        newtestViewController *des = segue.destinationViewController;
        //NSLog(@"%@",_passSymbol);
        des.symbol = _symbol;
        des.urlString = _linkArray[_itemnum];
        des.total = _passedArray;
    }
    
    if([segue.identifier isEqualToString:@"pass2"] || [segue.identifier isEqualToString:@"pass"]){
        
        startView *des = segue.destinationViewController;
        des.passBack =_passedArray;
        
    }
}
- (IBAction)goback:(id)sender {
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
