#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import "InstagramSimpleOAuthViewController.h"

@interface InstagramSimpleOAuthViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *instagramWebView;

@property (strong, nonatomic, readwrite) NSString *clientID;
@property (strong, nonatomic, readwrite) NSString *clientSecret;
@property (strong, nonatomic, readwrite) NSURL *callbackURL;
@property (copy, nonatomic) void (^completion)(NSString *authToken);

@end

SpecBegin(InstagramSimpleOAuthViewControllerTests)

describe(@"InstagramSimpleOAuthViewController", ^{
    __block InstagramSimpleOAuthViewController *controller;
    __block NSURL *callbackURL;
    __block NSString *retAuthToken;
    
    beforeEach(^{
        callbackURL = [NSURL URLWithString:@"http://swizzlean.com"];
        controller = [[InstagramSimpleOAuthViewController alloc] initWithClientID:@"fancyID"
                                                                     clientSecret:@"12345"
                                                                      callbackURL:callbackURL
                                                                       completion:^(NSString *authToken) {
                                                                           retAuthToken = authToken;
                                                                       }];
    });
    
    it(@"throws exception when -init is called", ^{
        __block InstagramSimpleOAuthViewController *exceptionController;
        
        expect(^{
            @try {
                exceptionController = [[InstagramSimpleOAuthViewController alloc] init];
            } @catch (NSException *ex) {
                // check exception to see if it contains all the right data
                // if it does, re-throw for the test to pass
                if ([ex.name isEqualToString:@"InstagramSimpleOAuth"] &&
                    [ex.reason isEqualToString:@"Cannot use -init:, use :initWithClientID:clientSecret:callbackURL:completion: instead"] &&
                    !ex.userInfo) {
                    @throw ex;
                }
            }
        }).to.raise(@"InstagramSimpleOAuth");
    });
    
    it(@"has a clientID", ^{
        expect(controller.clientID).to.equal(@"fancyID");
    });
    
    it(@"has a clientSecet", ^{
        expect(controller.clientSecret).to.equal(@"12345");
    });
    
    it(@"has a callbackURL", ^{
        expect(controller.callbackURL).to.equal([NSURL URLWithString:@"http://swizzlean.com"]);
    });
    
    it(@"has a completion block", ^{
        BOOL hasCompletionBlock = NO;
        if (controller.completion) {
            hasCompletionBlock = YES;
        }
        expect(hasCompletionBlock).to.equal(YES);
    });
    
    it(@"conforms to <UIWebView>", ^{
        BOOL conformsToWebViewDelegateProtocol = [controller conformsToProtocol:@protocol(UIWebViewDelegate)];
        expect(conformsToWebViewDelegateProtocol).to.equal(YES);
    });
    
    describe(@"#viewDidLoad", ^{
        beforeEach(^{
            [controller view];
        });
    });
    
    describe(@"<UIWebViewDelegate>", ^{
        describe(@"#webView:shouldStartLoadWithRequest:navigationType:", ^{
        });
    });
});

SpecEnd
