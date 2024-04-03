package softuni.exam.service.impl;

import com.google.gson.Gson;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import softuni.exam.models.dto.CountryImportDto;
import softuni.exam.models.entity.Country;
import softuni.exam.repository.CountryRepository;
import softuni.exam.service.CountryService;
import softuni.exam.util.ValidationUtil;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import static softuni.exam.models.Constants.*;

@Service
public class CountryServiceImpl implements CountryService {
    private static String COUNTRY_FILE_PATH = "src/main/resources/files/json/countries.json";

    private final CountryRepository countryRepository;

    private final ValidationUtil validationUtil;
    private final ModelMapper modelMapper;
    private final Gson gson;

    @Autowired
    public CountryServiceImpl(CountryRepository countryRepository, ValidationUtil validationUtil, ModelMapper modelMapper, Gson gson) {
        this.countryRepository = countryRepository;
        this.validationUtil = validationUtil;
        this.modelMapper = modelMapper;
        this.gson = gson;
    }


    @Override
    public boolean areImported() {
        return this.countryRepository.count() > 0;
    }

    @Override
    public String readCountriesFromFile() throws IOException {
        return Files.readString(Path.of(COUNTRY_FILE_PATH));
    }

    @Override
    public String importCountries() throws IOException {
        final StringBuilder stringBuilder = new StringBuilder();

        final List<CountryImportDto> countries = Arrays.stream(this.gson.fromJson(readCountriesFromFile(), CountryImportDto[].class)).collect(Collectors.toList());

        for (CountryImportDto country : countries) {
            stringBuilder.append(System.lineSeparator());

            if (this.countryRepository.findFirstByName(country.getName()).isPresent() || !this.validationUtil.isValid(country)) {
                stringBuilder.append(String.format(INVALID_FORMAT, COUNTRY));
                continue;
            }

            this.countryRepository.save(this.modelMapper.map(country, Country.class));

            stringBuilder.append(String.format(SUCCESSFUL_FORMAT, COUNTRY, country.getName()));
            stringBuilder.append(String.format(" - %s", country.getCapital()));
        }

        return stringBuilder.toString().trim();
    }

    @Override
    public Optional<Country> getCountryById(Long countryId) {
        return Optional.empty();
    }

    @Override
    public void saveAddedVolcanoInCountry(Country country) {

    }
}
