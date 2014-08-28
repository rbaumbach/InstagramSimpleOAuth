#import "InstagramLoginUtils.h"
#import "InstagramConstants.h"


NSString *const InstagramAuthClientIDEndpoint = @"/oauth/authorize/?client_id=";
NSString *const InstagramAuthRedirectParams = @"&client=touch&redirect_uri=";
NSString *const InstagramAuthResponseTypeParams = @"&response_type=code";
NSString *const InstagramAuthCodeParam = @"/?code=";

@implementation InstagramLoginUtils

#pragma mark - Public Methods

- (NSURLRequest *)buildLoginRequestWithClientID:(NSString *)clientID
                                    callbackURL:(NSURL *)callbackURL
{
    NSString *fullInstagramLoginURLString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                                             InstagramAuthURL,
                                             InstagramAuthClientIDEndpoint,
                                             clientID,
                                             InstagramAuthRedirectParams,
                                             callbackURL.absoluteString,
                                             InstagramAuthResponseTypeParams];
    
    NSURL *fullInstagramLoginURL = [NSURL URLWithString:fullInstagramLoginURLString];
    return [NSURLRequest requestWithURL:fullInstagramLoginURL];
}

- (BOOL)request:(NSURLRequest *)request hasAuthCodeWithCallbackURL:(NSURL *)callbackURL;
{
    NSString *requestURLString = request.URL.absoluteString;
    NSString *callbackWithAuthParam = [self appendAuthCodeParamToURLString:callbackURL.absoluteString];
    
    return [requestURLString hasPrefix:callbackWithAuthParam];
}

- (NSString *)authCodeFromRequest:(NSURLRequest *)request withCallbackURL:(NSURL *)callbackURL
{
    NSString *requestURLString = request.URL.absoluteString;
    NSString *callbackWithAuthParam = [self appendAuthCodeParamToURLString:callbackURL.absoluteString];
    
    return [requestURLString substringFromIndex:[callbackWithAuthParam length]];
}

#pragma mark - Private Methods

- (NSString *)appendAuthCodeParamToURLString:(NSString *)urlString
{
    return [NSString stringWithFormat:@"%@%@", urlString, InstagramAuthCodeParam];
}

@end
