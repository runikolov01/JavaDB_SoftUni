package softuni.exam.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import softuni.exam.models.entity.Car;
import softuni.exam.models.entity.Task;

// TODO:
public interface TasksRepository extends JpaRepository<Task, Long> {

}
