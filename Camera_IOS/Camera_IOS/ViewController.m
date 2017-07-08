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
    
    UIImageView* imageViewOri;
    UIImageView* imageView1;
    UIImageView* imageView2;
    UIImageView* imageView3;
    UIImageView* imageView4;
    UIImageView* imageView5;
    
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
    
    //[self pngtojpg];
    [self loadImage];
    //[self convertFormatTest];
    [self testImageGray];
    [self testImageReColor];
    [self testImageHighlight];
}

-(void) testImageGray {
    UIImage* image = [UIImage imageNamed:@"lena.jpg"];
    unsigned char* imageData = [self convertUIImageToData:image];
    unsigned char* imageGrayData = [self imageGrayWithData:imageData width:image.size.width height:image.size.height];
    UIImage* imageNew = [self convertDataToUIImage:imageGrayData width:image.size.width height:image.size.height];
    imageView1.image = imageNew;
}

-(void) testImageReColor {
    UIImage* image = [UIImage imageNamed:@"lena.jpg"];
    unsigned char* imageData = [self convertUIImageToData:image];
    unsigned char* imageReColorData = [self imageReColorWithData:imageData width:image.size.width height:image.size.height];
    UIImage* imageNew = [self convertDataToUIImage:imageReColorData width:image.size.width height:image.size.height];
    imageView2.image = imageNew;
}

-(void) testImageHighlight {
    UIImage* image = [UIImage imageNamed:@"lena.jpg"];
    unsigned char* imageData = [self convertUIImageToData:image];
    unsigned char* imageHightlightData = [self imageHighlightWithData:imageData width:image.size.width height:image.size.height];
    UIImage* imageNew = [self convertDataToUIImage:imageHightlightData width:image.size.width height:image.size.height];
    imageView3.image = imageNew;
}

-(void) convertFormatTest {
    UIImage* image = [UIImage imageNamed:@"lena.jpg"];
    unsigned char* imageData = [self convertUIImageToData:image];
    UIImage* imageNew = [self convertDataToUIImage:imageData width:image.size.width height:image.size.height];
    imageView1.image = imageNew;
}

-(void) loadImage {
    imageViewOri = [[UIImageView alloc] initWithFrame:CGRectMake(18, 18, 180, 135)];
    [self.view addSubview:imageViewOri];
    imageViewOri.image = [UIImage imageNamed:@"lena.jpg"];
    
    imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(18 + 180 + 18, 18, 180, 135)];
    [self.view addSubview:imageView1];

    imageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(18, 18 + 135 + 18, 180, 135)];
    [self.view addSubview:imageView2];

    imageView3 = [[UIImageView alloc] initWithFrame:CGRectMake(18 + 180 + 18, 18 + 135 + 18, 180, 135)];
    [self.view addSubview:imageView3];

    imageView4 = [[UIImageView alloc] initWithFrame:CGRectMake(18, 18 + 135 + 18 + 135 + 18, 180, 135)];
    [self.view addSubview:imageView4];
    
    imageView5 = [[UIImageView alloc] initWithFrame:CGRectMake(18 + 180 + 18, 18 + 135 + 18 + 135 + 18, 180, 135)];
    [self.view addSubview:imageView5];
}
- (unsigned char*) convertUIImageToData: (UIImage*) image {
    CGImageRef imageRef = [image CGImage];
    CGSize imageSize = image.size;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    void* data = malloc(imageSize.width * imageSize.height * 4);
    CGContextRef context = CGBitmapContextCreate(data, imageSize.width, imageSize.height, 8, 4 * imageSize.width, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextDrawImage(context, CGRectMake(0, 0, imageSize.width, imageSize.height), imageRef);
    CGColorSpaceRelease(colorSpace);
    CGContextRelease(context);
    return (unsigned char*)data;
}

- (UIImage*) convertDataToUIImage: (unsigned char*)imageData width: (CGFloat)width height :(CGFloat)height {
    NSInteger dataLength = width * height * 4;
    
    CGDataProviderRef provide = CGDataProviderCreateWithData(NULL, imageData, dataLength, NULL);
    int bitsPerComponent = 8;
    int bitsPerPixel = 32;
    int bytesPerRow = 4 * width;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
    CGColorRenderingIntent renderIntent = kCGRenderingIntentDefault;
    
    CGImageRef imageRef = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpace, bitmapInfo, provide, NULL, NO, renderIntent);
    UIImage* imageNew = [UIImage imageWithCGImage:imageRef];
    CFRelease(imageRef);
    CGColorSpaceRelease(colorSpace);
    CGDataProviderRelease(provide);
    return imageNew;
}

-(unsigned char*) imageGrayWithData:(unsigned char*) imageData width:(CGFloat)width height: (CGFloat)height {
    unsigned char* resultData = malloc(width * height * sizeof(unsigned char) * 4 );
    memset(resultData, 0, width * height * sizeof(unsigned char) * 4);
    
    for(int h = 0; h < height; ++h) {
        for(int w = 0; w < width; ++w) {
            unsigned int imageIndex = h * width + w;
            unsigned char bitMapRed = *(imageData + imageIndex * 4);
            unsigned char bitMapGreen = *(imageData + imageIndex * 4 + 1);
            unsigned char bitMapBlue = *(imageData + imageIndex * 4 + 2);
            
            int bitMap = bitMapRed * 77 / 255 + bitMapGreen * 151 / 255 + bitMapBlue * 88 / 255;
            unsigned char newBitMap = (bitMap > 255) ? 255 : bitMap;
            memset(resultData + imageIndex * 4, newBitMap, 1);
            memset(resultData + imageIndex * 4 + 1, newBitMap, 1);
            memset(resultData + imageIndex * 4 + 2, newBitMap, 1);
        }
    }
    
    return resultData;
}

-(unsigned char*) imageReColorWithData:(unsigned char*) imageData width:(CGFloat)width height: (CGFloat)height {
    unsigned char* resultData = malloc(width * height * sizeof(unsigned char) * 4 );
    memset(resultData, 0, width * height * sizeof(unsigned char) * 4);
    
    for(int h = 0; h < height; ++h) {
        for(int w = 0; w < width; ++w) {
            unsigned int imageIndex = h * width + w;
            unsigned char bitMapRed = *(imageData + imageIndex * 4);
            unsigned char bitMapGreen = *(imageData + imageIndex * 4 + 1);
            unsigned char bitMapBlue = *(imageData + imageIndex * 4 + 2);
            
            unsigned char bitMapRedNew = 255 - bitMapRed;
            unsigned char bitMapGreenNew = 255 - bitMapGreen;
            unsigned char bitMapBlueNew = 255 - bitMapBlue;
            memset(resultData + imageIndex * 4, bitMapRedNew, 1);
            memset(resultData + imageIndex * 4 + 1, bitMapGreenNew, 1);
            memset(resultData + imageIndex * 4 + 2, bitMapBlueNew, 1);
        }
    }
    
    return resultData;
}

-(unsigned char*) imageHighlightWithData:(unsigned char*) imageData width:(CGFloat)width height: (CGFloat)height {
    unsigned char* resultData = malloc(width * height * sizeof(unsigned char) * 4 );
    memset(resultData, 0, width * height * sizeof(unsigned char) * 4);
    
    NSArray* colorArrayBase = @[@"55", @"110", @"155", @"185", @"220", @"240", @"250", @"255"];
    NSMutableArray* colorArray = [[NSMutableArray alloc] init];
    
    float step = 0.0f;
    int beforeNum = 0;
    for(int i = 0; i < 8; ++i) {
        NSString *numStr = [colorArrayBase objectAtIndex:i];
        int num = numStr.intValue;
        
        step = (num - beforeNum) / 32.0f;
        for(int j = 0; j < 32; ++j) {
            int newNum = (int)(beforeNum + j * step);
            
            NSString *newNumStr = [NSString stringWithFormat:@"%d", newNum];
            [colorArray addObject:newNumStr];
        }
        beforeNum = num;
    }
    
    for(int h = 0; h < height; ++h) {
        for(int w = 0; w < width; ++w) {
            unsigned int imageIndex = h * width + w;
            unsigned char bitMapRed = *(imageData + imageIndex * 4);
            unsigned char bitMapGreen = *(imageData + imageIndex * 4 + 1);
            unsigned char bitMapBlue = *(imageData + imageIndex * 4 + 2);
            
            NSString* redStr = [colorArray objectAtIndex:bitMapRed];
            NSString* greenStr = [colorArray objectAtIndex:bitMapGreen];
            NSString* blueStr = [colorArray objectAtIndex:bitMapBlue];
            unsigned char bitMapRedNew = redStr.intValue;
            unsigned char bitMapGreenNew = greenStr.intValue;
            unsigned char bitMapBlueNew = blueStr.intValue;
            memset(resultData + imageIndex * 4, bitMapRedNew, 1);
            memset(resultData + imageIndex * 4 + 1, bitMapGreenNew, 1);
            memset(resultData + imageIndex * 4 + 2, bitMapBlueNew, 1);
        }
    }
    
    return resultData;
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
