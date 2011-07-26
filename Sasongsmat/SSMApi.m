//
//  SSMApi.m
//  Sasongsmat
//
//  Created by Matti Ryhänen on 2011-07-21.
//  Copyright 2011 Matti Ryhänen, Säsongsmat.
//
//  Licensed under the BSD license
//  Please consult the LICENSE file in the root directory for more information. All rights reserved.
//

#import "SSMApi.h"
#import "ASIHTTPRequest.h"
#import "FoodListItem.h"
#import "SBJson.h"

@implementation SSMApi

- (NSString *)baseUrlForAction:(NSString *)action {
    return [NSString stringWithFormat:@"%@%@?action=%@&format=json", host, apiUrl, action];
}

- (NSURL *)createAPIUrl {
    NSString *urlString = [NSString stringWithFormat:@"%@%@?action=ssmlista&ns=0&props=Baskategori&format=json", host, apiUrl];
    
    return [NSURL URLWithString:urlString];
}

- (void)getArticleWithName:(NSString *)name loadedBlock:(DictionaryLoadedBlock)successBlock error:(APIErrorBlock)errorBlock {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@&page=%@", [self baseUrlForAction:@"parse"], name]];

    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.defaultResponseEncoding = NSUTF8StringEncoding;
    
    
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        NSDictionary *responseJson = (NSDictionary *)[responseString JSONValue];
        
        successBlock(responseJson);
    }];
    
    [request setFailedBlock:^{
        errorBlock([[request error] localizedDescription]);
    }];
    
    [request startAsynchronous];

}
- (void)getSeasonItemsWithBlock:(ArrayLoadedBlock)successBlock error:(APIErrorBlock)errorBlock {
    NSURL *url = [self createAPIUrl];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.defaultResponseEncoding = NSUTF8StringEncoding;
    
    
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        //NSLog(@"%@", responseString);
        
        NSDictionary *responseJson = (NSDictionary *)[responseString JSONValue];
        successBlock([FoodListItem listItemsForJsonArray:[[responseJson objectForKey:@"ssm"] allValues]]);
    }];
    
    [request setFailedBlock:^{
        errorBlock([[request error] localizedDescription]);
    }];
    
    [request startAsynchronous];

}

- (id)init {
    self = [super init];
    if (self) {
        host    = @"http://xn--ssongsmat-v2a.nu/";
        apiUrl  = @"w/api.php";
    }
    
    return self;
}

#pragma mark - Singleton implementation
static SSMApi *_sharedSSMApi;

+ (SSMApi *)sharedSSMApi {
    if (_sharedSSMApi == nil) {
        _sharedSSMApi = [[super allocWithZone:NULL] init];
    }
    return _sharedSSMApi;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [[SSMApi sharedSSMApi] retain];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (NSUInteger)retainCount {
    return NSUIntegerMax;
}

- (void)release {
    // Nopes
}

- (id)autorelease {
    return self;
}

#pragma mark -

@end
