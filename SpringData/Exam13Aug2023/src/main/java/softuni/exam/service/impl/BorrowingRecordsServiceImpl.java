package softuni.exam.service.impl;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import softuni.exam.models.dto.BRImportDto;
import softuni.exam.models.dto.BRWrapperDto;
import softuni.exam.models.entity.Book;
import softuni.exam.models.entity.BorrowingRecord;
import softuni.exam.models.entity.LibraryMember;
import softuni.exam.repository.BookRepository;
import softuni.exam.repository.BorrowingRecordRepository;
import softuni.exam.repository.LibraryMemberRepository;
import softuni.exam.service.BorrowingRecordsService;
import softuni.exam.util.ValidationUtils;
import softuni.exam.util.XmlParser;

import javax.xml.bind.JAXBException;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;

import static softuni.exam.models.Constants.*;

@Service
public class BorrowingRecordsServiceImpl implements BorrowingRecordsService {
    private static String BORROWING_RECORDS_FILE_PATH = "src/main/resources/files/xml/borrowing-records.xml";

    private final BorrowingRecordRepository borrowingRecordRepository;
    private final BookRepository bookRepository;
    private final LibraryMemberRepository libraryMemberRepository;
    private final ValidationUtils validationUtils;
    private final ModelMapper modelMapper;
    private final XmlParser xmlParser;


    @Autowired
    public BorrowingRecordsServiceImpl(BorrowingRecordRepository borrowingRecordRepository, BookRepository bookRepository, LibraryMemberRepository libraryMemberRepository, ValidationUtils validationUtils, ModelMapper modelMapper, XmlParser xmlParser) {
        this.borrowingRecordRepository = borrowingRecordRepository;
        this.bookRepository = bookRepository;
        this.libraryMemberRepository = libraryMemberRepository;
        this.validationUtils = validationUtils;
        this.modelMapper = modelMapper;
        this.xmlParser = xmlParser;
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
        StringBuilder sb = new StringBuilder();

        BRWrapperDto wrapperDto = xmlParser.fromFile(new File(BORROWING_RECORDS_FILE_PATH), BRWrapperDto.class);
        List<BRImportDto> records = wrapperDto.getBorrowingRecordImportDto();

        for (BRImportDto record : records) {
            sb.append(System.lineSeparator());
            Optional<Book> optionalBook = bookRepository.findFirstByTitle(record.getBook().getTitle());
            Optional<LibraryMember> optionalLibraryMember = libraryMemberRepository.findFirstById(record.getMember().getId());

            if (optionalBook.isEmpty() || optionalLibraryMember.isEmpty() || !validationUtils.isValid(record)) {
                sb.append(String.format(INVALID_FORMAT, BORROWINGRECORD));
                continue;
            }

            // Map DTO to entity
            BorrowingRecord borrowingRecord = modelMapper.map(record, BorrowingRecord.class);
            borrowingRecord.setBook(optionalBook.get());
            borrowingRecord.setMember(optionalLibraryMember.get());

            // Save the borrowing record
            borrowingRecordRepository.save(borrowingRecord);

            sb.append(String.format(SUCCESSFUL_FORMAT,
                    BORROWINGRECORD,
                    record.getBook().getTitle(),
                    record.getBorrowDate()
            ));
        }

        return sb.toString().trim();
    }





    @Override
    public String exportBorrowingRecords() {
        return null;
    }
}
