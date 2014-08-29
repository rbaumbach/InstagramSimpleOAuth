#import <Specta/Specta.h>
#import <Swizzlean/Swizzlean.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "NSLayoutConstraint+TestUtils.h"
#import "UIAlertView+TestUtils.h"
#import "FakeAFHTTPSessionManager.h"
#import "FakeInstagramAuthResponse.h"
#import "InstagramSimpleOAuth.h"
#import "InstagramLoginUtils.h"
#import "InstagramLoginmanager.h"
#import "FakeInstagramLoginManager.h"


@interface InstagramSimpleOAuthViewController () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *instagramWebView;
@property (strong, nonatomic) InstagramLoginManager *loginManager;
@property (strong, nonatomic) InstagramLoginUtils *instagramLoginUtils;
@end

SpecBegin(InstagramSimpleOAuthViewControllerTests)

describe(@"InstagramSimpleOAuthViewController", ^{
    __block InstagramSimpleOAuthViewController *controller;
    __block id fakeLoginUtils;
    __block NSURL *callbackURL;
    __block InstagramLoginResponse *retLoginResponse;
    __block NSError *retError;
    
    beforeEach(^{
        callbackURL = [NSURL URLWithString:@"http://swizzlean.com"];
        controller = [[InstagramSimpleOAuthViewController alloc] initWithClientID:@"fancyID"
                                                                     clientSecret:@"12345"
                                                                      callbackURL:callbackURL
                                                                       completion:^(InstagramLoginResponse *response, NSError *error) {
                                                                           retLoginResponse = response;
                                                                           retError = error;
                                                                       }];
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
        expect(hasCompletionBlock).to.beTruthy();
    });
    
    it(@"has shouldShowErrorAlert flag that defaults to YES", ^{
        expect(controller.shouldShowErrorAlert).to.beTruthy();
    });
    
    it(@"conforms to <UIWebViewDelegate>", ^{
        BOOL conformsToWebViewDelegateProtocol = [controller conformsToProtocol:@protocol(UIWebViewDelegate)];
        expect(conformsToWebViewDelegateProtocol).to.equal(YES);
    });
    
    it(@"has an InstagramLoginManager", ^{
        expect(controller.loginManager).to.beInstanceOf([InstagramLoginManager class]);
        expect(controller.loginManager.clientID).to.equal(@"fancyID");
        expect(controller.loginManager.clientSecret).to.equal(@"12345");
        expect(controller.loginManager.callbackURL).to.equal(controller.callbackURL);
    });
    
    it(@"has an InstagramLoginUtils", ^{
        expect(controller.instagramLoginUtils).to.beInstanceOf([InstagramLoginUtils class]);
        expect(controller.instagramLoginUtils.clientID).to.equal(@"fancyID");
        expect(controller.instagramLoginUtils.callbackURL).to.equal(callbackURL);
    });
    
    describe(@"#viewDidAppear", ^{
        __block Swizzlean *superSwizz;
        __block BOOL isSuperCalled;
        __block BOOL retAnimated;
        __block UIWebView *fakeWebView;
        __block id fakeLoginRequest;
        
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
            
            fakeLoginRequest = OCMClassMock([NSURLRequest class]);
            
            fakeLoginUtils = OCMClassMock([InstagramLoginUtils class]);
            controller.instagramLoginUtils = fakeLoginUtils;
            OCMStub([controller.instagramLoginUtils buildLoginRequest]).andReturn(fakeLoginRequest);
            

            [controller viewDidAppear:YES];
        });
        
        it(@"calls super!!! Thanks for asking!!! =)", ^{
            expect(retAnimated).to.beTruthy();
            expect(isSuperCalled).to.beTruthy();
        });
        
        describe(@"instagramWebView", ^{
            it(@"loads the login using the login request", ^{
                OCMVerify([fakeWebView loadRequest:fakeLoginRequest]);
            });
        });
    });
    
    describe(@"<UIWebViewDelegate>", ^{
        describe(@"#webView:shouldStartLoadWithRequest:navigationType:", ^{
            __block id hudClassMethodMock;
            __block BOOL shouldStartLoad;
            __block id fakeURLRequest;
            __block FakeInstagramLoginManager *fakeLoginManager;
            
            beforeEach(^{
                hudClassMethodMock = OCMClassMock([MBProgressHUD class]);
            });
                
            context(@"request contains instagram callback URL as the URL Prefix with code param", ^{
                beforeEach(^{
                    fakeURLRequest = OCMClassMock([NSURLRequest class]);
                    
                    fakeLoginUtils = OCMClassMock([InstagramLoginUtils class]);
                    controller.instagramLoginUtils = fakeLoginUtils;
                    OCMStub([controller.instagramLoginUtils requestHasAuthCode:fakeURLRequest]).andReturn(YES);
                    OCMStub([controller.instagramLoginUtils authCodeFromRequest:fakeURLRequest]).andReturn(@"authorization-Picard-four-seven-alpha-tango");
                    
                    fakeLoginManager = [[FakeInstagramLoginManager alloc] init];
                    controller.loginManager = fakeLoginManager;
                    
                    shouldStartLoad = [controller webView:nil
                               shouldStartLoadWithRequest:fakeURLRequest
                                           navigationType:UIWebViewNavigationTypeFormSubmitted];
                });
                
                it(@"displays Progress HUD", ^{
                    OCMVerify([hudClassMethodMock showHUDAddedTo:controller.view animated:YES]);
                });
                
                it(@"attempts to authenticate with instagram with authCode", ^{
                    expect(fakeLoginManager.authCode).to.equal(@"authorization-Picard-four-seven-alpha-tango");
                });
                
                context(@"successfully gets auth token from Instagram", ^{
                    __block id partialMock;
                    __block id fakeInstagramLoginResponse;
                    
                    beforeEach(^{
                        fakeInstagramLoginResponse = OCMClassMock([InstagramLoginResponse class]);
                    });

                    context(@"has a navigation controlller", ^{
                        beforeEach(^{
                            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
                            partialMock = OCMPartialMock(navigationController);
                            
                            if (fakeLoginManager.success) {
                                fakeLoginManager.success(fakeInstagramLoginResponse);
                            }
                        });
                        
                        it(@"calls completion with instagram login response", ^{
                            expect(retLoginResponse).to.equal(fakeInstagramLoginResponse);
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
                            
                            if (fakeLoginManager.success) {
                                fakeLoginManager.success(fakeInstagramLoginResponse);
                            }
                        });
                        
                        it(@"calls completion with instagram login response", ^{
                            expect(retLoginResponse).to.equal(fakeInstagramLoginResponse);
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
                        bogusError = [[NSError alloc] initWithDomain:@"bogusDomain" code:177 userInfo:@{ @"NSLocalizedDescription" : @"boooogussss"}];
                    });
                    
                    context(@"shouldShowErrorAlert == YES", ^{
                        beforeEach(^{
                            controller.shouldShowErrorAlert = YES;
                            [controller webView:nil didFailLoadWithError:bogusError];
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
                            [controller webView:nil didFailLoadWithError:bogusError];
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
                            
                            if (fakeLoginManager.failure) {
                                fakeLoginManager.failure(bogusError);
                            }
                        });
                        
                        it(@"calls completion with nil token", ^{
                            expect(retLoginResponse).to.beNil();
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
                            
                            if (fakeLoginManager.failure) {
                                fakeLoginManager.failure(bogusError);
                            }
                        });
                        
                        it(@"calls completion with nil token", ^{
                            expect(retLoginResponse).to.beNil();
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
                    expect(shouldStartLoad).to.beFalsy();
                });
            });
            
            context(@"request does NOT contain instagram callback URL", ^{
                beforeEach(^{
                    fakeURLRequest = OCMClassMock([NSURLRequest class]);

                    fakeLoginUtils = OCMClassMock([InstagramLoginUtils class]);
                    controller.instagramLoginUtils = fakeLoginUtils;
                    OCMStub([controller.instagramLoginUtils requestHasAuthCode:fakeURLRequest]).andReturn(NO);
                    
                    shouldStartLoad = [controller webView:nil
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
                    bogusRequestError = [NSError errorWithDomain:@"NSURLBlowUpDomain"
                                                            code:42
                                                        userInfo:@{ @"NSLocalizedDescription" : @"You have no internetz"}];
                });
                
                context(@"shouldShowErrorAlert == YES", ^{
                    beforeEach(^{
                        controller.shouldShowErrorAlert = YES;
                        [controller webView:nil didFailLoadWithError:bogusRequestError];
                    });
                    
                    it(@"displays a UIAlertView with proper error", ^{
                        UIAlertView *errorAlert = [UIAlertView currentAlertView];
                        expect(errorAlert.title).to.equal(@"Instagram Login Error");
                        expect(errorAlert.message).to.equal(@"NSURLBlowUpDomain - You have no internetz");
                    });
                });
                
                context(@"shouldShowErrorAlert == NO", ^{
                    beforeEach(^{
                        controller.shouldShowErrorAlert = NO;
                        [controller webView:nil didFailLoadWithError:bogusRequestError];
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
                        
                        [controller webView:nil didFailLoadWithError:bogusRequestError];
                    });
                    
                    it(@"calls completion with nil token", ^{
                        expect(retLoginResponse).to.beNil();
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
                    
                    it(@"calls completion with nil token", ^{
                        expect(retLoginResponse).to.beNil();
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
