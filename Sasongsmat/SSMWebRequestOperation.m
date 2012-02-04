//
//  SSMWebRequestOperation.m
//  Sasongsmat
//
//  Created by Matti on 2011-10-13.
//  Copyright 2011 Matti Ryhänen, Säsongsmat.
//
//  Licensed under the BSD license
//  Please consult the LICENSE file in the root directory for more information. All rights reserved.
//

#import "SSMWebRequestOperation.h"

@implementation SSMWebRequestOperation
#pragma mark - AFHTTPClientOperation

+ (BOOL)canProcessRequest:(NSURLRequest *)request {
    return YES;
}

+ (AFHTTPRequestOperation *)HTTPRequestOperationWithRequest:(NSURLRequest *)urlRequest
                                                    success:(void (^)(id object))success 
                                                    failure:(void (^)(NSHTTPURLResponse *response, NSError *error))failure
{
    AFHTTPRequestOperation *operation = [[[AFHTTPRequestOperation alloc] initWithRequest:urlRequest] autorelease];
    
    operation.completionBlock = ^{
        if ([operation hasAcceptableStatusCode]) {
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                success(operation);
            });
        } else {
            failure(operation.response, operation.error);
        }
    };
    
    return operation;
}

@end
