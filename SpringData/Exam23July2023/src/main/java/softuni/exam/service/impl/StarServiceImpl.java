package softuni.exam.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import softuni.exam.repository.StarRepository;
import softuni.exam.service.StarService;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

@Service
public class StarServiceImpl implements StarService {
    private static String STARS_FILE_PATH = "src/main/resources/files/json/stars.json";
    private final StarRepository starRepository;

    @Autowired
    public StarServiceImpl(StarRepository starRepository) {
        this.starRepository = starRepository;
    }

    @Override
    public boolean areImported() {
        return this.starRepository.count() > 0;
    }

    @Override
    public String readStarsFileContent() throws IOException {
        return Files.readString(Path.of(STARS_FILE_PATH));
    }

    @Override
    public String importStars() throws IOException {
        return null;
    }

    @Override
    public String exportStars() {
        return null;
    }
}
