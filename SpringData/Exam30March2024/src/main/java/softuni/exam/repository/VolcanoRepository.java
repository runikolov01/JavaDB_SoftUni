package softuni.exam.repository;


import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import softuni.exam.models.entity.Volcano;

import java.util.List;
import java.util.Optional;
import java.util.Set;

public interface VolcanoRepository extends JpaRepository<Volcano, Long> {
    Optional<Volcano> findFirstByName(String name);
    @Query("FROM Volcano v WHERE v.elevation > 3000 AND v.lastEruption IS NOT NULL " +
            "AND v.isActive = true ORDER BY v.elevation DESC ")
    Set<Volcano> export();
}
