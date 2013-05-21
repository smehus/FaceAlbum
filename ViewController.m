//
//  ViewController.m
//  FaceAlbum
//
//  Created by scott mehus on 5/11/13.
//  Copyright (c) 2013 scott mehus. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "FaceBook.h"
#import "FacebookPhotoCell.h"
#import <QuartzCore/QuartzCore.h>


@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *pictureArray;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *actualImageArray;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation ViewController {
    
    UIImage *pinImage;
    NSMutableArray *sourceArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    pinImage = [UIImage imageNamed:@"pushpin.png"];
    self.refreshControl = nil;
    sourceArray = [[NSMutableArray alloc] initWithCapacity:20];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(reloadProfile) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    [self.collectionView addSubview:self.refreshControl];
    self.collectionView.alwaysBounceVertical = YES;
    
    self.pictureArray = [@[] mutableCopy];
    self.actualImageArray = [[NSMutableArray alloc] initWithCapacity:30];
    
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
    
    

    
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

- (void)reloadProfile {
    
    [self.actualImageArray removeAllObjects];
    [self.pictureArray removeAllObjects];
    [sourceArray removeAllObjects];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSString *firstAlbum = @"https://graph.facebook.com/569895742409/photos";
    NSString *homeFeed = @"https://graph.facebook.com/me/home";
    
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeFacebook
                                            requestMethod:SLRequestMethodGET
                                                      URL:[NSURL URLWithString:homeFeed] parameters:nil];
    
    

    request.account = appDelegate.facebookAccount;
    
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
    
        NSError *jsonError;
        NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:responseData
                                                                     options:NSJSONReadingAllowFragments
                                                                       error:&jsonError];
        

        NSArray *array = responseJSON[@"data"];
        NSLog(@"array: %@", array);

        
   
        for (NSDictionary *photo in array) {
            NSArray *images = photo[@"images"];
            NSString *picture = photo[@"picture"];
            if (picture) {
                [self.pictureArray addObject:picture];
            }
            
            for (NSDictionary *photoInfo in images) {
                
                
            }
     
        
        }
        
        for (NSString *string in self.pictureArray) {
            
            NSURL *url = [NSURL URLWithString:string];
            NSData *imageData = [NSData dataWithContentsOfURL:url];
            UIImage *pictureImage = [UIImage imageWithData:imageData];
            if (pictureImage.size.width <= 300) {
                
                 [self.actualImageArray addObject:pictureImage];
            }
           
            [self.collectionView reloadData];
            
        }
        
        
        //NSLog(@"actual image %@", self.actualImageArray);
        [self.refreshControl endRefreshing];
        

        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.collectionView reloadData];
        });

    }];
            
    [self.collectionView reloadData];

}



#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.actualImageArray count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FacebookPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];
    
    cell.imageView.image = self.actualImageArray[indexPath.row];
    return cell;
}

/*
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    return [[UICollectionReusableView alloc] init];
}
*/


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    UIImage *pictureImage;
    
    if ([self.actualImageArray count] > 0) {
        pictureImage = self.actualImageArray[indexPath.row];
    }

    CGSize retval = pictureImage.size;
    int sideBorder = 15;
    retval.height += 0;
    retval.width += 0;
    return retval;
    
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(50, 20, 50, 20);
}


















@end
