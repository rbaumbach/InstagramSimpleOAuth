#import <Expecta/Expecta.h>
#import <Specta/Specta.h>

#import "NSLayoutConstraint+TestUtils.h"
#import "InstagramSimpleOAuth.h"

SpecBegin(InstagramSimpleOAuthViewControllerXib)

describe(@"InstagramSimpleOAuthViewControllerXib", ^{
    __block InstagramSimpleOAuthViewController *controller;
    
    describe(@"constraints", ^{
        __block UIView *iPhoneView;
        __block UIWebView *instagramWebView;
        
        beforeEach(^{
            // controller is only loaded for ownership needs when loading the nib from the bundle
            controller = [[InstagramSimpleOAuthViewController alloc] init];
            
            NSBundle *bundle = [NSBundle bundleForClass:[InstagramSimpleOAuthViewController class]];
            
            NSArray *nibViews = [bundle loadNibNamed:@"InstagramSimpleOAuthViewController"
                                               owner:controller
                                             options:nil];
            
            iPhoneView = nibViews[0];
            
            instagramWebView = iPhoneView.subviews[0]; // only subview of the main view
        });
        
        it(@"has at least 4 constraints", ^{
            expect(iPhoneView.constraints.count).to.beGreaterThanOrEqualTo(4);
        });
        
        it(@"has Vertical Space - instagramWebView to View", ^{
            NSLayoutConstraint *expectedConstraint = [NSLayoutConstraint constraintWithItem:instagramWebView
                                                                                  attribute:NSLayoutAttributeTop
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:iPhoneView
                                                                                  attribute:NSLayoutAttributeTop
                                                                                 multiplier:1
                                                                                   constant:0];
            expectedConstraint.priority = 1000;
            expectedConstraint.shouldBeArchived = YES;
            
            expect(iPhoneView.constraints).to.contain(expectedConstraint);
        });
        
        it(@"has Horizontal Space - View to instagramWebView", ^{
            NSLayoutConstraint *expectedConstraint = [NSLayoutConstraint constraintWithItem:iPhoneView
                                                                                  attribute:NSLayoutAttributeTrailing
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:instagramWebView
                                                                                  attribute:NSLayoutAttributeTrailing
                                                                                 multiplier:1
                                                                                   constant:0];
            expectedConstraint.priority = 1000;
            expectedConstraint.shouldBeArchived = YES;
            
            expect(iPhoneView.constraints).to.contain(expectedConstraint);
        });
        
        it(@"has Vertical Space - View to instagramWebView", ^{
            NSLayoutConstraint *expectedConstraint = [NSLayoutConstraint constraintWithItem:iPhoneView
                                                                                  attribute:NSLayoutAttributeBottom
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:instagramWebView
                                                                                  attribute:NSLayoutAttributeBottom
                                                                                 multiplier:1
                                                                                   constant:0];
            expectedConstraint.priority = 1000;
            expectedConstraint.shouldBeArchived = YES;
            
            expect(iPhoneView.constraints).to.contain(expectedConstraint);
        });
        
        it(@"has Horizontal Space - instagramWebView to View", ^{
            NSLayoutConstraint *expectedConstraint = [NSLayoutConstraint constraintWithItem:instagramWebView
                                                                                  attribute:NSLayoutAttributeLeading
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:iPhoneView
                                                                                  attribute:NSLayoutAttributeLeading
                                                                                 multiplier:1
                                                                                   constant:0];
            expectedConstraint.priority = 1000;
            expectedConstraint.shouldBeArchived = YES;
            
            expect(iPhoneView.constraints).to.contain(expectedConstraint);
        });
    });
});

SpecEnd
