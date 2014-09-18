//Copyright (c) 2014 Ryan Baumbach <rbaumbach.github@gmail.com>
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

#import <AFNetworking/AFNetworking.h>
#import "InstagramLoginManager.h"
#import "InstagramLoginResponse.h"
#import "InstagramConstants.h"


NSString *const InstagramAuthTokenEndpoint = @"/oauth/access_token/";
NSString *const ClientIDKey = @"client_id";
NSString *const ClientSecretKey = @"client_secret";
NSString *const GrantTypeKey = @"grant_type";
NSString *const GrantTypeValue = @"authorization_code";
NSString *const RedirectURIKey = @"redirect_uri";
NSString *const CodeKey = @"code";

@interface InstagramLoginManager ()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;
@property (copy, nonatomic, readwrite) NSString *clientID;
@property (copy, nonatomic, readwrite) NSString *clientSecret;
@property (strong, nonatomic, readwrite) NSURL *callbackURL;

@end

@implementation InstagramLoginManager

#pragma mark - Init Methods

- (instancetype)initWithClientID:(NSString *)clientID
                    clientSecret:(NSString *)clientSecret
                     callbackURL:(NSURL *)callbackURL
{
    self = [super init];
    if (self) {
        self.clientID = clientID;
        self.clientSecret = clientSecret;
        self.callbackURL = callbackURL;
        self.sessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:InstagramAuthURL]];
        self.sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    return self;
}

#pragma mark - Public Methods

- (void)authenticateWithAuthCode:(NSString *)authCode
                         success:(void (^)(InstagramLoginResponse *instagramLoginResponse))success
                         failure:(void (^)(NSError *error))failure
{
    [self.sessionManager POST:InstagramAuthTokenEndpoint
                   parameters:[self instagramTokenParams:authCode]
                      success:^(NSURLSessionDataTask *task, id responseObject) {
                          InstagramLoginResponse *loginResponse = [[InstagramLoginResponse alloc] initWithInstagramOAuthResponse:responseObject];
                          success(loginResponse);
                      } failure:^(NSURLSessionDataTask *task, NSError *error) {
                          failure(error);
                      }];
}

#pragma mark - Private Methods

- (NSDictionary *)instagramTokenParams:(NSString *)authCode
{
    return @{ ClientIDKey     : self.clientID,
              ClientSecretKey : self.clientSecret,
              GrantTypeKey    : GrantTypeValue,
              RedirectURIKey  : self.callbackURL.absoluteString,
              CodeKey         : authCode };
}

@end
