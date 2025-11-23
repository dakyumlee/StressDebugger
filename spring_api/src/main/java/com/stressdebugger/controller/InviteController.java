package com.stressdebugger.controller;

import com.stressdebugger.dto.*;
import com.stressdebugger.service.InviteService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/invites")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class InviteController {
    
    private final InviteService inviteService;
    
    @PostMapping
    public ResponseEntity<InviteResponse> createInvite(
        Authentication auth,
        @RequestBody InviteRequest request
    ) {
        return ResponseEntity.ok(inviteService.createInvite(auth.getName(), request));
    }
}
