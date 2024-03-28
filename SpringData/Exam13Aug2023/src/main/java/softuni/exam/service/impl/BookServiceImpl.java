package softuni.exam.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import softuni.exam.repository.BookRepository;
import softuni.exam.service.BookService;

import java.io.IOException;

@Service
public class BookServiceImpl implements BookService {
    private static String BOOKS_FILE_PATH = "src/main/resources/files/json/books.json";
    private final BookRepository bookRepository;

    @Autowired
    public BookServiceImpl(BookRepository bookRepository) {
        this.bookRepository = bookRepository;
    }

    @Override
    public boolean areImported() {
        return this.bookRepository.count() > 0;
    }

    @Override
    public String readBooksFromFile() throws IOException {
        return null;
    }

    @Override
    public String importBooks() throws IOException {
        return null;
    }
}
