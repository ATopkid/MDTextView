//
//  Token.m
//  lex
//
//  Created by xiaoxliang on 2021/3/16.
//

#import "Token.h"

@implementation Token

- (instancetype)initWithType:(TokenType)type value:(NSString *)value
{
    self = [super init];
    if (self) {
        self.type = type;
        self.value = value;
    }
    return self;
}
@end
