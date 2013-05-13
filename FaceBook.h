//
//  FaceBook.h
//  FaceAlbum
//
//  Created by scott mehus on 5/12/13.
//  Copyright (c) 2013 scott mehus. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^FacebookPhotoCompletionBlock)(UIImage *facebookPhoto);

@interface FaceBook : NSObject


- (void)retrieveFacebookPhoto:(NSURL *)url completionBlocker:(FacebookPhotoCompletionBlock)completionBlock;

@end
