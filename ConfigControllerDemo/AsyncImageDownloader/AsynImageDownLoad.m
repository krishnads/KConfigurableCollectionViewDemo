//
//  AsynImageDownLoad.m
//  StoryBoardDemo
//
//  Created by Ghanshyam on 24/04/14.
//  Copyright (c) 2014 Ghanshyam. All rights reserved.
//


#import "AsynImageDownLoad.h"

@implementation AsynImageDownLoad

-(void)downLoadingAsynImage:(UIImageView *)imgViewReference imagePath:(NSString *)imagePath  backgroundQueue:(dispatch_queue_t)queue localIdentifier:(NSString *)localIdentifier{
    //self.backgroundQueue = queue;
    //dispatch_async(_backgroundQueue, ^{
    
    localFileIdentifier = localIdentifier;
        self.imgView = imgViewReference;
        self.imgPath = imagePath;
        
        //Creating URL With URLRequest
        NSURL *url = [NSURL URLWithString:imagePath];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        self.imgData = nil;
        self.connection = nil;
        
        //Creating Mutable NSData object to collect downloaded data
        self.imgData = [[NSMutableData alloc] init];
        //Creating connection with specified URL
        self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:NO];
        [_connection scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        [_connection start];
       // CFRunLoopRun();
    
        self.downloadInProgress = YES;
        if (_connection == nil) {
            self.downloadInProgress = NO;
            self.connection = nil;
            self.imgData = nil;
           // CFRunLoopStop(CFRunLoopGetCurrent());
        }
    //});
    
}

-(void)cancelDownLoading{
    [self.connection cancel];
    self.downloadInProgress = NO;
    self.connection = nil;
    self.imgData = nil;
    //CFRunLoopStop(CFRunLoopGetCurrent());
    if ([_delegate conformsToProtocol:@protocol(AsyncImageDelegate)] &&
        [_delegate respondsToSelector:@selector(downloadingCanceled)]) {
        [_delegate downloadingCanceled];
    }
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
    self.downloadInProgress = NO;
    self.connection = nil;
    self.imgData = nil;
    //CFRunLoopStop(CFRunLoopGetCurrent());
    if ([_delegate conformsToProtocol:@protocol(AsyncImageDelegate)] &&
        [_delegate respondsToSelector:@selector(downloadingFailed)]) {
        [_delegate downloadingFailed];
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [_imgData appendData:data];
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
   // NSLog(@"loading finished");
    self.downloadInProgress = NO;
    if (self.imgView) {
        dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self showImage];
        });
        [self saveCacheImage];
    }
}
- (void)showImage{
    if (_imgView) {
        UIImage *image = [UIImage imageWithData:_imgData];
        _imgView.image = image;
        UIView *contentView = [_imgView superview];
        
        UIActivityIndicatorView *activity = (UIActivityIndicatorView *)[contentView viewWithTag:100];
        [activity stopAnimating];
        [activity setHidden:YES];
        
        
        if ([_delegate conformsToProtocol:@protocol(AsyncImageDelegate)] &&
            [_delegate respondsToSelector:@selector(downloadingCompleted)]) {
            [_delegate downloadingCompleted];
        }
    }
}

-(void)saveCacheImage{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *strTmpPath = paths[0];
    //NSString *fileName = [[self.imgPath componentsSeparatedByString:@"/"] lastObject];
    NSString *ImgPath = [strTmpPath stringByAppendingPathComponent:localFileIdentifier];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:ImgPath]) {
        [self.imgData writeToFile:ImgPath atomically:YES];
    }
}


-(void)dealloc{
    self.connection         = nil;
    self.imgData            = nil;
    //self.backgroundQueue    = nil;
    self.imgPath            = nil;
}

@end
