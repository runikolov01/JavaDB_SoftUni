package softuni.exam.service.impl;

import com.google.gson.Gson;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import softuni.exam.models.dto.VolcanoImportDto;
import softuni.exam.models.entity.Volcano;
import softuni.exam.models.entity.Volcanologist;
import softuni.exam.repository.VolcanoRepository;
import softuni.exam.service.VolcanoService;
import softuni.exam.util.ValidationUtil;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import static softuni.exam.models.Constants.*;

@Service
public class VolcanoServiceImpl implements VolcanoService {
    private static String VOLCANO_FILE_PATH = "src/main/resources/files/json/volcanoes.json";
    private final VolcanoRepository volcanoRepository;

    private final ValidationUtil validationUtil;
    private final ModelMapper modelMapper;
    private final Gson gson;


    @Autowired
    public VolcanoServiceImpl(VolcanoRepository volcanoRepository, ValidationUtil validationUtil, ModelMapper modelMapper, Gson gson) {
        this.volcanoRepository = volcanoRepository;
        this.validationUtil = validationUtil;
        this.modelMapper = modelMapper;
        this.gson = gson;
    }

    @Override
    public boolean areImported() {
        return this.volcanoRepository.count() > 0;
    }

    @Override
    public String readVolcanoesFileContent() throws IOException {
        return Files.readString(Path.of(VOLCANO_FILE_PATH));
    }

    @Override
    public String importVolcanoes() throws IOException {
        final StringBuilder stringBuilder = new StringBuilder();

        final List<VolcanoImportDto> volcanoes = Arrays.stream(this.gson.fromJson(readVolcanoesFileContent(), VolcanoImportDto[].class)).collect(Collectors.toList());

        for (VolcanoImportDto volcano : volcanoes) {
            stringBuilder.append(System.lineSeparator());

            if (this.volcanoRepository.findFirstByName(volcano.getName()).isPresent() || !this.validationUtil.isValid(volcano)) {
                stringBuilder.append(String.format(INVALID_FORMAT, VOLCANO));
                continue;
            }

            this.volcanoRepository.save(this.modelMapper.map(volcano, Volcano.class));

            stringBuilder.append(String.format(SUCCESSFUL_FORMAT, VOLCANO, volcano.getName()));


            stringBuilder.append(String.format(" of type %s", volcano.getVolcanoType()));
        }

        return stringBuilder.toString().trim();
    }

    @Override
    public Volcano findVolcanoById(Long volcanoId) {
        return null;
    }

    @Override
    public void addAndSaveAddedVolcano(Volcano volcano, Volcanologist volcanologist) {

    }

    @Override
    public String exportVolcanoes() {
        return this.volcanoRepository.export().stream()
                .map(volcano -> String.format("Volcano: %s\n" +
                                "   *Located in: %s\n" +
                                "   **Elevation: %d\n" +
                                "   ***Last eruption on: %s",
                        volcano.getName(),
                        volcano.getCountry().getName(),
                        volcano.getElevation(),
                        volcano.getLastEruption()))
                .collect(Collectors.joining(System.lineSeparator()));
    }
}