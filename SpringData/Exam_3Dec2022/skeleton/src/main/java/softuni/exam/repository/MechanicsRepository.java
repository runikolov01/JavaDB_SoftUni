package softuni.exam.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import softuni.exam.models.entity.Car;
import softuni.exam.models.entity.Mechanic;

import java.util.Optional;

// TODO:
public interface MechanicsRepository extends JpaRepository<Mechanic, Long> {
    Optional<Mechanic> findFirstByEmail(String email);
    Optional<Mechanic> findFirstByFirstName(String firstName);
}
