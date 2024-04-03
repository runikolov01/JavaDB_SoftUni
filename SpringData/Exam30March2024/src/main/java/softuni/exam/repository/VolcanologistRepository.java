package softuni.exam.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import softuni.exam.models.dto.VolcanologistImportDto;
import softuni.exam.models.entity.Volcano;
import softuni.exam.models.entity.Volcanologist;

import java.util.Optional;

public interface VolcanologistRepository extends JpaRepository<Volcanologist, Long> {
    Optional<Volcanologist> findFirstByFirstNameAndLastName(String firstName, String lastName);
}
