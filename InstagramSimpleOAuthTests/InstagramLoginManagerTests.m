#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <SimpleOAuth2/SimpleOAuth2.h>
#import <RealFakes/RealFakes.h>
#import "FakeInstagramOAuthResponse.h"
#import "FakeSimpleOAuth2AuthenticationManager.h"
#import "InstagramSimpleOAuth.h"
#import "InstagramAuthenticationManager.h"
#import "InstagramTokenParameters.h"


@interface InstagramAuthenticationManager ()

@property (copy, nonatomic) NSString *clientID;
@property (copy, nonatomic) NSString *clientSecret;
@property (copy, nonatomic) NSString *callbackURLString;
@property (copy, nonatomic) SimpleOAuth2AuthenticationManager *simpleOAuth2AuthenticationManager;

@end

SpecBegin(InstagramAuthenticationManagerTests)

describe(@"InstagramAuthenticationManager", ^{
    __block InstagramAuthenticationManager *instagramAuthenticationManager;
    __block FakeSimpleOAuth2AuthenticationManager *fakeSimpleAuthManager;
    __block InstagramLoginResponse *retInstagramLoginResponse;
    __block NSError *authError;
    
    beforeEach(^{
        instagramAuthenticationManager = [[InstagramAuthenticationManager alloc] initWithClientID:@"give-me-the-keys"
                                                                                     clientSecret:@"spilling-beans"
                                                                                callbackURLString:@"http://call-me-back.8675309"];
        
        fakeSimpleAuthManager = [[FakeSimpleOAuth2AuthenticationManager alloc] init];
    });
    
    it(@"has an appKey", ^{
        expect(instagramAuthenticationManager.clientID).to.equal(@"give-me-the-keys");
    });
    
    it(@"has an appSecret", ^{
        expect(instagramAuthenticationManager.clientSecret).to.equal(@"spilling-beans");
    });
    
    it(@"has a callbackURLString", ^{
        expect(instagramAuthenticationManager.callbackURLString).to.equal(@"http://call-me-back.8675309");
    });
    
    it(@"has a simpleOAuth2AuthenticationManager", ^{
        expect(instagramAuthenticationManager.simpleOAuth2AuthenticationManager).to.beInstanceOf([SimpleOAuth2AuthenticationManager class]);
    });
    
    describe(@"#authenticateClientWithAuthCode:success:failure:", ^{
        beforeEach(^{
            instagramAuthenticationManager.simpleOAuth2AuthenticationManager = fakeSimpleAuthManager;
            
            [instagramAuthenticationManager authenticateClientWithAuthCode:@"SF-Giants-The-Best"
                                                                   success:^(InstagramLoginResponse *response) {
                                                                       retInstagramLoginResponse = response;
                                                                   } failure:^(NSError *error) {
                                                                       authError = error;
                                                                   }];
        });
        
        it(@"is called with authURL", ^{
            expect(fakeSimpleAuthManager.authURL).to.equal([NSURL URLWithString:@"https://api.instagram.com/oauth/access_token/"]);
        });
        
        it(@"is called with token parameters", ^{
            InstagramTokenParameters *tokenParameters = (InstagramTokenParameters *)fakeSimpleAuthManager.tokenParameters;
            
            expect(tokenParameters.clientID).to.equal(@"give-me-the-keys");
            expect(tokenParameters.clientSecret).to.equal(@"spilling-beans");
            expect(tokenParameters.callbackURLString).to.equal(@"http://call-me-back.8675309");
            expect(tokenParameters.authorizationCode).to.equal(@"SF-Giants-The-Best");
        });
        
        context(@"On Success", ^{
            beforeEach(^{
                if (fakeSimpleAuthManager.success) {
                    fakeSimpleAuthManager.success([FakeInstagramOAuthResponse response]);
                }
            });
            
            it(@"calls success block with InstagramLoginResponse", ^{
                expect(retInstagramLoginResponse).to.beInstanceOf([InstagramLoginResponse class]);
                expect(retInstagramLoginResponse.accessToken).to.equal(@"12345IdiotLuggageCombo");
                expect(retInstagramLoginResponse.user.userID).to.equal(@"yepyepyep");
                expect(retInstagramLoginResponse.user.username).to.equal(@"og-gsta");
                expect(retInstagramLoginResponse.user.fullName).to.equal(@"Ice Cube");
                expect(retInstagramLoginResponse.user.profilePictureURL).to.equal([NSURL URLWithString:@"http://uh.yeah.yuuueaaah.com/og-gsta"]);
            });
        });
        
        context(@"On Failure", ^{
            __block id fakeError;
            
            beforeEach(^{
                fakeError = OCMClassMock([NSError class]);
                
                if (fakeSimpleAuthManager.failure) {
                    // This is here because the Expecta short hand methods #define "failure"
                    // #define failure(...) EXP_failure((__VA_ARGS__))
                    void(^authFailure)(NSError *error) = [fakeSimpleAuthManager.failure copy];
                    
                    authFailure(fakeError);
                }
            });
            
            it(@"calls simpleOAuth failure block with error", ^{
                expect(authError).to.equal(fakeError);
            });
        });
    });
});

SpecEnd