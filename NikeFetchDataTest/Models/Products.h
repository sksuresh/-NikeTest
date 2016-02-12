//
//  Products.h
//  NikeFetchDataTest
//
//  Created by SureshDokula on 10/02/16.
//  Copyright © 2016 SureshDokula. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Products : NSObject
{
    NSString *product_name;
    NSString *product_clrcode;
    NSMutableArray *arr_imgs;
    NSMutableDictionary *prices;
}

@property (nonatomic,strong) NSString *product_name;
@property (nonatomic,strong) NSString *product_clrcode;
@property (nonatomic,strong) NSMutableArray *arr_imgs;
@property (nonatomic,strong) NSMutableDictionary *prices;
-(void)setProduct:(id)obj;

@end
