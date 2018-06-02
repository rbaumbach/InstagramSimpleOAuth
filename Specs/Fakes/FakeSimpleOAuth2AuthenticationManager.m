#import "FakeSimpleOAuth2AuthenticationManager.h"

@implementation FakeSimpleOAuth2AuthenticationManager

- (void)authenticateOAuthClient:(NSURL *)authURL
      tokenParametersDictionary:(NSDictionary *)tokenParameters
                        success:(void (^)(id authResponseObject))success
                        failure:(void (^)(NSError *error))failure
{
    self.authURL = authURL;
    self.tokenParametersDictionary = tokenParameters;
    self.success = success;
    self.failure = failure;
}

- (void)authenticateOAuthClient:(NSURL *)authURL
                tokenParameters:(id<TokenParameters>)tokenParameters
                        success:(void (^)(id authResponseObject))success
                        failure:(void (^)(NSError *error))failure
{
    self.authURL = authURL;
    self.tokenParameters = tokenParameters;
    self.success = success;
    self.failure = failure;
}

@end
