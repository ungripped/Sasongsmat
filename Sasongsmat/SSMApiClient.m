//
//  SSMApiClient.m
//  Sasongsmat
//
//  Created by Matti on 2011-10-14.
//  Copyright 2011 Matti Ryhänen, Säsongsmat.
//
//  Licensed under the BSD license
//  Please consult the LICENSE file in the root directory for more information. All rights reserved.
//

#import "SSMApiClient.h"
#import "AFJSONRequestOperation.h"

NSString * const kSSMApiBaseURLString = @"http://xn--ssongsmat-v2a.nu";


@implementation SSMApiClient

+ (SSMApiClient *)sharedClient {
    static SSMApiClient *_sharedClient = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kSSMApiBaseURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    [self setDefaultHeader:@"Accept" value:@"application/json"];

    // Set default headers here, e.g:
    //[self setDefaultHeader:@"X-SSM-API-Version" value:@"1.0"];
    
    [self setDefaultHeader:@"X-UDID" value:[[UIDevice currentDevice] uniqueIdentifier]];
    
    return self;
}



@end
