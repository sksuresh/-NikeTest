//
//  Products.m
//  NikeFetchDataTest
//
//  Created by SureshDokula on 10/02/16.
//  Copyright © 2016 SureshDokula. All rights reserved.
//

#import "Products.h"

@implementation Products

@synthesize product_name,
product_clrcode,
arr_imgs,
prices;

-(id)init
{
    self = [super init];
    if(self)
    {
        
    }
    return  self;
}

-(void)setProduct:(id)obj
{
    self.product_name    =  [obj objectForKey:@"name1"];
    self.prices          =  [obj objectForKey:@"prices"];
    self.product_clrcode =  [obj objectForKey:@"colorDescription"];
    self.arr_imgs        =  [obj objectForKey:@"images"];

}

@end
