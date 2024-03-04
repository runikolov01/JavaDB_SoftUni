package softuni.exam.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import softuni.exam.models.entity.Car;

import java.util.Optional;

public interface CarsRepository extends JpaRepository<Car, Long> {
    Optional<Car> findFirstByPlateNumber(String plateNumber);
}
