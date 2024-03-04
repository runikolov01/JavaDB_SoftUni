package softuni.exam.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import softuni.exam.models.entity.Car;
import softuni.exam.models.entity.Part;

import java.util.Optional;

// TODO:
public interface PartsRepository extends JpaRepository<Part, Long> {
    Optional<Part> findFirstByPartName(String name);
}
