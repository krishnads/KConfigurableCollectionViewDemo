//
//  AsynImageDownLoad.h
//  StoryBoardDemo
//
//  Created by Ghanshyam on 24/04/14.
//  Copyright (c) 2014 Ghanshyam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol AsyncImageDelegate <NSObject>
-(void)downloadingCompleted;
-(void)downloadingFailed;
-(void)downloadingCanceled;
@end

@interface AsynImageDownLoad : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate>{
    UIImage  *imageRef;
    NSString    *localFileIdentifier;
}

@property (nonatomic,strong)   NSString                 *imgPath;
@property (strong,nonatomic)   NSMutableData            *imgData;
@property (strong,nonatomic)   NSURLConnection          *connection;
@property (weak,nonatomic)     UIImageView              *imgView;
@property (assign,nonatomic)   BOOL                     downloadInProgress;
@property (strong,nonatomic)   dispatch_queue_t         backgroundQueue;
@property (nonatomic,weak)     id<AsyncImageDelegate>   delegate;

-(void)downLoadingAsynImage:(UIImageView *)imgViewReference imagePath:(NSString *)imagePath  backgroundQueue:(dispatch_queue_t)queue localIdentifier:(NSString *)localIdentifier;
-(void)cancelDownLoading;

@end
