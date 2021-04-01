#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MDCtFrameTokenType) {
    MDCtFrameTokenTypeHyperlinks,
};

@interface MDCtFrameToken : NSObject

@property (nonatomic, assign) NSRange range;
@property (nonatomic, strong) UIColor *color;

@property (nonatomic, assign) MDCtFrameTokenType type;

- (instancetype)initWithType:(MDCtFrameTokenType)type;

@end
