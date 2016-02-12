//
//  ListCell.m
//  NikeFetchDataTest
//
//  Created by SureshDokula on 10/02/16.
//  Copyright © 2016 SureshDokula. All rights reserved.
//

#import "ListCell.h"

@implementation ListCell
@synthesize img,ProductName,Price,Color;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
