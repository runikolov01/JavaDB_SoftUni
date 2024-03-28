package softuni.exam.service.impl;

import com.google.gson.Gson;
import org.modelmapper.ModelMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import softuni.exam.models.dto.LibraryMembersImportDto;
import softuni.exam.models.entity.LibraryMember;
import softuni.exam.repository.LibraryMemberRepository;
import softuni.exam.service.LibraryMemberService;
import softuni.exam.util.ValidationUtils;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import static softuni.exam.models.Constants.*;

@Service
public class LibraryMemberServiceImpl implements LibraryMemberService {
    private static final String LIBRARY_MEMBER_FILE_PATH = "src/main/resources/files/json/library-members.json";
    private final LibraryMemberRepository libraryMemberRepository;

    private final ValidationUtils validationUtils;
    private final ModelMapper modelMapper;
    private final Gson gson;


    @Autowired
    public LibraryMemberServiceImpl(LibraryMemberRepository libraryMemberRepository, ValidationUtils validationUtils, ModelMapper modelMapper, Gson gson) {
        this.libraryMemberRepository = libraryMemberRepository;
        this.validationUtils = validationUtils;
        this.modelMapper = modelMapper;
        this.gson = gson;
    }

    @Override
    public boolean areImported() {
        return this.libraryMemberRepository.count() > 0;
    }

    @Override
    public String readLibraryMembersFileContent() throws IOException {
        return Files.readString(Path.of(LIBRARY_MEMBER_FILE_PATH));
    }

    @Override
    public String importLibraryMembers() throws IOException {
        final StringBuilder stringBuilder = new StringBuilder();

        final List<LibraryMembersImportDto> members = Arrays.stream(this.gson.fromJson(readLibraryMembersFileContent(), LibraryMembersImportDto[].class)).collect(Collectors.toList());

        for (LibraryMembersImportDto member : members) {
            stringBuilder.append(System.lineSeparator());

            if (this.libraryMemberRepository.findFirstByPhoneNumber(member.getPhoneNumber()).isPresent() || !this.validationUtils.isValid(member)) {
                stringBuilder.append(String.format(INVALID_FORMAT, LIBRARYMEMBER));
                continue;
            }

            this.libraryMemberRepository.save(this.modelMapper.map(member, LibraryMember.class));

            stringBuilder.append(String.format(SUCCESSFUL_FORMAT,
                    LIBRARYMEMBER,
                    member.getFirstName(),
                    member.getLastName()));
        }

        return stringBuilder.toString().trim();
    }
}
