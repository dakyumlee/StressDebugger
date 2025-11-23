package com.stressdebugger.service;

import com.stressdebugger.dto.*;
import org.springframework.stereotype.Service;
import java.util.*;

@Service
public class InviteService {
    
    public InviteResponse createInvite(String username, InviteRequest request) {
        String code = UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        
        return InviteResponse.builder()
            .inviteCode(code)
            .message("초대 코드가 생성되었습니다: " + code)
            .build();
    }
}
