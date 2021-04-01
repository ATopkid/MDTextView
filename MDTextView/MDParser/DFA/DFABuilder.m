#import "DFABuilder.h"
#import "DFAUtils.h"
#import "Dfa.h"

@implementation DFABuilder
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dfa2Pattern = [NSMutableDictionary dictionary];
    }
    return self;
}

- (Dfa *)convertNfa:(Nfa *)nfa tokenType:(TokenType)tokenType {
    Dfa *resultDfa = [DFAUtils hopcroft:[DFAUtils subsetConstruction:nfa]];
    resultDfa.type = tokenType;
    return resultDfa;
}
@end
