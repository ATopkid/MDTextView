//
//  reBuilder.m
//  lex
//
//  Created by xiaoxliang on 2021/3/15.
//

#import "ReBuilder.h"
#import "ReUtils.h"

@interface ReBuilder()

@property (nonatomic, copy) NSDictionary *reOperatorPriority;
@property (nonatomic, copy) NSSet *reOperatorSet;
@property (nonatomic, copy) NSSet *letterSet;
@property (nonatomic, copy) NSSet *digitSet;
@property (nonatomic, copy) NSSet *mdTagSet;

@end

@implementation ReBuilder

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self onCreate];
    }
    return self;
}

- (void)onCreate {
    self.reOperatorPriority = @{
        @"*" : @(3),
        @"·" : @(2),
        @"|" : @(1),
    };
    
    self.letterSet = [NSSet setWithObjects:@"a", @"b", @"c", @"d", @"e", @"f", @"g", @"h", @"i", @"j", @"k", @"l", @"m", @"n", @"o", @"p", @"q", @"r", @"s", @"t", @"u", @"v", @"w", @"x", @"y", @"z", @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"ε", nil];
    
    self.digitSet = [NSSet setWithObjects:@"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
    self.mdTagSet = [NSSet setWithObjects:@"[", @"]", @"(", @")", nil];
    self.reOperatorSet = [NSSet setWithArray:[self.reOperatorPriority allKeys]];
}

- (NSString *)convertToSuffixRe:(NSString *)re  tokenType:(TokenType)tokenType {  
    NSMutableArray<NSString *> *stack = [NSMutableArray array];
    NSMutableArray<NSString *> *suffixReResult = [NSMutableArray array];
    
    NSRange range;
    for(int i = 0; i < re.length; i += range.length){
        range = [re rangeOfComposedCharacterSequenceAtIndex:i];
        NSString *ch = [re substringWithRange:range];
        
        if ([ch isEqualToString:@"\\"]) {
            //处理转义字符
            //向前看一个字符
            if (i + 1 < re.length) {
                NSString *forwardCh = [re substringWithRange:NSMakeRange(i + 1, 1)];
                if ([self.mdTagSet containsObject:forwardCh]) {
                    [suffixReResult addObject:forwardCh];
                    i += 1;
                } else {
                    [suffixReResult addObject:ch];
                }
            }
        } else if ([self.letterSet containsObject:ch] || [self.digitSet containsObject:ch]) {
            //处理普通字符
            [suffixReResult addObject:ch];
        } else if ([self.reOperatorSet containsObject:ch] || [self.mdTagSet containsObject:ch]) {
            //处理re符号
            if (!stack.count) {
                [stack addObject:ch];
            } else {
                NSString *stackTopCh = [stack lastObject];
                if ([ch isEqualToString:@"("]) {
                    [stack addObject:ch];
                } else if ([ch isEqualToString:@")"]) {
                    NSUInteger index = stack.count - 1;
                    for (; index >= 0; index--) {
                        [suffixReResult addObject:stack[index]];
                        if ([stack[index] isEqualToString:@"("]) {
                            [suffixReResult removeLastObject];
                            break;
                        }
                    }
                    [stack removeObjectsInRange:NSMakeRange(index, stack.count - index)];
                } else if ([stackTopCh isEqualToString:@"("]) {
                    [stack addObject:ch];
                } else if ([self.reOperatorPriority[ch] intValue] < [self.reOperatorPriority[stackTopCh] intValue]) {
                    NSUInteger index = stack.count - 1;
                    for (; index >= 0; index--) {
                        if (!stack.count) {
                            break;
                        }
                        if ([stack[index] isEqualToString:@"("] || ([self.reOperatorPriority[ch] intValue] > [self.reOperatorPriority[stackTopCh] intValue])) {
                            [stack addObject:ch];
                            break;
                        } else {
                            [suffixReResult addObject:stack[index]];
                        }
                        [stack removeObjectsInRange:NSMakeRange(index, stack.count - index)];
                    }
                    [stack addObject:ch];
                } else {
                    [stack addObject:ch];
                }
            }
        } else {
            NSLog(@"异常输入");
        }
    }
    
    for (NSInteger index = stack.count - 1; index >= 0; index--) {
        [suffixReResult addObject:stack[index]];
    }
    
    
    NSMutableString *suffixReString = [NSMutableString string];
    [suffixReResult enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [suffixReString appendString:obj];
    }];
    
    [self.re2Pattern setObject:@(tokenType) forKey:suffixReString];
    return suffixReString;
}

@end
