//
//  SSMApi.h
//  Sasongsmat
//
//  Created by Matti Ryhänen on 2011-07-21.
//  Copyright 2011 Matti Ryhänen, Säsongsmat.
//
//  Licensed under the BSD license
//  Please consult the LICENSE file in the root directory for more information. All rights reserved.
//

#import <Foundation/Foundation.h>

//typedef void (^ArticleLoadedBlock)(ItemArticleViewController *);
typedef void (^ArrayLoadedBlock)(NSArray *);
typedef void (^DictionaryLoadedBlock)(NSDictionary *);
typedef void (^StringLoadedBlock)(NSString *);
typedef void (^APIErrorBlock)(NSString *);
//typedef void (^APIErrorBlock)(NSError *);


@interface SSMApi : NSObject {
    
    NSString *host;
    NSString *apiUrl;
    
}

+ (SSMApi *)sharedSSMApi;

- (NSURL *)createAPIUrl;

- (void)getArticleWithName:(NSString *)name loadedBlock:(DictionaryLoadedBlock)successBlock error:(APIErrorBlock)errorBlock;

- (void)getSeasonItemsWithBlock:(ArrayLoadedBlock)successBlock error:(APIErrorBlock)errorBlock;

@end
