package softuni.exam.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import softuni.exam.repository.ConstellationRepository;
import softuni.exam.service.ConstellationService;

import java.io.IOException;

@Service
public class ConstellationServiceImpl implements ConstellationService {
    private final ConstellationRepository constellationRepository;

    @Autowired
    public ConstellationServiceImpl(ConstellationRepository constellationRepository) {
        this.constellationRepository = constellationRepository;
    }

    @Override
    public boolean areImported() {
        return false;
    }

    @Override
    public String readConstellationsFromFile() throws IOException {
        return null;
    }

    @Override
    public String importConstellations() throws IOException {
        return null;
    }
}
