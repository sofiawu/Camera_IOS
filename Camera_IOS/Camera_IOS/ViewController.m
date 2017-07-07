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

- (AVAudioRecorder*) recorder {
    if(!_recorder) {
        NSString* path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/record"];
        NSMutableDictionary* settingDic = [[NSMutableDictionary alloc] init];
        [settingDic setValue:[NSNumber numberWithInt:44100] forKey:AVSampleRateKey];
        [settingDic setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
        [settingDic setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
        [settingDic setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
        
        _recorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:path] settings:settingDic error:nil];
        [_recorder prepareToRecord];
    }
    return _recorder;
}

- (AVAudioPlayer*) player {
    if(!_player) {
        //NSString* path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/record"];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"q0000" ofType:@"wav"];
        
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path] error:nil];
        [_player prepareToPlay];
    }
    return _player;
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


- (IBAction)record:(UIButton *)sender {
    if(sender.isSelected == NO) {
        [self.recorder record];
        sender.selected = YES;
    } else {
        [self.recorder stop];
        sender.selected = NO;
    }
}
- (IBAction)play:(UIButton *)sender {
    [self.player play];
}

@end
