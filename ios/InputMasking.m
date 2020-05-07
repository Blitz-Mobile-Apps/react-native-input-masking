
#import <Foundation/Foundation.h>
#import <React/RCTViewManager.h>


@interface RCT_EXTERN_MODULE(InputMasking, RCTViewManager)
RCT_EXPORT_VIEW_PROPERTY(value, NSString )
RCT_EXPORT_VIEW_PROPERTY(textSize, CGFloat)
RCT_EXPORT_VIEW_PROPERTY(textColor, NSString)
RCT_EXPORT_VIEW_PROPERTY(disabled, BOOL)
RCT_EXPORT_VIEW_PROPERTY(placeholder, NSString)
RCT_EXPORT_VIEW_PROPERTY(placeholderTextColor, NSString)
RCT_EXPORT_VIEW_PROPERTY(maskFormat, NSString)
RCT_EXPORT_VIEW_PROPERTY(textAlign, NSString )
RCT_EXPORT_VIEW_PROPERTY(keyboardType, NSString )
RCT_EXPORT_VIEW_PROPERTY(returnKeyType, NSString )
RCT_EXPORT_VIEW_PROPERTY(onChangeText, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onFocusText, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onErrorForMasking, RCTDirectEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onSubmitText, RCTDirectEventBlock)


@end
