//
//  AppDelegate.h
//  FaceAlbum
//
//  Created by scott mehus on 5/11/13.
//  Copyright (c) 2013 scott mehus. All rights reserved.
//

#import <UIKit/UIKit.h>


#define AccountFacebookAccountAccessGranted @"FacebookAccountAccessGranted"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@property (nonatomic, strong) ACAccountStore *accountStore;
@property (nonatomic, strong) ACAccount *facebookAccount;


- (void)getFacebookAccount;

@end
