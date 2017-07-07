//
//  ViewController.m
//  Camera_IOS
//
//  Created by sofiawu on 2017/7/7.
//  Copyright © 2017年 sofiawu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

//懒加载
- (UIImagePickerController*) imagePickerController {
    if(!_imagePickerController) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        
        //采集源类型
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //媒体类型
        _imagePickerController.mediaTypes = [NSArray arrayWithObject:(__bridge NSString*)kUTTypeImage];
        //代理
        _imagePickerController.delegate = self;
    }
    return _imagePickerController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnClick:(id)sender {
    //通过摄像头采集
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else { //通过图片库采集
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

//完成采集图片后的回调处理
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    //获取媒体类型
    NSString *type = info[UIImagePickerControllerMediaType];
    if([ type isEqualToString:(__bridge NSString*)kUTTypeImage]) {
        UIImage* image = info[UIImagePickerControllerOriginalImage];
        
        self.imageView.image = image;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
//取消采集图片的处理
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    NSLog(@"取消采集图片");
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
