#import <XCTest/XCTest.h>
#import "ReUtils.h"

@interface MDReUtilsTests : XCTestCase

@end

@implementation MDReUtilsTests

- (void)setUp {
}

- (void)tearDown {
}

- (void)testBracket {
    NSString *re = @"[a-c]";
    
    re = [ReUtils standardizeRe:re];
    
    XCTAssertTrue([re isEqualToString:@"(a|b|c)"]);
}

- (void)testCurlyBracket {
    NSString *re = @"a{1,3}";
    
    re = [ReUtils standardizeRe:re];
    
    XCTAssertTrue([re isEqualToString:@"a(ε|a)(ε|a)"]);
}

- (void)testPlus {
    NSString *re = @"a+";
    
    re = [ReUtils standardizeRe:re];
    
    XCTAssertTrue([re isEqualToString:@"(aa*)"]);
}

- (void)testQuestionMark {
    NSString *re = @"a?";
    
    re = [ReUtils standardizeRe:re];
    
    XCTAssertTrue([re isEqualToString:@"(ε|a)"]);
}
@end
