//
//  ListCell.h
//  NikeFetchDataTest
//
//  Created by SureshDokula on 10/02/16.
//  Copyright © 2016 SureshDokula. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListCell : UITableViewCell
@property (nonatomic,strong) IBOutlet UIImageView *img;
@property (nonatomic,strong) IBOutlet UILabel *ProductName;
@property (nonatomic,strong) IBOutlet UILabel *Price;
@property (nonatomic,strong) IBOutlet UILabel *Color;
@end
