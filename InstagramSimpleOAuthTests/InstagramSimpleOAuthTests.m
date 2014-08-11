#import <Specta/Specta.h>
#import <Swizzlean/Swizzlean.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import "InstagramSimpleOAuthViewController.h"
#import "NSLayoutConstraint+TestUtils.h"

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
    
    describe(@"constraints", ^{
        context(@"iPhone", ^{
            __block UIView *iPhoneView;
            
            beforeEach(^{
                NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"InstagramSimpleOAuthViewController"
                                                                  owner:controller
                                                                options:nil];
                
                iPhoneView = nibViews[0];
            });
            
            it(@"has at least 4 constraints", ^{
                expect(iPhoneView.constraints.count).to.beGreaterThanOrEqualTo(4);
            });
            
            it(@"has Vertical Space - instagramWebView to View", ^{
                NSLayoutConstraint *expectedConstraint = [NSLayoutConstraint constraintWithItem:controller.instagramWebView
                                                                              attribute:NSLayoutAttributeTop
                                                                              relatedBy:NSLayoutRelationEqual
                                                                                 toItem:controller.view
                                                                              attribute:NSLayoutAttributeTop
                                                                             multiplier:1
                                                                               constant:0];
                expectedConstraint.priority = 1000;
                expectedConstraint.shouldBeArchived = YES;
                
                expect(iPhoneView.constraints).to.contain(expectedConstraint);
            });
            
            it(@"has Horizontal Space - View to instagramWebView", ^{
                NSLayoutConstraint *expectedConstraint = [NSLayoutConstraint constraintWithItem:controller.view
                                                                                      attribute:NSLayoutAttributeTrailing
                                                                                      relatedBy:NSLayoutRelationEqual
                                                                                         toItem:controller.instagramWebView
                                                                                      attribute:NSLayoutAttributeTrailing
                                                                                     multiplier:1
                                                                                       constant:0];
                expectedConstraint.priority = 1000;
                expectedConstraint.shouldBeArchived = YES;
                
                expect(iPhoneView.constraints).to.contain(expectedConstraint);
            });
            
            it(@"has Vertical Space - View to instagramWebView", ^{
                NSLayoutConstraint *expectedConstraint = [NSLayoutConstraint constraintWithItem:controller.view
                                                                                      attribute:NSLayoutAttributeBottom
                                                                                      relatedBy:NSLayoutRelationEqual
                                                                                         toItem:controller.instagramWebView
                                                                                      attribute:NSLayoutAttributeBottom
                                                                                     multiplier:1
                                                                                       constant:0];
                expectedConstraint.priority = 1000;
                expectedConstraint.shouldBeArchived = YES;
                
                expect(iPhoneView.constraints).to.contain(expectedConstraint);
            });
            
            it(@"has Horizontal Space - instagramWebView to View", ^{
                NSLayoutConstraint *expectedConstraint = [NSLayoutConstraint constraintWithItem:controller.instagramWebView
                                                                                      attribute:NSLayoutAttributeLeading
                                                                                      relatedBy:NSLayoutRelationEqual
                                                                                         toItem:controller.view
                                                                                      attribute:NSLayoutAttributeLeading
                                                                                     multiplier:1
                                                                                       constant:0];
                expectedConstraint.priority = 1000;
                expectedConstraint.shouldBeArchived = YES;
                
                expect(iPhoneView.constraints).to.contain(expectedConstraint);
            });
        });
        
        context(@"iPad", ^{
            __block UIView *iPadView;
            
            beforeEach(^{
                NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"InstagramSimpleOAuthViewController~ipad"
                                                                  owner:controller
                                                                options:nil];
                
                iPadView = nibViews[0];
            });
            
            it(@"has at least 4 constraints", ^{
                expect(iPadView.constraints.count).to.beGreaterThanOrEqualTo(4);
            });
            
            it(@"has Vertical Space - instagramWebView to View", ^{
                NSLayoutConstraint *expectedConstraint = [NSLayoutConstraint constraintWithItem:controller.instagramWebView
                                                                                      attribute:NSLayoutAttributeTop
                                                                                      relatedBy:NSLayoutRelationEqual
                                                                                         toItem:controller.view
                                                                                      attribute:NSLayoutAttributeTop
                                                                                     multiplier:1
                                                                                       constant:0];
                expectedConstraint.priority = 1000;
                expectedConstraint.shouldBeArchived = YES;
                
                expect(iPadView.constraints).to.contain(expectedConstraint);
            });
            
            it(@"has Horizontal Space - View to instagramWebView", ^{
                NSLayoutConstraint *expectedConstraint = [NSLayoutConstraint constraintWithItem:controller.view
                                                                                      attribute:NSLayoutAttributeTrailing
                                                                                      relatedBy:NSLayoutRelationEqual
                                                                                         toItem:controller.instagramWebView
                                                                                      attribute:NSLayoutAttributeTrailing
                                                                                     multiplier:1
                                                                                       constant:0];
                expectedConstraint.priority = 1000;
                expectedConstraint.shouldBeArchived = YES;
                
                expect(iPadView.constraints).to.contain(expectedConstraint);
            });
            
            it(@"has Vertical Space - View to instagramWebView", ^{
                NSLayoutConstraint *expectedConstraint = [NSLayoutConstraint constraintWithItem:controller.view
                                                                                      attribute:NSLayoutAttributeBottom
                                                                                      relatedBy:NSLayoutRelationEqual
                                                                                         toItem:controller.instagramWebView
                                                                                      attribute:NSLayoutAttributeBottom
                                                                                     multiplier:1
                                                                                       constant:0];
                expectedConstraint.priority = 1000;
                expectedConstraint.shouldBeArchived = YES;
                
                expect(iPadView.constraints).to.contain(expectedConstraint);
            });
            
            it(@"has Horizontal Space - instagramWebView to View", ^{
                NSLayoutConstraint *expectedConstraint = [NSLayoutConstraint constraintWithItem:controller.instagramWebView
                                                                                      attribute:NSLayoutAttributeLeading
                                                                                      relatedBy:NSLayoutRelationEqual
                                                                                         toItem:controller.view
                                                                                      attribute:NSLayoutAttributeLeading
                                                                                     multiplier:1
                                                                                       constant:0];
                expectedConstraint.priority = 1000;
                expectedConstraint.shouldBeArchived = YES;
                
                expect(iPadView.constraints).to.contain(expectedConstraint);
            });
        });
    });
    
    describe(@"#viewDidLoad", ^{
        __block Swizzlean *superSwizz;
        __block BOOL isSuperCalled;
        
        beforeEach(^{
            isSuperCalled = NO;
            superSwizz = [[Swizzlean alloc] initWithClassToSwizzle:[UIViewController class]];
            [superSwizz swizzleInstanceMethod:@selector(viewDidLoad) withReplacementImplementation:^(id _self) {
                isSuperCalled = YES;
            }];
            
            [controller view];
        });
        
        it(@"calls super!!! Thanks for asking!!! =)", ^{
            expect(isSuperCalled).to.equal(YES);
        });
    });
    
    describe(@"<UIWebViewDelegate>", ^{
        describe(@"#webView:shouldStartLoadWithRequest:navigationType:", ^{
        });
    });
});

SpecEnd
