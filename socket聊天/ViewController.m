//
//  ViewController.m
//  socket聊天
//
//  Created by locklight on 17/3/6.
//  Copyright © 2017年 LockLight. All rights reserved.
//

#import "ViewController.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>

@interface ViewController (){
    int _clientId;
}

@property (weak, nonatomic) IBOutlet UITextField *ipAddr;
@property (weak, nonatomic) IBOutlet UITextField *portID;
@property (weak, nonatomic) IBOutlet UITextField *msgText;
@property (weak, nonatomic) IBOutlet UILabel *receiveLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)connectAddr:(id)sender {
    if([self connectToHost:self.ipAddr.text andPort:self.portID.text.integerValue]){
        NSLog(@"连接成功");
    }else{
        NSLog(@"连接失败");
    }
}



- (IBAction)sendMsg:(UIButton *)sender {
    self.receiveLabel.text = [self sendAndReceive:self.msgText.text];
}


//连接
- (BOOL)connectToHost:(NSString *)host andPort:(NSInteger)port{
    //套戒指int socket(int domain, int type, int protocol);
    _clientId = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    
    
    //int connect (int sockfd, struct sockaddr * serv_addr, int addrlen);
    struct sockaddr_in serverAddr;
    serverAddr.sin_family = AF_INET;
    serverAddr.sin_addr.s_addr = inet_addr(host.UTF8String);
    serverAddr.sin_port = htons(port);
    
    int connectID = connect(_clientId, (const struct sockaddr *)&serverAddr, sizeof(serverAddr)) == 0;
    
    return connectID;
}

//发送与接收
- (NSString *)sendAndReceive:(NSString *)message{
    //发送
    const char *msg = message.UTF8String;
    ssize_t sendLength = send(_clientId, msg, strlen(msg), 0);
    NSLog(@"发送了 %zd个字节",sendLength);
    
    //接受
    uint8_t buffer[1024];
    ssize_t recvLen = recv(_clientId, buffer, sizeof(buffer),0);
    
    NSData *data = [NSData dataWithBytes:buffer length:recvLen];
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"接收到内容 %@",str);
    
    return str;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
