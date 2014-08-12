#import "InstagramSimpleOAuthViewController.h"


NSString *const INSTAGRAM_AUTH_URL = @"https://api.instagram.com";
NSString *const INSTAGRAM_AUTH_CLIENT_ID_ENDPOINT = @"/oauth/authorize/?client_id=";
NSString *const INSTAGRAM_AUTH_REDIRECT_PARAMS = @"&client=touch&redirect_uri=";
NSString *const INSTAGRAM_AUTH_RESPONSE_TYPE_PARAMS = @"&response_type=code";

@interface InstagramSimpleOAuthViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *instagramWebView;

@end

@implementation InstagramSimpleOAuthViewController

#pragma mark - Init Methods

- (instancetype)initWithClientID:(NSString *)clientID
                    clientSecret:(NSString *)clientSecret
                     callbackURL:(NSURL *)callbackURL
                      completion:(void (^)(NSString *authToken))completion
{
    self = [super init];
    if (self) {
        self.clientID = clientID;
        self.clientSecret = clientSecret;
        self.callbackURL = callbackURL;
        self.completion = completion;
    }
    return self;
}

- (instancetype)init
{
    return [self initWithClientID:nil
                     clientSecret:nil
                      callbackURL:nil
                       completion:nil];
}

#pragma mark - View Lifecycle

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self loadInstagramLogin];
}

#pragma mark - <UIWebViewDelegate>

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
//    let requestURLString = request.URL.absoluteString
//    println(requestURLString)
//    
//    if (requestURLString.hasPrefix(INSTAGRAM_CALLBACK_AUTH_CODE_URL)) {
    
    NSString *requestURLString = request.URL.absoluteString;
    NSString *expectedInstagramCallbackPrefix = [NSString stringWithFormat:@"%@/?code=", self.callbackURL.absoluteString];
    
    if ([requestURLString hasPrefix:expectedInstagramCallbackPrefix]) {
        return NO;
    }
    
    return YES;
}

#pragma mark - Private Methods

- (void)loadInstagramLogin
{
    NSString *fullInstagramLoginURLString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                                             INSTAGRAM_AUTH_URL,
                                             INSTAGRAM_AUTH_CLIENT_ID_ENDPOINT,
                                             self.clientID,
                                             INSTAGRAM_AUTH_REDIRECT_PARAMS,
                                             self.callbackURL,
                                             INSTAGRAM_AUTH_RESPONSE_TYPE_PARAMS];
    
    NSURL *fullInstagramLoginURL = [NSURL URLWithString:fullInstagramLoginURLString];
    NSURLRequest *fullInstagramLoginRequest = [NSURLRequest requestWithURL:fullInstagramLoginURL];
    [self.instagramWebView loadRequest:fullInstagramLoginRequest];
}

@end
