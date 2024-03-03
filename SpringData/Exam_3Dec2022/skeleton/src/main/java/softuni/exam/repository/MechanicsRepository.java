package softuni.exam.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import softuni.exam.models.entity.Car;
import softuni.exam.models.entity.Mechanic;

// TODO:
public interface MechanicsRepository extends JpaRepository<Mechanic, Long> {


}
