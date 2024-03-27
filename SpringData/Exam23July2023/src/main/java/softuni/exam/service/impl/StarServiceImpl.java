package softuni.exam.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import softuni.exam.repository.StarRepository;
import softuni.exam.service.StarService;

import java.io.IOException;

@Service
public class StarServiceImpl implements StarService {
    private final StarRepository starRepository;

    @Autowired
    public StarServiceImpl(StarRepository starRepository) {
        this.starRepository = starRepository;
    }

    @Override
    public boolean areImported() {
        return false;
    }

    @Override
    public String readStarsFileContent() throws IOException {
        return null;
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