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


@interface ViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray *pictureArray;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *actualImageArray;

@end

@implementation ViewController {
    
    UIImage *pinImage;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    pinImage = [UIImage imageNamed:@"pushpin.png"];
    
    self.pictureArray = [@[] mutableCopy];
    self.actualImageArray = [[NSMutableArray alloc] initWithCapacity:20];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
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

    //[self.collectionView registerClass:[FacebookPhotoCell class] forCellWithReuseIdentifier:@"PhotoCell"];
    
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
                                                      URL:[NSURL URLWithString:@"https://graph.facebook.com/me/home"] parameters:nil];
    
    

    request.account = appDelegate.facebookAccount;
    
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        
        
        //NSLog(@"response data: %@", responseData);
        NSError *jsonError;
        NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:responseData
                                                                     options:NSJSONReadingAllowFragments
                                                                       error:&jsonError];
        
        
        NSArray *array = responseJSON[@"data"];
        
        for (NSDictionary *action in array) {
            
            //NSDictionary *nameDict = action[@"from"];
            NSString *picture = action[@"picture"];
           
            if (picture) {
                [self.pictureArray addObject:picture];
               // NSLog(@"response picture: %@", picture);
            }      
        }
        
        
        for (NSString *string in self.pictureArray) {
            
            
            NSURL *url = [NSURL URLWithString:string];
            NSData *imageData = [NSData dataWithContentsOfURL:url];
            UIImage *pictureImage = [UIImage imageWithData:imageData];
           // NSLog(@"PICTURE IMAGE %@", pictureImage);
            [self.actualImageArray addObject:pictureImage];
            [self.collectionView reloadData];
            
        }
        


        
        
      /*
        
        [self.pictureArray enumerateObjectsUsingBlock:^(NSString *stringURL, NSUInteger idx, BOOL *stop) {
            
            NSURL *url = [NSURL URLWithString:stringURL];
            //NSLog(@"STRING ARRAY %@", stringURL);
            
            FaceBook *facebook = [[FaceBook alloc] init];
            [facebook retrieveFacebookPhoto:url completionBlocker:^(UIImage *facebookPhoto) {
                
                NSLog(@"ADD PHOTO FROM BLOCK");
                [self.actualImageArray insertObject:facebookPhoto atIndex:0];
                 NSLog(@"response array: %@", self.actualImageArray);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.collectionView reloadData];
                });
            }];
        }];
        
        */
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.collectionView reloadData];
        });
    }];
    [self.collectionView reloadData];
}



#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.pictureArray count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FacebookPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCell" forIndexPath:indexPath];

    cell.imageView.image = self.actualImageArray[indexPath.row];
    NSLog(@"CELL: %@", self.actualImageArray[indexPath.row]);
    cell.backgroundColor = [UIColor whiteColor];
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
    retval.height += 10;
    retval.width += 10;
    return retval;
    
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    
    return UIEdgeInsetsMake(50, 5, 50, 5);
}


















@end
