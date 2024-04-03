package softuni.exam.models.entity;

import javax.persistence.*;
import java.util.List;

@Entity
@Table(name = "countries")
public class Country extends BaseEntity {
    @Column(unique = true, nullable = false)
    private String name;
    @Column(nullable = true)
    private String capital;

    @OneToMany(mappedBy = "country")
    private List<Volcano> volcano;

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCapital() {
        return capital;
    }

    public void setCapital(String capital) {
        this.capital = capital;
    }

    public List<Volcano> getVolcano() {
        return volcano;
    }

    public void setVolcano(List<Volcano> volcano) {
        this.volcano = volcano;
    }
}
