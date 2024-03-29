package softuni.exam.models.dto;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;
import java.util.List;

@XmlRootElement(name = "borrowing_records")
@XmlAccessorType(XmlAccessType.FIELD)
public class BRWrapperDto {
    @XmlElement(name = "borrowing_record")
    private List<BRImportDto> borrowingRecordImportDto;

    public List<BRImportDto> getBorrowingRecordImportDto() {
        return borrowingRecordImportDto;
    }

    public void setBorrowingRecordImportDto(List<BRImportDto> borrowingRecordImportDto) {
        this.borrowingRecordImportDto = borrowingRecordImportDto;
    }
}
