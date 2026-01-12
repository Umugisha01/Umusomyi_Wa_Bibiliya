
package com.umusomyi.backend.controller;

import com.umusomyi.backend.model.Reading;
import com.umusomyi.backend.service.ReadingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/api/readings")
@CrossOrigin(origins = "*") // Allow Flutter app (or all) to access
public class ReadingController {

    @Autowired
    private ReadingService readingService;

    @GetMapping
    public Iterable<Reading> getAllReadings() {
        return readingService.getAllReadings();
    }

    @PostMapping("/upload")
    public ResponseEntity<String> uploadReadings(@RequestParam("file") MultipartFile file) {
        if (file.isEmpty()) {
            return ResponseEntity.badRequest().body("Please select a file to upload");
        }

        try {
            readingService.uploadReadings(file);
            return ResponseEntity.ok("File uploaded and readings merged successfully!");
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Failed to upload file: " + e.getMessage());
        }
    }
}
