//
//  ViewController.h
//  ConfigControllerDemo
//
//  Created by Krishana on 6/3/16.
//  Copyright © 2016 Konstant Info Solutions Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController




/**
 *  Reference to Initializer method initialing controller with directory images
 */
-(instancetype) initWithDirectoryPath:(NSString *) directoryPath;

/**
 *  Reference to Initializer method initialing controller with array images
 */
-(instancetype) initWithArrayOfImage:(NSArray *) imageArray;
@end

