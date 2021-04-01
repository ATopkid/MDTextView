#import <Foundation/Foundation.h>

@class Node;
@class Dfa;
@class Nfa;
@class Token;

@interface DFAUtils : NSObject

/// 子集构造法
+ (Dfa *)subsetConstruction:(Nfa *)nfa;

/// 最小化DFA
+ (Dfa *)hopcroft:(Dfa *)dfa;

/// 经过dfa后的token
+ (Token *)tokenizer:(NSMutableString *)str inDfa:(Dfa *)dfa dfa2Pattern:(NSDictionary<Dfa *, NSNumber *> *)dfa2Pattern;
@end
