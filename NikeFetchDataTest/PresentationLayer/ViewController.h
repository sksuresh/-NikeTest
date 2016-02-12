//
//  ViewController.h
//  NikeFetchDataTest
//
//  Created by SureshDokula on 09/02/16.
//  Copyright © 2016 SureshDokula. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataDownLoader.h"

@interface ViewController : UITableViewController<DataDownLoaderProtocol>
{
    NSMutableArray *arrProducts;
}
@property (nonatomic, strong) NSMutableArray *arrProducts;
-(void)downloadData:(NSString*)urlStr andDelegate:(id)current;
@end

