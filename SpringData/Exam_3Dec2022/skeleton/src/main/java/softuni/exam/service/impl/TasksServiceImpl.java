package softuni.exam.service.impl;

import softuni.exam.service.TasksService;

import javax.xml.bind.JAXBException;
import java.io.IOException;
// TODO: Implement all methods
public class TasksServiceImpl implements TasksService {
    private static String TASKS_FILE_PATH = "";

    @Override
    public boolean areImported() {
        return false;
    }

    @Override
    public String readTasksFileContent() throws IOException {
        return null;
    }

    @Override
    public String importTasks() throws IOException, JAXBException {
        return null;
    }

    @Override
    public String getCoupeCarTasksOrderByPrice() {
        return null;
    }
}
