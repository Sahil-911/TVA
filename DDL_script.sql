DROP SCHEMA DBMS_PROJECT CASCADE;
CREATE SCHEMA DBMS_PROJECT;
SET search_path TO DBMS_PROJECT;

CREATE TABLE "User" (
    User_id INT NOT NULL,
    User_name VARCHAR(20) NOT NULL,
	PRIMARY KEY(User_id)
);

CREATE TABLE Project (
    Project_id INT NOT NULL,
    Project_name VARCHAR(20) NOT NULL,
    Manager_id INT NOT NULL,
	PRIMARY KEY(Project_id)
);

CREATE TABLE Collaborator (
    Project_id INT NOT NULL,
    User_id INT NOT NULL,
    Role VARCHAR(20) NOT NULL,
    PRIMARY KEY (Project_id, User_id)
);

CREATE TABLE Local_Files (
    Local_id INT NOT NULL,
    Project_id INT NOT NULL,
    User_id INT,
    Timeline_id INT DEFAULT 0 NOT NULL,
    PRIMARY KEY (Local_id, Project_id)
);

CREATE TABLE "File" (
    File_id INT NOT NULL,
    Local_id INT NOT NULL,
    Project_id INT NOT NULL,
    File_name VARCHAR(20) NOT NULL,
    Length INT NOT NULL,
    PRIMARY KEY (Local_id, Project_id)
);

CREATE TABLE "Line" (
    Line_id INT NOT NULL,
    File_id INT NOT NULL,
    Local_id INT NOT NULL,
    Project_id INT NOT NULL,
    Content VARCHAR(1024) NOT NULL,
    PRIMARY KEY (Local_id, Project_id, File_id)
);

CREATE TABLE Timeline (
    Timeline_id INT NOT NULL,
    Project_id INT NOT NULL,
    Latest_Version VARCHAR(20) NOT NULL,
    Latest_Files VARCHAR(20) NOT NULL,
    PRIMARY KEY (Project_id, Timeline_id)
);

CREATE TABLE "Version" (
    Version_id INT NOT NULL,
    Timeline_id INT NOT NULL,
    Project_id INT NOT NULL,
    Updater_id INT NOT NULL,
    PRIMARY KEY (Version_id, Timeline_id, Project_id)
);

CREATE TABLE Change (
    Version_id INT NOT NULL,
    Timeline_id INT NOT NULL,
    Project_id INT NOT NULL,
    Line_id INT NOT NULL,
    File_id INT NOT NULL,
    Previous_content VARCHAR(1024) NOT NULL,
    New_content VARCHAR(1024) NOT NULL,
    PRIMARY KEY (Version_id, Timeline_id, Project_id, Line_id, File_id)
);

ALTER TABLE Collaborator
    ADD FOREIGN KEY (Project_id) REFERENCES Project(Project_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
    ADD FOREIGN KEY (User_id) REFERENCES "User"(User_id)
    ON DELETE SET NULL ON UPDATE CASCADE;
    
ALTER TABLE Local_Files
    ADD FOREIGN KEY (Project_id) REFERENCES Project(Project_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
    ADD FOREIGN KEY (User_id) REFERENCES "User"(User_id)
    ON DELETE SET NULL ON UPDATE CASCADE,
    ADD FOREIGN KEY (Timeline_id) REFERENCES Timeline(Timeline_id)
    ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE "File"
    ADD FOREIGN KEY (Local_id) REFERENCES Local_Files(Local_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
    ADD FOREIGN KEY (Project_id) REFERENCES Project(Project_id)
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "Line"
    ADD FOREIGN KEY (File_id) REFERENCES "File"(File_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
    ADD FOREIGN KEY (Local_id) REFERENCES Local_Files(Local_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
    ADD FOREIGN KEY (Project_id) REFERENCES Project(Project_id)
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE Timeline
    ADD FOREIGN KEY (Project_id) REFERENCES Project(Project_id)
    ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "Version"
    ADD FOREIGN KEY (Timeline_id) REFERENCES Timeline(Timeline_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
    ADD FOREIGN KEY (Project_id) REFERENCES Project(Project_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
    ADD FOREIGN KEY (Updater_id) REFERENCES "User"(User_id);

ALTER TABLE Change
    ADD FOREIGN KEY (Version_id) REFERENCES "Version"(Version_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
    ADD FOREIGN KEY (Timeline_id) REFERENCES Timeline(Timeline_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
    ADD FOREIGN KEY (Project_id) REFERENCES Project(Project_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
    ADD FOREIGN KEY (Line_id) REFERENCES "Line"(Line_id)
    ON DELETE CASCADE ON UPDATE CASCADE,
    ADD FOREIGN KEY (File_id) REFERENCES "File"(File_id)
    ON DELETE CASCADE ON UPDATE CASCADE;