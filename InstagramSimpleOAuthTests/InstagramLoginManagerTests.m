#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import <AFNetworking/AFNetworking.h>
#import <RealFakes/RealFakes.h>
#import "InstagramLoginManager.h"
#import "InstagramSimpleOAuth.h"
#import "FakeInstagramOAuthResponse.h"


@interface InstagramLoginManager ()

@property (strong, nonatomic) AFHTTPSessionManager *sessionManager;

@end

SpecBegin(InstagramLoginManagerTests)

describe(@"InstagramLoginManager", ^{
    __block InstagramLoginManager *manager;
    __block FakeAFHTTPSessionManager *fakeSessionManager;
    
    beforeEach(^{
        manager = [[InstagramLoginManager alloc] initWithClientID:@"BiggieSmalls"
                                                     clientSecret:@"egg, cheese, welch's grape"
                                                      callbackURL:[NSURL URLWithString:@"http://mo-money-mo-problems.org"]];
    });
    
    it(@"has clientID", ^{
        expect(manager.clientID).to.equal(@"BiggieSmalls");
    });
    
    it(@"has a clientSecret", ^{
        expect(manager.clientSecret).to.equal(@"egg, cheese, welch's grape");
    });
    
    it(@"has a callbackURL", ^{
        expect(manager.callbackURL).to.equal([NSURL URLWithString:@"http://mo-money-mo-problems.org"]);
    });
    
    it(@"has an AFHTTPSessionManager", ^{
        expect(manager.sessionManager).to.beInstanceOf([AFHTTPSessionManager class]);
        expect(manager.sessionManager.baseURL).to.equal([NSURL URLWithString:@"https://api.instagram.com"]);
        expect(manager.sessionManager.responseSerializer).to.beInstanceOf([AFJSONResponseSerializer class]);
    });
    
    describe(@"#authenticateWithAuthCode:success:failure:", ^{
        __block InstagramLoginResponse *retLoginResponse;
        __block NSError *retError;
        
        beforeEach(^{
            fakeSessionManager = [[FakeAFHTTPSessionManager alloc] init];
            manager.sessionManager = fakeSessionManager;
            
            [manager authenticateWithAuthCode:@"Fidelio"
                                      success:^(InstagramLoginResponse *instagramLoginResponse) {
                                          retLoginResponse = instagramLoginResponse;
                                      } failure:^(NSError *error) {
                                          retError = error;
                                      }];
        });
        
        context(@"on success", ^{
            __block id fakeLoginResponse;

            beforeEach(^{
                fakeLoginResponse = OCMClassMock([InstagramLoginResponse class]);

                if (fakeSessionManager.postSuccessBlock) {
                    fakeSessionManager.postSuccessBlock(nil, [FakeInstagramOAuthResponse response]);
                }
            });
            
            it(@"makes a POST call with the correct endpoint and parameters to Instagram", ^{
                expect(fakeSessionManager.postURLString).to.equal(@"/oauth/access_token/");
                expect(fakeSessionManager.postParameters).to.equal(@{ @"client_id"     : manager.clientID,
                                                                      @"client_secret" : manager.clientSecret,
                                                                      @"grant_type"    : @"authorization_code",
                                                                      @"redirect_uri"  : manager.callbackURL.absoluteString,
                                                                      @"code"          : @"Fidelio" });
            });
            
            it(@"calls success with instagramLoginResponse", ^{
                expect(retLoginResponse).to.beInstanceOf([InstagramLoginResponse class]);
                expect(retLoginResponse.accessToken).to.equal(@"12345IdiotLuggageCombo");
                expect(retLoginResponse.user.userID).to.equal(@"yepyepyep");
                expect(retLoginResponse.user.username).to.equal(@"og-gsta");
                expect(retLoginResponse.user.fullName).to.equal(@"Ice Cube");
                expect(retLoginResponse.user.profilePictureURL).to.equal([NSURL URLWithString:@"http://uh.yeah.yuuueaaah.com/og-gsta"]);
            });
        });
        
        context(@"on failure", ^{
            __block id fakeError;
            
            beforeEach(^{
                fakeError = OCMClassMock([NSError class]);
                
                if (fakeSessionManager.postFailureBlock) {
                    fakeSessionManager.postFailureBlock(nil, fakeError);
                }
            });
            
            it(@"calls failure block", ^{
                expect(retError).to.equal(fakeError);
            });
        });
    });
});

SpecEnd