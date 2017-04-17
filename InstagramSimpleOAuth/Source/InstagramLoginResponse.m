//Copyright (c) 2016 Ryan Baumbach <github@ryan.codes>
//
//Permission is hereby granted, free of charge, to any person obtaining
//a copy of this software and associated documentation files (the "Software"),
//to deal in the Software without restriction, including
//without limitation the rights to use, copy, modify, merge, publish,
//distribute, sublicense, and/or sell copies of the Software, and to
//permit persons to whom the Software is furnished to do so, subject to
//the following conditions:
//
//The above copyright notice and this permission notice shall be
//included in all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "InstagramLoginResponse.h"
#import "InstagramUser.h"


NSString *const InstagramAccessTokenKey = @"access_token";
NSString *const InstagramUserKey = @"user";
NSString *const InstagramAuthCodeKey = @"auth_code";

@interface InstagramLoginResponse ()

@property (copy, nonatomic, readwrite) NSString *accessToken;
@property (strong, nonatomic, readwrite) InstagramUser *user;
@property (copy, nonatomic, readwrite) NSString *authorizationCode;


@end

@implementation InstagramLoginResponse

#pragma mark - Init Methods

- (instancetype)initWithInstagramOAuthResponse:(NSDictionary *)response
{
    self = [super init];
    if (self) {
        if (response) {
            self.accessToken = response[InstagramAccessTokenKey];
            self.authorizationCode = response[InstagramAuthCodeKey];
            InstagramUser *user = [[InstagramUser alloc] initWithDictionary:response[InstagramUserKey]];
            self.user = user;
        }
    }
    return self;
}

@end
