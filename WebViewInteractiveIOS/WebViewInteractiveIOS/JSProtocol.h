//
//  JSProtocol.h
//  WebViewInteractive
//
//  Created by shuoliu on 2018/5/14.
//  Copyright © 2018年 shuoliu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JSProtocol <JSExport>

-(void)print:(NSString *)str;

@end
