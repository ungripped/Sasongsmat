//
//  SSMWebClient.h
//  Sasongsmat
//
//  Created by Matti on 2011-10-12.
//  Copyright 2011 Matti Ryhänen, Säsongsmat.
//
//  Licensed under the BSD license
//  Please consult the LICENSE file in the root directory for more information. All rights reserved.
//

#import "AFHTTPClient.h"

extern NSString * const kSSMWebBaseURLString;

@interface SSMWebClient : AFHTTPClient
+ (SSMWebClient *)sharedClient;
@end
