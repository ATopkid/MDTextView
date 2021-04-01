#import "MDParser.h"
#import "MDParserManager.h"
#import "MDParser.h"
#import "ASTUtils.h"
#import "DFAUtils.h"
#import "Dfa.h"
#import "Token.h"
#import "DFABuilder.h"

@implementation MDParser

- (ASTNode *)startParser {
    ///用户输入
    NSMutableString *userInput = [@"aaa[bbb[abc](cba)](ccc)ddd" mutableCopy];
    
    NSMutableArray<Token *> *tokens = [NSMutableArray array];
    NSMutableArray<Dfa *> *allDfas = [MDParserManager sharedInstance].allDfas;
    
    for (int i = 0; i < allDfas.count;) {
        Dfa *dfa = allDfas[i];
        
        Token *token = [DFAUtils tokenizer:userInput inDfa:dfa dfa2Pattern:[MDParserManager sharedInstance].dfa2Pattern];
        if (token.value.length) {
            [tokens addObject:token];
            [userInput deleteCharactersInRange:NSMakeRange(0, token.value.length)];
            if (!userInput.length) {
                break;
            }
            i = 0;
        } else {
            i++;
        }
    }
    
    ASTNode *root = [ASTUtils parseHyperlinksS:tokens];
    return root;
}

@end
