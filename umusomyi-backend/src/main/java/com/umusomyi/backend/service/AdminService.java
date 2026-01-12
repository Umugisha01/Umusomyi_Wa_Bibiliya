package com.umusomyi.backend.service;

import com.umusomyi.backend.model.Admin;
import com.umusomyi.backend.repository.AdminRepository;
import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Optional;
import java.util.Random;

@Service
public class AdminService {

    @Autowired
    private AdminRepository adminRepository;

    @Autowired
    private EmailService emailService;

    @PostConstruct
    public void init() {
        // Create default admin if not exists
        String defaultEmail = "umugishaone@gmail.com";
        if (adminRepository.findByEmail(defaultEmail).isEmpty()) {
            Admin admin = new Admin();
            admin.setEmail(defaultEmail);
            adminRepository.save(admin);
            System.out.println("Default admin created: " + defaultEmail);
        }
    }

    public void generateOtp(String email) {
        Optional<Admin> adminOpt = adminRepository.findByEmail(email);
        if (adminOpt.isPresent()) {
            Admin admin = adminOpt.get();
            // Generate 4-digit OTP
            String otp = String.format("%04d", new Random().nextInt(10000));

            admin.setOtp(otp);
            admin.setOtpExpiry(LocalDateTime.now().plusMinutes(10)); // 10 min expiry
            adminRepository.save(admin);

            // Send Email
            emailService.sendEmail(
                    email,
                    "Admin Login OTP",
                    "Your OTP for Admin Login is: " + otp + "\nIt expires in 10 minutes.");

            // Log for dev convenience
            System.out.println("OTP for " + email + ": " + otp);
        } else {
            // Security: Don't reveal if email exists, but log it
            System.out.println("Login attempt for non-existent admin: " + email);
        }
    }

    public boolean verifyOtp(String email, String otp) {
        Optional<Admin> adminOpt = adminRepository.findByEmail(email);
        if (adminOpt.isPresent()) {
            Admin admin = adminOpt.get();
            if (admin.getOtp() != null &&
                    admin.getOtp().equals(otp) &&
                    admin.getOtpExpiry().isAfter(LocalDateTime.now())) {

                // Clear OTP after successful use
                admin.setOtp(null);
                admin.setOtpExpiry(null);
                adminRepository.save(admin);
                return true;
            }
        }
        return false;
    }

    public boolean createNewAdmin(String email) {
        if (adminRepository.findByEmail(email).isPresent()) {
            return false;
        }
        Admin admin = new Admin();
        admin.setEmail(email);
        adminRepository.save(admin);
        return true;
    }

    public boolean checkAdminExists(String email) {
        return adminRepository.findByEmail(email).isPresent();
    }
}
