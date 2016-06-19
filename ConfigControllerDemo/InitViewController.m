//
//  InitViewController.m
//  ConfigControllerDemo
//
//  Created by Krishana on 6/3/16.
//  Copyright © 2016 Konstant Info Solutions Pvt. Ltd. All rights reserved.
//

#import "InitViewController.h"
#import "ViewController.h"

@interface InitViewController ()

@end

@implementation InitViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma Init button Action
-(IBAction)btnAction:(id)sender
{
    UIButton *btn = (UIButton *) sender;
    ViewController *vc;
    
    if (btn.tag == 10)
    {
        vc = [[ViewController alloc] initWithDirectoryPath:@"myfolder"];
    }
    else
    {
        NSMutableArray *imageDataArray = [[NSMutableArray alloc] init];
        for (int i =0; i< 50; i++)
        {
            [imageDataArray addObject:@"https://cdn5.raywenderlich.com/wp-content/uploads/2015/05/meme-nopictures.jpg"];
        }

        vc = [[ViewController alloc] initWithArrayOfImage:imageDataArray];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
