#import <Specta/Specta.h>
#import <Swizzlean/Swizzlean.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>
#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>
#import "InstagramSimpleOAuthViewController.h"
#import "NSLayoutConstraint+TestUtils.h"
#import "UIAlertView+TestUtils.h"


@interface InstagramSimpleOAuthViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *instagramWebView;

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
    
    describe(@"init", ^{
        it(@"calls -initWithClientID:clientSecret:callbackURL:completion:", ^{
            InstagramSimpleOAuthViewController *basicController = [[InstagramSimpleOAuthViewController alloc] init];
            expect(basicController.clientID).to.beNil;
            expect(basicController.clientSecret).to.beNil;
            expect(basicController.callbackURL).to.beNil;
            expect(basicController.completion).to.beNil;
        });
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
    
    it(@"conforms to <UIWebViewDelegate>", ^{
        BOOL conformsToWebViewDelegateProtocol = [controller conformsToProtocol:@protocol(UIWebViewDelegate)];
        expect(conformsToWebViewDelegateProtocol).to.equal(YES);
    });
    
    describe(@"#viewDidAppear", ^{
        __block Swizzlean *superSwizz;
        __block BOOL isSuperCalled;
        __block BOOL retAnimated;
        __block UIWebView *fakeWebView;
        
        beforeEach(^{
            isSuperCalled = NO;
            superSwizz = [[Swizzlean alloc] initWithClassToSwizzle:[UIViewController class]];
            [superSwizz swizzleInstanceMethod:@selector(viewDidAppear:) withReplacementImplementation:^(id _self, BOOL isAnimated) {
                isSuperCalled = YES;
                retAnimated = isAnimated;
            }];
            
            [controller view];
            
            fakeWebView = mock([UIWebView class]);
            controller.instagramWebView = fakeWebView;
            
            [controller viewDidAppear:YES];
        });
        
        it(@"calls super!!! Thanks for asking!!! =)", ^{
            expect(retAnimated).to.equal(YES);
            expect(isSuperCalled).to.equal(YES);
        });
        
        describe(@"instagramWebView", ^{
            context(@"has clientID, clientSecret, callbackURL", ^{
                it(@"loads the Instagram login page", ^{
                    NSString *instagramLoginURLString = [NSString stringWithFormat:@"https://api.instagram.com/oauth/authorize/?client_id=%@&client=touch&redirect_uri=%@&response_type=code",
                                                         controller.clientID, controller.callbackURL.absoluteString];
                    NSURL *instagramLoginURL = [NSURL URLWithString:instagramLoginURLString];
                    NSURLRequest *instagramURLRequest = [NSURLRequest requestWithURL:instagramLoginURL];
                    
                    [verify(controller.instagramWebView) loadRequest:instagramURLRequest];
                });
            });
        });
    });
    
    describe(@"<UIWebViewDelegate>", ^{
        describe(@"#webView:shouldStartLoadWithRequest:navigationType:", ^{
            __block BOOL shouldStartLoad;
            __block NSURLRequest *urlRequest;
            
            context(@"request contains instagram callback URL as the URL Prefix with code param", ^{
                beforeEach(^{
                    NSString *callbackURLString = [NSString stringWithFormat:@"%@/?code=", controller.callbackURL];
                    NSURL *callbackURL = [NSURL URLWithString:callbackURLString];
                    urlRequest = [NSURLRequest requestWithURL:callbackURL];
                    
                    shouldStartLoad = [controller webView:nil
                               shouldStartLoadWithRequest:urlRequest
                                           navigationType:UIWebViewNavigationTypeFormSubmitted];
                });
                
                it(@"returns NO", ^{
                    expect(shouldStartLoad).to.equal(NO);
                });
            });
            
            context(@"request does NOT contain instagram callback URL", ^{
                beforeEach(^{
                    urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://pumpkin.ale.bills.com"]];
                    shouldStartLoad = [controller webView:nil
                               shouldStartLoadWithRequest:urlRequest
                                           navigationType:UIWebViewNavigationTypeFormSubmitted];
                });
                
                it(@"returns YES", ^{
                    expect(shouldStartLoad).to.equal(YES);
                });
            });
        });
    });
});

SpecEnd
