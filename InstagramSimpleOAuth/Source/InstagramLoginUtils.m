#import "InstagramLoginUtils.h"


#define INSTAGRAM_AUTH_URL @"https://api.instagram.com"
#define INSTAGRAM_AUTH_CLIENT_ID_ENDPOINT @"/oauth/authorize/?client_id="
#define INSTAGRAM_AUTH_REDIRECT_PARAMS @"&client=touch&redirect_uri="
#define INSTAGRAM_AUTH_RESPONSE_TYPE_PARAMS @"&response_type=code"
#define INSTAGRAM_AUTH_CODE_PARAM @"/?code="

@implementation InstagramLoginUtils

- (NSURLRequest *)buildLoginRequestWithClientID:(NSString *)clientID
                                    callbackURL:(NSURL *)callbackURL
{
    NSString *fullInstagramLoginURLString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                                             INSTAGRAM_AUTH_URL,
                                             INSTAGRAM_AUTH_CLIENT_ID_ENDPOINT,
                                             clientID,
                                             INSTAGRAM_AUTH_REDIRECT_PARAMS,
                                             callbackURL.absoluteString,
                                             INSTAGRAM_AUTH_RESPONSE_TYPE_PARAMS];
    
    NSURL *fullInstagramLoginURL = [NSURL URLWithString:fullInstagramLoginURLString];
    return [NSURLRequest requestWithURL:fullInstagramLoginURL];
}

- (BOOL)request:(NSURLRequest *)request hasAuthCodeWithCallbackURL:(NSURL *)callbackURL;
{
    NSString *requestURLString = request.URL.absoluteString;
    NSString *expectedInstagramCallbackPrefix = [NSString stringWithFormat:@"%@%@",
                                                 callbackURL.absoluteString,
                                                 INSTAGRAM_AUTH_CODE_PARAM];
    
    return [requestURLString hasPrefix:expectedInstagramCallbackPrefix];
}

@end
