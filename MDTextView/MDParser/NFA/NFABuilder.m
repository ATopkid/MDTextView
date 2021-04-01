#import "NFABuilder.h"
#import "Nfa.h"
#import "NFAUtils.h"
#import "Token.h"

@implementation NFABuilder

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.nfas = [NSMutableArray array];
        self.nfa2Pattern = [NSMutableDictionary dictionary];
    }
    return self;
}

- (Nfa *)convertRe:(NSString *)re tokenType:(TokenType)tokenType {
    for (int i = 0; i < re.length; i++) {
        NSString *ch = [re substringWithRange:NSMakeRange(i, 1)];
        if ([ch isEqualToString:@"·"]) {
            Nfa *nfa2 = [self.nfas lastObject];
            [self.nfas removeLastObject];
            Nfa *nfa1 = [self.nfas lastObject];
            [self.nfas removeLastObject];
            [self.nfas addObject:[NFAUtils join:nfa1 and:nfa2]];
        } else if ([ch isEqualToString:@"|"]) {
            Nfa *nfa2 = [self.nfas lastObject];
            [self.nfas removeLastObject];
            Nfa *nfa1 = [self.nfas lastObject];
            [self.nfas removeLastObject];
            [self.nfas addObject:[NFAUtils or:nfa1 and:nfa2]];
        } else if ([ch isEqualToString:@"*"]) {
            Nfa *nfa1 = [self.nfas lastObject];
            [self.nfas removeLastObject];
            [self.nfas addObject:[NFAUtils closure:nfa1]];
        } else {
            [self.nfas addObject:[NFAUtils char2nfa:ch]];
        }
    }
    
    Nfa *resultNfa = [self.nfas firstObject];
    [self.nfas removeAllObjects];
    [self.nfa2Pattern setObject:@(tokenType) forKey:resultNfa];
    [resultNfa.alphabet removeObject:@"ε"];
    
    return resultNfa;
}

@end
