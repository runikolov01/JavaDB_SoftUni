package softuni.exam.service.impl;

import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import softuni.exam.models.dto.VolcanologistImportDto;
import softuni.exam.models.dto.VolcanologistWrapperDto;
import softuni.exam.models.entity.Volcano;
import softuni.exam.models.entity.Volcanologist;
import softuni.exam.repository.VolcanoRepository;
import softuni.exam.repository.VolcanologistRepository;
import softuni.exam.service.VolcanologistService;
import softuni.exam.util.ValidationUtil;
import softuni.exam.util.XmlParser;

import javax.xml.bind.JAXBException;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.HashSet;
import java.util.List;
import java.util.Optional;
import java.util.Set;

import static softuni.exam.models.Constants.*;

@Service
public class VolcanologistServiceImpl implements VolcanologistService {
    private static String VOLCANOLOGIST_FILE_PATH = "src/main/resources/files/xml/volcanologists.xml";

    private final VolcanologistRepository volcanologistRepository;
    private final VolcanoRepository volcanoRepository;


    private final ValidationUtil validationUtil;
    private final ModelMapper modelMapper;
    private final XmlParser xmlParser;


    @Autowired
    public VolcanologistServiceImpl(VolcanologistRepository volcanologistRepository, VolcanoRepository volcanoRepository, ValidationUtil validationUtil, ModelMapper modelMapper, XmlParser xmlParser) {
        this.volcanologistRepository = volcanologistRepository;
        this.volcanoRepository = volcanoRepository;
        this.validationUtil = validationUtil;
        this.modelMapper = modelMapper;
        this.xmlParser = xmlParser;
    }

    @Override
    public boolean areImported() {
        return this.volcanologistRepository.count() > 0;
    }

    @Override
    public String readVolcanologistsFromFile() throws IOException {
        return Files.readString(Path.of(VOLCANOLOGIST_FILE_PATH));
    }

    @Override
    public String importVolcanologists() throws IOException, JAXBException {
        //final
        StringBuilder stringBuilder = new StringBuilder();

        final List<VolcanologistImportDto> volcanologists = this.xmlParser.fromFile(Path.of(VOLCANOLOGIST_FILE_PATH).toFile(), VolcanologistWrapperDto.class).getVolcanologists();

        for (VolcanologistImportDto volcanologist : volcanologists) {
            stringBuilder.append(System.lineSeparator());
            String fullName = volcanologist.getFirstName() + " " + volcanologist.getLastName();
            Optional<Volcanologist> existPerson = volcanologistRepository.findFirstByFirstNameAndLastName(volcanologist.getFirstName(), volcanologist.getLastName());
            Optional<Volcano> volcanoOptional = this.volcanoRepository
                    .findById(volcanologist.getExploringVolcanoId());

            if (existPerson.isPresent() || !this.validationUtil.isValid(volcanologist)
                    ||volcanoOptional.isEmpty()) {
                stringBuilder.append(String.format(INVALID_FORMAT, VOLCANOLOGIST));
                continue;
            }
            Volcanologist mapped = this.modelMapper.map(volcanologist, Volcanologist.class);
            mapped.setExploredVolcano(volcanoOptional.get());
            this.volcanologistRepository.save(mapped);

            stringBuilder.append(String.format(SUCCESSFUL_FORMAT,
                    VOLCANOLOGIST,
                    fullName));
        }

        return stringBuilder.toString().trim();
    }

}