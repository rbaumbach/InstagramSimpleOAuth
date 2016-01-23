#import <Expecta/Expecta.h>
#import <Specta/Specta.h>
#import <Swizzlean/Swizzlean.h>
#import <OCMock/OCMock.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <SimpleOAuth2/SimpleOAuth2.h>
#import "UIAlertView+TestUtils.h"
#import "FakeInstagramAuthenticationManager.h"
#import "InstagramSimpleOAuth.h"
#import "InstagramTokenParameters.h"
#import "FakeInstagramOAuthResponse.h"
#import "InstagramAuthenticatioNManager.h"


@interface InstagramSimpleOAuthViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *instagramWebView;
@property (strong, nonatomic) InstagramAuthenticationManager *instagramAuthenticationManager;

@end

@interface InstagramAuthenticationManager ()

@property (copy, nonatomic) NSString *clientID;
@property (copy, nonatomic) NSString *clientSecret;
@property (copy, nonatomic) NSString *callbackURLString;

@end

SpecBegin(InstagramSimpleOAuthViewControllerTests)

describe(@"InstagramSimpleOAuthViewController", ^{
    __block InstagramSimpleOAuthViewController *controller;
    __block InstagramLoginResponse *retLoginResponse;
    __block NSError *retError;
    
    __block id fakeWebView;
    
    beforeEach(^{
        fakeWebView = OCMClassMock([UIWebView class]);
        
        controller = [[InstagramSimpleOAuthViewController alloc] initWithClientID:@"They-call-me-number-two"
                                                                     clientSecret:@"beans"
                                                                      callbackURL:[NSURL URLWithString:@"http://Delta-Tau-Chi.ios"]
                                                                       completion:^(InstagramLoginResponse *response, NSError *error) {
                                                                           retLoginResponse = response;
                                                                           retError = error;
                                                                       }];
    });
    
    afterEach(^{
        [UIAlertView reset];
    });
    
    describe(@"init", ^{
        it(@"calls -initWithClientID:clientSecret:callbackURL:completion: with nil parameters", ^{
            InstagramSimpleOAuthViewController *basicController = [[InstagramSimpleOAuthViewController alloc] init];
            expect(basicController.clientID).to.beNil;
            expect(basicController.clientSecret).to.beNil;
            expect(basicController.callbackURL).to.beNil;
            expect(basicController.completion).to.beNil;
        });
    });
    
    it(@"has a clientID", ^{
        expect(controller.clientID).to.equal(@"They-call-me-number-two");
    });
    
    it(@"has a client secret", ^{
        expect(controller.clientSecret).to.equal(@"beans");
    });
    
    it(@"has a callbackURL", ^{
        expect(controller.callbackURL).to.equal([NSURL URLWithString:@"http://Delta-Tau-Chi.ios"]);
    });
    
    it(@"has a completion block", ^{
        BOOL hasCompletionBlock = NO;
        if (controller.completion) {
            hasCompletionBlock = YES;
        }
        expect(hasCompletionBlock).to.beTruthy();
    });
    
    it(@"has shouldShowErrorAlert flag that defaults to YES", ^{
        expect(controller.shouldShowErrorAlert).to.beTruthy();
    });
    
    it(@"conforms to <UIWebViewDelegate>", ^{
        BOOL conformsToWebViewDelegateProtocol = [controller conformsToProtocol:@protocol(UIWebViewDelegate)];
        expect(conformsToWebViewDelegateProtocol).to.equal(YES);
    });
    
    it(@"has a InstagramAuthenticationManager", ^{
        expect(controller.instagramAuthenticationManager).to.beInstanceOf([InstagramAuthenticationManager class]);
        expect(controller.instagramAuthenticationManager.clientID).to.equal(@"They-call-me-number-two");
        expect(controller.instagramAuthenticationManager.clientSecret).to.equal(@"beans");
        expect(controller.instagramAuthenticationManager.callbackURLString).to.equal(@"http://Delta-Tau-Chi.ios");
    });
    
    describe(@"#viewDidAppear", ^{
        __block Swizzlean *superSwizz;
        __block BOOL isSuperCalled;
        __block BOOL retAnimated;
        __block id hudClassMethodMock;
        __block id fakeLoginRequest;
        
        beforeEach(^{
            isSuperCalled = NO;
            superSwizz = [[Swizzlean alloc] initWithClassToSwizzle:[UIViewController class]];
            [superSwizz swizzleInstanceMethod:@selector(viewDidAppear:) withReplacementImplementation:^(id _self, BOOL isAnimated) {
                isSuperCalled = YES;
                retAnimated = isAnimated;
            }];
            
            [controller view];
            
            hudClassMethodMock = OCMClassMock([MBProgressHUD class]);
            
            controller.instagramWebView = fakeWebView;
            controller.permissionScope = @[@"stuff", @"more-stuff", @"lot-o-stuff"];
            
            fakeLoginRequest = OCMClassMock([NSURLRequest class]);
            NSURL *expectedLoginURL = [NSURL URLWithString:@"https://api.instagram.com/oauth/authorize?client_id=They-call-me-number-two&response_type=code&client=touch&redirect_uri=http://Delta-Tau-Chi.ios"];
            OCMStub(ClassMethod([fakeLoginRequest buildWebLoginRequestWithURL:expectedLoginURL permissionScope:controller.permissionScope])).andReturn(fakeLoginRequest);
            
            [controller viewDidAppear:YES];
        });
        
        it(@"calls super!!! Thanks for asking!!! =)", ^{
            expect(retAnimated).to.beTruthy();
            expect(isSuperCalled).to.beTruthy();
        });
        
        it(@"displays Progress HUD", ^{
            OCMVerify([hudClassMethodMock showHUDAddedTo:controller.view animated:YES]);
        });
        
        it(@"loads the login using the login request", ^{
            OCMVerify([fakeWebView loadRequest:fakeLoginRequest]);
        });
    });
    
    describe(@"<UIWebViewDelegate>", ^{
        describe(@"#webView:shouldStartLoadWithRequest:navigationType:", ^{
            __block id hudClassMethodMock;
            __block BOOL shouldStartLoad;
            __block id fakeURLRequest;
            __block FakeInstagramAuthenticationManager *fakeAuthManager;
            
            beforeEach(^{
                hudClassMethodMock = OCMClassMock([MBProgressHUD class]);
            });
            
            context(@"request contains Instagram callback URL as the URL Prefix with code param", ^{
                beforeEach(^{
                    fakeURLRequest = OCMClassMock([NSURLRequest class]);
                    OCMStub([fakeURLRequest oAuth2AuthorizationCode]).andReturn(@"authorization-sir");
                    
                    fakeAuthManager = [[FakeInstagramAuthenticationManager alloc] init];
                    controller.instagramAuthenticationManager = fakeAuthManager;
                    
                    shouldStartLoad = [controller webView:fakeWebView
                               shouldStartLoadWithRequest:fakeURLRequest
                                           navigationType:UIWebViewNavigationTypeFormSubmitted];
                });
                
                it(@"attempts to authenticate with instagram with authCode", ^{
                    expect(fakeAuthManager.authCode).to.equal(@"authorization-sir");
                });
                
                context(@"successfully gets auth token from Instagram", ^{
                    __block id partialMock;
                    __block id fakeInstagramResponse;
                    
                    beforeEach(^{
                        fakeInstagramResponse = OCMClassMock([InstagramLoginResponse class]);
                    });
                    
                    context(@"has a navigation controlller", ^{
                        beforeEach(^{
                            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
                            partialMock = OCMPartialMock(navigationController);
                            
                            if (fakeAuthManager.success) {
                                fakeAuthManager.success(fakeInstagramResponse);
                            }
                        });
                        
                        it(@"pops itself off the navigation controller", ^{
                            OCMVerify([partialMock popViewControllerAnimated:YES]);
                        });
                        
                        it(@"removes the progress HUD", ^{
                            OCMVerify([hudClassMethodMock hideHUDForView:controller.view
                                                                animated:YES]);
                        });
                        
                        it(@"calls completion with Instagram login response", ^{
                            expect(retLoginResponse).to.equal(fakeInstagramResponse);
                        });
                    });
                    
                    context(@"does NOT have a navigation controller", ^{
                        beforeEach(^{
                            partialMock = OCMPartialMock(controller);
                            
                            if (fakeAuthManager.success) {
                                fakeAuthManager.success(fakeInstagramResponse);
                            }
                        });
                        
                        it(@"pops itself off the navigation controller", ^{
                            OCMVerify([partialMock dismissViewControllerAnimated:YES completion:nil]);
                        });
                        
                        it(@"removes the progress HUD", ^{
                            OCMVerify([hudClassMethodMock hideHUDForView:controller.view
                                                                animated:YES]);
                        });
                        
                        it(@"calls completion with Instagram login response", ^{
                            expect(retLoginResponse).to.equal(fakeInstagramResponse);
                        });
                    });
                });
                
                context(@"failure while attempting to get auth token from Instagram", ^{
                    __block id partialMock;
                    __block NSError *bogusError;
                    
                    beforeEach(^{
                        bogusError = [[NSError alloc] initWithDomain:@"bogusDomain"
                                                                code:177
                                                            userInfo:@{ @"NSLocalizedDescription" : @"boooogussss"}];
                    });
                    
                    context(@"shouldShowErrorAlert == YES", ^{
                        beforeEach(^{
                            controller.shouldShowErrorAlert = YES;
                            [controller webView:fakeWebView didFailLoadWithError:bogusError];
                        });
                        
                        it(@"displays a UIAlertView with proper error", ^{
                            UIAlertView *errorAlert = [UIAlertView currentAlertView];
                            expect(errorAlert.title).to.equal(@"Instagram Login Error");
                            expect(errorAlert.message).to.equal(@"bogusDomain - boooogussss");
                        });
                    });
                    
                    context(@"shouldShowErrorAlert == NO", ^{
                        beforeEach(^{
                            controller.shouldShowErrorAlert = NO;
                            [controller webView:fakeWebView didFailLoadWithError:bogusError];
                        });
                        
                        it(@"does not display alert view for the error", ^{
                            UIAlertView *errorAlert = [UIAlertView currentAlertView];
                            expect(errorAlert).to.beNil();
                        });
                    });
                    
                    context(@"has a navigation controlller", ^{
                        beforeEach(^{
                            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
                            partialMock = OCMPartialMock(navigationController);
                            
                            if (fakeAuthManager.failure) {
                                // This is here because the Expecta short hand methods #define "failure"
                                // #define failure(...) EXP_failure((__VA_ARGS__))
                                void(^authFailure)(NSError *error) = [fakeAuthManager.failure copy];
                                
                                authFailure(bogusError);
//                                fakeAuthManager.failure(bogusError);
                            }
                        });
                        
                        it(@"pops itself off the navigation controller", ^{
                            OCMVerify([partialMock popViewControllerAnimated:YES]);
                        });
                        
                        it(@"removes the progress HUD", ^{
                            OCMVerify([hudClassMethodMock hideHUDForView:controller.view
                                                                animated:YES]);
                        });
                        
                        it(@"calls completion with nil token", ^{
                            expect(retLoginResponse).to.beNil();
                        });
                        
                        it(@"calls completion with AFNetworking error", ^{
                            expect(retError).to.equal(bogusError);
                        });
                    });
                    
                    context(@"does NOT have a navigation controller", ^{
                        beforeEach(^{
                            partialMock = OCMPartialMock(controller);
                            
                            if (fakeAuthManager.failure) {
                                // This is here because the Expecta short hand methods #define "failure"
                                // #define failure(...) EXP_failure((__VA_ARGS__))
                                void(^authFailure)(NSError *error) = [fakeAuthManager.failure copy];
                                
                                authFailure(bogusError);
//                                
//                                fakeAuthManager.failure(bogusError);
                            }
                        });
                        
                        it(@"pops itself off the view controller", ^{
                            OCMVerify([partialMock dismissViewControllerAnimated:YES completion:nil]);
                        });
                        
                        it(@"removes the progress HUD", ^{
                            OCMVerify([hudClassMethodMock hideHUDForView:controller.view
                                                                animated:YES]);
                        });
                        
                        it(@"calls completion with nil token", ^{
                            expect(retLoginResponse).to.beNil();
                        });
                        
                        it(@"calls completion with AFNetworking error", ^{
                            expect(retError).to.equal(bogusError);
                        });
                    });
                });
                
                it(@"returns NO", ^{
                    expect(shouldStartLoad).to.beFalsy();
                });
            });
            
            context(@"request does NOT contain Instagram callback URL", ^{
                beforeEach(^{
                    fakeURLRequest = OCMClassMock([NSURLRequest class]);
                    OCMStub([fakeURLRequest oAuth2AuthorizationCode]).andReturn(nil);
                    
                    shouldStartLoad = [controller webView:fakeWebView
                               shouldStartLoadWithRequest:fakeURLRequest
                                           navigationType:UIWebViewNavigationTypeFormSubmitted];
                });
                
                it(@"returns YES", ^{
                    expect(shouldStartLoad).to.beTruthy();
                });
            });
        });
        
        describe(@"#webViewDidFinishLoad:", ^{
            __block id hudClassMethodMock;
            
            beforeEach(^{
                hudClassMethodMock = OCMClassMock([MBProgressHUD class]);
                [controller webViewDidFinishLoad:fakeWebView];
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
                                                        userInfo:@{ @"NSLocalizedDescription" : @"WTH Error" }];
                    
                    [controller webView:fakeWebView didFailLoadWithError:bogusRequestError];
                });
                
                it(@"does not display alert view for the error", ^{
                    UIAlertView *errorAlert = [UIAlertView currentAlertView];
                    expect(errorAlert).to.beNil();
                });
                
                it(@"removes the progress HUD", ^{
                    OCMVerify([hudClassMethodMock hideHUDForView:controller.view
                                                        animated:YES]);
                });
            });
            
            context(@"all other error codes", ^{
                __block id partialMock;
                
                beforeEach(^{
                    bogusRequestError = [NSError errorWithDomain:@"NSURLBlowUpDomainBOOM"
                                                            code:42
                                                        userInfo:@{ @"NSLocalizedDescription" : @"You have no internetz and what not"}];
                });
                
                context(@"shouldShowErrorAlert == YES", ^{
                    beforeEach(^{
                        controller.shouldShowErrorAlert = YES;
                        [controller webView:fakeWebView didFailLoadWithError:bogusRequestError];
                    });
                    
                    it(@"displays a UIAlertView with proper error", ^{
                        UIAlertView *errorAlert = [UIAlertView currentAlertView];
                        expect(errorAlert.title).to.equal(@"Instagram Login Error");
                        expect(errorAlert.message).to.equal(@"NSURLBlowUpDomainBOOM - You have no internetz and what not");
                    });
                });
                
                context(@"shouldShowErrorAlert == NO", ^{
                    beforeEach(^{
                        controller.shouldShowErrorAlert = NO;
                        [controller webView:fakeWebView didFailLoadWithError:bogusRequestError];
                    });
                    
                    it(@"does not display alert view for the error", ^{
                        UIAlertView *errorAlert = [UIAlertView currentAlertView];
                        expect(errorAlert).to.beNil();
                    });
                });
                
                context(@"has a navigation controlller", ^{
                    beforeEach(^{
                        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
                        partialMock = OCMPartialMock(navigationController);
                        
                        [controller webView:fakeWebView didFailLoadWithError:bogusRequestError];
                    });
                    
                    it(@"pops itself off the navigation controller", ^{
                        OCMVerify([partialMock popViewControllerAnimated:YES]);
                    });
                    
                    it(@"removes the progress HUD", ^{
                        OCMVerify([hudClassMethodMock hideHUDForView:controller.view
                                                            animated:YES]);
                    });
                    
                    it(@"calls completion with nil token", ^{
                        expect(retLoginResponse).to.beNil();
                    });
                    
                    it(@"calls completion with request error", ^{
                        expect(retError).to.equal(bogusRequestError);
                    });
                });
                
                context(@"does NOT have a navigation controller", ^{
                    beforeEach(^{
                        partialMock = OCMPartialMock(controller);
                        
                        [controller webView:fakeWebView didFailLoadWithError:bogusRequestError];
                    });
                    
                    it(@"pops itself off the view controller", ^{
                        OCMVerify([partialMock dismissViewControllerAnimated:YES completion:nil]);
                    });
                    
                    it(@"removes the progress HUD", ^{
                        OCMVerify([hudClassMethodMock hideHUDForView:controller.view
                                                            animated:YES]);
                    });
                    
                    it(@"calls completion with nil token", ^{
                        expect(retLoginResponse).to.beNil();
                    });
                    
                    it(@"calls completion with request error", ^{
                        expect(retError).to.equal(bogusRequestError);
                    });
                });
            });
        });
    });
});

SpecEnd
