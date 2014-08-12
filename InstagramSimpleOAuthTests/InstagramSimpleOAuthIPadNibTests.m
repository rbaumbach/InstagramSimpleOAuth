#import <Specta/Specta.h>
#import <Swizzlean/Swizzlean.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import "InstagramSimpleOAuthViewController.h"
#import "NSLayoutConstraint+TestUtils.h"

SpecBegin(InstagramSimpleOAuthIPadNibTests)

describe(@"InstagramSimpleOAuthIPadNib", ^{
    __block InstagramSimpleOAuthViewController *controller;
    
    describe(@"constraints", ^{
        __block UIView *iPadView;
        __block UIWebView *instagramWebView;
        
        beforeEach(^{
            // controller is only loaded for ownership needs when loading the nib from the bundle
            controller = [[InstagramSimpleOAuthViewController alloc] init];
            NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"InstagramSimpleOAuthViewController~ipad"
                                                              owner:controller
                                                            options:nil];
            
            iPadView = nibViews[0];
            
            instagramWebView = iPadView.subviews[0]; // only subview of the main view
        });
        
        it(@"has at least 4 constraints", ^{
            expect(iPadView.constraints.count).to.beGreaterThanOrEqualTo(4);
        });
        
        it(@"has Vertical Space - instagramWebView to View", ^{
            NSLayoutConstraint *expectedConstraint = [NSLayoutConstraint constraintWithItem:instagramWebView
                                                                                  attribute:NSLayoutAttributeTop
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:iPadView
                                                                                  attribute:NSLayoutAttributeTop
                                                                                 multiplier:1
                                                                                   constant:0];
            expectedConstraint.priority = 1000;
            expectedConstraint.shouldBeArchived = YES;
            
            expect(iPadView.constraints).to.contain(expectedConstraint);
        });
        
        it(@"has Horizontal Space - View to instagramWebView", ^{
            NSLayoutConstraint *expectedConstraint = [NSLayoutConstraint constraintWithItem:iPadView
                                                                                  attribute:NSLayoutAttributeTrailing
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:instagramWebView
                                                                                  attribute:NSLayoutAttributeTrailing
                                                                                 multiplier:1
                                                                                   constant:0];
            expectedConstraint.priority = 1000;
            expectedConstraint.shouldBeArchived = YES;
            
            expect(iPadView.constraints).to.contain(expectedConstraint);
        });
        
        it(@"has Vertical Space - View to instagramWebView", ^{
            NSLayoutConstraint *expectedConstraint = [NSLayoutConstraint constraintWithItem:iPadView
                                                                                  attribute:NSLayoutAttributeBottom
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:instagramWebView
                                                                                  attribute:NSLayoutAttributeBottom
                                                                                 multiplier:1
                                                                                   constant:0];
            expectedConstraint.priority = 1000;
            expectedConstraint.shouldBeArchived = YES;
            
            expect(iPadView.constraints).to.contain(expectedConstraint);
        });
        
        it(@"has Horizontal Space - instagramWebView to View", ^{
            NSLayoutConstraint *expectedConstraint = [NSLayoutConstraint constraintWithItem:instagramWebView
                                                                                  attribute:NSLayoutAttributeLeading
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:iPadView
                                                                                  attribute:NSLayoutAttributeLeading
                                                                                 multiplier:1
                                                                                   constant:0];
            expectedConstraint.priority = 1000;
            expectedConstraint.shouldBeArchived = YES;
            
            expect(iPadView.constraints).to.contain(expectedConstraint);
        });
    });
});

SpecEnd