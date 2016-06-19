//
//  ViewController.m
//  ConfigControllerDemo
//
//  Created by Krishana on 6/3/16.
//  Copyright © 2016 Konstant Info Solutions Pvt. Ltd. All rights reserved.
//

#import "ViewController.h"
#import "ImageViewCell.h"
#import "Config.h"
#import "ImageModel.h"
#import "AsynImageDownLoad.h"


@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
{
    /**
     *  Reference to array used to populate collectionView
     */
    NSArray * imageArrayForView;
    
    /**
     *  Reference to bool value which check whether user is sending array or a directory
     */
    BOOL isImageinArray;
    
    /**
     *  Reference to the directory path if user sends directory on this controller
     */
    NSString *imageDirectoryPath;
}

/**
 *  Reference to Image collection view
 */
@property (weak) IBOutlet UICollectionView *imageCollectionView;

@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder*)coder
{
    if ((self = [super initWithCoder:coder]))
    {
        
    }
    return self;
}

-(instancetype) initWithDirectoryPath:(NSString *) directoryPath
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //self = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    
    self = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    
    if (self)
    {
        imageDirectoryPath = directoryPath;
        isImageinArray = false;
    }
    return self;
}

-(instancetype) initWithArrayOfImage:(NSArray *) imageArray
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self =  [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];

    if (self)
    {
        imageDirectoryPath = @"";
        isImageinArray = true;
        imageArrayForView = [NSArray arrayWithArray:imageArray];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (isImageinArray)
    {
        NSLog(@"array->%@",imageArrayForView);
        [self.imageCollectionView reloadData];
    }
    else
    {
        [self createArrayofImagesFromDirectory:imageDirectoryPath];
    }
}

#pragma mark - Config Collection View

-(void) createArrayofImagesFromDirectory:(NSString *) directoryPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *myPath = [paths objectAtIndex:0];
    // if you save fies in a folder
    myPath = [myPath stringByAppendingPathComponent:directoryPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // all files in the path
    NSArray *directoryContents = [fileManager contentsOfDirectoryAtPath:myPath error:nil];
    // filter image files
    NSMutableArray *subpredicates = [NSMutableArray array];
    [subpredicates addObject:[NSPredicate predicateWithFormat:@"SELF ENDSWITH '.png'"]];
    [subpredicates addObject:[NSPredicate predicateWithFormat:@"SELF ENDSWITH '.jpg'"]];
    NSPredicate *filter = [NSCompoundPredicate orPredicateWithSubpredicates:subpredicates];
    
    imageDirectoryPath = myPath;
    imageArrayForView = [directoryContents filteredArrayUsingPredicate:filter];
    
//    for (int i = 0; i < onlyImages.count; i++)
//    {
//        NSString *imagePath = [myPath stringByAppendingPathComponent:[onlyImages objectAtIndex:i]];
//        //UIImage *tempImage = [UIImage imageWithContentsOfFile:imagePath];
//        // do something you want
//    }
    [self.imageCollectionView reloadData];
}

#pragma Mark - Collection View Delegate and Datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return imageArrayForView.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Dequeue cell
    ImageViewCell* cell = (ImageViewCell*) [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    if (isImageinArray)
    {
        //ImageModel *model = (ImageModel *)[imageArrayForView objectAtIndex:indexPath.row];
        NSString *imgstr = [imageArrayForView objectAtIndex:indexPath.row];
        if (imgstr != nil && ![imgstr isEqualToString:@""])
        {
            NSString *fileName = [[imgstr componentsSeparatedByString:@"/"] lastObject];
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *strTmpPath = paths[0];
            NSString *imgPath = [strTmpPath stringByAppendingPathComponent:fileName];
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ([fileManager fileExistsAtPath:imgPath])
            {
                cell.feedImage.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:imgPath]];
                [cell.indicatorView setHidden:YES];
            }
            else
            {
                AsynImageDownLoad *asynImageDownLoad = [[AsynImageDownLoad alloc] init];
                NSString *backgroundQueueIdentifier = [NSString stringWithFormat:@"com.fs.asyncdownload.profileimage"];
                [asynImageDownLoad downLoadingAsynImage:cell.feedImage imagePath:imgstr backgroundQueue:dispatch_queue_create([backgroundQueueIdentifier cStringUsingEncoding:NSASCIIStringEncoding], NULL) localIdentifier:fileName];
            }
        }
        else
        {
            cell.feedImage.image = [UIImage imageNamed:@"Apple_Swift_Logo.png"];
            [cell.indicatorView setHidden:YES];
        }
    }
    else
    {
        NSString *imagePath = [imageDirectoryPath stringByAppendingPathComponent:[imageArrayForView objectAtIndex:indexPath.row]];
        UIImage *tempImage = [UIImage imageWithContentsOfFile:imagePath];
        cell.feedImage.image = tempImage;
        [cell.indicatorView setHidden:YES];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat imgWidth = (SCREEN_WIDTH - (COLLECTION_CELL_INTER_ITEMS_PADDING * (NUMBER_OF_ITEMS_PER_ROW - 1)) - (2 * COLLECTION_CELL_LEFT_PADDING)) / NUMBER_OF_ITEMS_PER_ROW;
    return CGSizeMake(imgWidth, imgWidth);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return COLLECTION_CELL_MIN_LINE_SPACING;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return COLLECTION_CELL_INTER_ITEMS_PADDING;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
