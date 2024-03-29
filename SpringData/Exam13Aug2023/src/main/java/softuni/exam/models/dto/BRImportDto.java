package softuni.exam.models.dto;

import softuni.exam.models.entity.Book;
import softuni.exam.models.entity.LibraryMember;
import softuni.exam.util.LocalDateAdapter;

import javax.validation.constraints.NotNull;
import javax.validation.constraints.Size;
import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.adapters.XmlJavaTypeAdapter;
import java.time.LocalDate;

@XmlRootElement(name = "borrowing_record")
@XmlAccessorType(XmlAccessType.FIELD)
public class BRImportDto {
    @XmlElement(name = "borrow_date")
    @XmlJavaTypeAdapter(LocalDateAdapter.class)
    @NotNull
    private LocalDate borrowDate;

    @XmlElement(name = "return_date")
    @XmlJavaTypeAdapter(LocalDateAdapter.class)
    @NotNull
    private LocalDate returnDate;

    @XmlElement
    @Size(min = 3, max = 100)
    private String remarks;

    @XmlElement
    @NotNull
    private BookImportDto book;

    @XmlElement
    @NotNull
    private LibraryMemberDto member;

    public LocalDate getBorrowDate() {
        return borrowDate;
    }

    public void setBorrowDate(LocalDate borrowDate) {
        this.borrowDate = borrowDate;
    }

    public LocalDate getReturnDate() {
        return returnDate;
    }

    public void setReturnDate(LocalDate returnDate) {
        this.returnDate = returnDate;
    }

    public String getRemarks() {
        return remarks;
    }

    public void setRemarks(String remarks) {
        this.remarks = remarks;
    }

    public BookImportDto getBook() {
        return book;
    }

    public void setBook(BookImportDto book) {
        this.book = book;
    }

    public LibraryMemberDto getMember() {
        return member;
    }

    public void setMember(LibraryMemberDto member) {
        this.member = member;
    }
}
