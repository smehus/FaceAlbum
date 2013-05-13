//
//  FaceBook.m
//  FaceAlbum
//
//  Created by scott mehus on 5/12/13.
//  Copyright (c) 2013 scott mehus. All rights reserved.
//

#import "FaceBook.h"

@implementation FaceBook

- (void)retrieveFacebookPhoto:(NSURL *)url completionBlocker:(FacebookPhotoCompletionBlock)completionBlock {
 
    

    NSData *imageData;    
    imageData = [NSData dataWithContentsOfURL:url];
    UIImage *pictureImage = [UIImage imageWithData:imageData];
    NSLog(@"PICTURE IMAGE %@", pictureImage);
    
    if (pictureImage) {
    completionBlock(pictureImage);
    }
   
}

@end
