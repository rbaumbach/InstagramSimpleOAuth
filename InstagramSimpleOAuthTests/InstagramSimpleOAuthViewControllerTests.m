#import <Specta/Specta.h>
#import <Swizzlean/Swizzlean.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <AFNetworking/AFNetworking.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "InstagramSimpleOAuthViewController.h"
#import "NSLayoutConstraint+TestUtils.h"
#import "UIAlertView+TestUtils.h"
#import "FakeAFHTTPSessionManager.h"

#define INSTAGRAM_AUTH_URL = @"https://api.instagram.com";


@interface InstagramSimpleOAuthViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *instagramWebView;
@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;

@end

SpecBegin(InstagramSimpleOAuthViewControllerTests)

describe(@"InstagramSimpleOAuthViewController", ^{
    __block InstagramSimpleOAuthViewController *controller;
    __block NSURL *callbackURL;
    __block NSString *retAuthToken;
    __block NSError *retError;
    
    beforeEach(^{
        callbackURL = [NSURL URLWithString:@"http://swizzlean.com"];
        controller = [[InstagramSimpleOAuthViewController alloc] initWithClientID:@"fancyID"
                                                                     clientSecret:@"12345"
                                                                      callbackURL:callbackURL
                                                                       completion:^(NSString *authToken, NSError *error) {
                                                                           retAuthToken = authToken;
                                                                           retError = error;
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
    
    it(@"has an AFHTTPSessionManager", ^{
        expect(controller.sessionManager).to.beInstanceOf([AFHTTPSessionManager class]);
        expect(controller.sessionManager.baseURL).to.equal([NSURL URLWithString:@"https://api.instagram.com"]);
        expect(controller.sessionManager.responseSerializer).to.beInstanceOf([AFJSONResponseSerializer class]);
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
            
            fakeWebView = OCMClassMock([UIWebView class]);
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
                    
                    OCMVerify([fakeWebView loadRequest:instagramURLRequest]);
                });
            });
        });
    });
    
    describe(@"<UIWebViewDelegate>", ^{
        describe(@"#webView:shouldStartLoadWithRequest:navigationType:", ^{
            __block id hudClassMethodMock;
            __block BOOL shouldStartLoad;
            __block NSURLRequest *urlRequest;
            __block FakeAFHTTPSessionManager *fakeSessionManager;
            
            beforeEach(^{
                hudClassMethodMock = OCMClassMock([MBProgressHUD class]);
            });
                
            context(@"request contains instagram callback URL as the URL Prefix with code param", ^{
                beforeEach(^{
                    NSString *callbackURLString = [NSString stringWithFormat:@"%@/?code=%@", controller.callbackURL, @"authorization-Picard-four-seven-alpha-tango"];
                    NSURL *callbackURL = [NSURL URLWithString:callbackURLString];
                    urlRequest = [NSURLRequest requestWithURL:callbackURL];
                    
                    fakeSessionManager = [[FakeAFHTTPSessionManager alloc] init];
                    controller.sessionManager = fakeSessionManager;
                    shouldStartLoad = [controller webView:nil
                               shouldStartLoadWithRequest:urlRequest
                                           navigationType:UIWebViewNavigationTypeFormSubmitted];
                });
                
                it(@"displays Progress HUD", ^{
                    OCMVerify([hudClassMethodMock showHUDAddedTo:controller.view animated:YES]);
                });
                
                it(@"makes a POST call with the correct endpoint and parameters to Instagram", ^{
                    expect(fakeSessionManager.postURLString).to.equal(@"/oauth/access_token/");
                    expect(fakeSessionManager.parameters).to.equal(@{ @"client_id"     : controller.clientID,
                                                                      @"client_secret" : controller.clientSecret,
                                                                      @"grant_type"    : @"authorization_code",
                                                                      @"redirect_uri"  : controller.callbackURL.absoluteString,
                                                                      @"code"          : @"authorization-Picard-four-seven-alpha-tango" });
                });
                
                context(@"successfully gets auth token from Instagram", ^{
                    __block id partialMock;
                    
                    context(@"has a navigation controlller", ^{
                        beforeEach(^{
                            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
                            partialMock = OCMPartialMock(navigationController);
                            
                            if (fakeSessionManager.success) {
                                fakeSessionManager.success(nil, @{ @"access_token" : @"12345IdiotLuggageCombo" });
                            }
                        });
                        
                        it(@"calls completion with authToken", ^{
                            expect(retAuthToken).to.equal(@"12345IdiotLuggageCombo");
                        });
                        
                        it(@"pops itself off the navigation controller", ^{
                            OCMVerify([partialMock popViewControllerAnimated:YES]);
                        });
                        
                        it(@"removes the progress HUD", ^{
                            OCMVerify([hudClassMethodMock hideHUDForView:controller.view
                                                                animated:YES]);
                        });
                    });
                    
                    context(@"does NOT have a navigation controller", ^{
                        beforeEach(^{
                            partialMock = OCMPartialMock(controller);
                            
                            if (fakeSessionManager.success) {
                                fakeSessionManager.success(nil, @{ @"access_token" : @"12345IdiotLuggageCombo" });
                            }
                        });
                        
                        it(@"calls completion with authToken", ^{
                            expect(retAuthToken).to.equal(@"12345IdiotLuggageCombo");
                        });
                        
                        it(@"pops itself off the navigation controller", ^{
                            OCMVerify([partialMock dismissViewControllerAnimated:YES completion:nil]);
                        });
                        
                        it(@"removes the progress HUD", ^{
                            OCMVerify([hudClassMethodMock hideHUDForView:controller.view
                                                                animated:YES]);
                        });
                    });
                });
                
                context(@"failure while attempting to get auth token from Instagram", ^{
                    __block id partialMock;
                    __block NSError *bogusError;
                    
                    beforeEach(^{
                        bogusError = [[NSError alloc] initWithDomain:@"bogusDomain" code:177 userInfo:nil];
                    });
                    
                    context(@"has a navigation controlller", ^{
                        beforeEach(^{
                            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
                            partialMock = OCMPartialMock(navigationController);
                            
                            if (fakeSessionManager.failure) {
                                fakeSessionManager.failure(nil, bogusError);
                            }
                        });
                        
                        it(@"calls completion with nil token", ^{
                            expect(retAuthToken).to.equal(nil);
                        });
                        
                        it(@"calls completion with AFNetworking error", ^{
                            expect(retError).to.equal(bogusError);
                        });
                        
                        it(@"pops itself off the navigation controller", ^{
                            OCMVerify([partialMock popViewControllerAnimated:YES]);
                        });
                        
                        it(@"removes the progress HUD", ^{
                            OCMVerify([hudClassMethodMock hideHUDForView:controller.view
                                                                animated:YES]);
                        });
                    });
                    
                    context(@"does NOT have a navigation controller", ^{
                        beforeEach(^{
                            partialMock = OCMPartialMock(controller);
                            
                            if (fakeSessionManager.failure) {
                                fakeSessionManager.failure(nil, bogusError);
                            }
                        });
                        
                        it(@"calls success with nil token", ^{
                            expect(retAuthToken).to.equal(nil);
                        });

                        it(@"calls completion with AFNetworking error", ^{
                            expect(retError).to.equal(bogusError);
                        });
                        
                        it(@"pops itself off the view controller", ^{
                            OCMVerify([partialMock dismissViewControllerAnimated:YES completion:nil]);
                        });
                        
                        it(@"removes the progress HUD", ^{
                            OCMVerify([hudClassMethodMock hideHUDForView:controller.view
                                                                animated:YES]);
                        });
                    });
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
                
                it(@"displays Progress HUD", ^{
                    OCMVerify([hudClassMethodMock showHUDAddedTo:controller.view animated:YES]);
                });
                
                it(@"returns YES", ^{
                    expect(shouldStartLoad).to.equal(YES);
                });
            });
        });
        
        describe(@"#webViewDidFinishLoad:", ^{
            __block id hudClassMethodMock;
            
            beforeEach(^{
                hudClassMethodMock = OCMClassMock([MBProgressHUD class]);
                [controller webViewDidFinishLoad:nil];
            });
            
            it(@"removes the progress HUD", ^{
                OCMVerify([hudClassMethodMock hideHUDForView:controller.view
                                                    animated:YES]);
            });
        });
        
        describe(@"#webView:didFailLoadWithError:", ^{
            __block id hudClassMethodMock;
            __block NSError *bogusRequestError;
            
            beforeEach(^{
                hudClassMethodMock = OCMClassMock([MBProgressHUD class]);
            });

            context(@"error code 102 (WebKitErrorDomain)", ^{
                beforeEach(^{
                    bogusRequestError = [NSError errorWithDomain:@"LameWebKitErrorThatHappensForNoGoodReason"
                                                            code:102
                                                        userInfo:@{ @"NSLocalizedDescription" : @"WTF Error"}];
                    
                    [controller webView:nil didFailLoadWithError:bogusRequestError];
                });
                
                it(@"does not display alert view for the error", ^{
                    UIAlertView *errorAlert = [UIAlertView currentAlertView];
                    expect(errorAlert).to.equal(nil);
                });
                
                it(@"removes the progress HUD", ^{
                    OCMVerify([hudClassMethodMock hideHUDForView:controller.view
                                                        animated:YES]);
                });
            });
            
            context(@"all other error codes", ^{
                __block id partialMock;

                beforeEach(^{
                    bogusRequestError = [NSError errorWithDomain:@"NSURLBlowUpDomain"
                                                            code:42
                                                        userInfo:@{ @"NSLocalizedDescription" : @"You have no internetz"}];
                });
                
                context(@"has a navigation controlller", ^{
                    beforeEach(^{
                        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
                        partialMock = OCMPartialMock(navigationController);
                        
                        [controller webView:nil didFailLoadWithError:bogusRequestError];
                    });
                    
                    it(@"displays a UIAlertView with proper error", ^{
                        UIAlertView *errorAlert = [UIAlertView currentAlertView];
                        expect(errorAlert.title).to.equal(@"Load Request Error");
                        expect(errorAlert.message).to.equal(@"NSURLBlowUpDomain - You have no internetz");
                    });
                    
                    it(@"calls completion with nil token", ^{
                        expect(retAuthToken).to.equal(nil);
                    });
                    
                    it(@"calls completion with request error", ^{
                        expect(retError).to.equal(bogusRequestError);
                    });
                    
                    it(@"pops itself off the navigation controller", ^{
                        OCMVerify([partialMock popViewControllerAnimated:YES]);
                    });
                    
                    it(@"removes the progress HUD", ^{
                        OCMVerify([hudClassMethodMock hideHUDForView:controller.view
                                                            animated:YES]);
                    });
                });
                
                context(@"does NOT have a navigation controller", ^{
                    beforeEach(^{
                        partialMock = OCMPartialMock(controller);
                        
                        [controller webView:nil didFailLoadWithError:bogusRequestError];
                    });
                    
                    it(@"displays a UIAlertView with proper error", ^{
                        UIAlertView *errorAlert = [UIAlertView currentAlertView];
                        expect(errorAlert.title).to.equal(@"Load Request Error");
                        expect(errorAlert.message).to.equal(@"NSURLBlowUpDomain - You have no internetz");
                    });
                    
                    it(@"calls completion with nil token", ^{
                        expect(retAuthToken).to.equal(nil);
                    });
                    
                    it(@"calls completion with request error", ^{
                        expect(retError).to.equal(bogusRequestError);
                    });
                    
                    it(@"pops itself off the view controller", ^{
                        OCMVerify([partialMock dismissViewControllerAnimated:YES completion:nil]);
                    });
                    
                    it(@"removes the progress HUD", ^{
                        OCMVerify([hudClassMethodMock hideHUDForView:controller.view
                                                            animated:YES]);
                    });
                });
            });
        });
    });
});

SpecEnd
