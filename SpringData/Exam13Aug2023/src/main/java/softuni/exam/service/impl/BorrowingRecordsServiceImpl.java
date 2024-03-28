package softuni.exam.service.impl;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import softuni.exam.models.dto.BorrowingRecordImportDto;
import softuni.exam.models.entity.Book;
import softuni.exam.models.entity.BorrowingRecord;
import softuni.exam.repository.BookRepository;
import softuni.exam.repository.BorrowingRecordRepository;
import softuni.exam.service.BorrowingRecordsService;
import softuni.exam.util.ValidationUtils;
import softuni.exam.util.XmlParser;

import javax.xml.bind.JAXBException;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;
import java.util.Optional;

import static softuni.exam.models.Constants.*;

@Service
public class BorrowingRecordsServiceImpl implements BorrowingRecordsService {
    private static final String BORROWING_RECORDS_FILE_PATH = "src/main/resources/files/xml/borrowing-records.xml";

    private final BorrowingRecordRepository borrowingRecordRepository;
    private final ValidationUtils validationUtils;
    private final ModelMapper modelMapper;
    private final XmlParser xmlParser;
    private final BookRepository bookRepository;

    @Autowired
    public BorrowingRecordsServiceImpl(BorrowingRecordRepository borrowingRecordRepository, ValidationUtils validationUtils, ModelMapper modelMapper, XmlParser xmlParser, BookRepository bookRepository) {
        this.borrowingRecordRepository = borrowingRecordRepository;
        this.validationUtils = validationUtils;
        this.modelMapper = modelMapper;
        this.xmlParser = xmlParser;
        this.bookRepository = bookRepository;
    }

    @Override
    public boolean areImported() {
        return this.borrowingRecordRepository.count() > 0;
    }

    @Override
    public String readBorrowingRecordsFromFile() throws IOException {
        return Files.readString(Path.of(BORROWING_RECORDS_FILE_PATH));
    }

    @Override
    public String importBorrowingRecords() throws IOException, JAXBException {
        StringBuilder stringBuilder = new StringBuilder();

        // Parse XML data into objects
        BorrowingRecordWrapperDto borrowingRecordWrapper = this.xmlParser.fromFile(Path.of(BORROWING_RECORDS_FILE_PATH).toFile(), BorrowingRecordWrapperDto.class);
        List<BorrowingRecordImportDto> records = borrowingRecordWrapper.getRecords();

        // Iterate over each record
        for (BorrowingRecordImportDto record : records) {
            // Validate the record
            if (!this.validationUtils.isValid(record)) {
                stringBuilder.append(String.format(INVALID_FORMAT, BORROWINGRECORD));
                continue; // Skip to the next record if validation fails
            }

            // Check if a borrowing record with the same book title already exists
            String bookTitle = record.getBook().getTitle(); // Access book title through the Book object
            Optional<BorrowingRecord> existingRecordOptional = this.borrowingRecordRepository.findByBook_Title(bookTitle);
            if (existingRecordOptional.isPresent()) {
                stringBuilder.append(String.format(INVALID_FORMAT, BORROWINGRECORD));
                continue; // Skip to the next record if a record with the same book title exists
            }

            Optional<Book> bookOptional = bookRepository.findFirstByTitle(bookTitle);
            Book book = bookOptional.orElseThrow(() -> new RuntimeException("Book not found")); // Or handle the absence of the book appropriately

            BorrowingRecord borrowingRecord = new BorrowingRecord();
            borrowingRecord.setBorrowDate(record.getBorrowDate());
            borrowingRecord.setReturnDate(record.getReturnDate());
            borrowingRecord.setBook(book); // Set the Book entity

// Save the borrowing record to the database
            this.borrowingRecordRepository.save(borrowingRecord);


            // Save the borrowing record to the database
            this.borrowingRecordRepository.save(borrowingRecord);

            stringBuilder.append(String.format(SUCCESSFUL_FORMAT, BORROWINGRECORD, bookTitle, record.getBorrowDate()));
        }

        return stringBuilder.toString().trim();
    }


    @Override
    public String exportBorrowingRecords() {
        return null;
    }
}
