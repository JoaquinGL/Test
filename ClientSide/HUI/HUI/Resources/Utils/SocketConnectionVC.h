//
//  SocketConnectionVC.h
//  HUI
//
//  Created by Joaquin Giraldez on 23/2/16.
//  Copyright © 2016 Giraldez Lopez SL. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface SocketConnectionVC : UIViewController<NSStreamDelegate>
{
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    
    NSInputStream   *inputStream;
    NSOutputStream  *outputStream;
    
    NSMutableArray  *messages;
}

@property (weak, nonatomic) IBOutlet UITextField *ipAddressText;
@property (weak, nonatomic) IBOutlet UITextField *portText;
@property (weak, nonatomic) IBOutlet UITextField *dataToSendText;
@property (weak, nonatomic) IBOutlet UITextView *dataRecievedTextView;
@property (weak, nonatomic) IBOutlet UILabel *connectedLabel;


@end