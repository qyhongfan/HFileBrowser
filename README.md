# HFileBrowser
纯代码实现沙盒文件目录结构，支持图片、视频、文本文件预览 ,支持swift2.3和swift3.0

pod：
swift2.3:   pod 'HFileBrowser’,:git => 'https://github.com/qyhongfan/HFileBrowser.git', branch: 'swift2.3'
swift3.0:   pod 'HFileBrowser’,:git => 'https://github.com/qyhongfan/HFileBrowser.git', branch: 'swift3.0'

OC调用：
#import "HFileBrowser-Swift.h"
HFileBrowser * VC = [[HFileBrowser alloc]initWithPath:NSHomeDirectory() frame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)]; 

swift调用： 
#import HFileBrowser
var VC = HFileBrowser(path:NSHomeDirectory(),frame:self.view.frame)
