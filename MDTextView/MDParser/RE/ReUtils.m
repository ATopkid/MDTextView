//
//  ReUtils.m
//  lex
//
//  Created by xiaoxliang on 2021/3/15.
//


#import "ReUtils.h"

static NSSet *syntacticSugarSet;
static NSDictionary *reOperatorPriority;
static NSSet *reOperatorSet;
static NSSet *letterSet;
static NSSet *digitSet;
static NSSet *mdTagSet;
@implementation ReUtils

+(void)initialize {
    syntacticSugarSet = [NSSet setWithObjects:@"{", @"[", @"?", @"+", nil];
    reOperatorPriority = @{
        @"*" : @(3),
        @"·" : @(2),
        @"|" : @(1),
    };
    letterSet = [NSSet setWithObjects:@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", nil];
    digitSet = [NSSet setWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
    mdTagSet = [NSSet setWithObjects:@"[", @"]", @"(", @")", nil];
    reOperatorSet = [NSSet setWithArray:[reOperatorPriority allKeys]];
}

+ (NSMutableString *)standardizeRe:(NSString *)re {
    //处理语法糖

    re = [re stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSMutableString *result = [NSMutableString string];
    
    NSRange range;
    NSInteger syntaxEndIndex = -1;

    for(NSUInteger i = 0; i < re.length;){
        range = [re rangeOfComposedCharacterSequenceAtIndex:i];
        NSString *ch = [re substringWithRange:range];

        if ([syntacticSugarSet containsObject:ch] && ( i == 0 || ![[re substringWithRange:NSMakeRange(i - 1, 1)] isEqualToString:@"\\"])) {
            //首先确定该语法糖前面的主体
            if ([ch isEqualToString:@"["]) {
                //@"["特殊处理 不需要找主体
               //[m-nA-z]
                NSArray *separaArray = [re componentsSeparatedByString:@"-"];
                NSUInteger count = separaArray.count - 1;
                [result appendString:@"("];

                for (NSUInteger tmpCount = 0; tmpCount < count; tmpCount++) {
                    const char *start = [[re substringWithRange:NSMakeRange(i + 1 + tmpCount * 3, 1)] UTF8String];
                    const char *end = [[re substringWithRange:NSMakeRange(i + 3 + tmpCount * 3, 1)] UTF8String];
                    for (char ch = *start; ch <= *end; ch++) {
                        if (tmpCount == count - 1 && ch == *end) {
                            [result appendString:[NSString stringWithFormat:@"%c", ch]];
                        } else {
                            [result appendString:[NSString stringWithFormat:@"%c|", ch]];
                        }
                    }
                }
                
                [result appendString:@")"];
                syntaxEndIndex = i + 3 * count + 1;
                i = syntaxEndIndex + 1;
                
                continue;
            }
            NSRange bodyRange = [self bodyStringWithResult:result];
            if (!bodyRange.length) {
                NSLog(@"正则表达式错误");
                return nil;
            }
            //bodyRange 是在result中 当前语法糖的主体部分 也是result里需要删除的部分
            NSString *bodyString = [result substringWithRange:bodyRange];
            result = [[result substringToIndex:bodyRange.location] mutableCopy];
                        
            if ([ch isEqualToString:@"{"]) {
                //{m,n}
                syntaxEndIndex = i + 4;
                NSUInteger min = [[re substringWithRange:NSMakeRange(i + 1, 1)] intValue];
                NSUInteger max = [[re substringWithRange:NSMakeRange(i + 3, 1)] intValue];
                for (NSUInteger appendIndex = 0; appendIndex < min; appendIndex++) {
                    [result appendString:bodyString];
                }
                for (NSUInteger appendIndex = min; appendIndex < max; appendIndex++) {
                    [result appendString:[NSString stringWithFormat:@"(ε|%@)", bodyString]];
                }
            } else if ([ch isEqualToString:@"?"]) {
                syntaxEndIndex = i;
                NSString *appendString = [NSString stringWithFormat:@"(ε|%@)", bodyString];
                [result appendString:appendString];
            } else if ([ch isEqualToString:@"+"]) {
                syntaxEndIndex = i;
                NSString *appendString = [NSString stringWithFormat:@"(%@%@*)", bodyString, bodyString];
                [result appendString:appendString];
            }
            
            i = syntaxEndIndex + 1;
        } else {
            [result appendString:[re substringWithRange:NSMakeRange(i, 1)]];
            i += range.length;
        }
    }
    return result;
}

+ (NSRange)bodyStringWithResult:(NSString *)re {
    NSRange range = NSMakeRange(0, 0);
    NSUInteger i = re.length - 1;
    NSString *beforeCh = [re substringWithRange:NSMakeRange(i, 1)];
    if ([beforeCh isEqualToString:@")"]) {
        NSRange backRange;
        NSUInteger backChIndex = -1;
        for (NSUInteger j = re.length - 1; j >= 0; j--) {
            backRange = [re rangeOfComposedCharacterSequenceAtIndex:j];
            NSString *backCh = [re substringWithRange:backRange];
            if ([backCh isEqualToString:@"("]) {
                backChIndex = j;
                break;;
            }
        }
        if (backChIndex >= 0) {
            range = NSMakeRange(backChIndex, re.length);
        }
        
    } else {
        if (i >= 1 && [[re substringWithRange:NSMakeRange(i - 1, 1)] isEqualToString:@"\\"]) {
            range = NSMakeRange(i - 1, 2);
        } else {
            range = NSMakeRange(i, 1);
        }
    }
    
    return range;
}

+ (TokenType)rePattern2TokenType:(NSString *)re {
    if ([re isEqualToString:@"sentence"]) {
        return TokenTypeSentence;
    } else if ([re isEqualToString:@"mdtag"]) {
        return TokenTypeMdtag;;
    }
    return TokenTypeUnknow;
}

@end
