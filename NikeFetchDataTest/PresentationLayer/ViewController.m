//
//  ViewController.m
//  NikeFetchDataTest
//
//  Created by SureshDokula on 09/02/16.
//  Copyright © 2016 SureshDokula. All rights reserved.
//

#import "ViewController.h"
#import "Products.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize  arrProducts;

-(void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    arrProducts = [NSMutableArray array];
    [self downloadData:@"http://www.petesalvo.com/products.json" andDelegate:self];
    [self.tableView setAccessibilityLabel:@"listtable"];
    [self.tableView setAccessibilityIdentifier:@"listtable"];
}
/*
  Method for downloading data
 */
-(void)downloadData:(NSString*)urlStr andDelegate:(id)current
{
    DataDownLoader *d = [DataDownLoader new];
    d.dataDelegate = current;
    [d downloadDataWithRequest:[NSURL URLWithString:urlStr] andRequest:NULL];
}
/*
   Protcol methods 
 */
-(void)downloadedData:(NSData*)data withCurrentDownloaderObject:(DataDownLoader*)downldr
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSError *error;
        id jsonresult = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves  error:&error];
        if(error == nil)
        {
            if([jsonresult isKindOfClass:[NSDictionary class]])
            {
                @try {
                    NSDictionary *dict = (NSDictionary*)jsonresult;
                    if([dict objectForKey:@"results"] != nil && [[dict objectForKey:@"results"] isKindOfClass:[NSArray class]]){
                        NSMutableArray *arr = [NSMutableArray arrayWithArray:[dict objectForKey:@"results"]];
                        for (NSDictionary *obj in arr) {
                            Products *prd      = [Products new];
                            [prd setProduct:obj];
                            [self.arrProducts addObject:prd];
                        }
                    }
                }
                @catch (NSException *exception) {
                    NSLog(@"ViewController.m downloadedData:(NSData*)data withCurrentDownloaderObject:(DataDownLoader*)downldr %@ %@",[exception name],[exception reason]);
                }
                @finally {
                    [self.tableView reloadData];
                }
            }
        }
    });
}

-(void)failWithError:(NSError*)error withCurrentDownloaderObject:(DataDownLoader*)downldr
{
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrProducts count];
}

/*
  Table DataSource Methods for loading cells on table view
 */
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListCell"];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ListCell"];
    }
    [cell setAccessibilityLabel:@"listcell"];
    Products *prd = [self.arrProducts objectAtIndex:indexPath.row];
    UILabel *lblPrd = (UILabel*)[cell viewWithTag:100];
    lblPrd.text =  prd.product_name;
    UILabel *lblPrdCrl = (UILabel*)[cell viewWithTag:200];
    lblPrdCrl.text =  prd.product_clrcode;
    dispatch_queue_t t = dispatch_queue_create("test", NULL);
    dispatch_async(t, ^{
        @try {
            NSURL *url = [NSURL URLWithString:
                          [[prd.arr_imgs objectAtIndex:1] objectForKey:@"thumb"]];
            NSURLSessionDownloadTask *downloadPhotoTask = [[NSURLSession sharedSession]
                                                           downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                               // 3
                                                               UIImage *downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                                                               dispatch_sync(dispatch_get_main_queue(), ^{
                                                                   UIImageView *imgThumb = (UIImageView*)[cell viewWithTag:500];
                                                                   imgThumb.image = downloadedImage;
                                                               });
                                                               
                                                           }];
            
            [downloadPhotoTask resume];

        }
        @catch (NSException *exception) {
        NSLog(@"Exception in viewcontrollercellview %@ %@",[exception name],[exception reason]);
        }
       
    });
    return cell;
}

/*
    Delegation to identify the cell taping and returns the control here data download is worked with GCD in async manner
 */
-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    [self.tableView setUserInteractionEnabled:false];
    Products *prd = [self.arrProducts objectAtIndex:indexPath.row];
    dispatch_queue_t t = dispatch_queue_create("test", NULL);
    dispatch_async(t, ^{
        @try {
        NSURL *url = [NSURL URLWithString:
                      [[prd.arr_imgs objectAtIndex:0] objectForKey:@"full"]];
        // 2
        NSURLSessionDownloadTask *downloadPhotoTask = [[NSURLSession sharedSession]
                                                       downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                           // 3
                                                           UIImage *downloadedImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                                                           dispatch_sync(dispatch_get_main_queue(), ^{
                                                               UIButton *layer = [UIButton new];
                                                               layer.frame = self.view.bounds;
                                                               [layer setImage:downloadedImage forState:UIControlStateNormal];
                                                               [self.view.window addSubview:layer];
                                                               [self.view.window bringSubviewToFront:layer];
                                                            [layer addTarget:self action:@selector(close:) forControlEvents:UIControlEventTouchUpInside];
                                                               [layer setAccessibilityLabel:@"closeFllView"];
                                                               [self.tableView setAlpha:0.5];
                                                           });
                                                       }];
        [downloadPhotoTask resume];
        }
        @catch (NSException *exception) {
            NSLog(@"Exception in viewcontrollercellview %@ %@",[exception name],[exception reason]);
        }
       });
}

-(void)close:(id)sender
{
    [UIView beginAnimations:@"colse" context:NULL];
    [sender removeFromSuperview];
    [self.tableView setAlpha:1.0];
    [self.tableView setUserInteractionEnabled:true];
    [UIView commitAnimations];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
