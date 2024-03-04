package softuni.exam.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import softuni.exam.models.entity.Car;
import softuni.exam.models.entity.CarType;
import softuni.exam.models.entity.Task;

import java.util.List;

// TODO:
public interface TasksRepository extends JpaRepository<Task, Long> {
    List<Task> findAllByCarCarTypeOrderByPriceDesc(CarType carType);
}