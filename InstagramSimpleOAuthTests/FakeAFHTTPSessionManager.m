#import "FakeAFHTTPSessionManager.h"


@implementation FakeAFHTTPSessionManager

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(id)parameters
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    self.postURLString = URLString;
    self.parameters = parameters;
    self.success = success;
    self.failure = failure;
    
    return nil;
}

@end
