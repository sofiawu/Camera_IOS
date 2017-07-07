//
//  ViewController.m
//  Camera_IOS
//
//  Created by sofiawu on 2017/7/7.
//  Copyright © 2017年 sofiawu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSURL *mediaUrl;
    
}

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

//懒加载
- (UIImagePickerController*) imagePickerController {
    if(!_imagePickerController) {
        _imagePickerController = [[UIImagePickerController alloc] init];
        
        //采集源类型
        //_imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        //媒体类型
        //_imagePickerController.mediaTypes = [NSArray arrayWithObject:(__bridge NSString*)kUTTypeImage];
        _imagePickerController.mediaTypes = [NSArray arrayWithObject:(__bridge NSString*)kUTTypeMovie];
        _imagePickerController.videoQuality = UIImagePickerControllerQualityTypeHigh;
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

- (AVPlayerViewController*) playerController {
    if(!_playerController) {
        _playerController = [[AVPlayerViewController alloc] init];
        
        _playerController.player = [[AVPlayer alloc] initWithURL:mediaUrl];
        
        //全屏播放
        //[self presentViewController:self.playerController animated:YES completion:nil];
        
        //小窗口播放
        self.playerController.view.frame = CGRectMake(10, 100, 400, 400);
        [self.view addSubview:self.playerController.view];
    }
    
    return _playerController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    //self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 654, 382)];
    //[self.view addSubview:self.imageView];
    
    [self pngtojpg];
}
- (void) imageShow {
    UIImage* image = [UIImage imageNamed:@"a.png"];
    self.imageView.image = image;
}

- (void) pngtojpg {
    UIImage* image = [UIImage imageNamed:@"a.png"];
    
    NSData* data = UIImageJPEGRepresentation(image, 1.0f);
    UIImage *imageJpg = [UIImage imageWithData:data];
    self.imageView.image = imageJpg;
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
    } else if([ type isEqualToString:(__bridge NSString*)kUTTypeMovie]) {
        mediaUrl = info[UIImagePickerControllerMediaURL];
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

- (IBAction)takeVideo:(UIButton *)sender {
    if([UIImagePickerController isSourceTypeAvailable:
        UIImagePickerControllerSourceTypeCamera]) {
        [self presentViewController:self.imagePickerController animated:YES completion:nil];
    }
}
- (IBAction)playVideo:(UIButton *)sender {
    [self.playerController.player play];
}
@end
