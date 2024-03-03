package softuni.exam.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import softuni.exam.models.entity.Car;
import softuni.exam.models.entity.Part;

// TODO:
public interface PartsRepository extends JpaRepository<Part, Long> {


}
