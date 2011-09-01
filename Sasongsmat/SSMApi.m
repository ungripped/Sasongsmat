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

@interface SSMApi(Private)

- (void)asyncCallTo:(NSURL *)url withBlock:(DictionaryLoadedBlock)successBlock error:(APIErrorBlock)errorBlock;

@end

@implementation SSMApi

- (NSString *)baseUrlForAction:(NSString *)action {
    return [NSString stringWithFormat:@"%@%@?action=%@&format=json", host, apiUrl, action];
}

- (NSURL *)createAPIUrl:(NSString *)ns {
    NSString *urlString = [NSString stringWithFormat:@"%@%@?action=ssmlista&ns=%@&props=Baskategori,Kategori,bild,Nyckel&format=json", host, apiUrl, ns];
    
    return [NSURL URLWithString:urlString];
}

- (void)asyncCallTo:(NSURL *)url withBlock:(DictionaryLoadedBlock)successBlock error:(APIErrorBlock)errorBlock {
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

- (void)getBarcodeDataForBarcode:(NSString *)barcode withBlock:(DictionaryLoadedBlock)successBlock error:(APIErrorBlock)errorBlock {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%&kod=%@", [self baseUrlForAction:@"ssmstreckkod"], barcode]];
    
    [self asyncCallTo:url withBlock:successBlock error:errorBlock];
}

- (void)getArticleWithName:(NSString *)name loadedBlock:(DictionaryLoadedBlock)successBlock error:(APIErrorBlock)errorBlock {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@&page=%@", [self baseUrlForAction:@"parse"], name]];

    [self asyncCallTo:url withBlock:successBlock error:errorBlock];
}

- (void)getSeasonItemsInNamespace:(NSString *)ns withBlock:(ArrayLoadedBlock)successBlock error:(APIErrorBlock)errorBlock {
    NSURL *url = [self createAPIUrl:ns];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.defaultResponseEncoding = NSUTF8StringEncoding;
    
    
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        //NSLog(@"%@", responseString);
        
        NSDictionary *responseJson = (NSDictionary *)[responseString JSONValue];
        successBlock([[responseJson objectForKey:@"ssm"] allValues]);
    }];
    
    [request setFailedBlock:^{
        errorBlock([[request error] localizedDescription]);
    }];
    
    [request startAsynchronous];
}

/*
- (void)getSeasonRecipesWithBlock:(ArrayLoadedBlock)successBlock error:(APIErrorBlock)errorBlock {
    NSURL *url = [self createAPIUrl:@"550"];
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.defaultResponseEncoding = NSUTF8StringEncoding;
    
    [request setCompletionBlock:^{
        NSString *responseString = [request
    }];
    
    [request setFailedBlock:^{
        
    }];
     
    [request startAsynchronous];
}
 */

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
