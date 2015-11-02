//
//  NTalkerFlashServersModel.m
//  CustomerServerSDK2
//
//  Created by NTalker on 15/7/23.
//  Copyright (c) 2015年 黄 倩. All rights reserved.
//

#import "NTalkerFlashServersModel.h"

@implementation NTalkerFlashServersModel

- (NSString *)description
{
    return [NSString stringWithFormat:@"presenceserver:%@\npresencegoserver:%@\nhistory:%@\navserver:%@\ntfileserver:%@\nt2dserver:%@\nt2dstatus:%@\ntchatserver:%@\ntchatgourl:%@\ntrailserver:%@\nmanageserver:%@\ncrmserver:%@\ncoopurl:%@\nupdateurl:%@\ncoopserver:%@\npromotionserver:%@\ncrmcenter:%@\nagentserver:%@\nt2dmqttserver:%@\ntchatmqttserver:%@\nimmqttserver:%@\nusecache:%@\n",
            _presenceserver,
            _presencegoserver,
            _history,
            _avserver,
            _fileserver,
            _t2dserver,
            _t2dstatus,
            _tchatserver,
            _tchatgourl,
            _trailserver,
            _manageserver,
            _crmserver,
            _coopurl,
            _updateurl,
            _coopserver,
            _promotionserver,
            _crmcenter,
            _agentserver,
            _t2dmqttserver,
            _tchatmqttserver,
            _immqttserver,
            _usecache];
}

@end
