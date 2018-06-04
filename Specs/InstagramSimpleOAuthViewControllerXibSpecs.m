#import <Expecta/Expecta.h>
#import <Specta/Specta.h>

#import "InstagramSimpleOAuth.h"
#import "NSLayoutConstraintSpecHelper.h"

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
        
        it(@"has Vertical Space - instagramWebView.top to superview top", ^{
            NSLayoutConstraint *expectedConstraint = [NSLayoutConstraint constraintWithItem:instagramWebView
                                                                                  attribute:NSLayoutAttributeTop
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:iPhoneView
                                                                                  attribute:NSLayoutAttributeTop
                                                                                 multiplier:1
                                                                                   constant:0];
            expectedConstraint.priority = 1000;
            expectedConstraint.shouldBeArchived = YES;
            
            __block BOOL constraintsAreEqual = NO;
            
            [iPhoneView.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger index, BOOL *stop) {
                if ([constraint.identifier isEqualToString:@"instagramWebView.top-to-superview-top"]) {
                    constraintsAreEqual = [NSLayoutConstraintSpecHelper isLayoutConstraint:constraint
                                                                   equalToLayoutConstraint:expectedConstraint];
                }
            }];

            expect(constraintsAreEqual).to.beTruthy();
        });
        
        it(@"has Horizontal Space - superview trailing to instagramWebView.trailing", ^{
            NSLayoutConstraint *expectedConstraint = [NSLayoutConstraint constraintWithItem:iPhoneView
                                                                                  attribute:NSLayoutAttributeTrailing
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:instagramWebView
                                                                                  attribute:NSLayoutAttributeTrailing
                                                                                 multiplier:1
                                                                                   constant:0];
            expectedConstraint.priority = 1000;
            expectedConstraint.shouldBeArchived = YES;

            __block BOOL constraintsAreEqual = NO;
            
            [iPhoneView.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger index, BOOL *stop) {
                if ([constraint.identifier isEqualToString:@"superview-trailing-to-instagramWebView.trailing"]) {
                    constraintsAreEqual = [NSLayoutConstraintSpecHelper isLayoutConstraint:constraint
                                                                   equalToLayoutConstraint:expectedConstraint];
                }
            }];
            
            expect(constraintsAreEqual).to.beTruthy();
        });

        it(@"has Vertical Space - superview bottom to instagramWebView.bottom", ^{
            NSLayoutConstraint *expectedConstraint = [NSLayoutConstraint constraintWithItem:iPhoneView
                                                                                  attribute:NSLayoutAttributeBottom
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:instagramWebView
                                                                                  attribute:NSLayoutAttributeBottom
                                                                                 multiplier:1
                                                                                   constant:0];
            expectedConstraint.priority = 1000;
            expectedConstraint.shouldBeArchived = YES;
            
            __block BOOL constraintsAreEqual = NO;

            [iPhoneView.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger index, BOOL *stop) {
                if ([constraint.identifier isEqualToString:@"superview-bottom-to-instagramWebView.bottom"]) {
                    constraintsAreEqual = [NSLayoutConstraintSpecHelper isLayoutConstraint:constraint
                                                                   equalToLayoutConstraint:expectedConstraint];
                }
            }];
            
            expect(constraintsAreEqual).to.beTruthy();
        });

        it(@"has Horizontal Space - instagramWebView.leading to superview leading", ^{
            NSLayoutConstraint *expectedConstraint = [NSLayoutConstraint constraintWithItem:instagramWebView
                                                                                  attribute:NSLayoutAttributeLeading
                                                                                  relatedBy:NSLayoutRelationEqual
                                                                                     toItem:iPhoneView
                                                                                  attribute:NSLayoutAttributeLeading
                                                                                 multiplier:1
                                                                                   constant:0];
            expectedConstraint.priority = 1000;
            expectedConstraint.shouldBeArchived = YES;

            __block BOOL constraintsAreEqual = NO;
            
            [iPhoneView.constraints enumerateObjectsUsingBlock:^(NSLayoutConstraint *constraint, NSUInteger index, BOOL *stop) {
                if ([constraint.identifier isEqualToString:@"instagramWebView.leading-to-superview-leading"]) {
                    constraintsAreEqual = [NSLayoutConstraintSpecHelper isLayoutConstraint:constraint
                                                                   equalToLayoutConstraint:expectedConstraint];
                }
            }];
            
            expect(constraintsAreEqual).to.beTruthy();
        });
    });
});

SpecEnd
