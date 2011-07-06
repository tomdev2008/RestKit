//
//  RKURL.m
//  RestKit
//
//  Created by Jeff Arena on 10/18/10.
//  Copyright 2010 Two Toasters. All rights reserved.
//

#import "RKURL.h"
#import "RKClient.h"

@implementation RKURL

@synthesize baseURLString = _baseURLString;
@synthesize resourcePath = _resourcePath;
@synthesize queryParams = _queryParams;

+ (RKURL*)URLWithBaseURLString:(NSString*)baseURLString resourcePath:(NSString*)resourcePath {
	return [[[self alloc] initWithBaseURLString:baseURLString resourcePath:resourcePath] autorelease];
}

+ (RKURL*)URLWithBaseURLString:(NSString*)baseURLString resourcePath:(NSString*)resourcePath queryParams:(NSDictionary*)queryParams {
	return [[[self alloc] initWithBaseURLString:baseURLString resourcePath:resourcePath queryParams:queryParams] autorelease];
}

- (id)initWithBaseURLString:(NSString*)baseURLString resourcePath:(NSString*)resourcePath {
	return [self initWithBaseURLString:baseURLString resourcePath:resourcePath queryParams:nil];
}

- (id)initWithBaseURLString:(NSString*)baseURLString resourcePath:(NSString*)resourcePath queryParams:(NSDictionary*)queryParams {
    // Ensure the resource path always has a leading slash
    if ([resourcePath length] > 0) {
        resourcePath = ([resourcePath characterAtIndex:0] != '/') ? [NSString stringWithFormat:@"/%@", resourcePath] : resourcePath;
    }
	NSString* resourcePathWithQueryString = RKPathAppendQueryParams(resourcePath, queryParams);
	NSURL *baseURL = [NSURL URLWithString:baseURLString];
    NSURL *completeURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", baseURL, resourcePathWithQueryString]];
	if (!completeURL) {
		[self release];
		return nil;
	}
	
	// You can't safely use initWithString:relativeToURL: in a NSURL subclass, see http://www.openradar.me/9729706
    NSLog(@"Initialized the string: %@", [completeURL absoluteString]);
	self = [self initWithString:[completeURL absoluteString]];
	if (self) {
		_baseURLString = [baseURLString copy];
		_resourcePath = [resourcePath copy];
		_queryParams = [queryParams retain];
	}
	return self;
}

- (void)dealloc {
	[_baseURLString release];
	_baseURLString = nil;
	[_resourcePath release];
	_resourcePath = nil;
	[_queryParams release];
	_queryParams = nil;
	[super dealloc];
}

@end
