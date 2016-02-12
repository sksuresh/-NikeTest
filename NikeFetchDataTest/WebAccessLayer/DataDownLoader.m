//
//  DataDownLoader.m
//  NikeFetchDataTest
//
//  Created by SureshDokula on 10/02/16.
//  Copyright © 2016 SureshDokula. All rights reserved.
//

#import "DataDownLoader.h"

@implementation DataDownLoader
@synthesize session,tagvalue,datais,dataDelegate;
/*
    Delegate design pattern to get the data from the recieved url and returns to sender
 */
-(void)downloadDataWithRequest:(NSURL*)url andRequest:(NSMutableURLRequest*)request {
    NSURLSessionDataTask *downloadTask = [[NSURLSession sharedSession]
                                          dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                              if(error == nil)
                                              {
                                                  if(self.dataDelegate != nil && [self.dataDelegate respondsToSelector:@selector(downloadedData:withCurrentDownloaderObject:)])
                                                  {
                                                      [self.dataDelegate  downloadedData:data withCurrentDownloaderObject:self];
                                                  }
                                              }
                                              else{
                                                  if(self.dataDelegate != nil && [self.dataDelegate respondsToSelector:@selector(failWithError:withCurrentDownloaderObject:)])
                                                  {
                                                      [self.dataDelegate  failWithError:error withCurrentDownloaderObject:self];
                                                  }
                                              }

                                          }];
    [downloadTask resume];

    
}

@end
