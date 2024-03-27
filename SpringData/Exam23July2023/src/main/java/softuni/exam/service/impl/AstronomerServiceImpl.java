package softuni.exam.service.impl;

import com.google.gson.Gson;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import softuni.exam.repository.AstronomerRepository;
import softuni.exam.service.AstronomerService;
import softuni.exam.util.ValidationUtils;

import javax.xml.bind.JAXBException;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;

@Service
public class AstronomerServiceImpl implements AstronomerService {
    private static String ASTRONOMER_FILE_PATH = "src/main/resources/files/xml/astronomers.xml";

    private final AstronomerRepository astronomerRepository;
    private final ValidationUtils validationUtils;
    private final ModelMapper modelMapper;
    private final Gson gson;


    @Autowired
    public AstronomerServiceImpl(AstronomerRepository astronomerRepository, ValidationUtils validationUtils, ModelMapper modelMapper, Gson gson) {
        this.astronomerRepository = astronomerRepository;
        this.validationUtils = validationUtils;
        this.modelMapper = modelMapper;
        this.gson = gson;
    }

    @Override
    public boolean areImported() {
        return this.astronomerRepository.count() > 0;
    }

    @Override
    public String readAstronomersFromFile() throws IOException {
        return Files.readString(Path.of(ASTRONOMER_FILE_PATH));
    }

    @Override
    public String importAstronomers() throws IOException, JAXBException {
       final StringBuilder stringBuilder = new StringBuilder();


        return null;
    }
}
