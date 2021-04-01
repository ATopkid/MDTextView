#import "MDParserManager.h"
#import "DFABuilder.h"
#import "NFABuilder.h"
#import "ReBuilder.h"
#import "DFAUtils.h"
#import "NFAUtils.h"
#import "ReUtils.h"
#import "Dfa.h"
#import "Nfa.h"

@interface MDParserManager()

@property (nonatomic, strong)NSMutableArray<Dfa *> *allDfas;

@end

@implementation MDParserManager

+ (instancetype)sharedInstance {
    static MDParserManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MDParserManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self onCreate];
    }
    return self;
}

- (void)onCreate {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"re_input" ofType:@"txt"];
    NSString *content = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSArray<NSString *> *patternAndReArray = [content componentsSeparatedByString:@"\n"];
    self.allDfas = [NSMutableArray array];
    ReBuilder *reBuilder = [ReBuilder new];
    NFABuilder *nfaBuilder = [NFABuilder new];
    DFABuilder *dfaBuilder = [DFABuilder new];
    for (NSString *item in patternAndReArray) {
        if (item.length) {
            NSArray<NSString *> *keyAndValue = [item componentsSeparatedByString:@" "];
            NSString *pattern = [keyAndValue firstObject];
            TokenType tokenType = [ReUtils rePattern2TokenType:pattern];
            NSString *re = [keyAndValue lastObject];
            NSString *standardRe = [ReUtils standardizeRe:re];
            NSString *suffixRe = [reBuilder convertToSuffixRe:standardRe tokenType:tokenType];
            Nfa *nfa = [nfaBuilder convertRe:suffixRe tokenType:tokenType];
            Dfa *dfa = [dfaBuilder convertNfa:nfa tokenType:tokenType];
            [self.allDfas addObject:dfa];
        }
    }
    self.dfa2Pattern = dfaBuilder.dfa2Pattern;
}
@end
