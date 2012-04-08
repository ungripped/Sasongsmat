//
//  SSMWebClient.m
//  Sasongsmat
//
//  Created by Matti on 2011-10-12.
//  Copyright 2011 Matti Ryhänen, Säsongsmat.
//
//  Licensed under the BSD license
//  Please consult the LICENSE file in the root directory for more information. All rights reserved.
//

#import "SSMWebClient.h"
#import "SSMWebRequestOperation.h"

NSString * const kSSMWebBaseURLString = @"http://xn--ssongsmat-v2a.nu:4000";

@implementation SSMWebClient

+ (SSMWebClient *)sharedClient {
    static SSMWebClient *_sharedClient = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        _sharedClient = [[self alloc] initWithBaseURL:[NSURL URLWithString:kSSMWebBaseURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[SSMWebRequestOperation class]];
    
    
    // Set default headers here, e.g:
    //[self setDefaultHeader:@"X-SSM-API-Version" value:@"1.0"];
    
    //[self setDefaultHeader:@"X-UDID" value:[[UIDevice currentDevice] uniqueIdentifier]];
    
    return self;
}

@end
