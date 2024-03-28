package softuni.exam.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import softuni.exam.repository.BorrowingRecordRepository;
import softuni.exam.service.BorrowingRecordsService;

import javax.xml.bind.JAXBException;
import java.io.IOException;

@Service
public class BorrowingRecordsServiceImpl implements BorrowingRecordsService {
    private static String BORROWING_RECORDS_FILE_PATH = "src/main/resources/files/xml/borrowing-records.xml";

    private final BorrowingRecordRepository borrowingRecordRepository;

    @Autowired
    public BorrowingRecordsServiceImpl(BorrowingRecordRepository borrowingRecordRepository) {
        this.borrowingRecordRepository = borrowingRecordRepository;
    }

    @Override
    public boolean areImported() {
        return this.borrowingRecordRepository.count() > 0;
    }

    @Override
    public String readBorrowingRecordsFromFile() throws IOException {
        return null;
    }

    @Override
    public String importBorrowingRecords() throws IOException, JAXBException {
        return null;
    }

    @Override
    public String exportBorrowingRecords() {
        return null;
    }
}
