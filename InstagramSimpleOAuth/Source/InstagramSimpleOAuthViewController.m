#import "InstagramSimpleOAuthViewController.h"


@interface InstagramSimpleOAuthViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *instagramWebView;

@property (strong, nonatomic, readwrite) NSString *clientID;
@property (strong, nonatomic, readwrite) NSString *clientSecret;
@property (strong, nonatomic, readwrite) NSURL *callbackURL;
@property (copy, nonatomic) void (^completion)(NSString *authToken);


@end

@implementation InstagramSimpleOAuthViewController

#pragma mark - Init Method

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
    @throw [NSException exceptionWithName:@"InstagramSimpleOAuth"
                                   reason:@"Cannot use -init:, use :initWithClientID:clientSecret:callbackURL:completion: instead"
                                 userInfo:nil];
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
}

@end
