//
//  ViewController.m
//  FaceAlbum
//
//  Created by scott mehus on 5/11/13.
//  Copyright (c) 2013 scott mehus. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadProfile)
                                                 name:AccountFacebookAccountAccessGranted object:nil];
    AppDelegate *appDelegate =
    [[UIApplication sharedApplication] delegate];
    
    if (appDelegate.facebookAccount)
    {
        [self reloadProfile];
    }
    else
    {
        AppDelegate *appDelegate =
        [[UIApplication sharedApplication] delegate];
        [appDelegate getFacebookAccount];
    }

    
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadProfile {
    
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                            requestMethod:SLRequestMethodGET
                                                      URL:[NSURL URLWithString:@"https://graph.facebook.com/me/friends"] parameters:nil];
    
    

    request.account = appDelegate.facebookAccount;
    
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        
        
        //NSLog(@"response data: %@", responseData);
        NSError *jsonError;
        NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:responseData
                                                                     options:NSJSONReadingAllowFragments
                                                                       error:&jsonError];
        
        NSLog(@"response JSON: %@", responseJSON);
    }];
}







@end
