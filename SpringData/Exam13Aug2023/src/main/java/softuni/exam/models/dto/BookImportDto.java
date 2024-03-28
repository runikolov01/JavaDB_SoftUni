package softuni.exam.models.dto;

import softuni.exam.models.entity.GenreType;

import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.validation.constraints.NotNull;
import javax.validation.constraints.Positive;
import javax.validation.constraints.Size;

public class BookImportDto {

    @NotNull
    @Size(min = 3, max = 40)
    private String author;

    @NotNull
    private boolean available;

    @NotNull
    @Size(min = 5)
    private String description;

    @Enumerated(EnumType.STRING)
    @NotNull
    private GenreType genre;

    @NotNull
    @Size(min = 3, max = 40)
    private String title;

    @NotNull
    @Positive
    private double rating;

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public boolean isAvailable() {
        return available;
    }

    public void setAvailable(boolean available) {
        this.available = available;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public GenreType getGenre() {
        return genre;
    }

    public void setGenre(GenreType genre) {
        this.genre = genre;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public double getRating() {
        return rating;
    }

    public void setRating(double rating) {
        this.rating = rating;
    }
}
