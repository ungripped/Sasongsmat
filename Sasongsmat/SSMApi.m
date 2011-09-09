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

- (ASIHTTPRequest *)asyncCallTo:(NSURL *)url withBlock:(DictionaryLoadedBlock)successBlock error:(APIErrorBlock)errorBlock;

- (ASIHTTPRequest *)asyncCallToUrlString:(NSString *)urlString withBlock:(DictionaryLoadedBlock)successBlock error:(APIErrorBlock)errorBlock;
@end

@implementation SSMApi

- (NSString *)baseUrlForAction:(NSString *)action {
    return [NSString stringWithFormat:@"%@%@?action=%@&format=json", host, apiUrl, action];
}

- (NSURL *)createSearchUrl:(NSString *)searchString {
    NSString *urlString = [NSString stringWithFormat:@"%@&list=search&srsearch=%@&srprop=Baskategori|bild", [self baseUrlForAction:@"query"], searchString];
    
    return [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

- (NSURL *)createAPIUrl:(NSString *)ns {
    NSString *urlString = [NSString stringWithFormat:@"%@%@?action=ssmlista&sasong=3&ns=%@&props=Baskategori,Kategori,bild,Nyckel&format=json", host, apiUrl, ns];
    
    return [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}

- (ASIHTTPRequest *)asyncCallTo:(NSURL *)url withBlock:(DictionaryLoadedBlock)successBlock error:(APIErrorBlock)errorBlock {
    __block ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    request.defaultResponseEncoding = NSUTF8StringEncoding;
    
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        NSDictionary *responseJson = (NSDictionary *)[responseString JSONValue];
        
        NSLog(@"Json response: %@", responseJson);
        successBlock(responseJson);
    }];
    
    [request setFailedBlock:^{
        errorBlock(request.error);
    }];
    
    [request startAsynchronous];
    return request;
}

- (ASIHTTPRequest *)asyncCallToUrlString:(NSString *)urlString withBlock:(DictionaryLoadedBlock)successBlock error:(APIErrorBlock)errorBlock {
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    return [self asyncCallTo:url withBlock:successBlock error:errorBlock];
}

- (void)getBarcodeDataForBarcode:(NSString *)barcode withBlock:(DictionaryLoadedBlock)successBlock error:(APIErrorBlock)errorBlock {
    NSString *urlString = [NSString stringWithFormat:@"%@%&kod=%@", [self baseUrlForAction:@"ssmstreckkod"], barcode];
    [self asyncCallToUrlString:urlString withBlock:successBlock error:errorBlock];
}

- (void)getArticleWithName:(NSString *)name loadedBlock:(DictionaryLoadedBlock)successBlock error:(APIErrorBlock)errorBlock {
    
    if (articleRequest != nil) {
        [articleRequest cancel];
        [articleRequest release];
        articleRequest = nil;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@&page=%@", [self baseUrlForAction:@"parse"], name];
    
    ASIHTTPRequest *req = [self asyncCallToUrlString:urlString withBlock:successBlock error:errorBlock];
    
    articleRequest = [req retain];
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
        errorBlock(request.error);
    }];
    
    [request startAsynchronous];
}

- (NSArray *)search:(NSString *)searchString {
    
    NSURL *url = [self createSearchUrl:[NSString stringWithFormat:@"*%@*", searchString]];
    
    NSLog(@"Searching: %@", url);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request appendPostData:[searchString dataUsingEncoding:NSUTF8StringEncoding]]; // Set the POST data to our search string
    [request startSynchronous];
    NSError *error = [request error];
    if (!error) {
        //NSLog(@"Got result for %@", searchString);
        NSString *responseString = [request responseString];
        NSDictionary *responseJson = (NSDictionary *)[responseString JSONValue];
            
        NSArray *tmp = [[[responseJson objectForKey:@"query"] allValues] objectAtIndex:0];
        
        if ([tmp count] > 0) {
            NSMutableArray *result = [NSMutableArray arrayWithCapacity:[tmp count]];
            NSLog(@"%@", tmp);
            for (NSDictionary *obj in tmp) {
                [result addObject:[obj objectForKey:@"title"]];
            }
            return result;
        }
        else {
            return tmp;
        }
        
    }
    else {
        NSLog(@"Error: %@", error);
        return nil;
    }
    
    return nil;
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
        // Use in development only:
        [ASIHTTPRequest setMaxBandwidthPerSecond:ASIWWANBandwidthThrottleAmount];
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

/*
- (void)release {
    // Nopes
}
*/

- (id)autorelease {
    return self;
}

#pragma mark -

@end
