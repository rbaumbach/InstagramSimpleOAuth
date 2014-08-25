#import <Specta/Specta.h>
#import <Swizzlean/Swizzlean.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#import <OCMock/OCMock.h>
#import "InstagramUser.h"


SpecBegin(InstagramUserTests)

describe(@"InstagramUser", ^{
    __block InstagramUser *user;
    
    beforeEach(^{
        user = [[InstagramUser alloc] init];
        user.userID = @"bam99";
        user.username = @"bammy_bam_bam99";
        user.fullName = @"Senor Bam";
        user.profilePictureURL = [NSURL URLWithString:@"https://bam.bam.codes/photo_4_bam"];
    });
    
    it(@"has an userID", ^{
        expect(user.userID).to.equal(@"bam99");
    });
    
    it(@"has a username", ^{
        expect(user.username).to.equal(@"bammy_bam_bam99");
    });
    
    it(@"has a fullName", ^{
        expect(user.fullName).to.equal(@"Senor Bam");
    });
    
    it(@"has a profile picture URL", ^{
        expect(user.profilePictureURL).to.equal([NSURL URLWithString:@"https://bam.bam.codes/photo_4_bam"]);
    });
});

SpecEnd