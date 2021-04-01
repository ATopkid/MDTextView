#import <Foundation/Foundation.h>

@class Nfa;

@interface NFAUtils : NSObject

+ (Nfa *)char2nfa:(NSString *)ch;
+ (Nfa *)join:(Nfa *)nfa1 and:(Nfa *)nfa2;
+ (Nfa *)or:(Nfa *)nfa1 and:(Nfa *)nfa2;
+ (Nfa *)closure:(Nfa *)nfa;

@end
