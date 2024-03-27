package softuni.exam.service;

import org.springframework.stereotype.Service;

import javax.xml.bind.JAXBException;
import java.io.IOException;

@Service
public interface AstronomerService {

    boolean areImported();

    String readAstronomersFromFile() throws IOException;

	String importAstronomers() throws IOException, JAXBException;

}
