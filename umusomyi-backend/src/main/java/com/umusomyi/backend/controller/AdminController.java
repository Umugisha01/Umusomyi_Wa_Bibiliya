package com.umusomyi.backend.controller;

import com.umusomyi.backend.service.AdminService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.Map;

@RestController
@RequestMapping("/api/admin")
@CrossOrigin(origins = "*") // Allow Flutter app to access
public class AdminController {

    @Autowired
    private AdminService adminService;

    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody Map<String, String> payload) {
        String email = payload.get("email");
        if (email == null || email.isEmpty()) {
            return ResponseEntity.badRequest().body("Email is required");
        }
        adminService.generateOtp(email);
        return ResponseEntity.ok("If the email exists, an OTP has been sent.");
    }

    @PostMapping("/verify")
    public ResponseEntity<?> verify(@RequestBody Map<String, String> payload) {
        String email = payload.get("email");
        String otp = payload.get("otp");

        if (email == null || otp == null) {
            return ResponseEntity.badRequest().body("Email and OTP are required");
        }

        boolean isValid = adminService.verifyOtp(email, otp);
        if (isValid) {
            return ResponseEntity.ok("Login successful");
            // In a real app, return a JWT token here
        }
        return ResponseEntity.status(401).body("Invalid or expired OTP");
    }

    @PostMapping("/add")
    public ResponseEntity<?> addAdmin(@RequestBody Map<String, String> payload) {
        String email = payload.get("email");
        if (email == null || email.isEmpty()) {
            return ResponseEntity.badRequest().body("Email is required");
        }
        boolean created = adminService.createNewAdmin(email);
        if (created) {
            return ResponseEntity.ok("Admin added successfully");
        } else {
            return ResponseEntity.badRequest().body("Admin already exists");
        }
    }

    @GetMapping("/check")
    public ResponseEntity<?> checkAdmin(@RequestParam String email) {
        if (email == null || email.isEmpty()) {
            return ResponseEntity.badRequest().body("Email is required");
        }
        boolean exists = adminService.checkAdminExists(email);
        return ResponseEntity.ok(Map.of("exists", exists));
    }
}
