#import "SimpleOAuth2AuthenticationManager.h"


@interface FakeSimpleOAuth2AuthenticationManager : SimpleOAuth2AuthenticationManager

@property (strong, nonatomic) NSURL *authURL;
@property (strong, nonatomic) NSDictionary *tokenParametersDictionary;
@property (strong, nonatomic) id<TokenParameters> tokenParameters;
@property (copy, nonatomic) void (^success)(id authResponseObject);
@property (copy, nonatomic) void (^failure)(NSError *error);

@end
