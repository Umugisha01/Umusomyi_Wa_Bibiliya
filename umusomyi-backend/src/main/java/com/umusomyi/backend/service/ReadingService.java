
package com.umusomyi.backend.service;

import com.opencsv.CSVReader;
import com.opencsv.exceptions.CsvValidationException;
import com.umusomyi.backend.model.Reading;
import com.umusomyi.backend.repository.ReadingRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.Optional;

@Service
public class ReadingService {

    @Autowired
    private ReadingRepository readingRepository;

    public Iterable<Reading> getAllReadings() {
        return readingRepository.findAll();
    }

    @Transactional
    public void uploadReadings(MultipartFile file) throws IOException, CsvValidationException {
        try (BufferedReader reader = new BufferedReader(new InputStreamReader(file.getInputStream()));
                CSVReader csvReader = new CSVReader(reader)) {

            String[] line;
            // Skip header if present (Assuming standard: date,title,reference,content)
            // Or simple logic: Try parse first line as date, if fail, skip.

            boolean isFirstLine = true;

            while ((line = csvReader.readNext()) != null) {
                System.out.println("Processing line: " + java.util.Arrays.toString(line)); // DEBUG

                if (line.length < 4 && !(line.length == 1 && line[0].contains("|"))) {
                    System.out.println("Skipping line due to length: " + line.length);
                    continue;
                }

                // Try parse Separator | if standard CSV comma fails or looks wrong?
                // OpenCSV parses by comma by default.
                // User provided helper: "2026-01-01 | Title | Ref | Content"
                // If the CSV parser splits this single line into 1 element containing pipes,
                // handle it.

                String dateStr, title, reference, content;

                if (line.length == 1 && line[0].contains("|")) {
                    // Handle pipe separated manual parsing.
                    // Format: Date | Title | Content (Content may contain pipes)
                    // Using limit 3 ensures Date and Title are split, and everything else is
                    // Content.
                    String[] parts = line[0].split("\\|", 3);

                    if (parts.length < 3) {
                        System.out.println("Skipping pipe-line due to insufficient parts: " + parts.length);
                        continue;
                    }
                    dateStr = parts[0].trim();
                    title = parts[1].trim();
                    reference = ""; // Title usually contains reference in this specific user format
                    content = parts[2].trim();
                } else {
                    // Standard CSV
                    dateStr = line[0].trim();
                    title = line[1].trim();
                    reference = line[2].trim();
                    content = line[3].trim();
                }

                try {
                    // Check header
                    if (isFirstLine && dateStr.equalsIgnoreCase("date")) {
                        isFirstLine = false;
                        continue;
                    }

                    LocalDate date = LocalDate.parse(dateStr);

                    Optional<Reading> existing = readingRepository.findByDate(date);
                    if (existing.isPresent()) {
                        // Merge / Update
                        Reading r = existing.get();
                        r.setTitle(title);
                        r.setReference(reference);
                        r.setContent(content);
                        readingRepository.save(r);
                        System.out.println("Updated reading for date: " + date + " | Title: " + title);
                    } else {
                        // Create New
                        Reading r = new Reading();
                        r.setDate(date);
                        r.setTitle(title);
                        r.setReference(reference);
                        r.setContent(content);
                        readingRepository.save(r);
                        System.out.println("Created new reading for date: " + date + " | Title: " + title);
                    }
                } catch (DateTimeParseException e) {
                    // Log or skip invalid dates
                    System.err.println("Invalid date format: " + dateStr);
                }
            }
        }
    }
}
