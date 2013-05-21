//
//  AppDelegate.m
//  FaceAlbum
//
//  Created by scott mehus on 5/11/13.
//  Copyright (c) 2013 scott mehus. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
 
    self.accountStore = [[ACAccountStore alloc] init];
    
    
    UIColor *tintColor = [UIColor blueColor];
    [[UINavigationBar appearance] setTintColor:tintColor];

    return YES;
}
							


- (void)getPublishStream {
    
    // 1
    ACAccountType *facebookAccountType = [self.accountStore
                                          accountTypeWithAccountTypeIdentifier:
                                          ACAccountTypeIdentifierFacebook];
    
    // 2
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 3
        NSDictionary *facebookOptions = @{
                                          ACFacebookAppIdKey : @"505924356132066",
                                          ACFacebookPermissionsKey : @[@"publish_stream"],
                                          ACFacebookAudienceKey : ACFacebookAudienceEveryone };
        // 4
        [self.accountStore
         requestAccessToAccountsWithType:facebookAccountType
         options:facebookOptions completion:^(BOOL granted,
                                              NSError *error) {
             // 5
             if (granted)
             {
                 self.facebookAccount = [[self.accountStore
                                          accountsWithAccountType:facebookAccountType]
                                         lastObject];
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [[NSNotificationCenter defaultCenter]
                      postNotificationName:
                      AccountFacebookAccountAccessGranted
                      object:nil];
                 });
             }
             // 6
             else
             {
                 // 7
                 if (error)
                 {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Facebook"
                                                                             message:@"There was an error retrieving your Facebook account, make sure you have an account setup in Settings and that access is granted for iSocial"
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"Dismiss"
                                                                   otherButtonTitles:nil];
                         [alertView show];
                     });
                 }
                 // 8
                 else
                 {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Facebook"
                                                                             message:@"Access to Facebook was not granted. Please go to the device settings and allow access for iSocial"
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"Dismiss"
                                                                   otherButtonTitles:nil];
                         [alertView show];
                     });
                 }
             }
         }];
    });
    
}

- (void)getFacebookAccount
{
    // 1
    ACAccountType *facebookAccountType = [self.accountStore
                                          accountTypeWithAccountTypeIdentifier:
                                          ACAccountTypeIdentifierFacebook];
    
    // 2
    dispatch_async(dispatch_get_global_queue(
                                             DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 3
        NSDictionary *facebookOptions = @{
                                          ACFacebookAppIdKey : @"505924356132066",
                                          ACFacebookPermissionsKey : @[@"email", @"read_stream",
                                                                       @"user_relationships", @"user_website", @"user_photos", @"friends_photos", @"read_friendlists"],
                                          ACFacebookAudienceKey : ACFacebookAudienceEveryone };
        // 4
        [self.accountStore
         requestAccessToAccountsWithType:facebookAccountType
         options:facebookOptions completion:^(BOOL granted,
                                              NSError *error) {
             // 5
             if (granted)
             {
                 [self getPublishStream];
             }
             // 6
             else
             {
                 // 7
                 if (error)
                 {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Facebook"
                                                                             message:@"There was an error retrieving your Facebook account, make sure you have an account setup in Settings and that access is granted for iSocial"
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"Dismiss"
                                                                   otherButtonTitles:nil];
                         [alertView show];
                     });
                 }
                 // 8
                 else
                 {
                     dispatch_async(dispatch_get_main_queue(), ^{
                         UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Facebook"
                                                                             message:@"Access to Facebook was not granted. Please go to the device settings and allow access for iSocial"
                                                                            delegate:nil
                                                                   cancelButtonTitle:@"Dismiss"
                                                                   otherButtonTitles:nil];
                         [alertView show];
                     });
                 }
             }
         }];
    });
}







@end
