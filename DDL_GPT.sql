CREATE schema G5_7;
SET search_path TO G5_7;

CREATE TABLE User (
    User_id INT PRIMARY KEY,
    User_name VARCHAR(255)
);

CREATE TABLE Project (
    Project_id INT PRIMARY KEY,
    Project_name VARCHAR(255),
    Manager_id INT,
    FOREIGN KEY (Manager_id) REFERENCES User(User_id)
    ON UPDATE cascade ON DELETE cascade
);


CREATE TABLE Collaborator (
    Project_id INT,
    User_id INT,
    Role VARCHAR(255),
    PRIMARY KEY (Project_id, User_id),
    FOREIGN KEY (Project_id) REFERENCES Project(Project_id)
    ON UPDATE cascade ON DELETE cascade,
    FOREIGN KEY (User_id) REFERENCES User(User_id)
    ON UPDATE cascade ON DELETE cascade
);

CREATE TABLE Local_Files (
    Local_id INT PRIMARY KEY,
    Project_id INT,
    User_id INT,
    Timeline_id INT,
    FOREIGN KEY (Project_id) REFERENCES Project(Project_id)
    ON UPDATE cascade ON DELETE cascade,
    FOREIGN KEY (User_id) REFERENCES User(User_id)
    ON UPDATE cascade ON DELETE cascade
);

CREATE TABLE Files (
    File_id INT PRIMARY KEY,
    Local_id INT,
    File_name VARCHAR(255),
    length INT,
    FOREIGN KEY (Local_id) REFERENCES Local_Files(Local_id)
    ON UPDATE cascade ON DELETE cascade
);

CREATE TABLE Timeline (
    Timeline_id INT PRIMARY KEY,
    Project_id INT,
    Latest_Version INT,
    Latest_Files INT,
    FOREIGN KEY (Project_id) REFERENCES Project(Project_id)
    ON UPDATE cascade ON DELETE cascade,
    FOREIGN KEY (Latest_Files) REFERENCES Files(File_id)
    ON UPDATE cascade ON DELETE cascade
);

CREATE TABLE Version (
    Version_id INT PRIMARY KEY,
    Timeline_id INT,
    Project_id INT,
    Updater_id INT,
    FOREIGN KEY (Timeline_id) REFERENCES Timeline(Timeline_id)
    ON UPDATE cascade ON DELETE cascade,
    FOREIGN KEY (Project_id) REFERENCES Project(Project_id)
    ON UPDATE cascade ON DELETE cascade,
    FOREIGN KEY (Updater_id) REFERENCES User(User_id)
    ON UPDATE cascade ON DELETE cascade
);

CREATE TABLE Change (
    Version_id INT,
    Timeline_id INT,
    Project_id INT,
    Line_id INT,
    File_id INT,
    Previous_content VARCHAR(255),
    New_content VARCHAR(255),
    PRIMARY KEY (Version_id, Timeline_id, Project_id, Line_id, File_id),
    FOREIGN KEY (Version_id) REFERENCES Version(Version_id)
    ON UPDATE cascade ON DELETE cascade,
    FOREIGN KEY (Timeline_id) REFERENCES Timeline(Timeline_id)
    ON UPDATE cascade ON DELETE cascade,
    FOREIGN KEY (Project_id) REFERENCES Project(Project_id)
    ON UPDATE cascade ON DELETE cascade,
    FOREIGN KEY (File_id) REFERENCES Files(File_id)
    ON UPDATE cascade ON DELETE cascade
);
