package softuni.exam.service.impl;

import com.google.gson.Gson;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import softuni.exam.models.dto.StarsDTO;
import softuni.exam.models.entity.Star;
import softuni.exam.repository.StarRepository;
import softuni.exam.service.StarService;
import softuni.exam.util.ValidationUtils;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import static softuni.exam.models.Constants.*;

@Service
public class StarServiceImpl implements StarService {
    private static final String STARS_FILE_PATH = "src/main/resources/files/json/stars.json";
    private final StarRepository starRepository;
    private final ValidationUtils validationUtils;
    private final ModelMapper modelMapper;
    private final Gson gson;


    @Autowired
    public StarServiceImpl(StarRepository starRepository, ValidationUtils validationUtils, ModelMapper modelMapper, Gson gson) {
        this.starRepository = starRepository;
        this.validationUtils = validationUtils;
        this.modelMapper = modelMapper;
        this.gson = gson;
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
        final StringBuilder stringBuilder = new StringBuilder();
        final List<StarsDTO> stars = Arrays.stream(this.gson.fromJson(readStarsFileContent(), StarsDTO[].class)).collect(Collectors.toList());

        for (StarsDTO star : stars) {
            stringBuilder.append(System.lineSeparator());
            if (this.starRepository.findFirstByName(star.getName()).isPresent() || !this.validationUtils.isValid(star)) {
                stringBuilder.append(String.format(INVALID_FORMAT, STAR));
                continue;
            }
            this.starRepository.save(this.modelMapper.map(star, Star.class));
            stringBuilder.append(String.format(SUCCESSFUL_FORMAT, STAR, star.getName(), star.getLightYears() + " light years"));
        }

        return stringBuilder.toString().trim();
    }

    @Override
    public String exportStars() {
        return null;
    }
}
