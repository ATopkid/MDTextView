#import <XCTest/XCTest.h>
#import "ReBuilder.h"

@interface MDReBuilderTests : XCTestCase

@end

@implementation MDReBuilderTests

- (void)setUp {
}

- (void)tearDown {
}

- (void)testOr {
    ReBuilder *reBuilder = [ReBuilder new];
    
    NSString *suffixRe = [reBuilder convertToSuffixRe:@"a|b" tokenType:0];
    
    XCTAssertTrue([suffixRe isEqualToString:@"ab|"]);
}

- (void)testJoin {
    ReBuilder *reBuilder = [ReBuilder new];
    
    NSString *suffixRe = [reBuilder convertToSuffixRe:@"a·b" tokenType:0];
    
    XCTAssertTrue([suffixRe isEqualToString:@"ab·"]);
}

- (void)testOrAndEps {
    ReBuilder *reBuilder = [ReBuilder new];
    
    NSString *suffixRe = [reBuilder convertToSuffixRe:@"(a|b)c*" tokenType:0];
    
    XCTAssertTrue([suffixRe isEqualToString:@"ab|c*"]);
}

- (void)testOrAndJoin {
    ReBuilder *reBuilder = [ReBuilder new];
    
    NSString *suffixRe = [reBuilder convertToSuffixRe:@"(a|b)·c" tokenType:0];
    
    XCTAssertTrue([suffixRe isEqualToString:@"ab|c·"]);
}

- (void)testEpsAndJoin {
    ReBuilder *reBuilder = [ReBuilder new];
    
    NSString *suffixRe = [reBuilder convertToSuffixRe:@"a*·c" tokenType:0];
    
    XCTAssertTrue([suffixRe isEqualToString:@"a*c·"]);
}
@end
