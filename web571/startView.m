//
//  startView.m
//  web571
//
//  Created by 呵呵 on 14-4-19.
//  Copyright (c) 2014年 呵呵. All rights reserved.
//

#import "startView.h"
#import "AFNetworking.h"
#import "newsViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
@interface startView () <UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *myunderline;
@property (weak, nonatomic) IBOutlet UILabel *pvclose;
@property (weak, nonatomic) IBOutlet UILabel *open;
@property (weak, nonatomic) IBOutlet UILabel *bid;
@property (weak, nonatomic) IBOutlet UILabel *ask;
@property (weak, nonatomic) IBOutlet UILabel *oneyrtar;
@property (weak, nonatomic) IBOutlet UILabel *dayrange;
@property (weak, nonatomic) IBOutlet UILabel *yearrange;
@property (weak, nonatomic) IBOutlet UILabel *volumn;
@property (weak, nonatomic) IBOutlet UILabel *avgvolume;
@property (weak, nonatomic) IBOutlet UILabel *markcap;
@property (weak, nonatomic) IBOutlet UILabel *k52r;
@property (weak, nonatomic) IBOutlet UILabel *sttar;
@property (weak, nonatomic) IBOutlet UIButton *nslbotton;
@property (weak, nonatomic) IBOutlet UIImageView *myImg;
@property (strong,nonatomic) NSString *passSymbol;
@property (strong,nonatomic) NSString *symboltotal;
@property (strong,nonatomic) NSString *nametotal;
@property (strong,nonatomic) NSString *chart;

@property (strong,nonatomic) NSString *ct;

@property (weak, nonatomic) IBOutlet UIButton *fb_botton;
@property (weak, nonatomic) IBOutlet UISearchBar *mySearchbar;
@property (weak, nonatomic) IBOutlet UIImageView *chartimg;
@property (strong,nonatomic) NSArray *suggetionArray;
@property (weak, nonatomic) IBOutlet UIView *stockView;
@property (weak, nonatomic) IBOutlet UIScrollView *stockView2;
@property (strong ,nonatomic) NSString *responseString;
@property (weak, nonatomic) IBOutlet UILabel *ltpo;
@property (weak, nonatomic) IBOutlet UIImageView *arrayImage;
@property (weak, nonatomic) IBOutlet UILabel *change;
@property (weak, nonatomic) IBOutlet UILabel *changeinpercent;

@property (strong, nonatomic) IBOutlet UISearchDisplayController *searchController;
@property (weak, nonatomic) IBOutlet UILabel *nameText;

@end

@implementation startView
 static NSString *totalString;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)searchButton:(id)sender {
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _mySearchbar.backgroundImage = [UIImage imageNamed:@"ling.png"];
    
    NSURL *url = [NSURL URLWithString:@"http://cs-server.usc.edu:17897/examples/servlets/underline.png"];
    NSData *data = [[NSData alloc]initWithContentsOfURL:url ];
    UIImage *img = [[UIImage alloc]initWithData:data ];
    
    _myImg.image=img;

    self.mySearchbar.placeholder = @"Enter Stock Symbol        ";
    
    self.nslbotton.hidden = YES;
    self.fb_botton.hidden = YES;
    self.stockView2.hidden = YES;
    self.searchController.delegate = self;
    self.searchController.searchBar.delegate = self;
    self.searchController.searchResultsDelegate = self;
    self.searchController.searchResultsDataSource = self;
    
    if(_passBack.length != 0){
        
        [self.searchDisplayController setActive:NO animated:YES];
        [self.searchDisplayController.searchBar setText:_passBack];
        
        NSArray *broken = [_passBack componentsSeparatedByString:@","];
        
        [self fillAction:broken[0]];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     //NSLog(@"%@---------",_suggetionArray[0]);
    return self.suggetionArray.count;
    //return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (tableViewCell == nil) {
        tableViewCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    tableViewCell.textLabel.text = self.suggetionArray[indexPath.row];
     //UITableViewCell *cell = [create ]
    // cell.titleLabel.text = self.suggestions[indexPath.row];
    // return cell;
    return tableViewCell;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSString *text = searchBar.text;
   [self GetInformation:text];
    // // Store information to self.suggestions;
}

-(void) GetInformation:(NSString*) stringInput
{
   NSString *suggestion = stringInput;
    
  NSString *URLstring =  @"http://autoc.finance.yahoo.com/autoc?query=";
    
    URLstring = [URLstring stringByAppendingString:suggestion];
    
    URLstring = [URLstring stringByAppendingString: @"&callback=YAHOO.Finance.SymbolSuggest.ssCallback"];
    
    URLstring = [URLstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:URLstring parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject){_responseString  = [operation responseString];
        NSLog(@"%@",responseObject);
        
        NSArray *JsonValue = [_responseString componentsSeparatedByString:@"["];
        NSString *processedJson = JsonValue[1];
        
        processedJson = [processedJson substringWithRange:NSMakeRange(0, [processedJson length]-2)];
        
        processedJson = [@"{\"result\":[" stringByAppendingString:processedJson];
        
        NSData *jsonData = [processedJson dataUsingEncoding:NSUTF8StringEncoding];
        NSError *e;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:nil error:&e];
        totalString = @"";
        NSArray *monday = dict[@"result"];
        for ( NSDictionary *theCourse in monday )
        {
            NSString *symbol = theCourse[@"symbol"] ;
            NSString *name = theCourse[@"name"] ;
            NSString *exch = theCourse[@"exch"] ;
            
            NSString *subsug  = [symbol stringByAppendingString:@","];
            subsug = [subsug stringByAppendingString:name];
            subsug = [subsug stringByAppendingString:@"("];
            subsug = [subsug stringByAppendingString:exch];
            subsug = [subsug stringByAppendingString:@")"];
            
            totalString = [totalString stringByAppendingString:subsug];
            totalString = [totalString stringByAppendingString:@"$$$$$"];
            
        }
        
        _suggetionArray = [totalString componentsSeparatedByString:@"$$$$$"];
        
        
        [self.searchDisplayController.searchResultsTableView reloadData];
        
    
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
   
    //_suggetionArray = [NSArray arrayWithObjects:@"123", nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // search for the stock information
    // set the labels
    NSString *input = _suggetionArray[indexPath.item];
    
    NSArray *subsuggest = [input componentsSeparatedByString:@","];

    [self fillAction:subsuggest[0]];
    
    [self.searchDisplayController setActive:NO animated:YES];
    [self.searchDisplayController.searchBar setText:input];
}

- (IBAction)search_button:(id)sender {
    
    NSString *input = _mySearchbar.text;
    
    if([input isEqualToString:@""]){
        self.nslbotton.hidden = YES;
        self.fb_botton.hidden = YES;
        
        self.stockView2.hidden = YES;
    [[[UIAlertView alloc] initWithTitle:@"" message:@"Please enter stock symbol" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
    }
    else{
        
    [self fillAction:_mySearchbar.text];
    [self.searchDisplayController setActive:NO animated:YES];
    [self.searchDisplayController.searchBar setText:input];
    }
}


-(void)fillAction:(NSString*) stringInput{
    self.nslbotton.hidden = YES;
    self.fb_botton.hidden = YES;
    
    self.stockView2.hidden = YES;
    
    [self.searchDisplayController setActive:NO animated:YES];
    
    NSString *urlString = @"http://jasonpparser-env.elasticbeanstalk.com/?symbol=";
    
    NSArray *inputArray = [stringInput componentsSeparatedByString:@","];
    stringInput = inputArray[0];
    
    urlString = [urlString stringByAppendingString:stringInput];
    
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        _responseString  = [operation responseString];
        
        NSData *jsonData = [_responseString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *e;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:nil error:&e];
        
       NSDictionary *monday = dict[@"result"];
        
             _symboltotal = monday[@"Symbol"] ;
            _nametotal = monday[@"Name"];
        
            NSString *subsug  = [_nametotal stringByAppendingString:@"("];
            subsug = [subsug stringByAppendingString:_symboltotal];
            subsug = [subsug stringByAppendingString:@")"];
            _nameText.text = subsug;
        
        NSDictionary *quote = monday[@"Quote"];
        
        NSString *lastTradeOnly = quote[@"LastTradePriceOnly"];
        _ltpo.text = lastTradeOnly;
        
        NSString *change = quote[@"Change"];
        NSString *changeinpercent = quote[@"ChangeInPercent"];
        if([change isEqualToString:@""]){
            
            [[[UIAlertView alloc] initWithTitle:@"" message:@"Stock Information Not Found!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
        }
        else{
            
            self.nslbotton.hidden = FALSE;
            self.fb_botton.hidden = FALSE;
            
            self.stockView2.hidden = FALSE;
            
            [self.searchDisplayController setActive:NO animated:YES];
            
            _passSymbol = _symboltotal;
        }
        
        changeinpercent = [@"(" stringByAppendingString:changeinpercent];
        changeinpercent = [changeinpercent stringByAppendingString:@"%)"];
        _arrayImage.image = nil;
        if([quote[@"ChangeType"] isEqualToString:@"-"]){
            NSURL *url = [NSURL URLWithString:@"http://cs-server.usc.edu:17897/examples/servlets/down_r.gif"];
            NSData *data = [[NSData alloc]initWithContentsOfURL:url ];
            UIImage *img = [[UIImage alloc]initWithData:data ];
            
            _arrayImage.image=img;
            _change.textColor = [UIColor redColor];
            _changeinpercent.textColor = [UIColor redColor];
            
            _change.text = change;
            _changeinpercent.text = changeinpercent;
        }
        if([quote[@"ChangeType"] isEqualToString:@"+"]){
            NSURL *url = [NSURL URLWithString:@"http://cs-server.usc.edu:17897/examples/servlets/up_g.gif"];
            NSData *data = [[NSData alloc]initWithContentsOfURL:url ];
            UIImage *img = [[UIImage alloc]initWithData:data ];
            
            _arrayImage.image=img;
            
            _change.textColor = [UIColor greenColor];
            _changeinpercent.textColor = [UIColor greenColor];
            _change.text = change;
            _changeinpercent.text = changeinpercent;
        }
        if([quote[@"ChangeType"] isEqualToString:@""]){
            
            _change.textColor = [UIColor greenColor];
            _changeinpercent.textColor = [UIColor greenColor];
            _change.text = @"0.00";
            _changeinpercent.text = @"(0.00%)";
        }
        
        _ct = quote[@"ChangeType"];
        
        NSString *prevclose = quote[@"PreviousClose"];
        NSString *bid = quote[@"Bid"];
        NSString *ask = quote[@"Ask"];
        NSString *open = quote[@"Open"];
        NSString *oneyeartarget = quote[@"OneYearTargetPrice"];
        NSString *volume = quote[@"Volume"];
        NSString *avgvolume = quote[@"AverageDailyVolume"];
        NSString *cap = quote[@"MarketCapitalization"];
        NSString *dl = quote[@"DaysLow"];
        NSString *dh = quote[@"DaysHigh"];
        NSString *yl = quote[@"YearLow"];
        NSString *yh = quote[@"YearHigh"];
        
        _pvclose.text = prevclose;
        _open.text = open;
        _bid.text = bid;
        _ask.text = ask;
        _sttar.text = oneyeartarget;
        if(![dh isEqualToString:@""]&&![dl isEqualToString:@""]){
            NSString *dr = [dl stringByAppendingString:@" - "];
            dr = [dr stringByAppendingString:dh];
            
            _dayrange.text = dr;
        }
        else{
            _dayrange.text = @"";
        }
        if(![yh isEqualToString:@""]&&![yl isEqualToString:@""]){
            NSString *yr = [yl stringByAppendingString:@" - "];
            yr = [yr stringByAppendingString:yh];
            
            _k52r.text = yr;
        }
        else{
            _k52r.text = @"";
        }
        _volumn.text = volume;
        _avgvolume.text = avgvolume;
        _markcap.text = cap;
        
        NSString *chartUrl = monday[@"StockChartImageURL"];
        chartUrl = [chartUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        _chart = chartUrl;
        NSURL *url = [NSURL URLWithString:chartUrl];
        NSData *data = [[NSData alloc]initWithContentsOfURL:url ];
        UIImage *img = [[UIImage alloc]initWithData:data ];
        
        _chartimg.image=img;
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

   
    
}
- (IBAction)FaceBook:(id)sender {
    
    NSString *linkurl = [@"http://finance.yahoo.com/q?s=" stringByAppendingString:_symboltotal];
    NSString *caption = [@"Stock Information of " stringByAppendingString:_nametotal];
    caption = [caption stringByAppendingString:@"("];
    caption = [caption stringByAppendingString:_symboltotal];
    caption = [caption stringByAppendingString:@")"];
    NSString *discrep = [@"Last Trade Price:" stringByAppendingString:_ltpo.text];
    discrep = [discrep stringByAppendingString:@" , "];
    discrep = [discrep stringByAppendingString:@"Change:"];
     discrep = [discrep stringByAppendingString:_ct];
    discrep = [discrep stringByAppendingString:_change.text];
     discrep = [discrep stringByAppendingString:_changeinpercent.text];
   
    //description: 'Last Trade Price:'+" "+doc.result.Quote.LastTradePriceOnly+" "+', Change:'+ " "+doc.result.Quote.ChangeType + doc.result.Quote.Change+'('+doc.result.Quote.ChangeInPercent+'%)'
    
    //'Stock Information of'+" "+doc.result.Name+" "+'('+doc.result.Symbol+')',
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"822327661114535", @"app_id",
                                   linkurl, @"link",
                                  _chart, @"picture",
                                   _nametotal, @"name",
                                  caption, @"caption",
                                   discrep, @"description",
                                   nil];
    
    [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                           parameters:params
                                              handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                  
                                                  NSString *myString = [resultURL absoluteString];
                                                  
                                                  NSString *msg;
                                                  
                                                  if(result == FBWebDialogResultDialogNotCompleted){
                                                      msg = @"Post was not published.";
                                                  }
                                                  else{
                                                      if(myString.length > 19){
                                                          msg = @"Post was published.";
                                                      }
                                                      else{
                                                        msg = @"Post was not published.";
                                                      }
                                                  }
                                                  
                                                  [[[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
                                              
                                                  
                                              }];
    
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"passtable"]){
        
        newsViewController *des = segue.destinationViewController;
        des.passedArray = self.mySearchbar.text;
    }
}

- (IBAction)headline:(id)sender {
    
    
}

// Headiline button funciton
//[self performSegueWithIdentifier:@"segueName" sender:self];

@end
